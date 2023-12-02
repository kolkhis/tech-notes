
# The Shopt builtin  

This builtin allows you to change additional shell optional behavior.  

Documentation page 
[here](https://www.gnu.org/software/bash/manual/html_node/The-Shopt-Builtin.html).  


 

##  Shopt Flags  
```bash  
shopt [-pqsu] [-o] [optname …]  
```

Toggle the values of settings controlling optional shell behavior.  
The settings can be either those listed below, or, if the `-o` option is used,
those available with the `-o` option to the set builtin command (see The Set Builtin).  

With no options, or with the `-p` option, a list of all settable options  
is displayed, with an indication of whether or not each is set; if  
optnames are supplied, the output is restricted to those options.  

* The `-p` option causes output to be displayed in a form that may be reused as input.  

Other options have the following meanings:  

* `-s`: Enable (set) each optname.  



* `-u`: Disable (unset) each optname.  



* `-q`: Suppresses normal output; the return status indicates whether the optname is set or unset.  
If multiple optname arguments are given with `-q`, the return status is zero if all optnames are enabled; non-zero otherwise.  


* `-o`: Restricts the values of optname to be those defined for the `-o` option to the set builtin (see The Set Builtin).  

---  

If either `-s` or `-u` is used with no optname arguments, shopt shows  
only those options which are set or unset, respectively.  


Unless otherwise noted, the shopt options are disabled (off) by default.  

The return status when listing options is zero if all optnames are enabled, non-zero otherwise.  
When setting or unsetting options, the return status is zero unless an optname is not a valid shell option.  

---  


## The List of `shopt` Options  

* `assoc_expand_once`: 
    * If set, the shell suppresses multiple evaluation  
      of associative array subscripts during arithmetic 
      expression evaluation, while executing builtins  
      that can perform variable assignments, and while  
      executing builtins that perform array dereferencing.  


* `autocd`: 
    * This option is only used by interactive shells.  
    * If set, a command name that is the name of a directory  
      is executed as if it were the argument to the cd command.  


* `cdable_vars`: 
    * If this is set, an argument to the cd builtin command  
      that is not a directory is assumed to be the name of a 
      variable whose value is the directory to change to.  



* `cdspell`: 
    * This option is only used by interactive shells.  
    * If set, minor errors in the spelling of a directory  
      component in a cd command will be corrected.  
    * The errors checked for are transposed characters, a  
      missing character, and a character too many.  
    * If a correction is found, the corrected path is printed,
      and the command proceeds.  

* `checkhash`: 
    * If this is set, Bash checks that a command found in the hash 
      table exists before trying to execute it.  
    * If a hashed command no longer exists, a normal path search is performed.  


* `checkjobs`: 

    * If set, Bash lists the status of any stopped and running jobs  
      before exiting an interactive shell.  
    * If any jobs are running, this causes the exit to be deferred  
      until a second exit is attempted without an intervening  
      command (see Job Control).  
    * The shell always postpones exiting if any jobs are stopped.  

* `checkwinsize`: 

    * If set, Bash checks the window size after each external  
      (non-builtin) command and, if necessary, updates the  
      values of `LINES` and `COLUMNS`.  
    * This option is enabled by default.  


* `cmdhist`: 

    * If set, Bash attempts to save all lines of a multiple-line  
      command in the same history entry.  
    * This allows easy re-editing of multi-line commands.  
    * This option is enabled by default, but only has an effect if  
      command history is enabled (see Bash History Facilities).  

* `compat{num}`:  
    * `compat31` 
    * `compat32` 
    * `compat40` 
    * `compat41` 
    * `compat42` 
    * `compat43` 
    * `compat44` 
    * These control aspects of the shell’s compatibility mode (see Shell Compatibility Mode).  



* `complete_fullquote`: 
    * This variable is set by default, which is the default Bash behavior in versions through 4.2.  

    * If set, Bash quotes all shell metacharacters in filenames  
      and directory names when performing completion.  
    * If not set, Bash removes metacharacters such as the dollar 
      sign from the set of characters that will be quoted in completed  
      filenames when these metacharacters appear in shell variable 
      references in words to be completed.  

    * This means that dollar signs in variable names that expand to 
      directories will not be quoted; however, any dollar signs  
      appearing in filenames will not be quoted, either.  
    * This is active only when bash is using backslashes to quote  
      completed filenames. 

* `direxpand`: 
    * If set, Bash replaces directory names with the results of word 
      expansion when performing filename completion.  
    * This changes the contents of the Readline editing buffer.  
    * If not set, Bash attempts to preserve what the user typed.  

* `dirspell`: 
    * If set, Bash attempts spelling correction on directory names  
      during word completion if the directory name initially supplied  
      does not exist.  



* `dotglob`: 
    * If set, Bash includes filenames beginning with a `.` in the results of filename expansion.  
    * The filenames `.` and `..` must always be matched explicitly, even if dotglob is set.  

* `execfail`: 
    * If this is set, a non-interactive shell will not exit if it cannot  
      execute the file specified as an argument to the exec builtin command.  
    * An interactive shell does not exit if exec fails.  


* `expand_aliases`: 
    * This option is enabled by default for interactive shells.  
    * If set, aliases are expanded as described below under Aliases, Aliases.  


* `extdebug`: 

* If set at shell invocation, or in a shell startup file, arrange  
  to execute the debugger profile before the shell starts,
  identical to the `--debugger` option.  


* If set after invocation, behavior intended for use by debuggers is enabled:  

    * The `-F` option to the declare builtin (see Bash Builtin Commands)  
      displays the source file name and line number corresponding to  
      each function name supplied as an argument.  



    * If the command run by the `DEBUG` trap returns a non-zero value,
      the next command is skipped and not executed.  



    * If the command run by the `DEBUG` trap returns a value of 2, and the  
      shell is executing in a subroutine (a shell function or a shell  
      script executed by the `.` or `source` builtins), the  
      shell simulates a call to return.  


    * `BASH_ARGC` and `BASH_ARGV` are updated as described in their descriptions (see Bash Variables).  



    * Function tracing is enabled: command substitution, shell functions,
      and subshells invoked with ( command ) inherit the `DEBUG` and `RETURN` traps.  



    * Error tracing is enabled: command substitution, shell functions,
      and subshells invoked with ( `command` ) inherit the `ERR` trap.  
  
  


* `extglob`: 
    * If set, the extended pattern matching features described above (see Pattern Matching) are enabled.  



* `extquote`: 
    * This option is enabled by default.  
    * If set, `$'string'` and `$"string"` quoting is performed 
      within `${parameter}` expansions enclosed in double quotes.  


* `failglob`: 
    * If set, patterns which fail to match filenames during filename  
      expansion result in an expansion error.  



* `force_fignore`: 
    * This option is enabled by default.  
    * If set, the suffixes specified by the `FIGNORE` shell  
      variable cause words to be ignored when performing word 
      completion even if the ignored words are the only possible completions.  
      See Bash Variables, for a description of `FIGNORE`.  

* `globasciiranges`: 
    * If set, range expressions used in pattern matching bracket expressions 
      (see Pattern Matching) behave as if in the traditional 
      C locale when performing comparisons.  
    * That is, the current locale's collating sequence is not taken 
      into account, so `b` will not collate between `A` and `B`, and  
      upper-case and lower-case ASCII characters will collate together.  


* `globskipdots`: 
    * If set, filename expansion will never match the 
      filenames `.` and `..`, even if the pattern begins  
      with a `.`. This option is enabled by default.  

* `globstar`: 
    * If set, the pattern `**` used in a filename expansion context will 
      match all files and zero or more directories and subdirectories.  
    * If the pattern is followed by a `/`, only directories and subdirectories match.  


* `gnu_errfmt`: 
    * If set, shell error messages are written in the standard GNU error message format.  



* `histappend`: 
    * If set, the history list is appended to the file named by the value of 
      the `HISTFILE` variable when the shell exits, rather than overwriting the file.  



* `histreedit`: 
    * If set, and Readline is being used, a user is given the opportunity to re-edit a failed history substitution.  



* `histverify`: 
    * If set, and Readline is being used, the results of history substitution are not immediately passed to the shell parser.  
    * Instead, the resulting line is loaded into the Readline editing buffer, allowing further modification.  


* `hostcomplete`: 
    * This option is enabled by default.  
    * If set, and Readline is being used, Bash will attempt to perform 
      hostname completion when a word containing a `@` is being completed 
      (see Letting Readline Type For You).  


* `huponexit`: 
    * If set, Bash will send SIGHUP to all jobs when an interactive login shell exits (see Signals).  



* `inherit_errexit`: 
    * If set, command substitution inherits the value of the errexit  
      option, instead of unsetting it in the subshell environment.  
    * This option is enabled when POSIX mode is enabled.  


* `interactive_comments`: 
    * This option is enabled by default.  
    * Allow a word beginning with `#` to cause that word and all  
      remaining characters on that line to be ignored in an interactive shell.  


* `lastpipe`: 
    * If set, and job control is not active, the shell runs the  
      last command of a pipeline not executed in the background  
      in the current shell environment.  



* `lithist`: 
    * If enabled, and the cmdhist option is enabled,
      multi-line commands are saved to the history with embedded  
      newlines rather than using semicolon separators where possible.  



* `localvar_inherit`: 
    * If set, local variables inherit the value and attributes of  
      a variable of the same name that exists at a previous scope  
      before any new value is assigned.  
    * The `nameref` attribute is not inherited.  


* `localvar_unset`: 
    * If set, calling unset on local variables in previous function  
      scopes marks them so subsequent lookups find them unset until that function returns.  
    * This is identical to the behavior of unsetting local variables at the current function scope.  


* `login_shell`: 
    * The shell sets this option if it is started as a login shell (see Invoking Bash).  
    * The value may not be changed.  


* `mailwarn`: 
    * If set, and a file that Bash is checking for mail has been accessed  
      since the last time it was checked, the message 
      "The mail in mailfile has been read" is displayed.  



* `no_empty_cmd_completion`: 
    * If set, and Readline is being used, Bash will not attempt to search 
      the `PATH` for possible completions when completion is attempted on an empty line.  



* `nocaseglob`: 
    * If set, Bash matches filenames in a case-insensitive fashion when performing filename expansion.  



* `nocasematch`: 
    * If set, Bash matches patterns in a case-insensitive fashion when performing  
      matching while executing case or `[[` conditional commands (see Conditional Constructs),
      when performing pattern substitution word expansions,
      or when filtering possible completions as part of programmable completion.  



* `noexpand_translation`: 
    * If set, Bash encloses the translated results of `$"..."` quoting in  
      single quotes instead of double quotes.  
    * If the string is not translated, this has no effect.  


* `nullglob`: 
    * If set, Bash allows filename patterns which match no files to 
      expand to a null string, rather than themselves.  



* `patsub_replacement`: 
    * This option is enabled by default.  
    * If set, Bash expands occurrences of ‘&’ in the replacement string  
      of pattern substitution to the text matched by the pattern,
      as described above (see Shell Parameter Expansion).  



* `progcomp`: 
    * This option is enabled by default.  
    * If set, the programmable completion facilities (see Programmable Completion) are enabled.  



* `progcomp_alias`: 
    * If set, and programmable completion is enabled, Bash  
      treats a command name that doesn’t have any completions as a 
      possible alias and attempts alias expansion.  
    * If it has an alias, Bash attempts programmable completion using 
      the command word resulting from the expanded alias.  


* `promptvars`: 
    * This option is enabled by default.  
    * If set, prompt strings undergo parameter expansion, command substitution,
      arithmetic expansion, and quote removal after being expanded as  
      described below (see Controlling the Prompt).  


* `restricted_shell`: 
    * The shell sets this option if it is started in restricted mode (see The Restricted Shell).  
    * The value may not be changed.  
    * This is not reset when the startup files are executed,
      allowing the startup files to discover whether or not a shell is restricted.  

* `shift_verbose`: 
    * If this is set, the shift builtin prints an error message when the shift count exceeds the number of positional parameters.  



* `sourcepath`: 
    * If set, the `.` (source) builtin uses the value of `PATH` to find the directory containing the file supplied as an argument.  
    * This option is enabled by default.  

* `varredir_close`: 
    * If set, the shell automatically closes file descriptors assigned using the `{varname}` redirection syntax (see Redirections) instead of leaving them open when the command completes.  


* `xpg_echo`: 
    * If set, the echo builtin expands backslash-escape sequences by default.  





