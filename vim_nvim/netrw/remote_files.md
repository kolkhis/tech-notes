
# Remote Files and Directories with Netrw

## Paths to Remote Files
> *:h netrw-path*  

Paths to files are generally user-directory relative for most protocols.
```bash
vim scp://user@host/somefile
vim scp://user@host/subdir1/subdir2/somefile
```
where "somefile" is in the "user"'s home directory.  
Getting a file using root-relative paths, use the full path:
```bash
vim scp://user@host//somefile
vim scp://user@host//subdir1/subdir2/somefile
```


## Editing Remote Files
> *:h netrw-write* | *netrw-nwrite* | *:Nwrite* | *b:netrw_lastfile* 

You can edit remote files by just providing a URL with the protocol 
you want to use to retrieve the file.
```vim
" syntax:
:e [protocol]://[user]@hostname/path/
" to use ssh(scp):
:e scp://[user@]machine[[:#]port]/path 
" or
:Nwrite scp://[user@]machine[[:#]port]/path
```
The port can either be preceded by ':' or '#'.



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



### Default netrw commands used for actions:  
> *:h netrw-externapp*    

If there's a command you use which is different from the standard (for example, `ssh`),
the command that netrw uses can be changed.  

The `g:netrw_local..._cmd` options specify the external program to use handle each local action.  
The `g:netrw_..._cmd` options specify the external program to use handle each remote action/protocol.  

Vim allows you to customize how it interacts with SSH (server name, remote connection command,
etc).
```vim
let g:netrw_servername="NETRWSERVER"    " Name for netrw-ctrl-r to use for its server
let g:netrw_ssh_cmd="ssh"               " executable for netrw to ssh/remote actions
```

## Help Pages
## Remote Settings in netrw
> *:h netrw-transparent*
> *:h netrw-urls*  
> *:h netrw-protocol*  
> *:h .netrc*  
> *:h netrw-externapp*  
> *:h netrw-settings*  


*netrw-browser-var*     : netrw browser option variables  
*netrw-protocol*        : file transfer protocol option variables  
*netrw-settings*        : additional file transfer options  
*netrw-browser-options* : these options affect browsing directories  
*netrw-externapp*       : external apps used for commands in netrw  
