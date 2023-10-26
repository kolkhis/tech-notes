
## lynx - Terminal Browser
The ORIGINAL text-based browser
Designed for systems with multiple users

Why use lynx? 
    * Speed
    * Privacy
    * Copypastability
    * 

----------

### Installing

`$ sudo apt install lynx`

`type lynx`
`# /usr/bin/lynx`
----------

### Get Rid of Default Bindings

`,` (comma) will open the page in a GUI Browser

Find lynx config:

`man lynx`
lynx.lss > colors
lynx.cfg > config


> httsp://github.com/rwxrob/dot/blob/main/lynx/setup

Can use cURL to get the files.
    `$ curl -O {raw githubusercontent link}`
    `$ mv lynx.* ~/.local/bin/lynx`


## Source a new file to run
        printf ${PATH//:/\\n}
        Shows PATH in a nice way.

#### Need to make a place to store executables.

~/.local/bin 
    > Path for custom executables.


Getting Pics
- Find alt text of an image, and press `,` (comma) on it


# Search Engine & ChatGPT in the Terminal
sudo apt install gpt

curl -O https://raw.githubusercontent.com/rwxrob/dot/main/scripts/gpt
head: cannot open '/home/kolkhis/.config/gpt/token' for reading: No such file or directory
^ head means it's looking at the top, line 1

* **API Keys**: Store in a **file**, *not* environment variables.
* BE PARANOID ABOUT CLI TOOLS!

Four different sides of the web:
- doc web
- app web
- streaming web
- conversational web








Linux filter cmd history:
Make sure `set -o vi` is enabled.
`/search_term` - in normal mode (not insert). Then `n` and `N` to choose.

* Screenkey: Show Keys on screen
`$ sudo apt install screenkey`


After rebinding <leader> (default is <C-b> for tmux):
tmux: Ctrl a + smth


tmux 
copy mode
    Ctrl-a [
paste
    Ctrl-a ]


Extra Credit: alias ??? to search Google.
?? To use ChatGPT

w3m is a terminal browser that has support for images and JS.
Prioritizes images over text (dumb)


### Off-topic notes
"Progressive Web Design (PWA)"
Works for all users regardless of their browser choice.
- Important for blind users.


















Never use FTP, only SFTP
<!-- `zet` - Command -->
dev.to BLOCKS TEXT BROWSERS LOL


`wget` good for copying lots of things
`curl` is what you're gonna use a lot


vi mode for terminal:
`set -o vi`
Then you can search bash history with:
/<search_term> (in normal mode, NOT insert mode.)
Then `n` for next, `N` for previous.


args on the cmdline can be seen by anyone on the system


# Making Custom Binaries (executables)
~/.local/bin 
    > Path for custom executables.


## CLI Tools to Become Familiar With
xclip
npv/nvp # sound clips, pulse audio
ESXi
Ncdu
pandoc
ffmpeg

### Some Bash Tips
exec is the preferred way to hand off to another process.

exec bash -l
> This will reload shell (for .bashrc etc reloads)

### Untar file
Download the file
`curl -LO (tarfile link)` 
#### check file (check that it isn't a tarbomb)
`tar tvf (tarfile)`

#### Then untar (unzip) the file. 

tar zxvf (tarfile) 

