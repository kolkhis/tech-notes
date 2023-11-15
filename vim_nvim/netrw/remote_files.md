
# Remote Files and Directories with Netrw

## Remote Settings in netrw
> *:h netrw-protocol*  
> *:h .netrc*  
> *:h netrw-externapp*  
> *:h netrw-settings*  


### Default netrw commands used for actions:  
> *:h netrw-externapp*    

The `g:netrw_local..._cmd` options specify the external program to use handle each local action.  
The `g:netrw_..._cmd` options specify the external program to use handle each remote action/protocol.  

Vim allows you to customize how it interacts with SSH (server name, remote connection command,
etc).
```vim
let g:netrw_servername="NETRWSERVER"    " Name for netrw-ctrl-r to use for its server
let g:netrw_ssh_cmd="ssh"               " executable for netrw to ssh/remote actions
```

## Editing Remote Files
> *:h netrw-write* | *netrw-nwrite* | *:Nwrite* | *b:netrw_lastfile*  

Nwrite uses the `b:netrw_lastfile` variable for writing
```vim
:Nwrite "scp://[user@]machine[[:#]port]/path" " uses scp
```

## Browsing Remote Directories
> *:h netrw-dirlist* | *netrw-trailingslash*  

Browse a directory to get a listing by simply attempting to
edit the directory:
```vim
:e scp://[user]@hostname/path/
:e ftp://[user]@hostname/path/
```

For remote directory browsing, the trailing "/" is required. 
(the slash tells netrw to treat the argument
as a directory to browse instead of as a file to download).

The Nread command does the same thing:
```vim
:Nread [protocol]://[user]@hostname/path/
```

## Setting up SSH Key-Based Authentication
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


## Help Pages
*netrw-browser-var*     : netrw browser option variables  
*netrw-protocol*        : file transfer protocol option variables  
*netrw-settings*        : additional file transfer options  
*netrw-browser-options* : these options affect browsing directories  
*netrw-externapp*       : external apps used for commands in netrw  
