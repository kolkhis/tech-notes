
# Using External Processes in Neovim  


## Spawning External Processes with `vim.system()`

Runs a system command or throws an error if `{cmd}` cannot be run.  
```lua  
vim.system({cmd}, {opts}, {on_exit})  
```
---  

### `vim.system()` Examples:  
```lua  
local on_exit = function(obj)  
    print(obj.code)  
    print(obj.signal)  
    print(obj.stdout)  
    print(obj.stderr)  
end  

-- Runs asynchronously:  
vim.system({'echo', 'hello'}, { text = true }, on_exit)  

-- Runs synchronously:  
local obj = vim.system({'echo', 'hello'}, { text = true }):wait()  
-- Output:  
-- { code = 0, signal = 0, stdout = 'hello', stderr = '' }
```

Note: unlike `uv.spawn()`, `vim.system` throws an error if `{cmd}` cannot be run.  

```lua  
vim.system({'ls'}, {
on_stdout = function(chan_id, data, name)  
    vim.notify(vim.inspect(data) .. '\n' .. vim.inspect(name) .. '\n' .. vim.inspect(chan_id))  
end  
```

## Spawning External Processes with `vim.uv`

Neovim's `vim.uv` API is a Lua interface to libuv, an asynchronous  
I/O library used by Neovim for non-blocking operations.  

### Creating Pipes  
```lua  
local stdin = vim.uv.new_pipe()  
local stdout = vim.uv.new_pipe()  
local stderr = vim.uv.new_pipe()  
```
* `vim.uv.new_pipe()` creates new pipe objects for standard input, output, and error.  
    * These pipes are used to communicate with the spawned process.  


### Debugging Prints  
```lua  
print('stdin', stdin)  
print('stdout', stdout)  
print('stderr', stderr)  
```
* These lines print the pipe objects to Neovim's command line for debugging purposes, showing that the pipes have been created successfully.  


### Spawning the External Process  
```lua  
local handle, pid = vim.uv.spawn('cat', {
    stdio = { stdin, stdout, stderr },
}, function(code, signal) -- on exit  
    print('exit code', code)  
    print('exit signal', signal)  
end)  
```
* `vim.uv.spawn` is used to start an external process (`cat` in this instance), with the `stdio` option set to the previously created pipes, allowing the process to interact with Neovim.  
* The anonymous function provided as the last argument to `spawn` is a callback that will be called when the process exits, printing the exit code and signal.  


### Monitoring Process Output  
```lua  
print('process opened', handle, pid)  
-- One read for stdout and one for stderr  
vim.uv.read_start(stdout, function(err, data) 
    assert(not err, err)  
    if data then  
        print('stdout chunk', stdout, data)  
    else  
        print('stdout end', stdout)  
    end  
end)  

vim.uv.read_start(stderr, function(err, data)  
    assert(not err, err)  
    if data then  
        print('stderr chunk', stderr, data)  
    else  
        print('stderr end', stderr)  
    end  
end)  
```
* These blocks of code start reading data from the `stdout` and `stderr` pipes asynchronously.  
    * When data is received, it prints the data chunk to Neovim's command line.  
    * If an error occurs, it's asserted to ensure it's handled properly.  
    * When there's no more data (indicating the end of the stream), it prints  
      a message indicating the end.  

### Writing to the Process's Standard Input  
```lua  
vim.uv.write(stdin, 'Hello World')  
```
* This sends the string `'Hello World'` to the process's standard input through the `stdin` pipe.  


### Closing the Standard Input  

```lua  
vim.uv.shutdown(stdin, function()  
    print('stdin shutdown', stdin)  
    if handle then  
        vim.uv.close(handle, function()  
            print('process closed', handle, pid)  
        end)  
    end  
end)  
```
* This initiates a shutdown of the `stdin` pipe.  
    * The callback function is called once the shutdown is complete, 
      printing a message to indicate this.  
    * It's important to shutdown the `stdin` to signal to the spawned 
      process (in this case, `cat`) so that no more data will be sent.  

### Closing the Process  
```lua  
    if handle then  
        vim.uv.close(handle, function()  
            print('process closed', handle, pid)  
        end)  
    end  
```
* After shutting down `stdin`, this code checks if the process handle is still active.  
    * If the process handle is still active, it closes the handle using `vim.uv.close`.  
    * The callback function prints a message indicating that the process  
      has been closed, along with the process handle and PID for confirmation.  


---  


## `uv.spawn()` Parameters:  
`uv.spawn()` accepts the parameters:  
* `path`: `string`
* `options`: `table` 
* `on_exit`: `callable`
    * `code`: `integer`
    * `signal`: `integer`

Returns: 
* `handle` (`uv_process_t userdata`) 
* `PID`    (`integer`) 

```lua  
local stdin = vim.uv.new_pipe()  
local stdout = vim.uv.new_pipe()  
local stderr = vim.uv.new_pipe()  
 
uv.spawn("cat", {
    stdio = {stdin, stdout, stderr} -- These must be made with new pipes (`vim.uv.new_pipe()`)  
}, function(code, signal) -- on exit  
    print("exit code", code)  
    print("exit signal", signal)  
end)  
```

### `uv.spawn()`'s `options` parameter  
The `options` table accepts the fields:  

* `options.args` - CLI arguments as a list of strings.  
    * The first string should not be the path to the program, since that is already  
      provided via `path`.  
    * On Windows, this uses `CreateProcess` which concatenates the arguments into a string.  
    * This can cause some strange errors (see `options.verbatim` below for Windows).  

* `options.stdio`
    * Set the file descriptors that will be made available to the child process.  
    * The convention is that the first entries are stdin, stdout, and stderr.  

* `options.env`
    * Set environment variables for the new process.  
* `options.cwd`
    * Set the current working directory for the sub-process.  
* `options.uid`
    * Set the child process' user id.  
* `options.gid`
    * Set the child process' group id.  
* `options.verbatim`
    * If true, do not wrap any arguments in quotes (or any other escaping) when  
      converting the argument list into a command line string.  
    * This option is only meaningful on Windows systems.  
    * On Unix it is silently ignored.  

* `options.detached` 
    * If true, spawn the child process in a detached state 
    * This will make it a process group leader, and will effectively enable  
      the child to keep running after the parent exits.  
    * The child process will still keep the parent's event loop alive unless the parent  
      process calls `uv.unref()` on the child's process handle.  

* `options.hide` 
    * If true, hide the subprocess console window that would normally be created.  
    * This option is only meaningful on Windows systems.  
    * On Unix it is silently ignored.  

### `options.stdio`
The `options.stdio` entries can take many shapes.  

* If they are numbers, then the child process inherits that  
  same zero-indexed `fd` from the parent process.  
* If `uv_stream_t` handles are passed in, those are used as a read-write pipe or  
  inherited stream depending if the stream has a valid `fd`.  
* Including `nil` placeholders means to ignore that `fd` in the child process.  

When the child process exits, `on_exit` is called with an exit code and signal.  

`uv.spawn()` returns: `uv_process_t userdata` (handle), `integer` (PID)  



## Full Example Script  
###### *:h uv.spawn*  
```lua  
local stdin = vim.uv.new_pipe()  
local stdout = vim.uv.new_pipe()  
local stderr = vim.uv.new_pipe()  

print('stdin', stdin)  
print('stdout', stdout)  
print('stderr', stderr)  

local handle, pid = vim.uv.spawn('cat', {
    stdio = { stdin, stdout, stderr },
}, function(code, signal) -- on exit  
    print('exit code', code)  
    print('exit signal', signal)  
end)  

print('process opened', handle, pid)  

vim.uv.read_start(stdout, function(err, data)  
    assert(not err, err)  
    if data then  
        print('stdout chunk', stdout, data)  
    else  
        print('stdout end', stdout)  
    end  
end)  

vim.uv.read_start(stderr, function(err, data)  
    assert(not err, err)  
    if data then  
        print('stderr chunk', stderr, data)  
    else  
        print('stderr end', stderr)  
    end  
end)  

vim.uv.write(stdin, 'Hello World')  

vim.uv.shutdown(stdin, function()  
    print('stdin shutdown', stdin)  
    if handle then  
        vim.uv.close(handle, function()  
            print('process closed', handle, pid)  
        end)  
    end  
end)  

```

