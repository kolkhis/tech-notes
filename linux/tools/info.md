# The Info Command  

The `info` command is for reading "Info documents."  
Lets you read documentation in Info format.  

## Default Navigation Keys  
`C-n` (`next-line`)  
`<DOWN>` (an arrow key)  
     Move the cursor down to the next line.  

`C-p` (`prev-line`)  
`<UP>` (an arrow key)  
     Move the cursor up to the previous line.  

`C-a` (`beginning-of-line`)  
`<Home>` (on DOS/Windows only)  
     Move the cursor to the start of the current line.  

`C-e` (`end-of-line`)  
`<End>` (on DOS/Windows only)  
     Move the cursor to the end of the current line.  

`C-f` (`forward-char`)  
`<RIGHT>` (an arrow key)  
     Move the cursor forward a character.  

`C-b` (`backward-char`)  
`<LEFT>` (an arrow key)  
     Move the cursor backward a character.  

`M-f` (`forward-word`)  
`C-<RIGHT>` (on DOS/Windows only)  
     Move the cursor forward a word.  

`M-b` (`backward-word`)  
`C-<LEFT>` (on DOS/Windows only)  
     Move the cursor backward a word.  


`M-<` (`beginning-of-node`)  
`C-<Home>` (on DOS/Windows only)  
`b`
     Move the cursor to the start of the current node.  

`M->` (`end-of-node`)  
`C-<End>` (on DOS/Windows only)  
`e`
     Move the cursor to the end of the current node.  

`M-r` (`move-to-window-line`)  
     Move the cursor to a specific line of the window.  Without a  
     numeric argument, `M-r` moves the cursor to the start of the line  
     in the center of the window.  With a numeric argument of N, `M-r`
     moves the cursor to the start of the Nth line in the window.  

`M-x` (`execute-extended-command`) 
    lets you run a command by name.  
    (emacs)M-x, for more detailed information.  

## Mode Line
Sample mode line for a window containing a file named
`dir`, showing the node `Top`
```Info
     -----Info: (dir)Top, 40 lines --Top-------------------------------------
                 ^^   ^   ^^^        ^^
               (file)Node #lines    where
```
If there's a `$` at the beginning of the mode line,
that means it's truncating a long line.
If the file/node are surrounded by `*`, it's 
an "internally constructed" Info node.


## Window Commands

`C-x o` (`next-window`)
     Select the next window on the screen.  Note that the echo area can
     only be selected if it is already in use, and you have left it
     temporarily.  Normally, `C-x o` simply moves the cursor into the
     next window on the screen, or if you are already within the last
     window, into the first window on the screen.  Given a numeric
     argument, `C-x o` moves over that many windows.  A negative
     argument causes `C-x o` to select the previous window on the
     screen.

`M-x prev-window`
     Select the previous window on the screen.  This is identical to
     `C-x o` with a negative argument.

`C-x 2` (`split-window`)
     Split the current window into two windows, both showing the same
     node.  Each window is one half the size of the original window, and
     the cursor remains in the original window.  The variable
     `automatic-tiling` can cause all of the windows on the screen to be
     resized for you automatically (*note `automatic-tiling`:
     Variables.).

`C-x 0` (`delete-window`)
     Delete the current window from the screen.  If you have made too
     many windows and your screen appears cluttered, this is the way to
     get rid of some of them.

`C-x 1` (`keep-one-window`)
     Delete all of the windows excepting the current one.

`ESC C-v` (`scroll-other-window`)
     Scroll the other window, in the same fashion that `C-v` might
     scroll the current window.  Given a negative argument, scroll the
     "other" window backward.

`C-x ^` (`grow-window`)
     Grow (or shrink) the current window.  Given a numeric argument,
     grow the current window that many lines; with a negative numeric
     argument, shrink the window instead.

`C-x t` (`tile-windows`)
     Divide the available screen space among all of the visible windows.
     Each window is given an equal portion of the screen in which to
     display its contents.  The variable `automatic-tiling` can cause
     `tile-windows` to be called when a window is created or deleted.
     *Note `automatic-tiling`: Variables.


## Index Commands (search through the indices of an Info file)  

`i` (`index-search`)  
     Look up a string in the indices for this Info file, and select a  
     node to which the found index entry points.  

`I` (`virtual-index`)  
     Look up a string in the indices for this Info file, and show all  
     the matches in a new virtual node, synthesized on the fly.  

`,` (`next-index-match`)  
     Move to the node containing the next matching index item from the  
     last `i` command.  

`M-x index-apropos`
     Grovel the indices of all the known Info files on your system for a  
     string, and build a menu of the possible matches.  



## Cross-references (links to other nodes)  

* Cross-references have two major parts: 
    1. The first part is called the "label"  
        * it is the name that you can use to refer to the cross  
          reference,
    2. And the second is the "target"  
        * it is the full name of the node that the cross-reference points to.  

   The target is separated from the label by a colon `:`; first the  
label appears, and then the target.  For example, in the sample menu  
cross-reference below, the single colon separates the label from the  
target.  

     * Foo Label: Foo Target.        More information about Foo.  

   Note the `.` which ends the name of the target.  The `.` is not part  
of the target; it serves only to let Info know where the target name  
ends.  

### Cross-reference Shorthand  
   A shorthand way of specifying references allows two adjacent colons  
to stand for a target name which is the same as the label name:  

 * Foo Commands::                Commands pertaining to Foo.  

   In the above example, the name of the target is the same as the name  
of the label, in this case `Foo Commands`.  
