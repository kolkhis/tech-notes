
# Useful Ex Commands  

## Table of Contents
* [Line Numbers in the Command Line](#line-numbers-in-the-command-line) 
* [Filter](#filter) 
    * [Filtering Example](#filtering-example) 
* [How Bangs `!` in the Command Line are Expanded](#how-bangs-!-in-the-command-line-are-expanded) 
* [Buffer List](#buffer-list) 
    * [Buffer Types](#buffer-types) 
* [Quickfix List](#quickfix-list) 
* [Location List](#location-list) 
* [Searching with :vimgrep or :vim](#searching-with-vimgrep-or-vim) 
* [++opt - Options/Flags for Ex Commands](#++opt---options/flags-for-ex-commands) 
* [Browsing the List of Options](#browsing-the-list-of-options) 
    * [`ex-flags`](#ex-flags) 
* [Ex Commands for Inputting Text](#ex-commands-for-inputting-text) 
* [Redirecting the Output of Ex Commands](#redirecting-the-output-of-ex-commands) 
    * [Redirect Ex command output into a file](#redirect-ex-command-output-into-a-file) 
    * [Redirect Ex command output into a register](#redirect-ex-command-output-into-a-register) 
    * [Redirect Ex command output into system clipboard](#redirect-ex-command-output-into-system-clipboard) 
    * [Redirect Ex command output into variables](#redirect-ex-command-output-into-variables) 
* [Using the Filter Command](#using-the-filter-command) 
* [Useful for Scripting](#useful-for-scripting) 
    * [Insert Mode / Replace Mode](#insert-mode-/-replace-mode) 
    * [Reading Files](#reading-files) 
* [Pasting text](#pasting-text) 
* [Ex special characters](#ex-special-characters) 
* [Dynamically Generating Temporary Files](#dynamically-generating-temporary-files) 
* [Ex Command Substitution](#ex-command-substitution) 
    * [Using Expanded Variables](#using-expanded-variables) 
    * [Using Literal Variable Names](#using-literal-variable-names) 
* [Ex Mode Special Words](#ex-mode-special-words) 


---

Quickref:

* `:t`: Copy a line
```vim
" copy line 10 and paste it below the current line
:10t.
" copy the current line and paste it below line 10
:t10.
```

* `:tab <cmd>`: Open the result of `<cmd>` in a new tab. 
```vim
:tab Man tmux
```

* `xall`: Write all changed buffers and exit Vim.
* `xit`, `x` : Like `:wq`, but write only when changes have been made.

## Line Numbers in the Command Line

Line numbers may be specified with special characters:
| Character | Description
|-|-
| `{number}` | an absolute line number  
| `.` | the current line			  
| `$` | the last line in the file		  
| `%` | equal to 1,$ (the entire file)		  
| `'t` | position of mark t (lowercase)		  
| `'T` | position of mark T (uppercase); when the mark is in another file it cannot be used in a range
| `/{pattern}[/]` | the next line where `{pattern}` matches
| `?{pattern}[?]` | the previous line where `{pattern}` matches
| `\/` | the next line where the previously used search pattern matches
| `\?` | the previous line where the previously used search pattern matches
| `\&` | the next line where the previously used substitute pattern matches


## Filter
Vim filters are used to filter a line or range of lines
through an external program.

```vim
:{range}![!]{filter} [!][arg]
```
Filter `{range}` lines through the external program `{filter}`.

```vim
:.!python3
```
* This takes the current line and "filters" it using `python3`.
* The line is replaced with the output of the `filter` program.

### Filtering Example
You have these three lines in your buffer:
```python
print(12 * 33)
print(12 ** 4 )
print(220 / 12)
```

If you visually select those three lines and then use a filter:
```vim
'<'>!python3
```
Those lines will then be replaced with the output:
```plaintext
396
20736
18.333333333333332
```

## How Bangs `!` in the Command Line are Expanded

Vim replaces the optional bangs `!` with the
latest given command and appends the optional `[arg]`.
```vim
:!echo "Hello, "
" Output: Hello
:!! "World!"
" Expands to: `echo "Hello, " "World!"`
" Output: Hello World
```
* `:!echo "Hello "` just outputs `Hello ` 
* `:!! "World"`: The 2nd bang `!` is expanded to `echo "Hello "`


## Buffer List
Use `:buffers` (or `:files`, or `:ls`) to see the buffer list.  

* `:bad {fname}` / `:badd {fname}`:  Add a file to the buffer list without 
  loading it, if it wasn't listed yet. (Pneumonic: Buffer Add)  
    * You can specify a line number to go to when it's first entered.
    * `:bad 16 file.txt` will go to line 16 of `file.txt` when you first enter it.
* `:balt {fname}`: Same as `:badd`, but also set the `alternate file` for the current
                   window to `{fname}`. (Pneumonic: Buffer Alternate)

* `:b`: Edit buffer given by number, name, or partial name.
* `:sb`: Like `:b` but edit in a split.
* `:br`/`:bf`: Go to the first buffer in the buffer list.  
    * `:sbr`/`:sbf`: Same as above but do it in a split.  
* `:bl`: Go to the last buffer in the buffer list.  
    * `:sbl`: Same as above but do it in a split.  
* `:bm`: Go to the next buffer that has been modified.  
    * You can specify a number and go to the `n`th modified buffer.
    * Also finds buffers not in the buffer list. 
* `:unhide`: Rearranges the screen to open one window for each loaded buffer in the buffer list.
* `:ba`/`:ball` Rearrange the screen to open one window for each buffer in the buffer list.
    * When a count is given, this is the maximum number of windows to open.  

### Buffer Types
There are different buffer types, here are a few:
* quickfix
* help
* terminal
* directory
* scratch
* unlisted

---

## Quickfix List
The following commands create or modify the quickfix list:
* [`:vimgrep`](#searching-with-vimgrep-or-vim)
* `:grep`
* `:helpgrep`
* `:make`
* ... There are more


## Location List
You can prepend `l` to a lot of the commands that manipulate the 
quickfix list to use the location list instead.  
The following commands create or modify the location list:
* `:lvimgrep`
* `:lgrep`
* `:lhelpgrep`
* `:lmake`
* ... There are more

## Searching with :vimgrep or :vim  
To use `:vimgrep` (`:vim`)  to search for patterns across files  
in the current directory, use the syntax:  
```vim  
:vim /pattern/ *  
```
To search recursively:  
* Note: You may need to enable the `globstar` in your shell for this to work.  
```vim  
:vim /pattern/ **/*  
```
This uses the `globstar` feature in bash.  
The recursive searching goes up to 100 directories deep.  
* `:vimgrep` puts all matching files in the `quickfix list`/`error list`.  
    * Using `:lvimgrep` (or `:lvim`) will use the `location list` instead.  
* Just like in substitutions, the `/` can be swapped for another char (i.e., `;`)  
* `:vimgrep` follows the `'ignorecase'` option. 
    * To overrule it put `\c` in the pattern to ignore case or `\C` to match case.

To get the list of all files that were matched (the quickfix list):  
```vim  
:cope  
```

To search for a fixed string instead of a pattern, use the `f` flag:  
```vim  
:vimgrep /myString/f **/*  
```



## ++opt - Options/Flags for Ex Commands  
* See `++opt` for the possible values of `++opt`.  

The `[++opt]` argument can be used to set some options for one command, and to  
specify the behavior for bad characters.  

The form is: `++{optname}` or `++{optname}={value}`  
Where `{optname}` is one of: `++ff`, `++enc`, `++bin`, `++nobin`, `++edit`

| `{optname}` |Long `{optname}`| Purpose  
|-|-|-
|    `++ff`     |   `++fileformat` | overrides the `fileformat` option  
|    `++enc`    |   `++encoding`   | overrides the `fileencoding` option  
|    `++bin`    |   `++binary`     | sets the `binary` option  
|    `++nobin`  |   `++nobinary`   | resets the `binary` option  
|    `++bad`    |                  | specifies behavior for bad characters  
|    `++edit`   |                  | for `:read`: keeps options as if editing a file  
|    `++p`      |                  | for `:write`: creates the file's parent directory  
The `++edit` option is specific to the `:read` command.  
The `++p` option is specific to the `:write` command.  


The `++p` flag creates the parent directory of the file if it does not exist.  
```vim  
:edit foo/bar/file.txt  
:write ++p  
```
That will do `mkdir -p foo/bar; touch file.txt` and then write the file.  
This can be set as default behavior with an autocmd: 
```vim  
" Auto-create parent directories (except for URIs "://").  
au BufWritePre,FileWritePre * if @% !~# '\(://\)' | call mkdir(expand('<afile>:p:h'), 'p') | endif  
```



## Browsing the List of Options  
Browse the list of options with:  
```vim  
:browse set | :bro se  
:options    | :opt  
```

### `ex-flags`
These flags are supported by a selection of Ex commands.  They print the line  
that the cursor ends up after executing the command:  
* `l`: output like for `:list`
* `#`: add line number  
* `p`: output like for `:print`

The flags can be combined, thus `l#` uses both a line number and `:list` style output.  

---  

## Ex Commands for Inputting Text 

* `:a` `:append`
    * Insert several lines of text below the specified line.  
* `:i` `:in` `:insert`
    * Insert several lines of text above the specified line.  

---  

## Redirecting the Output of Ex Commands 
Using `:redir`, you can redirect the output of Ex commands.  
### Redirect Ex command output into a file  
You can redirect into files:  
```vim  
" Overwrite file with output:  
:redir > {file}   
" Append file with output:  
:redir >> {file}
:YourExCommands  
:redir END  
```

### Redirect Ex command output into a register  
You can also redirect into registers:  
```vim  
" Redirect Ex commands' outputs into register `a`:  
:redir @a  
" Optionally, you can use `@a>`:  
:redir @a> 
:YourExCommands  
" Append Ex commands' outputs to register `a`:  
:redir @a>>  
:redir END  
```
Then you can paste them with `"ap`, or `:put a`.  
Leaving out (omitting) the `>` in `:redir @a>` is recommended for 
backwards-compatibility.  

### Redirect Ex command output into system clipboard  
Redirect to the selection or clipboard:  
```vim  
" Overwrite selection/clipboard: 
:redir @*  
:redir @+  
" Or, optionally:  
:redir @*>  
:redir @+>  
" Append to selection/clipboard: 
:redir @*>>  
:redir @+>>  
" Append messages to the unnamed register:  
:redir @">>       
:YourExCommands  
:redir END  
```

### Redirect Ex command output into variables  
You can redirect Ex cmd output into variables; 
if the variable doesn't exist, then it is created.  
Only string variables can be used.  
To redirect into variables:  
```vim  
" Redefine the variable with Ex cmd output:  
:redir => {var}
" Append messages to an existing variable:    
:redi[r] =>> {var}  
```
Note: The variable will remain empty until redirection ends.  

---  

## Using the Filter Command  
```vim  
:filt[er][!] {pattern} {command}
:filt[er][!] /{pattern}/ {command}
```
Restrict the output of `{command}` to lines matching with `{pattern}`.  
For example, to list only xml files from the `oldfiles` command:  
```vim  
:filter /\.xml$/ oldfiles  
```
If the `[!]` is given, restricts the output of `{command}`
to lines that do NOT match `{pattern}`.  


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

* `:[range]p[rint] [flags]`: Print `[range]` lines (default is the current line).  
    * This outputs to the command line, but does not insert anything into the buffer.






## Ex special characters             
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


## Dynamically Generating Temporary Files  
Generate a (non-existent) filename located in the Nvim root 
`tempdir` with `tempname()` (or `vim.fn.tempname()` in lua).  
Scripts can use the filename as a temporary file.  
```vim  
let tmpfile = tempname()  
exe "redir > " .. tmpfile  
```


## Ex Command Substitution  
#####  ``` `= ```
You can have the backticks expanded as a Vim expression, instead of as an  
external command, by putting an equal sign right after the first backtick.  
e.g.: 
```vim  
:e `=tempname()`
```
The expression can contain just about anything, so this can also be used to  
avoid the special meaning of `"`, `|`, `%` and `#`.  

### Using Expanded Variables  
* Environment variables in the expression are expanded when evaluating the expression:  
```vim  
:e `=$HOME .. '/.vimrc'`
```
This will expand `$HOME` to `/home/yourUsername` (or wherever your home is.)  

### Using Literal Variable Names  
* This one uses the literal string `$HOME` and it will be used literally:  
```vim  
:e `='$HOME' .. '/.vimrc'`
```
This will use the string `'$HOME'`, resulting in `'$HOME/.vimrc'`.  

If the expression returns a string then names are separated with line breaks.  
When the result is a `List` then each item is used as a name.  
Line breaks also separate names.  

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
             being edited, or the file for a read or write.   
* `<abuf>`: When executing autocmds, is replaced with the currently effective buffer number.  
    * It's not set for all events, also see `bufnr()`.  
    * For `:r file` and `:so file` it is the current buffer,
      the file being read/sourced is not in a buffer.   

* `<amatch>`: When executing autocmds, is replaced with the match for  
    which this autocommand was executed.   
    * It differs from `<afile>` when the file name isn't used to  
      match with (for `FileType`, `Syntax` and `SpellFileMissing` events).  
    * When the match is with a file name, it is expanded to the full path.  

* `<sfile>`: When executing a `:source` command, is replaced with the  
             file name of the sourced file.   
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

* `<slnum>`: When executing a `:source` command, is replaced with the line number.   
    * When executing a function it's the line number relative to the start of the function.  

* `<sflnum>`: When executing a script, is replaced with the line number.  
    * It differs from `<slnum>` in that `<sflnum>` is replaced with  
      the script line number in any situation.   

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
|   Modifier              |     End Result                      |
|-------------------------|-------------------------------------|
|   `:p`                  |   `/home/mool/vim/src/version.c`    |
|   `:p:.`                |   `src/version.c`                   |
|   `:p:~`                |   `~/vim/src/version.c`             |
|   `:h`                  |   `src`                             |
|   `:p:h`                |   `/home/mool/vim/src`              |
|   `:p:h:h`              |   `/home/mool/vim`                  |
|   `:t`                  |   `version.c`                       |
|   `:p:t`                |   `version.c`                       |
|   `:r`                  |   `src/version`                     |
|   `:p:r`                |   `/home/mool/vim/src/version`      |
|   `:t:r`                |   `version`                         |
|   `:e`                  |   `c`                               |
|   `:s?version?main?`    |   `src/main.c`                      |
|   `:s?version?main?:p`  |   `/home/mool/vim/src/main.c`       |
|   `:p:gs?/?\\?`         |   `\home\mool\vim\src\version.c`    |

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
  
---  

## Debugging with gdb  
##### *:h termdebug-stepping*/*:h :Run*  
The main commands you'll use are `:Run`, to run the program, and  
`:Arguments` to set the arguments.  

These are the Ex commands for *running* Gnu Debugger (gdb):  
| Command               |       Effect                                                  |
|-----------------------|---------------------------------------------------------------|
| `:Run [args]`         | run the program with `[args]` or the previous arguments       |
| `:Arguments {args}`   | set arguments for the next `:Run`                             |
| `:Break`              | set a breakpoint at the current line; a sign will be displayed|
| `:Clear`              | delete the breakpoint at the current line                     |
| `:Step`               | execute the gdb "step" command                                |
| `:Over`               | execute the gdb "next" command (`:Next` is a Vim command)     |
| `:Until`              | execute the gdb "until" command                               |
| `:Finish`             | execute the gdb "finish" command                              |
| `:Continue`           | execute the gdb "continue" command                            |
| `:Stop`               | interrupt the program                                         |


### Inspecting variables 
##### *:h termdebug-variables*/*:h :Evaluate*  

| Command               |       Effect                              |
|-----------------------|-------------------------------------------|
| `:Evaluate`           | evaluate the expression under the cursor  |
| `K`                   | same (see `termdebug_map_K` to disable)   |
| `:Evaluate {expr}`    | evaluate `{expr}`                         |
| `:'<,'>Evaluate`      | evaluate the Visually selected text       |



### Navigating stack frames  
##### *:h termdebug-frames*/*:h :Frame*/*:h :Up*/*:h :Down*  

| Command               |       Effect                              |
|-----------------------|-------------------------------------------|
| `:Frame [frame]` | select frame `[frame]`, which is a frame number,address, or function name (default: current frame)  |
| `:Up [count]`     | go up `[count]` frames (default: 1; the frame that called the current)  |
| `+`               | same (see `termdebug_map_plus` to disable)  |
| `:Down [count]`   | go down `[count]` frames (default: 1; the frame called by the current)|
| `-`               | same (see `termdebug_map_minus` to disable)  |


### Other commands 
| Command   |       Effect                              |
|-----------|-------------------------------------------|
| `:Gdb`    | Jump to the gdb window.  
| `:Program`| Jump to the window with the running program.  
| `:Source` | Jump to the window with the source code, create it if there isn't one.  
| `:Asm`    | Jump to the window with the disassembly, create it if there isn't one.  
| `:Var`    | Jump to the window with the local and argument variables, create it if there isn't one. This window updates whenever the program is stopped. |


