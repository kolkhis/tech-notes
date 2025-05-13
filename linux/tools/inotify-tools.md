# `inotify-tools` (`inotifywait`)

The `inotify-tools` package comes with several tools that can be used to watch files
for changes.  


## `inotifywait`

The `inotifywait` tools comes with the `inotify-tools` package.  

It waits for changes to files (using `inotify` or `fanotify`, the latter from C) and 
can be used inside shell scripts to execute arbitrary code whenever the watched files 
are modified.  


### `inotifywait` Output
Whenever the watched file changes, it outputs an "event."  
By default the event uses the format:
```bash
watched_filename EVENT_NAMES event_filename
```
- `watched_filename`: The name of the file that the change occurred in.  
- `EVENT_NAMES`: Comma-separated `inotify` events that occurred.  
- `event_filename`: Only outputs when the event occurred on a directory.
    - This will hold the name of the file inside that directory which caused the "event."  

### `inotifywait` Usage

- `-m`: Monitor mode. Execute indefinitely. The default is to exit after the first event.  
    - You'll probably want to use this inside scripts.  
- `-r`: Recursive. Watch all subdirectories of any dirs being watched.  

- `-d`: Daemon. Same as `--monitor` but runs in the background.  
    - Logs events to a file (`--outfile` required).  
    - Also implies `--syslog`.  

- `-s`: Syslog. Outputs errors to system log module rather than `stderr`.  
    - `man 3 syslog`

- `-e`: Event. Listen for specific events only.  
    - Common events:
        - `access`
        - `modify`
        - `create`
        - `delete`
    - `man://inotifywait /^\s*EVENTS`




