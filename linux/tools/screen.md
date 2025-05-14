# GNU Screen  
Any system that doesn't have tmux will almost always have screen.  


## Table of Contents
* [Building from Source](#building-from-source) 
* [Basics](#basics) 
* [Default Keybindings:](#default-keybindings) 
    * [Copy mode](#copy-mode) 
* [Regions](#regions) 
    * [Working with regions (called panes in tmux):](#working-with-regions-called-panes-in-tmux) 
* [Screen Sharing with Multiuser Sessions](#screen-sharing-with-multiuser-sessions) 
    * [Useful Commands for Multiuser Sessions](#useful-commands-for-multiuser-sessions) 


## Building from Source
Build from source to enable 256color support.  
```bash
curl -O https://ftp.gnu.org/gnu/screen/screen-4.9.1.tar.gz
tar -zxvf screen-4.9.1.tar.gz
 
sh autogen.sh                                 &&
./configure --prefix=/usr                     \
            --enable-colors256                \
            --infodir=/usr/share/info         \
            --mandir=/usr/share/man           \
            --with-socket-dir=/run/screen     \
            --with-pty-group=5                \
            --with-sys-screenrc=/etc/screenrc &&
 
sed -i -e "s%/usr/local/etc/screenrc%/etc/screenrc%" {etc,doc}/* &&
make
```


## Basics  

* `screen`
    * Starts a new screen session.  
 
* `screen -ls`
    * This lists all screen sessions. 
    * Tmux has the same thing (as `tmux ls`)  
 
* `screen -r [processid]`
    * This reattaches to the given process.  
    * If there's no `[processid]`, it will reattach to the last screen session.  

* `screen -S [name]`
    * This starts a new screen session with the given name.  
 
* `screen -R [name]`
    * This reattaches to a running screen session with the given name.  
    * If the session doesn't exist, it will be created.  
 
* `screen -d [processid]`
    * This detaches from the given process.  
    * `<C-a>d` is the shortcut for this.  


## Default Keybindings:  

Screen's default `<leader>` is `<Ctrl-a>`
Since this can be changed, I'll use `<leader>` to refer to it.  

* `C-a` is the prefix/leader.  
* `<leader> ?` for a list of keybindings.  
* `<leader>w` (or `<leader>w`) will show which window is active  
* `<leader>0`: will take you to screen 0  
* `<leader>:`: will take you to screen command line  
* `<leader>:help<CR>`: shows help  
* `<leader>c`: Create a new window.  
* `<leader>aa`: Hop between screen windows  
* `<leader>d`: detaches from current window  
    * `screen -r` to reattach  
* `<leader>|`: Split window vertically. (i.e., `<Shift>\`) 
* `<leader>\`: Kill all windows and terminate screen  
    * Don't use this unless know you definitely want to.  


### Copy mode  

* `<leader>[`: Enter copy mode  
    * Select text with `<enter(or space)> motion <enter>`
* `<leader>]`: Paste from screen buffer  

To paste into vim/nvim:  

* `:set paste`
* `i`
* `<leader>]`


## Regions  
Regions don't take on their own terminal instance like in tmux.  
You can use them to access other windows.  
i.e., You can use a region to access window 2 while working in window 1.  


### Working with regions (called panes in tmux):  

* `C-a S` Splits the screen horizontally (capital S). 
* `C-a |` Splits the screen vertically. (not `\`, that kills all the windows).  
* `C-a C-i` switches between regions (panes).  
* `C-a C-tab` also switches between regions (panes).  
* `C-a Q` Kills all regions except the current one. 



## Screen Sharing with Multiuser Sessions  

To share screen session with another user:  

* `<leader>:multiuser on`
    * `<leader>` and then `:` to enter command mode  
    * `:multiuser on` to enable multi-user support  

Get the screen session with `<leader>d` (detach) and `screen -ls`

Then other user will connect with `screen -S [session_name]`
 
This feature of Screen has more robust multi-user support than tmux.  

### Useful Commands for Multiuser Sessions  

* `:displays`: Lists all the currently connected user front-ends (displays).  
    * In this interface you can detach displays.  
        * `d` in the `:displays` interface to detach that display.  
        * `D` in the `:displays` interface to force detach that display.  
    * `<space>` while in this interface to refresh the list.  


The following is an example of what displays could look like:  
```plaintext  
  xterm 80x42 jnweiger@/dev/ttyp4     0(m11)   &rWx  
  facit 80x24 mlschroe@/dev/ttyhf nb 11(tcsh)   rwx  
  xterm 80x42 jnhollma@/dev/ttyp5     0(m11)   &R.x  
   (A)   (B)     (C)     (D)      (E) (F)(G)   (H)(I)  
```
The legend is as follows:  

* `(A)`: The terminal type known by screen for this display.  
* `(B)`: Displays geometry as width x height.  
* `(C)`: Username who is logged in at the display.  
* `(D)`: Device name of the display or the attached device  
* `(E)`:  Display  is  in blocking or nonblocking mode.  The available modes are "nb", "NB", "Z<", "Z>", and "BL".  
* `(F)`: Number of the window  
* `(G)`: Name/title of window  
* `(H)`: Whether the window is shared  
* `(I)`: Window permissions. Made up of three characters.  


---  

