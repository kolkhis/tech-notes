

# Command Grouping - Using Curly Braces `{ ... }` to Group Commands 


The syntax `{ }` in Bash is used for command grouping.  
 
The `{ }` command grouping syntax is POSIX-compliant.
 

## Explanation of Command Grouping

Commands inside curly braces `{ ... }` are executed in the current 
shell context, and they are considered a single unit by the shell.  

Redirections, pipes, or logical operators (like `&&` and `||`) outside
the braces apply to all commands inside the braces.  


### Limitations:

* Commands inside `{ ... }` must be separated by semicolons
  or newlines. 

* There must be a space or newline after the opening `{` and a space
  or newline before the closing `}`.

* Grouping `{ ... }` executes commands in the current shell context. 
    * Any changes to the environment (`cd`, `set`, etc.) persist
      after the command group completes.  
    * This is different from using subshells `( ... )`, where
      changes are local to the subshell.


