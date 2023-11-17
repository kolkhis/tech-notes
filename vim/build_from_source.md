
# Build Vim From Source
The default installation of vim on Ubuntu Server is version 802 (`:echo v:version`), 
and does not come with python or clipboard support.  
The latest version from apt is only 8.2. Building from source is probably the only
way to get an up-to-date vim with full features.  

## Installing Vim With Full Feature Support
To get Vim with Python support, it can be installed from source:  
* `https://github.com/vim/vim/blob/master/src/INSTALL`  
### Dependencies
* Base Installation Dependencies:
    * `git`
    * `make`
    * `clang`
    * `libtool-bin`
* X-windows Clipboard Dependencies:
    * `libxt-dev`
* Python Dependencies:
    * `libpython3-dev`
    * The `CONF_OPT_PYTHON3 = --enable-python3interp` needs to be uncommented from the Makefile.
* GUI Dependencies (lol):
    * `libgtk-3-dev`
* Debugging:
    * `valgrind`
    * Uncomment in Makefile:
    `CFLAGS = -g -Wall -Wextra -Wshadow -Wmissing-prototypes -Wunreachable-code -Wno-deprecated-declarations -U_FORTIFY_SOURCE -D_FORTIFY_SOURCE=1`

## Installing Dependencies (full features):
```bash
sudo apt-get update && sudo apt-get install -y \
git \
make \
clang \
libtool-bin \
libxt-dev \
libpython3-dev \
libgtk-3-dev \
lua5.4 \
liblua5.4-dev \ 
```

## Compiling
> For features that you can't enable/disable in another way, you can edit the
file "feature.h" to match your preferences.  
  
1. Uncomment the desired features in the Makefile
    * Python 3 support
        * `CONF_OPT_PYTHON3 = --enable-python3interp` 
    * Debugging Support with Valgrind
        * `CFLAGS = -g -Wall -Wextra -Wshadow -Wmissing-prototypes -Wunreachable-code -Wno-deprecated-declarations -U_FORTIFY_SOURCE -D_FORTIFY_SOURCE=1`
1. `make` - run configure, compile and link
1. `make install` - installation in /usr/local  
  
> This will include the GUI and X11 libraries, if you have them.  If you want a
version of Vim that is small and starts up quickly, see the Makefile for how
to disable the GUI and X11.  If you don't have GUI libraries and/or X11, these
features will be disabled automatically.

## Language Interfaces
```bash
# Lua
sudo apt install -y lua5.4 liblua5.4-dev
# Perl
sudo apt install -y libperl-dev
# Python
sudo apt install -y libpython3-dev
```

### Enabling the Python Interface
* Required Debian package is "libpython3-dev".
* For Python3 support make a symbolic link in /usr/local/bin (required):
    ```bash
    which python3
    # ---> /usr/bin/python3
    cd /usr/local/bin/
    ln -s /usr/bin/python3 python3.1
    ```
Uncomment the following line from `vim/src/Makefile`
```makefile
CONF_OPT_PYTHON = --enable-pythoninterp
```

### Enabling Lua Interface
* Required Debian package is "lua5.3" and "liblua5.3-dev", OR "lua5.4" and "liblua5.4-dev".
* For Lua support make a symbolic link in /usr/local/bin (not required):
    ```bash
    which lua
    # ---> /usr/bin/lua
    cd /usr/local/bin/
    ln -s /usr/bin/lua .
    ```
Uncomment the following line from `vim/src/Makefile`
```makefile
CONF_OPT_LUA = --enable-luainterp
```

### Enabling Perl Interface
* Required Debian package is "libperl-dev"
Uncomment the following line from `vim/src/Makefile`
```makefile
CONF_OPT_PERL = --enable-perlinterp
```

### Enabling the Ruby Interface
* Required Debian package is "ruby-dev".
Uncomment the following line from `vim/src/Makefile`
```makefile
CONF_OPT_RUBY = --enable-rubyinterp
```

### After Editing Makefile
When you're done enabling the options you want
in the Makefile, run:
```bash
make reconfig
```

## TL;DR: Uncomment These in Makefile 
This will be what needs to be uncommented for compiling Vim  
with lua, ruby, perl, and python3 support.  
Uncomment the following lines from the Makefile:  
```Makefile
# Don't build the GUI version
CONF_OPT_GUI = --disable-gui

# Enable Lua
CONF_OPT_LUA = --enable-luainterp
# Make sure the exe is symlinked to /usr/local/bin
CONF_OPT_LUA_PREFIX = --with-lua-prefix=/usr/local

# Enable Perl
CONF_OPT_PERL = --enable-perlinterp
# Enable Python
CONF_OPT_PYTHON3 = --enable-python3interp
# Get the features, all the features
CONF_OPT_FEAT = --with-features=huge

# OPTIONAL: Change name and email in '--with-compiledby'
CONF_OPT_COMPBY = "--with-compiledby=Kolkhis <36500473+Kolkhis@users.noreply.github.com>"
```
Then, run:
```bash
make
# OR, if you've already run `make`:
make reconfig
```

## Starting Over
If you screwed it up the first time (like I did), go to 
vim/src (where you first ran `make`) and then run:
```bash
# in vim/src
make distclean   # or clean, distclean is more thorough.
```
Now, reconfigure and/or install 
the things that need installing.  
When you think you've got everything, run:
```bash
make
```


