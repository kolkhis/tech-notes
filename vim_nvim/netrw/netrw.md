

# Netrw Customization
> *:h :NetrwSettings*

## Basic Netrw Customization

### Pulling Remote Config
> *:h netrw-source*  

Use the URL notation with the normal file sourcing
command:
```vim
:Nsource "scp://[user@]machine[[:#]port]/path"	" uses scp
```
Nsource supports multiple protocols (scp, dav, fetch, http (wget), rcp, rsync, ftp, sftp)

### Appearance and Basic Behavior
> ##### *:h netrw-browser-settings*  
> ##### *:h netrw-variables*  

These are the basic quality-of-life changes that one would want. Flips the sides on which 'o' and 'v' open 
new windows, gets rid of banner, shows all files, and opens previews in vsplit.
```vim
" put that banner away, netrw. no one wants to see that.
let g:netrw_banner=0      " Remove banner from netrw
let g:netrw_alto=1        " split opens on bottom instead of top
let g:netrw_altv=1        " vsplit opens on right instead of left
let g:netrw_preview=1     " open previews in vsplit
let g:netrw_liststyle=3   " tree view
let g:netrw_hide=0        " show all files (including hidden. default 1)
let g:netrw_chgwin=-1     " -1 is default. Specifies a window number where netrw will open files.

" default - g:netrw_bufsettings="noma nomod nonu nowrap ro nobl"
let g:netrw_bufsettings+=" nu rnu"
```

The `g:netrw_alto` variable can be used to provide
additional splitting control:
| g:netrw_preview | g:netrw_alto |   result       |
|-----------------|--------------|----------------|
|             0   |          0   |  `:aboveleft`  |
|             0   |          1   |  `:belowright` |
|             1   |          0   |  `:topleft`    |
|             1   |          1   |  `:botright`   |

To control sizing, see `g:netrw_winsize`

### Show netrw if vim is launched without a filename or directory
> ##### *:h netrw-activate*  

While running `vi`, `vim`, or `nvim` without an argument afterwards, it opens an empty buffer.  
To instead have it launch netrw on the current directory, 
add this autocmd to runtime config:  
```vim
augroup VimStartup
  au!
  au VimEnter * if expand("%") == "" | e . | endif
augroup END
```


 
---

## Other Netrw Customization Options
> ##### *:h netrw-browser-settings*  

### Changing How Netrw Interacts with the Terminal
#### Local and Remote Terminal Command Options
> *:h netrw-externapp*  

Vim lets you specify the commands it runs in netrw when creating 
directories, files, and performing other actions.  
```vim
let g:netrw_localcopycmd="cp"           " Default for Linux/Unix/MacOS/Cygwin
                                        " For windows: =expand("$COMSPEC")"
let g:netrw_localcopycmdopt=''          " Linux/Unix etc. Windows: =' \c copy'
let g:netrw_localcopydircmd="cp"        " Same, but for directories
let g:netrw_localcopydircmdopt=" -R"    " Args/opts for copydircmd
let g:netrw_localmkdir="mkdir"          " Shell command for making local directory
let g:netrw_localmkdiropt=""            " Opts for localmkdir. Windows: =" \c mkdir"
" ^ These commands also have 'movecmd', and 'rmdir' counterparts

" The above variables also have remote (ssh) counterparts:
let g:netrw_mkdir_cmd="ssh USEPORT HOSTNAME mkdir"

" cmd for listing remote directories. Default:
let g:netrw_list_cmd="ssh HOSTNAME ls -FLa"
let g:netrw_list_cmd_options=NONE       " If it exists, acts as opts for list_cmd
```

### Remote Settings in netrw
> *:h netrw-protocol*  
> *:h .netrc*  

Vim allows you to customize how it interacts with SSH (server name, remote connection command,
etc).
```vim
let g:netrw_servername="NETRWSERVER"    " Name for netrw-ctrl-r to use for its server
let g:netrw_ssh_cmd="ssh"               " executable for netrw to ssh/remote actions
```

#### Editing Remote Files
> *:h netrw-write* | *netrw-nwrite*  

You can edit remote files by just providing a URL with the protocol 
you want to use to retrieve the file.
```vim
" syntax:
:e [protocol]://[user]@hostname/path/
" to use ssh(scp):
:e scp://[user@]machine[[:#]port]/path 
" or use :[range]Nw[rite]
:Nwrite scp://[user@]machine[[:#]port]/path
```
The port can either be preceded by ':' or '#'.
#### Browsing Remote Directories
Browse a directory to get a listing by simply attempting to
edit the directory:
```vim
:e scp://[user]@hostname/path/
:e ftp://[user]@hostname/path/
```

For remote directory browsing, the trailing "/" is necessary 
(the slash tells netrw to treat the argument
as a directory to browse instead of as a file to download).

The Nread command does the same thing:
```vim
:Nread [protocol]://[user]@hostname/path/
```

#### Setting up SSH Key-Based Authentication
> *:h netrw-ssh-hack*  

If you haven't already set up key-based authentication for SSH, the help page above
will walk you through it.  
If you set up a passphrase for your SSH key, you'll need to use `ssh-agent` as well. 
```bash
ssh-agent $SHELL
ssh-add
ssh {serverhostname}
```
External links on speeding up SSH + netrw:
* http://thomer.com/howtos/netrw_ssh.html
* http://usevim.com/2012/03/16/editing-remote-files/




### Visual and Accessibility Options
> *:h netrw-browser-options* | *netrw-browser-var*

You can set up vim so that it basically acts as a side bar filetree browser, just like any other 
plugin that offers the same thing.  
There are other customization options too, like the format of the time display, and how the mouse can
be used, among other things.
```vim
let g:netrw_sizestyle=NONE      " How size is displayed. ="H" for 1024 base human-readable
let g:netrw_list_hide=""        " Pattern(regex) for hiding files. Comma-delimited list

let g:netrw_mousemaps=1         " Enables mouse buttons while browsing. Disable: =0

" Lexplore. :h netrw-c-tab
let g:netrw_usetab=NONE         " If exists (and nonzero), the <tab> map supporting
                                " shrinking/expanding a Lexplore or netrw window is enabled"
let g:netrw_wiw=1               " Min window width to use when shrinking a netrw/Lexplore window

let g:netrw_retmap=NONE         " if in netrw-selected file *   no normalmode <2-leftmouse> map
                                " exists, then the 2-leftmouse will be mapped for return to netrw

let g:netrw_timefmt="%c"        " vim's strftime() format string for displaying time in netrw

let g:netrw_winsize=50          " 50% Initial size of new windows made with "o", "v" ":Hex" or ":Vex"
```

---

## Performing Actions in netrw

### Marking Files
> ##### *:h netrw-mf* | *:h netrw-mr*  

Mark files with `mf` when hovering with the cursor.  

Mark multiple files at a time using regex with `mr`.  
* `mr` takes a shell-style regex.
* Uses the vim function `glob()` 
    * `glob()` doesn't work on remote systems, so `*` is converted into `.*  ` on remote systems.
        *   `:h glob()`, `:h regexp`

You can also use the `:MF` command, which takes a list of files.  
```vim
:MF *.py
```

### Unmarking Files
> ##### *:h netrw-mF*  

Use `mf` on an already marked file to unmark just that file.
The `mF` command will unmark **all** files in the current directory.  
> ##### *:h netrw-mu*  
> `mu` uses the **global AND local** marked files lists.  

Using `mu` will unmark **all currently marked files**.  
This is different from `mF`, as `mF` only unmarks files in the current directory,
whereas `mu` will unmark global **and** all buffer-local marked files.


### Lists
netrw has three "main" lists: 
* Marked Files list
* Argument List  (`:h arglist`)
    * *:h netrw-mX*  
* Buffer list

Each of these lists has a relationship with one another.  
One can add files to one list from another list with the appropriate keys.  

## Argument List
The argument list is used for other editing commands not directly related to netrw:
* `:argument` | `[count]:argu` - edit file [count] in the argument list
    * When [count] is left out, the current entry is used.
* `:next` (`:args_f`) & `:prev` (`:Next`)
* `:rewind`


#### Adding Files to the Argument List
> ##### *:h :arga* | *:argadd*  

Use `:argadd {name}` to add a file with the given name to the argument list.  
If no name is provided, it adds the current buffer name to the argument list.  

> ##### *:h :arge* | *:argedit*  

Use `:argedit {name}` to add the file with the given name to the argument list, and edit it.  
If the name is already in the argument list, that entry is edited.  
This is like using `:argadd` and then `:edit`.  


#### Deleting Files from the Argument List
> ##### *:h :argd* | *:argdelete*  

Use the command `:argd {pattern}` to delete files from the argument list
that match the given pattern (`:h file-pattern`).


#### Define the Argument List and Replace the Current One
> ##### *:h ar* | *:args* | *:args_f*  

Use `:args {arglist}` to define the given arglist as the new argument list, nad edit the first one.  
 



### Marked Files / Argument List
> ##### *:h netrw-ma | netrw-mA*  
> Uses the **global** marked file list.  

* Using `ma`, one moves filenames from the marked file list to the argument list.
* Using `mA`, one moves filenames from the argument list to the marked file list.


### Marked Files / Buffer List
> ##### *:h netrw-cb* | *netrw-cB*    
> Uses the **global** marked file list.  

* Using cb, one moves  filenames from the marked file list to the buffer list.
* Using cB, one copies filenames from the buffer list to the marked file list.



### Arbitrary Vim Commands on Marked Files
> ##### *:h netrw-mv*    
> Uses the **local** marked file list.  

The `mv` map causes netrw to execute an arbitrary vim command on each file on
the **local** marked file list, individually.
1. Mark the files on which you want to run the vim command.
1. Press `mv`
1. Enter the vim command to run on each file.  



### Arbitrary Shell Commands on Marked Files
> ##### *:h netrw-mx*    
> `mx` uses the **local** marked file list.  

* `mx`: This will execute a command on each file **separately**
  ```bash
  # mx
  # Enter command: cat
  cat 'file1'
  cat 'file2'
  ```

> ##### *:h netrw-mX*  
> `mX` uses the **global** marked file list.  
 
* `mX`: This will execute a command all files 'en bloc'. 
  This means that **all** the files will be
  passed to the command you give it.
  ```bash
  # mX
  # Enter command: cat
  cat 'file1' 'file2'
  ```


### Compressing and Decompressing Marked Files
> ##### *:h netrw-mz*  
> Uses the **local** marked file list.  

* If any marked files are compressed, then `mz` will decompress them.
* If any marked files are decompressed, then `mz` will compress them
Uses the command specified by `g:netrw_compress`; by default, that's "`gzip`".  
#### Decompressing Files That Were Not Compressed With `gzip`
Compression programs for *decompression* can be added into a dictionary: 
`g:netrw_decompress` - default value:
```vim
let g:netrw_decompress={  
                        \ ".gz"  : "gunzip" ,
                        \ ".bz2" : "bunzip2" ,
                        \ ".zip" : "unzip" ,
                        \ ".tar" : "tar -xf"
                        \ }
```
Does not contain '7z' by default.



### Copying Marked Files
> ##### *:h netrw-mc*  
> Uses the **global** marked file list.  

You can copy all files in the 'Marked Files' list to a target directory.  
1. Select a target directory with `mt` (`:h netrw-mt`). 
1. Then change directory, and mark the files you want to copy.  
1. Press `mc`.  
The copy is done from the current window (where the marks are) to the target.  
* If one does not have a target directory set with `netrw-mt`, then netrw  
will query you for a directory to copy to.  
* You can copy local directories and their contents to a target directory.  
    *   Does not work on remote directories.  

Settings variables for copying in netrw:  
* `g:netrw_localcopycmd` 
* `g:netrw_localcopycmdopt`
* `g:netrw_localcopydircmd` 
* `g:netrw_localcopydircmdopt`
* `g:netrw_ssh_cmd`



### Using Diff (`vimdiff`) on Marked Files
> ##### *:h netrw-md*  
> Uses the **global** marked file list.  

Uses vimdiff to visualize difference between selected files (two or
three may be selected for this).  
1. Mark the files you want to use `diff` on.
1. Press `md`


### Editing Marked Files
> ##### *:h netrw-me*  
> Uses the **global** marked file list.  

The `me` command will put the marked files on the `arglist` and start
editing them.  
Return the to explorer window with `:Rexplore`.
1. Mark the files you want to edit
1. Press `me`
(use 
* `:n`: edit next file in the arglist
* `:p`: edit previous file in the arglist


### Use Grep (`:vimgrep`) on Marked Files
> ##### *:h netrw-mg*  
> Uses the **global** marked file list.  

The `mg` command will apply `:vimgrep` to the marked files (*`:h :vimgrep`*  ).  
The command will ask for the pattern; then enter:
```vim
/pattern/[g][j]
! /pattern/[g][j]
pattern
```
* The `/g` option will add every match (even ones on the same line) to the Quickfix List.  
* the `/j` option will remove non-matching files from the Marked Files list.  
The pattern is a Vim search pattern (*`:h search-pattern`*  ).  
1. Mark the files you want to `grep`
1. Press `mg`
1. Enter the pattern.



### Hiding and Unhiding Marked Files by Suffix
> ##### *:h netrw-mh*  
> Uses the **local** marked file list.  

The `mh` command extracts the suffices of the marked files and toggles their
presence on the hiding list.



### Moving Marked Files 
> ##### *:h netrw-mm*  
> Uses the **global** marked file list.  

#### **WARNING** for MOVING FILES WITH NETRW:
    A file being moved is first copied and then deleted; if the
    copy operation fails and the delete succeeds, you will lose
    the file.  
To move files using netrw in vim:  
1. Select a target directory with mt (`netrw-mt`).  
1. Then change directory,
1. Mark the files to be moved
1. Press `mm`.  
The move is done from the current window (where the marked files are) to the target.

Settings variables for moving files with netrw:  
* `g:netrw_localmovecmd` 
* `g:netrw_ssh_cmd`
Settings variables for other netrw operations:  
* `g:netrw_ssh_cmd`
* `g:netrw_list_cmd`
* `g:netrw_mkdir_cmd`
* `g:netrw_rm_cmd`
* `g:netrw_rmdir_cmd`
* `g:netrw_rmf_cmd`


### Sourcing Marked Files
> ##### *:h netrw-ms*  
> Uses the **local** marked file list.  

With `ms`, netrw will source the marked files (using vim's `:source` command)



# Setting the Target Directory for Marked Files
> ##### *:h netrw-mt*  

Set the marked file copy/move-to target (see `netrw-mc` and `netrw-mm`):  
  *   If the cursor is on a file name or in the banner, then the netrw window's currently
    displayed directory is used for the copy/move-to target.
    If the target already is the current directory, typing "mf" clears the target.
  *   If the cursor is on a directory name, then that directory is
    used for the copy/move-to target
  * Use :MT [directory] command to set the target	*:h netrw-:MT*  
    This command uses |<q-args>|, so spaces in the directory name are
    allowed without escaping.
  *   With mouse-enabled vim or with gvim, one may select a target by using
    <c-leftmouse>



### Tagging Marked Files with `ctags`
> ##### *:h netrw-mT*  
> Uses the **global** marked file list.  

The `mT` mapping will apply the command in |g:netrw_ctags| (by default, it is
"ctags") to marked files.




### Listing Bookmarks and History in netrw
> ##### *:h netrq-qb*  

Pressing `qb` (query bookmarks) will list both the bookmarked directories and
directory traversal history.


### Set Target Directory Using Bookmarks
> ##### *:h netrw-Tb*  

Sets the marked file copy/move-to target.
The `netrw-qb` map will give you a list of bookmarks (and history).
Choose one of the bookmarks to become your marked file
target by using [count]Tb (default count: 1).


### Set Target Directory Using History
> ##### *:h netrw-Th*  

The `netrw-qb` map will give you a list of history (and bookmarks).
Choose one of the history entries to become your marked file
target by using [count]Th (default count: 0; ie. the current directory).



## User Specified Maps in netrw
> ##### *:h netrw-usermaps*  

Custom user maps can be added.  
Make a variable (`g:Netrw_UserMaps`), to hold a List of lists
```vim
let g:Netrw_UserMaps = [["keymap-sequence","ExampleUserMapFunc"],
                      \ ["keymap-sequence","AnotherUserMapFunc"]]
```
* Vim will go through all entries of `g:Netrw_UserMaps`, and set up maps:
```vim
nno <buffer> <silent> KEYMAP-SEQUENCE
:call s:UserMaps(islocal,"ExampleUserMapFunc")
```
* refreshes if result from that function call is the string
  "refresh"
* if the result string is not "", then that string will be
  executed (`:exe result`)
* if the result is a List, then the above two actions on results
  will be taken for every string in the result List  

The user function is passed one argument; it resembles
```vim
fun! ExampleUserMapFunc(islocal)
```
where `a:islocal` is 1 if it's a local-directory system call or 0 when
remote-directory system call.

### Netrw Functions
> ##### *:h netrw-call* | *netrw-expose* | *netrw-modify*  

Use `netrw#Expose("varname")`          to access netrw-internal (script-local) variables.
Use `netrw#Modify("varname",newvalue)` to change netrw-internal variables.
Use `netrw#Call("funcname"[,args])`    to call a netrw-internal function with specified arguments.

Example: Get a copy of netrw's marked file list:  
```vim
let netrwmarkfilelist= netrw#Expose("netrwmarkfilelist")
```

Example: Modify the value of netrw's marked file list:  
```vim
call netrw#Modify("netrwmarkfilelist",[])
```

Example: Clear netrw's marked file list via a mapping on `gu`  
```vim
fun! ExampleUserMap(islocal)
    call netrw#Modify("netrwmarkfilelist",[])
    call netrw#Modify('netrwmarkfilemtch_{bufnr("%")}',"")
    let retval= ["refresh"]
    return retval
endfun
let g:Netrw_UserMaps= [["gu","ExampleUserMap"]]
```

## Help Pages
*netrw-browser-var*     : netrw browser option variables  
*netrw-protocol*        : file transfer protocol option variables  
*netrw-settings*        : additional file transfer options  
*netrw-browser-options* : these options affect browsing directories  
*netrw-externapp*       : external apps used for commands in netrw  

Netrw Ex Commands:  
* `:h netrw-ex`  

Marking Files:  
* `:h netrw-mf` and `:h netrw-mr` for how to mark files.  

Marked File List/Argument List  
* `:h netrw-cb`
* `:h netrw-cB`
* `:h netrw-qF`
* `:h argument-list`
* `:h :args`

Marked File List/Buffer List:  
* `:h netrw-ma`
* `:h netrw-mA`
* `:h netrw-qF`
* `:h buffer-list`
* `:h :buffers`

Marked Files List/Compression and Decompression	 
* `:h netrw-mz`  

Default netrw commands used for actions:  
The `g:netrw_local..._cmd` options specify the external program to use handle each local action.  
The `g:netrw_..._cmd` options specify the external program to use handle each remote action/protocol.  
* `g:netrw_localmovecmd` 
* `g:netrw_ssh_cmd`
* `g:netrw_ssh_cmd`
* `g:netrw_list_cmd`
* `g:netrw_mkdir_cmd`
* `g:netrw_rm_cmd`
* `g:netrw_rmdir_cmd`
* `g:netrw_rmf_cmd`
* `:h netrw-ssh-hack`
