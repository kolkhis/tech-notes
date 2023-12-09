
# Manipulating Windows in Vim  
>#### `:h :vert`/`:vertical`

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

" Look up:
:[N]sf[ind] [++opt] [+cmd] {file}        *:sf* *:sfi* *:sfind* *splitfind*  
```


