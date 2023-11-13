

# netrw Customization


## Basic Customization
These are the basic quality-of-life changes that one would want. Flips the sides 'o' and 'v' open 
new windows on from netrw, gets rid of banner, shows all files, and opens previews in vsplit.
```vim
" put that banner away, netrw. no one wants to see that.
let g:netrw_banner=0      " Remove banner from netrw
let g:netrw_alto=1        " split opens on bottom instead of top
let g:netrw_altv=1        " vsplit opens on right instead of left
let g:netrw_preview=1     " open previews in vsplit
let g:netrw_liststyle=3   " tree view
let g:netrw_hide=0        " show all files (including hidden. default 1)
```

## Other Customization Options

### Local and Remote (ssh) Terminal Command Options
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

" They also have remote (ssh) counterparts:
let g:netrw_mkdir_cmd="ssh USEPORT HOSTNAME mkdir"

" cmd for listing remote directories. Default:
let g:netrw_list_cmd="ssh HOSTNAME ls -FLa"
let g:netrw_list_cmd_options=NONE       " If it exists, acts as opts for list_cmd
```

### Remote SSH Settings in netrw
Vim allows you to customize how it interacts with SSH (server name, remote connection command,
etc).
```vim
let g:netrw_servername="NETRWSERVER"    " Name for netrw-ctrl-r to use for its server
let g:netrw_ssh_cmd="ssh"               " executable for netrw to ssh/remote actions
```

### Visual and Accessibility Options
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

let g:netrw_retmap=NONE         " if in netrw-selected file * no normalmode <2-leftmouse> map
                                " exists, then the 2-leftmouse will be mapped for return to netrw

let g:netrw_timefmt="%c"        " vim's strftime() format string for displaying time in netrw

let g:netrw_winsize=50          " 50% Initial size of new windows made with "o", "v" ":Hex" or ":Vex"
```


## Performing Actions in netrw

### Marking Files
> *:h netrw-mf* | *:h netrw-mr*
Mark files with `mf` when hovering with the cursor.  
You can also use the `:MF` command, which takes a list of files.  
```vim
:MF *.py
```

### Lists
netrw has three "main" lists: 
* Marked Files list     `:h `
* Argument List         `:h arglist`
    * > *:h netrw-mX*
* Buffer list

Each of these lists has a relationship with one another.  
One can add files to one list from another list with the appropriate keys.  

### Marked Files / Argument List
> *:h netrw-ma* | *netrw-mA*
* Using `ma`, one moves filenames from the marked file list to the argument list.
* Using `mA`, one moves filenames from the argument list to the marked file list.

### Marked Files / Buffer List
> *:h netrw-cb* | *netrw-cB*
* Using cb, one moves  filenames from the marked file list to the buffer list.
* Using cB, one copies filenames from the buffer list to the marked file list.

### Marked Files - Compression and Decompression
> *:h netrw-mz*
* If any marked files are compressed,   then "mz" will decompress them.
* If any marked files are decompressed, then "mz" will compress them

Uses the command specified by `g:netrw_compress`; by default, that's "gzip".

### Arbitrary Shell Commands on Marked Files
> *:h netrw-mx*
* `mx`: This will execute a command on each file separately
  ```bash
  # mx
  # Enter command: cat
  cat 'file1'
  cat 'file2'
  ```

* `mX`: This will execute a command all files 'en bloc'. This means that all the files will be
  passed to the command you give it.
  ```bash
  # mX
  # Enter command: cat
  cat 'file1' 'file2'
  ```


## Help Pages
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
> *:h netrw-mz*
