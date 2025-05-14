
# Macros in Vim  


## Table of Contents
* [Recording a Macro](#recording-a-macro) 
* [Paste a Recorded Macro](#paste-a-recorded-macro) 
* [Repeating Macro](#repeating-macro) 
* [Apply Macro to a Visual Selection](#apply-macro-to-a-visual-selection) 
* [Some keymaps](#some-keymaps) 
* [tl;dr: Recursive Macros](#tldr-recursive-macros) 
* [Recursive Macros (more detailed)](#recursive-macros-more-detailed) 
* [Making a Numbered List Using Macros](#making-a-numbered-list-using-macros) 
* [Etc](#etc) 


## Recording a Macro  

To record a macro in vim, just hit `q` followed by another letter.  
The other letter will be the register to record that macro into.  
For example, `qq` will start recording a macro into the register `q`.  


## Paste a Recorded Macro  
* `"qp` - Paste the macro recorded in the register `q`

## Repeating Macro  
* `Q`: Repeat the last *recorded* macro.  
* `@@`: Repeat the last *executed* macro.  


## Apply Macro to a Visual Selection  
Apply a macro to visual selection by calling `norm` with the macro:  
```vim  
:'<,'>norm @q  
```
> Side Note: You can also use this method with `cdo` or any  
> other commands/keystrokes you want to apply to each line.  


## Some keymaps  
```lua  
vim.keymap.set('n', 'Q', '@qj')  
vim.keymap.set('x', 'Q', ':norm @q<CR>')  
```


## tl;dr: Recursive Macros  
To make a macro recursive, you'll need to nest append a macro call  
to itself within the macro. 
Here's how:  
1.  **Position my cursor where I want to make the first change**  
2.  `qa` - start recording into register `a`
3.  **Make all my changes, doing it in a way that should apply cleanly to all locations**  
4.  `q` - stop recording  
5.  **Position cursor on next location I want changed**  
6.  `@a` - run the macro to test and make sure it works as intended  
7.  `qA` - start recording to append to macro register `a`
8.  **Move cursor to next location to change**  
9.  `@a`
10. `q`
Now you can call `@a` and it will repeat.  

## Recursive Macros (more detailed)  
To create a recursive macro, you need to first record the macro you want to repeat.  
For this example, we'll be using the `a` key as a macro register.  

1. Press `q` then another key to start recording to that macro register.  
    * e.g., `qa` will record to the `a` macro register.  
1. Perform the actions that you want to repeat.  
1. Stop recording with `q`.  
1. To make it recursive, you now need to **append** to the same macro register.  
    * To do this, press `q` and then `<Shift>+(original_register)` - the **capital** 
      of the key you chose.  
    * Since we chose `a`, we'd enter `qA`.  
      This **appends** to the macro in the `a` macro register.  
1. Now that you're appending, you want to enter the original macro (so the macro contains the  
   command to call itself). You only need to do this once.  
    * Press `@a` to call the macro.  
    * This calls the macro from within the macro, making it **recursive**.  
        * It's **appending** a macro call to itself to the macro.  
1. Exit macro recording with `q`.  
1. Now, call your recursive macro with `@a` (assuming you chose the `a` register)  


## Making a Numbered List Using Macros
1. Create the first list entry, make sure it starts with a number.
2. `qa`	     : start recording into register 'a'
3. `Y`	     : yank the entry
4. `p`	     : put a copy of the entry below the first one
5. `CTRL-A`  : increment the number
6. `q`	     : stop recording
7. `<cnt>@a` : repeat the yank, put and increment `<count>` times



## Etc  

A very common macro is `{!}fmt` (reformat the current paragraph).  

Can run files as pseudo-macros.  
E.g., a seven line file (36 characters) which runs a file through `wc`,
  and inserts a C-style comment at the top of the file containing that 
  word count data.  

I can apply that "macro" to a file by using a command like:  
`vim +'so mymacro.ex' ./mytarget`


The `+` command line option to vi/Vim is normally used to start the editing session at a given line number.  
It's a little known fact that one can follow the `+` by any valid ex command/expression,
such as a "source" command as I've done here;  
for a simple example I have scripts which invoke:  
```bash  
vi +'/foo/d|wq!' ~/.ssh/known_hosts 
```
to remove an entry from my SSH known hosts file non-interactively 
while I'm re-imaging a set of servers).  


The `@` command is probably the most obscure vi command.  
In occasionally teaching advanced systems administration courses for close to a decade I've met very few people who've ever used it.  
`@` executes the contents of a register as if it were a vi or ex command.  
Use: `:r!locate ...` to find some file on your system and read its name into your document.  





