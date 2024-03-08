
# Misc. Tmux notes that could be helpful in scripting  
##### See the [docs for more info](https://github.com/tmux/tmux/wiki/Getting-Started#other-features)

In tmux scripting, you'll separate each command with an escaped 
or quoted semicolon (`\;`/`';'`).  
Commands don't need to be quoted or escaped when run from  
the tmux command prompt (`:`).  


## Table of Contents
* [Default Keybindings (not exhaustive)](#default-keybindings-(not-exhaustive)) 
* [The Marked Pane](#the-marked-pane) 
* [How to Run Commands](#how-to-run-commands) 
* [Arguments](#arguments) 
    * [Variable Expansion](#variable-expansion) 
* [Braces](#braces) 
* [Conditionals and Format Variables](#conditionals-and-format-variables) 
* [Format Variables](#format-variables) 
* [Conditional Formats](#conditional-formats) 
    * [Basic Syntax of Format Conditionals](#basic-syntax-of-format-conditionals) 
    * [More Complicated Conditionals](#more-complicated-conditionals) 
* [String Comparisons](#string-comparisons) 
* [Regular Expression Comparisons and Globbing](#regular-expression-comparisons-and-globbing) 
    * [Searching the Current Pane with Pattern Matching or Regex](#searching-the-current-pane-with-pattern-matching-or-regex) 
* [Numeric Expressions](#numeric-expressions) 
    * [Numeric Expression Examples](#numeric-expression-examples) 
    * [Numbers to ASCII](#numbers-to-ascii) 
* [Limiting and Slicing Strings and Formats](#limiting-and-slicing-strings-and-formats) 
* [Time Variables](#time-variables) 
* [Variable Substitutions](#variable-substitutions) 
    * [Filenames and Directory Names](#filenames-and-directory-names) 
    * [Escaping Special Characters](#escaping-special-characters) 
    * [Iterators](#iterators) 
    * [Check for Window or Session Names](#check-for-window-or-session-names) 
* [Conditionals Using Shell Commands](#conditionals-using-shell-commands) 
* [Setting Environment Variables](#setting-environment-variables) 
* [Tmux Variables](#tmux-variables) 
    * [Variables with Aliases for Easy Reference](#variables-with-aliases-for-easy-reference) 
    * [Quick Reference](#quick-reference) 
    * [All Variables](#all-variables) 
    * [Cursor and Command Variables](#cursor-and-command-variables) 
    * [Hook Variables](#hook-variables) 
    * [Mouse Variables](#mouse-variables) 
    * [Pane Variables](#pane-variables) 
        * [Pane Flag Variables](#pane-flag-variables) 
    * [History, Buffer, and Copy Mode Variables](#history,-buffer,-and-copy-mode-variables) 
    * [Session Variables](#session-variables) 
    * [Window Variables](#window-variables) 
* [Names and Titles](#names-and-titles) 
    * [Names](#names) 
    * [Titles](#titles) 
* [Status Line Commands](#status-line-commands) 
* [Misc Commands](#misc-commands) 
* [Window Flags](#window-flags) 
* [Session Option for Monitoring Activity in a Window](#session-option-for-monitoring-activity-in-a-window) 
* [Hook Commands](#hook-commands) 


## Default Keybindings (not exhaustive)  
To see a full list: `man tmux` -> `/DEFAULT KEY BINDINGS`
```plaintext
m           Mark the current pane (see select-pane -m).  
M           Clear the marked pane.  
r           Force redraw of the attached client.  
z           Toggle zoom state of the current pane.  

------------- Showing Information -------------  
#           List all paste buffers.  
q           Briefly display pane indexes.  
?           List all key bindings.  
i           Display some information about the current window.  
t           Show the time.  
~           Show previous messages from tmux, if any.  

------------- Making and Killing Windows and Panes -------------  
&           Kill the current window.  
x           Kill the current pane.  
%           Split the current pane vertically, left and right.  
"           Split the current pane horizontally, top and bottom.  

------------- Moving Panes -------------  
{           Swap the current pane with the previous pane.  
}           Swap the current pane with the next pane.  


------------- Resizing Panes -------------  
C-{CursorKey}
           Resize the current pane in steps of one cell.  
M-{CursorKey}
           Resize the current pane in steps of five cells.  


------------- Preset Layouts -------------  
Space       Arrange the current window in the next preset layout.  
M-1 to M-5  Arrange panes in one of the five preset layouts: 
                even-horizontal,
                even-vertical  
                main-horizontal  
                main-vertical  
                tiled  

------------- Navigation -------------  
f           Prompt to search for text in open windows.  
0 to 9      Select windows 0 to 9.  
n           Change to the next window.  
l           Move to the previously selected window.  
o           Select the next pane in the current window.  
w           Choose the current window interactively.  
^           Move to the previous window  
```

## The Marked Pane  
Mark a pane with the `select-pane -m` command.  
Unmark it with either `select pane -M`, or marking a different pane.  

* `-m` and `-M`: Set and clear the `marked pane`.  
    * There is one marked pane at a time. 
    * Setting a new one clears the last.  

The marked pane is the default target for `-s` to:  
* `join-pane` (`joinp`)  
* `move-pane` (`movep`)  
* `swap-pane` (`swapp`)  
* `swap-window` (`swapw`)  



## How to Run Commands  
Commands can be bound to a key (`bind-key`), run from the shell prompt,
shell script, configuration file or the command prompt.  
```bash  
# From the shell  
tmux set-option -g status-style bg=cyan  
# In .tmux.conf  
set-option -g status-style bg=cyan  
# From a keybind set in .tmux.conf  
bind-key C set-option -g status-style bg=cyan  
# From the tmux command prompt (<prefix>-:)  
set-option -g status-style bg=cyan  
```
Some commands, like `if-shell` and `confirm-before`, parse  
their argument to create a new command which is inserted 
immediately after themselves.  


## Arguments  

Tmux supports line continuation with `\` at the end of the line,
but this doesn't apply inside braces (`{}`).  

Command arguments can be given as strings inside single 
(`'`) quotes, double quotes (`"`) or braces (`{}`).  
Single and double quotes can't span multiple lines, braces can.  

### Variable Expansion  
In double quotes, variables are expanded.  
* A leading `~` or `~user` is expanded to the home directory of 
  the current *or* specified user.  
* `\uXXXX` or `\uXXXXXXXX` is replaced by the Unicode codepoint  
  corresponding to the given four or eight digit hexadecimal number.  
* When escaped by a `\`, the following characters are replaced: 
    * `\e` by the escape character  
    * `\r` by a carriage return  
    * `\n` by a newline  
    * `\t` by a tab  

## Braces  

Braces are parsed as a configuration file (so conditions such as `%if` are processed)  
and then converted into a string.  

They are designed to avoid the need for additional escaping when 
passing a group of tmux commands as an argument (like to `if-shell`).  

## Conditionals and Format Variables  
Personally, I haven't had any luck using the `%if` format.
Prefer using [format conditionals](#conditional-formats) instead.

Conditionals with tmux work with `formats`. (see `FORMATS` in `man tmux`)  

Commands can be parsed conditionally by surrounding them with:  
* `%if`
* `%elif`
* `%else`
* `%endif`
Certain commands also accept the `-F` flag with a format argument.  

The argument to `%if` and `%elif` is expanded as a format  and if it  
evaluates to false, everything is ignored until the closing `%elif`,
`%else` or `%endif`.  


## Format Variables  
Format variables are enclosed in `#{` and `}`, e.g., `#{session_name}`.  

Some variables have a shorter alias such as `#S`;  
`##` is replaced by a single `#`, `#,` by a `,` and `#}` by a `}`.  

If an expression evaluates to zero or empty, it's false.  

---  

## Conditional Formats  
Note: Formats do **not** need to be in quotes.  

### Basic Syntax of Format Conditionals 
The basic conditional format follow the ternary syntax:
```
#{?conditional,if_true,if_false}
```
* `conditional`: The variable to check.
* `if_true`: The value to return if `conditional` is true.  
* `if_false`: The value to return if `conditional` is false.  


Example:
```.tmux.conf
bind G setw synchronize-panes #{?pane_synchronized,off,on}
```
* Here the conditional is `#{?pane_synchronized,off,on}`
    * If the `pane_synchronized` variable is `true` (`1`), returns `off`
    * If the `pane_synchronized` variable is `false` (`0`), returns `on`
* This will bind `<prefix> G` to set the window's `synchronize-panes` option
  to `off` if the `pane_synchronized` variable is `true` (`1`), and
  `on`, if it's false (`0`).

### More Complicated Conditionals
The example above can also be done by using a nested conditional statement.
checking the value of `pane_synchronized` directly:
```.tmux.conf
bind G setw synchronize-panes #{?#{==:pane_synchronized,1},off,on}
```
This is a nested conditional format statement:
* The `#{==:pane_synchronized,1}` expression is evaluated first.
    * Here, we're comparing the value of `pane_synchronized` to `1`.
    * This will return `1` or `0` (true or false).
* The output of the expression is then passed to the outer conditional.
    * If the value is `1`, `off` is returned.  
    * If the value is `0`, `on` is returned.

--- 

Conditionals are available by prefixing with `?` and separating two  
alternatives with a comma.  

If the specified variable exists and is not zero, the first  
alternative is chosen, otherwise the second is used.  

* `#{?session_attached,attached,not attached}` 
    * Will return the string `attached` if the session is attached,
      and the string `not attached` if it is unattached  

* `#{?automatic-rename,yes,no}` 
    * Will return `yes` if automatic-rename is enabled, or `no` if not.  

Inside a conditional, `,` and `}` need to be escaped with a hash 
symbol (e.g., `#,` and `#}`), unless they are part of `#{...}`:  
* `#{?pane_in_mode,#[fg=white#,bg=red],#[fg=red#,bg=white]}#W .`


---

## String Comparisons  
String comparisons may be expressed by prefixing two 
comma-separated alternatives by:  
* `==:`: Equality.
* `!=:`: Inequality.
* `<:`: Less than.
* `>:`: Greater than.
* `<=:`: Less than or equal to.
* `>=:`: Greater than or equal to.

Basically, your standard operators followed by a colon (`:`).  

For example `#{==:#{host},myhost}` will be replaced by `1` if  
running on `myhost`, otherwise by `0`.  

* `||` and `&&` evaluate to true if either or both of  
  two comma-separated alternatives are true, for example:  
    * `#{||:#{pane_in_mode},#{alternate_on}}`.  

```bash  
%if "#{==:#{host},myhost}"  
set -g status-style bg=red  
%elif "#{==:#{host},myotherhost}"  
set -g status-style bg=green  
%else  
set -g status-style bg=blue  
%endif  
```
This will change the status line to red if running on `myhost`,
green if running on `myotherhost`, or blue if running on another host.  

These `%if` statements can also be done inline:  
```tmux  
%if #{==:#{host},myhost} set -g status-style bg=red %endif  
```


## Regular Expression Comparisons and Globbing  
You can use regex comparisons using an `m:`.   
An `m` specifies an `fnmatch(3)` or regular expression comparison.  

An optional argument specifies flags: `r` means the pattern is a  
regular expression instead of the default `fnmatch(3)` pattern,
and `i` means to ignore case.  

Examles:  
```c  
#{m:*foo*,#{host}} 
#{m/ri:^A,MYVAR}
```
First will match the pattern `*foo*` with the `#{host}` variable.  
The second matches if `MYVAR` starts with `A` (`^A`).  

### Searching the Current Pane with Pattern Matching or Regex  
A `C` performs a search for an `fnmatch(3)` pattern or regex 
**in the pane content**  
and evaluates to zero if not found, or a line number if found.  

Like `m`, an `r` flag means search for a regular expression and `i` ignores case.  
For example: 
```c  
#{C/r:^Start}
```

## Numeric Expressions  
Numeric operators can be performed by prefixing two comma-separated  
alternatives with an `e` and an operator.  

An optional `f` flag may be given after the operator to use 
floating point numbers, otherwise integers are used.  
* This may be followed by a number giving the number of decimal places to use for the result.  

The available operators are: 
* addition `+`,
* subtraction `-`,
* multiplication `*`
* division `/`
* modulus `m` or `%` 
    * `%` must be escaped as `%%` in formats that are also expanded by `strftime(3)`  
* The equality operators: `==`, `!=`, `<`, `<=`, `>`, `>=`

### Numeric Expression Examples  
```c  
`#{e|*|f|4:5.5,3}`
```
multiplies 5.5 by 3 for a result with four decimal places 

```c  
#{e|%%:7,3}
```
returns the modulus of 7 and 3.  

### Numbers to ASCII  
Using `a` in a format replaces a numeric argument by its ASCII equivalent,
so `#{a:98}` results in `b`.  


---  


## Limiting and Slicing Strings and Formats  

A limit may be placed on the length of the resultant string by 
starting it with an `=`, a number and a colon.  

Positive numbers count from the start of the string and negative from the end:  
```c  
#{=5:pane_title} 
```
will include at most the first five characters of the pane title, or:  
```c  
#{=-5:pane_title} 
```
the last five characters.  

A suffix or prefix may be given as a second argument.  
It is appended or prepended to the string if the length 
has been trimmed:  
```c  
#{=/5/...:pane_title} 
```
will append `...` if the pane title is more than five characters.  

---  

## Time Variables  
Prefixing a time variable with `t:` will convert it to a string, so if `#{window_activity}`
gives `1445765102`, `#{t:window_activity}` gives `Sun Oct 25 09:25:02 2015`.  

Adding `p`  
```c  
#{t/p/}
```
will use shorter but less accurate time format for times in the past.  

Use a custom format with the `f` suffix (`#{t/f/}`).  
(note that `%` must be escaped as `%%` if the format is separately being  
passed through `strftime(3)`, for example in the status-left option):  
```c  
#{t/f/%%H#:%%M:window_activity}
```
Using `T` will escape things on its own.  


---  

## Variable Substitutions  
You can do substitutions on variables like with `sed`.  
A prefix of the form `s/foo/bar/:` will substitute `foo` with `bar` throughout.  
The first argument may be an extended regular expression and a final argument  
may be `i` to ignore case. 
Example:  
```c  
#{s/a(.)/\1x/i:abABab}  
```
would change `abABab` into `bxBxbx`.  


### Filenames and Directory Names  
Get the basename and directory name of the variable with:  
* `b:`: `basename(3)` 
* `d:`: `dirname(3)` 

### Escaping Special Characters  
Escape special characters automatically with `q`.  
* `q:` will escape `sh(1)` special characters. 
    * With a `h` suffix (`${q:h}`), escape hash characters (so `#` becomes `##`).  

* `E:` will expand the format twice:  
```c  
#{E:status-left} 
```
is the result of expanding the content of the `status-left`
option rather than the option itself. 

`T:` is like `E:` but also expands `strftime(3)` specifiers.  
  
### Iterators  
* `S:` will loop over each session  
* `W:` will loop over each window 
* `P:` will loop over each pane  
and each of these will insert the format once for each.  

For windows and panes, two comma-separated formats 
can be given: the second is used for the current window or active pane.  

For example, to get a list of windows formatted like the status line:  
```c  
#{W:#{E:window-status-format} ,#{E:window-status-current-format} }
```

### Check for Window or Session Names  

* `N:` checks if a window (without any suffix or with the `w` suffix) 
       or a session (with the `s` suffix) name exists.  

For example, `N/w:foo` is replaced with 1 if a window named `foo` exists.  

---  

## Conditionals Using Shell Commands  

The `if-shell` (alias: `if`) cmd is under `MISCELLANEOUS` in `man bash`.  

```bash  
if-shell true {
   display -p 'brace-dollar-foo: }$foo'  
}
if-shell true "display -p 'brace-dollar-foo: }\$foo'"  
```
Braces can also be nested:  
```bash  
bind x if-shell "true" {
   if-shell "true" {
       display "true!"  
   }
}
```

## Setting Environment Variables  
Variables set during parsing are added to the global environment.  
Environment vars can be set by using the 
syntax `name=value`, for example:  
```bash  
HOME=/home/user  
```
A hidden variable can be set with `%hidden`, for example:  
```bash  
%hidden MYVAR=42
```
Hidden variables are not passed to the environment of processes created by tmux.  
See the `GLOBAL AND SESSION ENVIRONMENT` section.  


## Tmux Variables  


### Variables with Aliases for Easy Reference  
These are the variables that have aliases available:  
| Variable Name            | Alias | Replaced with                      |
|--------------------------|-------|------------------------------------|
| `host`                        |`#H`| Hostname of local host 
| `host_short`                  |`#h`| Hostname of local host (no domain name) 
| `pane_id`                     |`#D`| Unique pane ID 
| `pane_index`                  |`#P`| Index of pane 
| `pane_title`                  |`#T`| Title of pane (can be set by application) 
| `session_name`                |`#S`| Name of session 
| `window_flags`                |`#F`| Window flags with # escaped as ## 
| `window_index`                |`#I`| Index of window 
| `window_name`                 |`#W`| Name of window 


### Quick Reference  
Quickref for useful variables  
| Variable Name            | Alias | Replaced with                      |
|--------------------------|-------|------------------------------------|
| `current_file`                |  | Current configuration file 
| `config_files`                |  | List of configuration files loaded 
| `client_prefix`               |  | 1 if prefix key has been pressed 
| `command_list_alias`          |  | Command alias if listing commands 
| `command_list_name`           |  | Command name if listing commands 
| `command_list_usage`          |  | Command usage if listing commands 
| `config_files`                |  | List of configuration files loaded 
| `pane_width`                  |  | Width of pane 
| `pane_top`                    |  | Top of pane 
| `pane_pipe`                   |  | 1 if pane is being piped 
| `pane_synchronized`           |  | 1 if pane is synchronized 
| `pane_last`                   |  | 1 if last pane 
| `pane_left`                   |  | Left of pane 
| `pane_marked`                 |  | 1 if this is the marked pane 
| `pane_marked_set`             |  | 1 if a marked pane is set 


---  


### All Variables  
The following variables are available, where appropriate:  
| Variable Name            | Alias | Replaced with                      |
|--------------------------|-------|------------------------------------|
| `active_window_index`         |  | Index of active window in session 
| `alternate_on`                |  | 1 if pane is in alternate screen 
| `alternate_saved_x`           |  | Saved cursor X in alternate screen 
| `alternate_saved_y`           |  | Saved cursor Y in alternate screen 
| `buffer_created`              |  | Time buffer created 
| `buffer_name`                 |  | Name of buffer 
| `buffer_sample`               |  | Sample of start of buffer 
| `buffer_size`                 |  | Size of the specified buffer in bytes 
| `client_activity`             |  | Time client last had activity 
| `client_cell_height`          |  | Height of each client cell in pixels 
| `client_cell_width`           |  | Width of each client cell in pixels 
| `client_control_mode`         |  | 1 if client is in control mode 
| `client_created`              |  | Time client created 
| `client_discarded`            |  | Bytes discarded when client behind 
| `client_flags`                |  | List of client flags 
| `client_height`               |  | Height of client 
| `client_key_table`            |  | Current key table 
| `client_last_session`         |  | Name of the client's last session 
| `client_name`                 |  | Name of client 
| `client_pid`                  |  | PID of client process 
| `client_prefix`               |  | 1 if prefix key has been pressed 
| `client_readonly`             |  | 1 if client is readonly 
| `client_session`              |  | Name of the client's session 
| `client_termfeatures`         |  | Terminal features of client, if any 
| `client_termname`             |  | Terminal name of client 
| `client_termtype`             |  | Terminal type of client, if available 
| `client_tty`                  |  | Pseudo terminal of client 
| `client_utf8`                 |  | 1 if client supports UTF-8 
| `client_width`                |  | Width of client 
| `client_written`              |  | Bytes written to client 


### Cursor and Command Variables  
| Variable Name            | Alias | Replaced with                      |
|--------------------------|-------|------------------------------------|
| `host`                        |`#H`| Hostname of local host 
| `host_short`                  |`#h`| Hostname of local host (no domain name) 
| `command`                     |  | Name of command in use, if any 
| `command_list_alias`          |  | Command alias if listing commands 
| `command_list_name`           |  | Command name if listing commands 
| `command_list_usage`          |  | Command usage if listing commands 
| `config_files`                |  | List of configuration files loaded 
| `copy_cursor_line`            |  | Line the cursor is on in copy mode 
| `copy_cursor_word`            |  | Word under cursor in copy mode 
| `copy_cursor_x`               |  | Cursor X position in copy mode 
| `copy_cursor_y`               |  | Cursor Y position in copy mode 
| `current_file`                |  | Current configuration file 
| `cursor_character`            |  | Character at cursor in pane 
| `cursor_flag`                 |  | Pane cursor flag 
| `cursor_x`                    |  | Cursor X position in pane 
| `cursor_y`                    |  | Cursor Y position in pane 


### Hook Variables  
| Variable Name            | Alias | Replaced with                      |
|--------------------------|-------|------------------------------------|
| `hook`                        |  | Name of running hook, if any 
| `hook_pane`                   |  | ID of pane where hook was run, if any 
| `hook_session`                |  | ID of session where hook was run, if any 
| `hook_session_name`           |  | Name of session where hook was run, if any 
| `hook_window`                 |  | ID of window where hook was run, if any 
| `hook_window_name`            |  | Name of window where hook was run, if any 

### Mouse Variables  
| Variable Name            | Alias | Replaced with                      |
|--------------------------|-------|------------------------------------|
| `line`                        |  | Line number in the list 
| `mouse_x`                     |  | Mouse X position, if any 
| `mouse_y`                     |  | Mouse Y position, if any 
| `mouse_line`                  |  | Line under mouse, if any 
| `mouse_word`                  |  | Word under mouse, if any 

### Pane Variables  
| Variable Name            | Alias | Replaced with                      |
|--------------------------|-------|------------------------------------|
| `pane_active`                 |  | 1 if active pane 
| `pane_at_bottom`              |  | 1 if pane is at the bottom of window 
| `pane_at_left`                |  | 1 if pane is at the left of window 
| `pane_at_right`               |  | 1 if pane is at the right of window 
| `pane_at_top`                 |  | 1 if pane is at the top of window 
| `pane_bg`                     |  | Pane background colour 
| `pane_bottom`                 |  | Bottom of pane 
| `pane_current_command`        |  | Current command if available 
| `pane_current_path`           |  | Current path if available 
| `pane_dead`                   |  | 1 if pane is dead 
| `pane_dead_status`            |  | Exit status of process in dead pane 
| `pane_fg`                     |  | Pane foreground colour 
| `pane_format`                 |  | 1 if format is for a pane 
| `pane_height`                 |  | Height of pane 
| `pane_id`                     |`#D`| Unique pane ID 
| `pane_index`                  |`#P`| Index of pane 
| `pane_input_off`              |  | 1 if input to pane is disabled 
| `pane_last`                   |  | 1 if last pane 
| `pane_left`                   |  | Left of pane 
| `pane_marked`                 |  | 1 if this is the marked pane 
| `pane_marked_set`             |  | 1 if a marked pane is set 
| `pane_pid`                    |  | PID of first process in pane 
| `pane_in_mode`                |  | 1 if pane is in a mode 
| `pane_mode`                   |  | Name of pane mode, if any 
| `pane_path`                   |  | Path of pane (can be set by application) 
| `pane_pipe`                   |  | 1 if pane is being piped 
| `pane_right`                  |  | Right of pane 
| `pane_search_string`          |  | Last search string in copy mode 
| `pane_start_command`          |  | Command pane started with 
| `pane_synchronized`           |  | 1 if pane is synchronized 
| `pane_tabs`                   |  | Pane tab positions 
| `pane_title`                  |`#T`| Title of pane (can be set by application) 
| `pane_top`                    |  | Top of pane 
| `pane_tty`                    |  | Pseudo terminal of pane 
| `pane_width`                  |  | Width of pane 
| `wrap_flag`                   |  | Pane wrap flag 

#### Pane Flag Variables  
| Variable Name            | Alias | Replaced with                      |
|--------------------------|-------|------------------------------------|
| `insert_flag`                 |  | Pane insert flag 
| `keypad_cursor_flag`          |  | Pane keypad cursor flag 
| `keypad_flag`                 |  | Pane keypad flag 
| `mouse_all_flag`              |  | Pane mouse all flag 
| `mouse_any_flag`              |  | Pane mouse any flag 
| `mouse_button_flag`           |  | Pane mouse button flag 
| `mouse_sgr_flag`              |  | Pane mouse SGR flag 
| `mouse_standard_flag`         |  | Pane mouse standard flag 
| `mouse_utf8_flag`             |  | Pane mouse UTF-8 flag 
| `origin_flag`                 |  | Pane origin flag 


### History, Buffer, and Copy Mode Variables  
| Variable Name            | Alias | Replaced with                      |
|--------------------------|-------|------------------------------------|
| `rectangle_toggle`            |  | 1 if rectangle selection is activated 
| `scroll_position`             |  | Scroll position in copy mode 
| `scroll_region_lower`         |  | Bottom of scroll region in pane 
| `scroll_region_upper`         |  | Top of scroll region in pane 
| `search_match`                |  | Search match if any 
| `search_present`              |  | 1 if search started in copy mode 
| `selection_active`            |  | 1 if selection started and changes with the cursor in copy mode 
| `selection_end_x`             |  | X position of the end of the selection 
| `selection_end_y`             |  | Y position of the end of the selection 
| `selection_present`           |  | 1 if selection started in copy mode 
| `selection_start_x`           |  | X position of the start of the selection 
| `selection_start_y`           |  | Y position of the start of the selection 
| `copy_cursor_line`            |  | Line the cursor is on in copy mode 
| `copy_cursor_word`            |  | Word under cursor in copy mode 
| `copy_cursor_x`               |  | Cursor X position in copy mode 
| `copy_cursor_y`               |  | Cursor Y position in copy mode 
| `buffer_created`              |  | Time buffer created 
| `buffer_name`                 |  | Name of buffer 
| `buffer_sample`               |  | Sample of start of buffer 
| `buffer_size`                 |  | Size of the specified buffer in bytes 
| `history_bytes`               |  | Number of bytes in window history 
| `history_limit`               |  | Maximum window history lines 
| `history_size`                |  | Size of history in lines 
| `line`                        |  | Line number in the list 


### Session Variables  
| Variable Name            | Alias | Replaced with                      |
|--------------------------|-------|------------------------------------|
| `pid`                         |  | Server PID 
| `session_activity`            |  | Time of session last activity 
| `session_alerts`              |  | List of window indexes with alerts 
| `session_attached`            |  | Number of clients session is attached to 
| `session_attached_list`       |  | List of clients session is attached to 
| `session_created`             |  | Time session created 
| `session_format`              |  | 1 if format is for a session 
| `session_group`               |  | Name of session group 
| `session_group_attached`      |  | Number of clients sessions in group are attached to 
| `session_group_attached_list` |  | List of clients sessions in group are attached to 
| `session_group_list`          |  | List of sessions in group 
| `session_group_many_attached` |  | 1 if multiple clients attached to sessions in group 
| `session_group_size`          |  | Size of session group 
| `session_grouped`             |  | 1 if session in a group 
| `session_id`                  |  | Unique session ID 
| `session_last_attached`       |  | Time session last attached 
| `session_many_attached`       |  | 1 if multiple clients attached 
| `session_marked`              |  | 1 if this session contains the marked pane 
| `session_name`                |`#S`| Name of session 
| `session_path`                |  | Working directory of session 
| `session_stack`               |  | Window indexes in most recent order 
| `session_windows`             |  | Number of windows in session 
| `socket_path`                 |  | Server socket path 
| `start_time`                  |  | Server start time 
| `version`                     |  | Server version 

### Window Variables  
| Variable Name            | Alias | Replaced with                      |
|--------------------------|-------|------------------------------------|
| `window_active`               |  | 1 if window active 
| `window_active_clients`       |  | Number of clients viewing this window 
| `window_active_clients_list`  |  | List of clients viewing this window 
| `window_active_sessions`      |  | Number of sessions on which this window is active 
| `window_active_sessions_list` |  | List of sessions on which this window is active 
| `window_activity`             |  | Time of window last activity 
| `window_activity_flag`        |  | 1 if window has activity 
| `window_bell_flag`            |  | 1 if window has bell 
| `window_bigger`               |  | 1 if window is larger than client 
| `window_cell_height`          |  | Height of each cell in pixels 
| `window_cell_width`           |  | Width of each cell in pixels 
| `window_end_flag`             |  | 1 if window has the highest index 
| `window_flags`                |`#F`| Window flags with # escaped as ## 
| `window_raw_flags`            |  | Window flags with nothing escaped 
| `window_format`               |  | 1 if format is for a window 
| `window_height`               |  | Height of window 
| `window_id`                   |  | Unique window ID 
| `window_index`                |`#I`| Index of window 
| `window_last_flag`            |  | 1 if window is the last used 
| `window_layout`               |  | Window layout description, ignoring zoomed window panes 
| `window_linked`               |  | 1 if window is linked across sessions 
| `window_linked_sessions`      |  | Number of sessions this window is linked to 
| `window_linked_sessions_list` |  | List of sessions this window is linked to 
| `window_marked_flag`          |  | 1 if window contains the marked pane 
| `window_name`                 |`#W`| Name of window 
| `window_offset_x`             |  | X offset into window if larger than client 
| `window_offset_y`             |  | Y offset into window if larger than client 
| `window_panes`                |  | Number of panes in window 
| `window_silence_flag`         |  | 1 if window has silence alert 
| `window_stack_index`          |  | Index in session most recent stack 
| `window_start_flag`           |  | 1 if window has the lowest index 
| `window_visible_layout`       |  | Window layout description, respecting zoomed window panes 
| `window_width`                |  | Width of window 
| `window_zoomed_flag`          |  | 1 if window is zoomed 
| `last_window_index`           |  | Index of last window in session 
| `session_windows`             |  | Number of windows in session 



## Names and Titles  

tmux distinguishes between names and titles.  

### Names  
A session's name is set with the new-session and rename-session commands.  
A window's name is set with one of:  

1. A command argument (such as `-n` for `new-window` or `new-session`).  
2. An escape sequence (if the `allow-rename` option is turned on):  
```bash  
printf '\033kWINDOW_NAME\033\\'  
```
3. Automatic renaming, which sets the name to the active command in the window's active  
     pane.  See the `automatic-rename` option.  

### Titles  
When a pane is first created, its title is the hostname.  
A pane's title can be set via the title setting escape sequence, for example:  
```bash  
printf '\033]2;My Title\033\\'  
```
It can also be modified with the `select-pane -T` command.  




## Status Line Commands  
Commands related to the status line are as follows:  

```bash  
# Open the tmux command prompt in a client.  
command-prompt [-1ikNTW] [-I inputs] [-p prompts] [-t target-client] [template]  

# Ask for confirmation before executing command.  
confirm-before [-p prompt] [-t target-client] command  
(alias: confirm)  

# Display a menu on target-client.  
display-menu [-O] [-c target-client] [-t target-pane] [-T title] [-x position] [-y position]  
(alias: menu)  

# Display a message.  
display-message [-aINpv] [-c target-client] [-d delay] [-t target-pane] [message]  
(alias: display)  

# Display a popup running shell-command on target-client  
display-popup [-CE] [-c target-client] [-d start-directory] [-h height] [-t target-pane] [-w  
(alias: popup)  
```



## Misc Commands  

Getting all panes by numbers:  
```bash  
tmux list-panes -F '#P'  
```

Getting all windows by their numbers:  
```bash  
tmux list-windows -F '#I'  
```

Sending keys to a specific pane:  
```bash  
send-keys -t ${pane} "$@"  
```

Sending keys to a specific pane in a specific window:  
```bash  
send-keys -t ${window}.${pane} "$@"  
```

Listing host and pane number in each pane:  
```bash  
setw -g pane-border-status top  # "off", or "{position}" (e.g., "top")  
```

Get current state of border status:  
```bash  
display-message -p "#{pane-border-status}" 
```

## Window Flags  
The flag is one of the following symbols appended to the window name:  
|Flag |  Meaning 
|-|-  
| `*` | Denotes the current window.  
| `-` | Marks the last window (previously selected).  
| `#` | Window activity is monitored and activity has been detected. (`monitor-activity` window option)  
| `!` | Window bells are monitored and a bell has occurred in the window.  
| `~` | The window has been silent for the monitor-silence interval.  
| `M` | The window contains the marked pane.  
| `Z` | The window's active pane is zoomed.  

## Session Option for Monitoring Activity in a Window  
* `monitor-activity [on | off]`
    * Monitor for activity in the window.  
    * Windows with activity are highlighted in the status line.  
* Window flag `#` 
    * Indicates window activity is monitored and activity has been detected. 
* `activity-action [any | none | current | other]`
    * Set action on window activity when monitor-activity is on.  
* `visual-activity [on | off | both]`
    * If on, display a message instead of sending a bell when activity occurs in a window for  
      which the monitor-activity window option is enabled.  
* `monitor-bell [on | off]`
    * Monitor for a bell in the window.  

Or, monitor for a lack of activity  
* `monitor-silence [interval]`
    * Monitor for silence (no activity) in the window within interval seconds.  
    * Windows that have been silent for the interval are highlighted in the status line.  
    * An interval of zero disables the monitoring.  

Hooks for activity:  
* `alert-activity`: Run when a window has activity. For `monitor-activity`.  
* `alert-bell`: Run when a window has received a bell. For `monitor-bell`.  
* `alert-silence`: Run when a window has been silent. For `monitor-silence`.  


## Hook Commands  
* `set-hook [-agpRuw] [-t target-pane] hook-name command`
    * Sets hook `hook-name` to `command`. (or unsets with `-u`)  
    * The flags are the same as for `set-option`.  
    * With `-R`, run `hook-name` immediately.  

* `show-hooks [-gpw] [-t target-pane]`
    * Shows hooks.  
    * The flags are the same as for `show-options`.  

Example:  
```tmux  
set-hook -g alert-activity 'display "Activity detected."'  
```

