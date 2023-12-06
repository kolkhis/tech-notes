
# Useful Ex Commands  


* See `++opt` for the possible values of `++opt`.  

### `ex-flags`
These flags are supported by a selection of Ex commands.  They print the line  
that the cursor ends up after executing the command:  
* `l`: output like for `:list`
* `#`: add line number  
* `p`: output like for `:print`

The flags can be combined, thus `l#` uses both a line number and `:list` style output.  

---  

### Ex Commands for Inputting Text 

* `:a` `:append`
    * Insert several lines of text below the specified line.  
* `:i` `:in` `:insert`
    * Insert several lines of text above the specified line.  



## Useful for Scripting  


### Insert Mode / Replace Mode  
* `:star[tinsert][!]`
    * `:start` / `:startinsert`
    * Start Insert mode (or `Terminal-mode` in a `terminal` buffer) just after executing this command.  

* `:stopi[nsert]`
    * `:stopi` `:stopinsert`
    * Stop Insert mode or `Terminal-mode` as soon as possible.  

* `:startr[eplace][!]`  
    * `replacing-ex`/`:startreplace`
    * Start Replace mode just after executing this command.  

* `:startg[replace][!]`
    * `:startgreplace`
    * Just like `:startreplace`, but use Virtual Replace mode, like with `gR`.  

### Reading Files  

* `:r[ead] [++opt] [name]`
    * `:r` `:re` `:read`
    * Insert the file `name` (default: current file) below the cursor.  
    * To insert text above the first line use the command `:0r {name}`.  
    * If a file name is given with `:r`, it becomes the `alternate file`.  
        * This can be used when you want to edit that file instead: `:e! #`

An example on how to use `:r !`: 
```vim
:r !uuencode binfile binfile
```
This command reads "binfile", uuencodes it and reads it into the current
buffer.  Useful when you are editing e-mail and want to include a binary file.

* `:{range}r[ead] [++opt] [name]`
    * Insert the file `name` (default: current file) below the specified line.  



* `:[range]r[ead] [++opt] !{cmd}`
    * `:r!` `:read!`
    * Execute `{cmd}` and insert its stdout below the cursor or the specified line.  
    * A temporary file is used to store the output of the command which is then read into the buffer.  
    * `shellredir` is used to save the output of the command,
      which can be set to include stderr or not.  
    * `{cmd}` is executed like with `:!{cmd}`,
        * any `!` is replaced with the previous command `:!`.  

## Pasting text  


                        *:p* *:pr* *:print* *E749*  
:[range]p[rint] [flags]  
            Print [range] lines (default current line).  





# Ex special characters             
* `cmdline-special`

Note: These are special characters in the executed command line.  If you want  
to insert special things while typing you can use the CTRL-R command.  For  
example, `%` stands for the current file name, while CTRL-R % inserts the  
current file name right away.  See `c_CTRL-R`.  

Note:  If you want to avoid the effects of special characters in a Vim script  
you may want to use `fnameescape()`.  Also see `\`=`.  


 In Ex mode, the following characters have a special meaning.  
 These can also be used in the expression function `expand()`.  
 
* `%` Is replaced with the current file name.  

* `#` Is replaced with the alternate file name.  
    * This is remembered for every window.  

* `#n`  (where n is a number) is replaced with the file name of buffer n.  
    * `#0` is the same as `#`.  

* `##`
    * Is replaced with all names in the `argument list` concatenated,
      separated by spaces.  
    * Each space in a name is preceded with a backslash.  

* ```#<n``` (where `n` is a number > 0) 
    * is replaced with old file name `n`.  
    * See `:oldfiles` (`:o`) or `v:oldfiles` to get the number.  

These (except ```#<n```) give the file name as it was typed.  
For an absolute path, you need to add `:p`.  See `filename-modifiers`.  

The ```#<n``` item returns an absolute path, but it will start with `~/` for files  
below your home directory.  

Spaces are escaped except for shell commands. Can use quotes for those:
```vim  
:!ls "%"  
:r !spell "%"  
```

Also see |`=|.  


## Ex Mode Special Words
* `<cword>`: is replaced with the word under the cursor (like `star`)
* `<cWORD>`: is replaced with the WORD under the cursor (see `WORD`)

* `<cexpr>`: is replaced with the word under the cursor, including more
    to form a C expression.
    * when the cursor is on `arg` of `ptr->arg` then the result is `ptr->arg`;
    * when the cursor is on `]` of `list[idx]` then the result is
    `list[idx]`.

* `<cfile>`: is replaced with the path name under the cursor (like what `gf` uses)

* `<afile>`: When executing autocmds, is replaced with the file name of the buffer
             being edited, or the file for a read or write. (`E495`)

* `<abuf>`: When executing autocmds, is replaced with the currently effective buffer number.
    * It is not set for all events, also see `bufnr()`.
    * For `:r file` and `:so file` it is the current buffer,
      the file being read/sourced is not in a buffer. (`E496`)

* `<amatch>`: When executing autocmds, is replaced with the match for
    which this autocommand was executed. (`E497`)
    * It differs from `<afile>` when the file name isn't used to
      match with (for `FileType`, `Syntax` and `SpellFileMissing` events).
    * When the match is with a file name, it is expanded to the full path.

* `<sfile>`: When executing a `:source` command, is replaced with the
             file name of the sourced file. (`E498`)
    * When executing a function, is replaced with the call stack,
      as with `<stack>` (this is for backwards compatibility, using `<stack>` or
      `<script>` is preferred).
    * Note that filename-modifiers are useless when `<sfile>` is not used inside a script.

* `<stack>`: Is replaced with the call stack, using
             `function {function-name}[{lnum}]` for a function line
             and `script {file-name}[{lnum}]` for a script line, and
             `..` in between items.  E.g.:
    * `function {function-name1}[{lnum}]..{function-name2}[{lnum}]`
    * If there is no call stack you get error (`E489`).

* `<script>`: When executing a `:source` command, is replaced with the file
              name of the sourced file.  
    * When executing a function, is replaced with the file name of the
      script where it is defined.
    * If the file name cannot be determined you get error (`E1274`).

* `<slnum>`: When executing a `:source` command, is replaced with the line number. (`E842`)
    * When executing a function it's the line number relative to the start of the function.

* `<sflnum>`: When executing a script, is replaced with the line number.
    * It differs from `<slnum>` in that `<sflnum>` is replaced with
      the script line number in any situation. (`E961`)

## `filename-modifiers`

The file name modifiers can be used after 
`%`, `#`, `#n`, `<cfile>`, `<sfile>`, `<afile>` or `<abuf>`.  


* `%:8`
    * `:8`  Converts the path to 8.3 short format (currently only on MS-Windows).  
* `%:p`
    * `:p` Make file name a full path.  
* `%:.`
    * `:.` Reduce file name to be relative to current directory, if possible.  
* `%:~`
    * `:~`    Reduce file name to be relative to the home directory, if possible.  
* `%:h`
    * `:h`  Head of the file name (the last component and any separators removed).  
    * Cannot be used with :e, `:r` or `:t`.  
* `%:t`
    * `:t`  Tail of the file name (last component of the name).  
    * Must precede any `:r` or `:e`.  
* `%:r`
    * `:r`  Root of the file name (the last extension removed).  
    * When there is only an extension (`.dotfiles`), it is not removed.  
* `%:e`
    * `:e`  Extension of the file name.  
    * When there is only an extension (`.dotfiles`), the result is empty.  
* `%:s`
    * `:s?pat?sub?`
    * Substitute the first occurrence of `pat` with `sub`.  
* `%:gs`
    * `:gs?pat?sub?`
    * Substitute all occurrences of `pat` with `sub`.  
    * Otherwise this works like `:s`.  
* `%:S`
    * `:S` Escape special characters for use with a shell command (see `shellescape()`).  


## Examples

Examples, when the file name is `src/version.c`, & current dir `/home/mool/vim`:  
|   Modifier              |   End Result                      |
|-------------------------|-----------------------------------|
|   `:p`                  |   /home/mool/vim/src/version.c    |
|   `:p:.`                |   src/version.c                   |
|   `:p:~`                |   ~/vim/src/version.c             |
|   `:h`                  |   src                             |
|   `:p:h`                |   /home/mool/vim/src              |
|   `:p:h:h`              |   /home/mool/vim                  |
|   `:t`                  |   version.c                       |
|   `:p:t`                |   version.c                       |
|   `:r`                  |   src/version                     |
|   `:p:r`                |   /home/mool/vim/src/version      |
|   `:t:r`                |   version                         |
|   `:e`                  |   c                               |
|   `:s?version?main?`    |   src/main.c                      |
|   `:s?version?main?:p`  |   /home/mool/vim/src/main.c       |
|   `:p:gs?/?\\?`         |   \home\mool\vim\src\version.c    |

Examples, when the file name is `src/version.c.gz`: 
|   Modifier              |   End Result                      |
|-------------------------|-----------------------------------|
|     `:p`                | /home/mool/vim/src/version.c.gz   |
|     `:e`                |            gz                     |
|     `:e:e`              |          c.gz                     |
|     `:e:e:e`            |          c.gz                     |
|     `:e:e:r`            |          c                        |
|     `:r`                |      src/version.c                |        
|     `:r:e`              |          c                        |     
|     `:r:r`              |      src/version                  |    
|     `:r:r:r`            |      src/version                  |    
  



