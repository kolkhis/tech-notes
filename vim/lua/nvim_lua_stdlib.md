

# Lua Standard Library

1. The Nvim Lua "standard library" (stdlib) is the `vim` module.
    1. It's always loaded, so `require("vim")` is unnecessary.


## Setting a Timer
Use the `vim.uv` module
`vim.uv` exposes the "luv" Lua bindings for the libUV library that Nvim uses
for networking, filesystem, and process management, see `luvref.txt`.
```lua
    -- Create a timer handle (implementation detail: uv_timer_t).
    local timer = vim.uv.new_timer()
    local i = 0
    -- Waits 1000ms, then repeats every 750ms until timer:close().
    timer:start(1000, 750, function()
      print('timer invoked! i='..tostring(i))
      if i > 4 then
        timer:close()  -- Always close handles to avoid leaks.
      end
      i = i + 1
    end)
    print('sleeping');
```

## Detect File Changes
See `:h watch-file`
```lua
    local w = vim.uv.new_fs_event()
    local function on_change(err, fname, status)
      -- Do work...
      vim.api.nvim_command('checktime')
      -- Debounce: stop/start.
      w:stop()
      watch_file(fname)
    end
    function watch_file(fname)
      local fullpath = vim.api.nvim_call_function(
        'fnamemodify', {fname, ':p'})
      w:start(fullpath, {}, vim.schedule_wrap(function(...)
        on_change(...) end))
    end
    vim.api.nvim_command(
      "command! -nargs=1 Watch call luaeval('watch_file(_A)', expand('<args>'))")
```

