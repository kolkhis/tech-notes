# Pdb - Python Debugger
The Python Debugger, or `pdb`, is the easiest way to debug python code from the
terminal.  


## Table of Contents
* [Using pdb](#using-pdb) 
    * [Breakpoints](#breakpoints) 
    * [Debugging an Entire Program](#debugging-an-entire-program) 
* [Commands in Pdb](#commands-in-pdb) 
* [Output of the `help` command](#output-of-the-help-command) 
    * [Getting Help with Specific Commands](#getting-help-with-specific-commands) 



## Using pdb
### Breakpoints
To set a breakpoint for `pdb`, you can either use the `breakpoint()` builtin
function, or use the `pdb` module.  
```python
breakpoint()

import pdb
pdb.set_trace()
```

### Debugging an Entire Program
Alternatively, you can debug a whole program by running it with the flag `-m pdb`.  
```bash
python -m pdb exppdb.py
```

* `c`: Continue execution
* `q`: Quit the debugger/execution
* `n`: Step to next line within the same function
* : Step to next line in this function or a called function

## Commands in Pdb
* `help`: To display all commands.  
* `w`/`where`: Print a stack trace. 
    * An arrow will indicate the "current frame", which determines the context of most commands.
    * `bt`: An alias for `w`/`where`.  
* `u`/`up`: Move the one level up in the stack trace to an older frame.  
* `d`/`down`: Move down one level in the stack trace to a newer frame.  
* `where`: Display the stack trace and line number of the current line.  
* `n`/`next`: Execute the current line and move to the next line ignoring function calls.  
* `s`/`step`: Step into functions called at the current line.  
* `whatis var`: Show the type of the given variable.  
* `j n`/`jump n`: Jump to the given line and execute that line next.  
* `unt n`/`until n`: Run until you reach line number `n`.  
* `longlist`/`ll`: List the source code for the current function.  
* `alias`: Create an alias to use in pdb.  
* `interact`: Start an interactive interpreter in the current namespace (scope).  


## Output of the `help` command
If you run `help` it'll give you all the commands available:
```bash
Documented commands (type help <topic>):
========================================
EOF    c          d        h         list      q        rv       undisplay
a      cl         debug    help      ll        quit     s        unt
alias  clear      disable  ignore    longlist  r        source   until
args   commands   display  interact  n         restart  step     up
b      condition  down     j         next      return   tbreak   w
break  cont       enable   jump      p         retval   u        whatis
bt     continue   exit     l         pp        run      unalias  where

Miscellaneous help topics:
==========================
exec  pdb

```

### Getting Help with Specific Commands
You can run `help <cmd>` for any of the commands to display what the command does,
and how to use it.  

```bash
(Pdb) help c
c(ont(inue))
        Continue execution, only stop when a breakpoint is encountered.
```

