# Autocommands in Vim/Neovim


## Removing Autocommands
> *`:h autocmd!`* | *`autocmd-remove`*
Using `:au!` will remove the autocommand(s) based on the other arguments.   
### Removing Autocommands for Certain `augroups`
```vim
:au! [group]            " Remove all autocommands from [augroup]"
:autocmd! MarkDownAug   " Remove all autocmds from the MarkDownAug augroup
```

## Autocommand Patterns
> *`:h aupat`* | *`autocmd-pattern`*
 
The {aupat} argument of `:autocmd` can be a comma-separated list.
```vim
:autocmd BufRead *.txt,*.info set et
" Is equivalent to: 
:autocmd BufRead *.txt set et
:autocmd BufRead *.info set et
```
### Using Expressions (like `<cword>`) in Autocommand Patterns
> *`:h *E499`* | *`E500`* | *`<afile>`*
When using `<abuf>` in an autocmd, it will be replaced with the current **active** 
buffer number (like `bufnr()`). 
For the name of the buffer: `bufname()`


## Autocommand Events and Event Data
            *v:event* *event-variable*
**`v:event`**    
Dictionary of event data for the current autocommand.  Valid
only during the event lifetime; storing or passing v:event is
invalid!  Copy it instead: 
    >
* `au`: 
    TextYankPost * let g:foo = deepcopy(v:event)
    Keys vary by event; see the documentation for the specific
    event, e.g. DirChanged or TextYankPost.
* `KEY`: 
    DESCRIPTION ~
* `abort`: 
    Whether the event triggered during
    an aborting condition (e.g. c_Esc or
            c_CTRL-C for CmdlineLeave).
* `chan`: 
    channel-id
* `cmdlevel`: 
    Level of cmdline.
* `cmdtype`: 
    Type of cmdline, cmdline-char.
* `cwd`: 
    Current working directory.
* `inclusive`: 
    Motion is inclusive, else exclusive.
* `scope`: 
    Event-specific scope name.
* `operator`: 
    Current operator.  Also set for Ex
    commands (unlike v:operator). For
    example if TextYankPost is triggered
    by the :yank Ex command then
    `v:event.operator` is "y".
* `regcontents`: 
    Text stored in the register as a
    readfile()-style list of lines.
* `regname`: 
    Requested register (e.g "x" for "xyy)
    or the empty string for an unnamed
    operation.
* `regtype`: 
    Type of register as returned by
    getregtype().
* `visual`: 
    Selection is visual (as opposed to,
            e.g., via motion).
* `completed_item`: 
    Current selected complete item on
    CompleteChanged, Is `{}` when no complete
    item selected.
* `height`: 
    Height of popup menu on CompleteChanged
* `width`: 
    width of popup menu on CompleteChanged
* `row`: 
    Row count of popup menu on CompleteChanged,
    relative to screen.
* `col`: 
    Col count of popup menu on CompleteChanged,
    relative to screen.
* `size`: 
    Total number of completion items on
    CompleteChanged.
* `scrollbar`: 
    Is v:true if popup menu have scrollbar, or
    v:false if not.
* `changed_window`: 
    Is v:true if the event fired while
    changing window (or tab) on DirChanged.
* `status`: 
    Job status or exit code, -1 means "unknown". TermClose
