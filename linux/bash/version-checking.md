# Bash Features and Versions

This document attempts to outline which versions of Bash introduced certain features.  

There is no comprehensive, canonical table in the Bash documentation that outlines 
which features relate to which versions of Bash.  

## Compatibility

Compatibility is a huge concern when writing Bash scripts.  

We tend to get into habits of using features that are available on the newest (or a
newer) version of Bash. All of these features may not be available on older versions
of Bash.

So, we need to be mindful of the syntax and features we're using if our scripts need
to be run in different environments.  

For example, if you're writing a script that needs to be run across a fleet of
servers, and one of them is an old CentOS server that only has Bash v4.0, then there
will be some features that are not available.  

For example, if you're using `mapfile` to read the output of a command into an array:
```bash
mapfile -t -d ':' < <(getent passwd)
```
This won't work on Bash 4.0, or even 4.2.  

The `mapfile` builtin is introduced in Bash 4.0, but the `-d DELIM` option isn't
introduced until Bash 4.3.  




## Bash Version Feature Matrix (Timeline)

Below is a list of versions and the features they introduced.  

### Bash 2.x

* `**` globstar (recursive globbing) -- introduced in **2.02**, enabled with `shopt -s globstar`
* `source` as synonym for `.` -- **2.0**

---

### Bash 3.0 (July 2004)

* `[[ string =~ regex ]]` (regex matching)
* `+=` for arrays (`arr+=(foo bar)`)
* `coproc` (but only as keyword in 3.0, no `coproc NAME` yet)
* `declare -f -F` (list functions by name)
* `${var:offset:length}` substring expansion (more POSIX-like)

---

### Bash 3.1 (Dec 2005)

* `printf -v var fmt ...`
* `+=` for string variables (`var+=value`)
* `COMP_WORDBREAKS` and programmable completion improvements

---

### Bash 3.2 (Oct 2006)

* `echo -e` behavior changed (no longer expands `\c` by default)
* `PIPESTATUS` array
* `;;&` and `;&` in `case` statements **NOT** yet (that's 4.0!)

<!-- What are these two things doing? You include them here but you say they're not implemented in 3.2? Please clarify -->

---

### Bash 4.0 (Feb 2009)

Major jump. Introduced **a ton** of features:

* Associative arrays: `declare -A`
* `mapfile` / `readarray`
* `coproc NAME` (named coprocs)
* `**` globstar updated & stabilized
* Case modification expansions:

  * `${var,,}` → lowercase
  * `${var^^}` → uppercase
  * `${var~}` → toggle first char
* `${parameter@Q}` quoting operator
* New `case` fall-through operators:

  * `;&` → continue execution with next pattern
  * `;;&` → test next pattern list

---

### Bash 4.1 (May 2010)

* `assoc+=( [k]=v )` to append to associative arrays
* `declare -g` (declare globals inside functions)
* `extglob` enhancements (`@(alt1|alt2)` etc. more robust)

---

### Bash 4.2 (Feb 2011)

* `lastpipe` option: pipelines can run the last command in the current shell
* `**=()` process substitution in array assignment
* `help -d` summaries
* `read -d DELIM` (delimiter) -- BUT careful: `mapfile -d` comes later
* `printf -v var` extended with array indexing

---

### Bash 4.3 (Feb 2014)

* `local -n` (name references, like aliases for variables)
* `mapfile -d DELIM` → custom delimiters
* `globasciiranges` option
* `wait -n` (wait for *any* job to finish)
* `compopt` for programmable completion
* `${var@a}` / `${var@A}` attribute expansion
* New `BASH_COMPAT` variable to force older compatibility mode

---

### Bash 4.4 (Sep 2016)

* `declare -n` improvements (namerefs with attributes)
* `wait -n` polished
* `PROMPT_DIRTRIM` support
* `help -m` (man-style help formatting)
* `printf -v` supports indexed arrays
* `@Q` quoting expansion extended

---

### Bash 5.0 (Jan 2019)

* `shopt -s localvar_inherit` → local vars inherit attributes
* `globstar` now follows symlinks by default
* New `history -d` syntax (`history -d offset [count]`)
* Changes in how associative arrays iterate
* `wait -n` extended to take PIDs

---

### Bash 5.1 (Dec 2020)

* `EPOCHSECONDS` and `EPOCHREALTIME` variables
* `BASH_ARGV0` variable (script name override)
* `getopts` enhanced: supports long options if `getopts_long` patch applied
* `${var@E}` expansion (expand to re-expandable text)

---

### Bash 5.2 (Sep 2022)

* New `SRANDOM` variable (secure random generator)
* `history -d -w` fixes
* New completion API hooks
* Case modification supports Unicode properly
* `$PS0` prompt string


## Feature Table

Below is a table that contains the feature and its corresponding version.  

| Feature                           | Syntax / example                             | First in | Notes for detection in scripts 
| --------------------------------- | -------------------------------------------- | -------- | ------------------------------
| Extended regex match in `[[ ... ]]` | `[[ s =~ re ]]`                            |      3.0 | Gate if you use `=~` or `BASH_REMATCH`.                                     
| `set -o pipefail`                 | `set -o pipefail`                            |      3.0 | Useful for robust pipelines.                                                
| Brace sequence expansion          | `{1..5}`, `{a..z}`                           |      3.0 | Zero-pad also in 4.0; but basic sequence is 3.0.                            
| `printf -v`                       | `printf -v var "%s" val`                     |      3.1 | Assign formatted output without subshells.                                  
| `nocasematch` (shopt)             | `shopt -s nocasematch`                       |      3.1 | Case-insensitive `[[ ]]` / `case`.                                          
| Associative arrays                | `declare -A map; map[k]=v`                   |      4.0 | Arrays keyed by strings.                                                    
| `coproc`                          | `coproc NAME { cmd; }`                       |      4.0 | Background co-processes (ksh-like).                                         
| `mapfile` / `readarray`           | `mapfile -t a < file`                        |      4.0 | Bulk read lines into arrays.                                                
| `globstar` (recursive `**`)       | `shopt -s globstar; echo **/*.py`            |      4.0 | Off by default.                                                             
| `PROMPT_DIRTRIM`                  | `PROMPT_DIRTRIM=2`                           |      4.0 | Trims `\w` in prompt.                                                       
| Case-modifying expansions `${v^^}`| `${var^}`, `${var^^}`, `${var,}`, `${var,,}` |      4.0 | Upper/lower-casing parameter expansions.                                    
| `\|&`                             | Shorthand for `2>&1 \|` -- `make \|& tee log`|      4.0 | Same as `2>&1 \|`.                                                          
| Append-both redirection           | `cmd &>>file`                                |      4.0 | Appends both stdout+stderr.                                                 
| `case` fallthrough                | `;;&` and `;&`                               |      4.0 | zsh/ksh-style.                                                              
| `lastpipe` (shopt)                | `shopt -s lastpipe`                          |      4.2 | Run last pipeline cmd in current shell (no subshell) if job control is off. 
| `direxpand` (shopt)               | `shopt -s direxpand`                         |      4.2 | Completes `~`/vars to literal paths.                                        
| `globasciiranges` (shopt)         | `shopt -s globasciiranges`                   |      4.3 | `[a-z]` like C locale.                                                      
| Namerefs                          | `local -n ref=NAME`                          |      4.3 | “Pointers” to variables.                                                    
| Negative array subscripts         | `a[-1]`                                      |      4.3 | From the 4.3 cycle.                                                         
| Mapfile record delimiter          | `mapfile -d ':' -t a`                        |      4.4 | `-d` (and `-t` pairs nicely).                                               
| New `${var@...}` transforms       | `${v@Q}`, `${v@L}`, etc.                     |      4.4 | Family of parameter transformations.                                        
| `EPOCHSECONDS` / `EPOCHREALTIME`  | `$EPOCHSECONDS`                              |      5.0 | Monotonic epoch counters.                                                   
| `localvar_inherit` (`shopt`)      | `shopt -s localvar_inherit`                  |      5.0 | Locals inherit previous scope.                                              
| `wait -f`                         | `wait -f %1`                                 |      5.0 | Wait until job/child terminates.                                            
| `SRANDOM`                         | `$SRANDOM`                                   |      5.1 | CSPRNG-backed 32-bit random.                                                
| `wait -n` improvements            | `wait -n -p pidvar`                          |  5.1–5.3 | `-p` added in 5.1; broader targets & behavior clarified in 5.2/5.3.         
| `BASH_COMPAT` tuning              | `BASH_COMPAT=42`                             |      5.x | Compatibility level toggles.                                                
| `globskipdots` (shopt)            | `shopt -s globskipdots`                      |      5.2 | Don't return `.`/`..` unless explicit.                                      
| New command-sub form              | `${ command; }`                              |      5.3 | Captures output without forking (implementation-dependent).                 

## Sources

* <https://tiswww.case.edu/php/chet/bash/NEWS> 
* <https://www.linuxjournal.com/content/globstar-new-bash-globbing-option> 
* <https://tiswww.case.edu/php/chet/bash/FAQ> 
* <https://www.gnu.org/software/bash/manual/html_node/The-Shopt-Builtin.html> 
* <https://lists.gnu.org/archive/html/info-gnu/2014-02/msg00010.html> 
* <https://www.i-programmer.info/news/98-languages/10128-no-comment-hvm-bash-a-coffeescript.html> 
* <https://github.com/gitGNU/gnu_bash/blob/master/CHANGES> 
