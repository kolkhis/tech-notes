# List of Vim Variables

This is a list of the Vim-builtin (`v:`) variables.

-----------------------

## Most Useful 

* `$NVIM_APPNAME`: Use to isolate nvim instances.  
* `v:servername`: Primary listen-address of Nvim, the first item returned by `
  serverlist()`.
    * See also `serverstart()` `serverstop()`.
* `v:shell_error`: Result of the last shell command.  When non-zero, the last shell 
  command had an error.
* `v:stderr`: `channel-id` corresponding to stderr. The value is always 2;
    * This variable just makes your code more descriptive.
    * Unlike stdin and stdout (see `stdioopen()`), stderr is always
      open for writing.
    ```vim
    :call chansend(v:stderr, "error: toaster empty\n")
    ```
* `v:swapchoice`: `SwapExists` autocommands can set this to the selected choice for 
  handling an existing swapfile:
    * `'o'`: Open read-only
    * `'e'`: Edit anyway
    * `'r'`: Recover
    * `'d'`: Delete swapfile
    * `'q'`: Quit
    * `'a'`: Abort
* `v:true`: Special value used to put "true" in JSON and msgpack.
one
* `v:warningmsg`: Last given warning message.
    * Modifiable (can be set).

* `v:lua`: Prefix for calling Lua functions from expressions.

-------------------------

## All Variables 

All variables found in `:h vim-variable` (or `v:var`/`v:`)
* `v:argv`: The CLI arguments passed to vim.  
* `v:char`: Arg for evaluating `formatexpr`
* `v:charconvert_from`: The name of the character encoding of a file to be converted.
    * Only valid while evaluating the 'charconvert' option.
* `v:charconvert_to`: The name of the character encoding of a file after conversion.
    * Only valid while evaluating the 'charconvert' option.
* `v:cmdarg`: The extra arguments ("++p", "++enc=", "++ff=") given to a file read
  /write command.
* `v:collate`: The current locale setting for collation order of the runtime 
  environment.
* `v:cmdbang`: Set like v:cmdarg for a file read/write command.
    * When a "!" was used the value is 1, otherwise it is 0.
* `v:completed_item`: Dictionary containing the most recent `complete-items` after `
  CompleteDone`.
* `v:count`: The count given for the last Normal mode command.
* `v:count1`: Just like "v:count", but defaults to one when no count is used.
* `v:ctype`: The current locale setting for characters of the runtime environment.
* `v:dying`: Normally zero.  When a deadly signal is caught it's set to one.
* `v:echospace`: Number of screen cells that can be used for an `:echo` message
                  in the last screen line before causing the `hit-enter-prompt`.
* `v:errmsg`: Last given error message. Modifiable (can be set).
* `v:errors`: Errors found by assert functions, such as `assert_true()`.
* `v:event`: Dictionary of event data for the current `autocommand`.
* `v:exception`: The value of the exception most recently caught and not finished.
* `v:exiting`: Exit code, or `v:null` before invoking the `VimLeavePre` and `VimLeave` 
  autocmds.
* `v:false`: Special value used to put "false" in JSON and msgpack.
* `v:fcs_choice`: What should happen after a `FileChangedShell` event was triggered.
* `v:fcs_reason`: The reason why the `FileChangedShell` event was triggered.

---

* `v:fname`: When evaluating `'includeexpr'`: the file name that was detected. Empty otherwise.
* `v:fname_diff`: The name of the diff (patch) file.
    * Only valid while evaluating `'patchexpr'`.
* `v:fname_in` / `v:fname_out`: The name of the input / output file.
    * Valid while evaluating:
        * `'charconvert'`:  file to be converted
        * `'diffexpr'`:     original file
        * `'patchexpr'`:    original file

* `v:fname_new`: The name of the new version of the file. Only valid while 
  evaluating `'diffexpr'`.

---

* `v:folddashes`: Used for 'foldtext': dashes representing foldlevel of a closed fold.
* `v:foldend`: Used for 'foldtext': last line of closed fold.
* `v:foldlevel`: Used for 'foldtext': foldlevel of closed fold.
* `v:foldstart`: Used for 'foldtext': first line of closed fold.

* `v:hlsearch`: Variable that indicates whether search highlighting is on.
    * Setting it makes sense only if `'hlsearch'` is enabled.
    * Setting this variable to `0` acts like the `:nohlsearch` command.
    * Setting it to `1` acts like:
      ```vim
      let &hlsearch = &hlsearch
      ```

* `v:insertmode`: Used for the `InsertEnter` and `InsertChange` autocommand events.
* `v:key`: Key of the current item of a `Dictionary`.
    * Only valid while evaluating the expression used with `map()` and `filter()`.
* `v:lang`: The current locale setting for messages of the runtime environment.
* `v:lc_time`: The current locale setting for time messages of the runtime 
  environment.

* `v:lnum`: Line number for the `foldexpr` `fold-expr`, `formatexpr`, `indentexpr` 
  and `statuscolumn` expressions, tab page number for `guitablabel` and `guitabtooltip`.

* `v:lua`: Prefix for calling Lua functions from expressions.

* `v:maxcol`: Maximum line length.  
    * Depending on where it is used it can be screen columns, characters or bytes.

* `v:mouse_col`: Column number for a mouse click obtained with `getchar()`.
    * This is the screen column number, like with `virtcol()`.
* `v:mouse_lnum`: Line number for a mouse click obtained with `getchar()`.
    * This is the text line number, not the screen line number.
* `v:mouse_win`: Window number for a mouse click obtained with `getchar()`.
    * First window has number 1, like with `winnr()`.
* `v:mouse_winid`: `window-ID` for a mouse click obtained with `getchar()`.
* `v:msgpack_types`: Dictionary containing msgpack types used by `msgpackparse()` and `
  msgpackdump()`.
* `v:null`: Special value used to put "null" in JSON and NIL in msgpack.

* `v:numbermax`: Maximum value of a number.
* `v:numbermin`: Minimum value of a number (negative).

* `v:numbersize`: Number of bits in a Number.
    * This is normally 64, but on some systems it may be 32.
* `v:oldfiles`: List of file names that is loaded from the `shada` file on startup.
* `v:operator`: The last operator given in Normal mode.
* `v:option_command`: Command used to set the option. Valid while executing an `
  OptionSet` autocommand.
* `v:option_new`: New value of the option. Valid while executing an `OptionSet` 
  autocommand.
* `v:option_old`: Old value of the option. Valid while executing an `OptionSet` 
  autocommand.
* `v:option_oldglobal`: Old global value of the option. Valid while executing an `
  OptionSet` autocommand.
* `v:option_oldlocal`: Old local value of the option. Valid while executing an `
  OptionSet` autocommand.
* `v:option_type`: Scope of the set command. Valid while executing an `OptionSet` 
  autocommand.
    * Can be either "global" or "local
      " 


* `v:prevcount`: The count given for the last but one Normal mode command.

* `v:profiling`: Normally zero.  Set to one after using ":profile start". See `
  profiling`
* `v:progname`: The name by which Nvim was invoked (with path removed).
* `v:progpath`: Absolute path to the current running Nvim.

* `v:register`: The name of the register in effect for the current normal mode
		        command (regardless of whether that command actually used a register).
* `v:relnum`: Relative line number for the 'statuscolumn' expression.

* `v:scrollstart`: String describing the script or function that caused the screen to 
  scroll up.
    * It's only set when it is empty, thus the first reason is remembered.
    * It is set to "Unknown" for a typed command.
    * This can be used to find out why your script causes the hit-enter prompt.

* `v:searchforward`: Search direction: 1 after a forward search, 0 after a backward 
  search.
* `v:servername`: Primary listen-address of Nvim, the first item returned by `
  serverlist()`.
* `v:shell_error`: Result of the last shell command.  When non-zero, the last shell 
  command had an error.
* `v:statusmsg`: Last given status message. Modifiable (can be set).
* `v:stderr`: `channel-id` corresponding to stderr. The value is always 2.
    * Use this variable to make your code more descriptive.

* `v:swapchoice`: `SwapExists` autocommands can set this to the selected choice for 
  handling an existing swapfile:
    * `'o'`: Open read-only
    * `'e'`: Edit anyway
    * `'r'`: Recover
    * `'d'`: Delete swapfile
    * `'q'`: Quit
    * `'a'`: Abort

* `v:swapcommand`: Normal mode command to be executed after a file has been opened.
* `v:swapname`: Name of the swapfile found. Only valid during `SwapExists` event.

* `v:t_TYPE`: Value of the `TYPE` type, where `TYPE` is one of:
    * `v:t_blob`: Value of `Blob` type.
    * `v:t_bool`: Value of `Boolean` type.
    * `v:t_dict`: Value of `Dictionary` type.
    * `v:t_float`: Value of `Float` type.
    * `v:t_func`: Value of `Funcref` type.
    * `v:t_list`: Value of `List` type.
    * `v:t_number`: Value of `Number` type.
    * `v:t_string`: Value of `String` type.
* `v:termrequest`: The value of the most recent OSC or DCS control sequence sent from 
  a process running in the embedded `terminal`.
* `v:termresponse`: The value of the most recent OSC or DCS control sequence received 
  by Nvim from the terminal.

* `v:testing`: Must be set before using `test_garbagecollect_now()`.
* `v:this_session`: Full filename of the last loaded or saved session file.
* `v:throwpoint`: The point where the exception most recently caught and not finished 
  was thrown.
    * Not set when commands are typed.

* `v:true`: Special value used to put "true" in JSON and msgpack.

* `v:val`: Value of the current item of a `List` or `Dictionary`.
    * Only valid while evaluating the expression used with `map()` and `filter()`.

* `v:version`: Vim version number: major version times 100 plus minor version.
* `v:vim_did_enter`: 0 during startup, 1 just before `VimEnter`.
* `v:virtnum`: Virtual line number for the 'statuscolumn' expression.
* `v:warningmsg`: Last given warning message.
    * Modifiable (can be set).

* `v:windowid`: Application-specific window "handle" which may be set by any attached 
  UI.
    * Defaults to zero.
    * Note: For Nvim `windows` use `winnr()` or `win_getid()`, see `window-ID`.


