
# Manipulating Windows in Vim  
>#### `:h :vert`/`:vertical`

TODO: 
Take notes on:  
1. Floating windows and popups in nvim/lua  
1. All builtin window handling functions.  


## Table of Contents
* [Easy Formatting](#easy-formatting) 
* [Using :wincmd or `<C-w>` to manipulate windows](#using-wincmd-or-cw-to-manipulate-windows) 



## Easy Formatting  
| Ex Command        | Effect            |
|-------------------|-------------------|
| `:ri`/`:right`    | Right-Align Text  |
| `:ce`/`:center`   | Center-Align Text |
| `:le`/`:left`     | Left-Align Text   |


* `:verbose pwd`
```vim  
" Set by :cd  
:verbose pwd  
[global] /path/to/current  

" Set by :lcd  
:verbose pwd  
[window] /path/to/current  

" Set by :tcd  
:verbose pwd  
[tabpage] /path/to/current  

" Split Find (:split with :find):  
:[N]sf[ind] [++opt] [+cmd] {file}        *:sf* *:sfi* *:sfind* *splitfind*  
```

## Using :wincmd or `<C-w>` to manipulate windows  
Anything that can be done with `:wincmd` can be done with `<C-w>`,
and vice versa.  

These commands control:  
Moving between, resizing, and adjusting the layout of windows and panes. 
```vim  
" Maximize current window height  
:wincmd _ 

" Maximize current window width  
:wincmd |

" Move window to far left/top/right/bottom 
:wincmd HMJL  

" Move current window to new tabpage  
:wincmd ]  

" Move current window to previous tabpage 
:wincmd [  

" Close current window  
:wincmd c  

" Split window horizontally and move to the new window 
:wincmd s  

" Split window vertically and move to the new window  
:wincmd v 

" Move to window number 3
:exe 3 . 'wincmd w'  

" Go to window number N  
:exe N . 'wincmd w'  

" Go to last accessed window 
:wincmd p 

" Go to previously accessed window  
:wincmd P 

" Rotate windows forwards  
:wincmd r  

" Rotate windows backwards  
:wincmd R  

" Move window to new tab page  
:wincmd T  

" Move window to previous tab page  
:wincmd t  


"""" Resizing windows and panes """"  
" Increase current window height by N (default 1) 
:wincmd N+  

" Decrease current window height by N (default 1)  
:wincmd N-  

" Set window height to N 
:exe 'wincmd ' . N  

" Increase current window width by N (default 1)  
:wincmd N> 

" Decrease current window width by N (default 1) 
:wincmd N<  

" Set window width to N  
:exe 'wincmd ' . N . '|'  
```

