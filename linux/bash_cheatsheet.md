# Linux Command Cheatsheet

## CLI Tools to Become Familiar With
xclip  
npv/nvp # sound clips, pulse audio  
ESXi  
Ncdu  
pandoc  
ffmpeg  
tar  
parallel (GNU Parallel)  
awk  
sed  

cht.sh - cheat sheet website for curling anything  

`ncal` - View a command-line calendar  
`ps aux | grep ssh` - List all processes containing "ssh" in their names.  
`who` - List of users currently logged in, along with their usernames, terminal devices, login
times, and IP addresses (`pts` means SSH sessions)  
`w` - Similar to `who`, with more details (load avg, system uptime)  

`grep -rl "oldstring" *.txt | xargs sed -i 's/oldstring/newstring/g'` - Replace a string in multiple files  
* `grep -r`ecursively, `-l`ist files that have a match  
* `sed` changes file `-i`n-place  



## Colored output for `less`
Kinda janky, and only displays in red, but red is easier to read.
```bash
man bash | grep --color=always -e '.*' | less -R
```



## Using `xargs` to Transform Input into Arguments
`xargs`: transform standard input (stdin) into arguments.
```bash
find . -name d | echo  # won't print anything because it doesn't take stdin as args
find . -name d | xargs echo  # Will print the output of the `find` command.
```

## Numeric Calculations & Random Numbers
Numeric calculations can be done in a subshell in parentheses.
```bas
$((a + 200))      # Add 200 to $a
$(($RANDOM%200))  # Random number 0..199
declare -i count  # Declare as type integer 
count+=1          # Increment
```

## Get the Directory of a Script
```bash
dir=${0%/*}
```

## Search Terms for Bash Man Page
`man bash` 
/pathname expansion
/pattern matching
/coprocesses (`coproc`)
/redirection


## Definitions
The following definitions are used throughout the `bash` man page.
* `blank`: A space or tab.
* `word`: A sequence of characters considered as a single unit by the shell.
          Also known as a token.
* `name`: A word consisting only of alphanumeric characters and underscores, and  beginning  with
          an alphabetic character or an underscore.  Also referred to as an identifier.
* `metacharacter`: 
    A character that, when unquoted, separates words.  One of the following:
    ```bash
    |  & ; ( ) < > space tab newline
    ```
* `control operator`: 
    A token that performs a control function.  It is one of the following symbols:
    ```bash 
    || & && ; ;; ;& ;;& ( ) | |& <newline>
    ```



## Terminal Colors

### 256-colors

38; indicates "foreground"  
5; indicates "256-color"  
```bash
SYNTAX="\e[38;5;${COLOR_CODE}m"
# or, if used in your prompt customization:
SYNTAX="\[\e[38;5;${COLOR_CODE}m\]"
0-7: Standard colors
8-15: Bright colors
16-231: 6x6x6 RGB cube
232-255: Grayscale
```

## SSH Logs and Processes
`journalctl -u ssh` - See SSH login attempts  
You can see the fingerprint of the SSH key is included in the logs. Failed login attempts will appear
like this:  
```bash
Mar 30 17:10:35 web0 sshd[5561]: Connection closed by authenticating user ubuntu 10.103.160.144 port
38860 [preauth]
```
`ps aux | grep ssh` - List all processes containing "ssh" in their names.  
For remote SSH sessions, you will see entries with "pts" in the terminal device column,
indicating that those are pseudo-terminals used for SSH connections.   
"tty" indicates a non-SSH connection.  
These pseudo-terminals allow you to interact with the remote machine as if you were sitting at the physical console.  


## Cron, Cronjobs & Crontabs
1. **Open Crontab Configuration**
Open the crontab configuration file with:
```bash
crontab -e
```

2. **Define a Cron Job**
A cron job is defined by a line in the crontab, which has the following format:
```bash
* * * * * command_to_be_executed
```
* The five asterisks represent:
    1. Minute (0-59)
    1. Hour (0-23)
    1. Day of the month (1-31)
    1. Month (1-12)
    1. Day of the week (0-7, where both 0 and 7 are Sunday)
For example, to run a Python script every day at 3:30 PM:
```bash
30 15 * * * python3 /path/to/the_script.py
```
Or, instead of the 5-asterisks method, special strings can be used
* Common Special Strings:
    * `@reboot`: Run once at startup.
    * `@yearly` or `@annually`: Run once a year, equivalent to `0 0 1 1 *`.
    * `@monthly`: Run once a month, equivalent to `0 0 1 * *`.
    * `@weekly`: Run once a week, equivalent to `0 0 * * 0`.
    * `@daily` or `@midnight`: Run once a day, equivalent to `0 0 * * *`.
    * `@hourly`: Run once an hour, equivalent to `0 * * * *`.



## File and Directory Permissions
The permissions are listed in the following order (left to right):
1. Owner
2. Group
3. Other (any other user not in group)
-rw-r--r--
```bash
##own grp oth
-|---|---|---
```
`chmod` to change permissions.  
`chown` to change file owner.  


## Disable Shellcheck From Within Shell Scripts

To disable shellcheck, use this comment:

```bash
# shellcheck disable=SC2059
```

## Check if an argument is empty
The `-z` conditional flag checks if the string is empty.  
The `-n` conditional flag checks that the string is not empty.  
```bash
if [[ -z "$1" ]]; then
    echo "The first position argument is an empty string."
elif [[ -n "$1" ]]; then
    echo "The first position argument is NOT an empty string."
```
* `-n`: Argument is present
* `-z`: Argument not present


## Get Command Locations, Binaries, and Aliases
* `find` - Finds a file:
* `which` - Shows which binary the command uses.
* `file` - Determine the file type.
* `type` - Builtin. Displays information about the command type.
* `whereis` - Finds the binary, source code, and man pages for a command.

## Using `find` 
### Exclude files using `find`
Basic Exclusion Syntax
```bash
find /path/to/search -type d -name 'directory_to_exclude' -prune -o -print
```
* `-type d`: specifies that you're looking for directories.
* `-name '.git'`: specifies the name of the directory you want to exclude.
* `-prune`: tells find to prune (skip) the directory when it's encountered.
* `-o`: is the **OR** operator.
* `-print`: specifies that any other files or directories that **don't** match the exclusion criteria should be printed.

To print everything in the current directory and all 
subdirectories **EXCEPT** the contents of `.git`:  
```bash
# Exclude '.git' from find:
find . -type d -name '.git' -prune -o -print
```


## Getting Help With Commands
* `whatis <cmd>` - Display one-line man page descriptions
* `man -f <cmd>` - Displays all man pages available for `<cmd>`(same as `whatis`)
* `man -k <cmd>` (same as `apropos <cmd>`) - Searches the short descriptions and man page names for the `<cmd>`
* `man 8 <cmd>` will open chapter 8's `<cmd>` man page.
* `command -V <cmd>` will inspect the `<cmd>`


## Trapping Errors
You can trap errors with the `trap` command.
```bash
trap 'echo Error at about $LINENO' ERR
# or
traperr() {
    echo "ERROR: ${BASH_SOURCE[1]} at about ${BASH_LINENO[0]}"
}
set -o errtrace
trap traperr ERR
```

## Source Relative Files
```bash
source "${0%/*}/../share/foo.sh"
```

## Changing the system's hostname
`hostnamectl hostname <new_hostname>`
`hostname -I` will display the current SSH IP (along with some other stuff)


## Stream Manipulation w/ `awk`, `grep`, and `sed`
Print all lines matching a pattern in a file:
```bash
awk '[pattern] {print $0}' [filename]
grep -E '[pattern]' [filename]
sed
```


## Compare Files

`cmp` - Compare two files byte by byte  
`diff` - Compare two files line by line  
`comm` - Compare two sorted files line by line  
`sort` - Sort a file line by line, write to stdout  


## Loops

```bash
# Basic for loop
for i in /etc/rc.*; do
  echo "$i"
done

# C-like for loop
for ((i = 0 ; i < 100 ; i++)); do
  echo "$i"
done

# Ranges
for i in {1..5}; do
    echo "Welcome $i"
done

# With step size
for i in {5..50..5}; do
    echo "Welcome $i"
done

# Reading lines
while read -r line; do
  echo "$line"
done <file.txt  # Reading from `file.txt`

# Forever (Infinite Loop)
while true; do
    echo "This will run forever."
done
```

## Getting Options and Arguments
```bash
while [[ "$1" =~ ^- && ! "$1" == "--" ]]; do 
    case $1 in
      -V | --version )
        echo "$version";
        exit;;
      -s | --string )
        shift; 
        string=$1 ;;
      -f | --flag )
        flag=1 ;;
    esac;
    shift;
done
if [[ "$1" == '--' ]]; then
    shift;
fi
```


## Options
```bash
set -o noclobber  # Avoid overlay files (echo "hi" > foo)
set -o errexit    # Used to exit upon error, avoiding cascading errors
set -o pipefail   # Unveils hidden failures
set -o nounset    # Exposes unset variables
```

## Glob Options
```bash
shopt -s nullglob    # Non-matching globs are removed  ('*.foo' => '')
shopt -s failglob    # Non-matching globs throw errors
shopt -s nocaseglob  # Case insensitive globs
shopt -s dotglob     # Wildcards match dotfiles ("*.sh" => ".foo.sh")
shopt -s globstar    # Allow ** for recursive matches ('lib/**/*.rb' => 'lib/a/b/c.rb')
```


## Functions & Scripts
Functions are the only way to change the state of the existing shell (e.g., using `cd` to change
directory)  
Scripts cannot do this.  

## Returning Values
To return values in bash/sh, just echo or printf them. 
```bash
myfunc() {
    local myresult='some value'
    echo "$myresult"
}
result=$(myfunc)
```
## Raising Errors
Do not use the `return` keyword for normal function value returns.
`return` raises errors.
```bash
myfunc() {
  return 1
}

if myfunc; then
  echo "success"
else
  echo "failure"
fi
```




## Special Arguments/Parameters
Full list [here](https://web.archive.org/web/20230318164746/https://wiki.bash-hackers.org/syntax/shellvars#special_parameters_and_shell_variables)
* `${PIPESTATUS[n]}`: return value of piped commands (array)
* `$#`:	Number of arguments
* `$*`:	All positional arguments (as a single word)
* `$@`:	All positional arguments (as separate strings)
* `$1`:	First argument
* `$_`:	Last argument of the previous command
* `$?`:	Exit code/Return code of the last command
* `$0`: The name of the shell or the shell script (filename). Set by the shell itself. (`argv[0]`)
* `$$`: The process ID (PID) of the shell. In an explicit subshell it expands to the PID of the current "main shell", not the subshell. This is different from $BASHPID!
* `$!`: The process ID (PID) of the most recently executed background pipeline (like started with command &)
* `$-`: Current option flags set by the shell itself, on invocation, or using the set builtin command. It's just a set of characters.  
In a code block for easier reading:
```bash
${PIPESTATUS[n]}    # return value of piped commands (array)
$#    # Number of arguments
$*    # All positional arguments (as a single word)
$@    # All positional arguments (as separate strings)
$1    # First argument
$_    # Last argument of the previous command
$0    # The name of the shell or the shell script (filename). Set by the shell itself. (`argv[0]`)
$$    # The process ID (PID) of the shell. In an explicit subshell it expands to the PID of the current "main shell", not the subshell. This is different from $BASHPID!
$!    # The process ID (PID) of the most recently executed background pipeline (like started with command &)
$-    # Current option flags set by the shell itself, on invocation, or using the set builtin command. It's just a set of characters.
```



## Arrays in Bash

## List-like Arrays & String Manipulation/Slicing
```bash
Fruits=('Apple' 'Banana' 'Orange')
Fruits[0]="Apple"
Fruits[1]="Banana"
Fruits[2]="Orange"
echo "${Fruits[0]}"           # Element #0
echo "${Fruits[-1]}"          # Last element
echo "${Fruits[@]}"           # All elements, space-separated
echo "${#Fruits[@]}"          # Number of elements
echo "${#Fruits}"             # String length of the 1st element
echo "${#Fruits[3]}"          # String length of the Nth element
echo "${Fruits[@]:3:2}"       # Range (from position 3, length 2)
echo "${!Fruits[@]}"          # Keys of all elements, space-separated

Fruits=("${Fruits[@]}" "Watermelon")    # Push
Fruits+=('Watermelon')                  # Also Push
Fruits=( "${Fruits[@]/Ap*/}" )          # Remove by regex (pattern?) match
unset Fruits[2]                         # Remove one item
Fruits=("${Fruits[@]}")                 # Duplicate
Fruits=("${Fruits[@]}" "${Veggies[@]}") # Concatenate
lines=(`cat "logfile"`)                 # Read from file

for i in "${arrayName[@]}"; do          # Iterating over an array
  echo "$i"
done
```

## Dictionaries (Associative Arrays)
```bash
declare -A sounds
# Declares sound as a Dictionary object (aka associative array).

sounds[dog]="bark"
sounds[cow]="moo"
sounds[bird]="tweet"
sounds[wolf]="howl"

# Working with dictionaries
echo "${sounds[dog]}" # Dog's sound
echo "${sounds[@]}"   # All values
echo "${!sounds[@]}"  # All keys
echo "${#sounds[@]}"  # Number of elements
unset sounds[dog]     # Delete dog

# Iterate over values
for val in "${sounds[@]}"; do
  echo "$val"
done

# Iterate over keys
for key in "${!sounds[@]}"; do
  echo "$key"
done
```





## Process Substitution
`man bash; /Process Substitution`
Process substitution allows a process's input or output to be referred to using a filename.  
It  takes the form of <(list) or >(list).  The process list is run asynchronously, and its input or output appears as a filename.  
This filename is passed as an argument to the current command as the result of the expansion.  
If the >(list) form is used, writing to the file will provide input for list.  
If the <(list) form is used, the file passed as an argument should be read to obtain the output of list.  
Process substitution is supported on systems that support
named pipes (FIFOs) or the /dev/fd method of naming open files.  


## Transforming Strings with `tr`
Transform strings
* `-c` 	Operations apply to characters not in the given set
* `-d` 	Delete characters
* `-s` 	Replaces repeated characters with single occurrence
* `-t` 	Truncates
* `[:upper:]` 	All upper case letters
* `[:lower:]` 	All lower case letters
* `[:digit:]` 	All digits
* `[:space:]` 	All whitespace
* `[:alpha:]` 	All letters
* `[:alnum:]` 	All letters and digits
```bash
echo "Welcome To This Wonderful Shell" | tr '[:lower:]' '[:upper:]'
#=> WELCOME TO THIS WONDERFUL SHELL
```

## All Bash Conditional Flags

* -a file
          True if file exists.
* -b file
          True if file exists and is a block special file.
* -c file
          True if file exists and is a character special file.
* -d file
          True if file exists and is a directory.
* -e file
          True if file exists.
* -f file
          True if file exists and is a regular file.
* -g file
          True if file exists and is set-group-id.
* -h file
          True if file exists and is a symbolic link.
* -k file
          True if file exists and its ``sticky'' bit is set.
* -p file
          True if file exists and is a named pipe (FIFO).
* -r file
          True if file exists and is readable.
* -s file
          True if file exists and has a size greater than zero.
* -t fd   
          True if file descriptor fd is open and refers to a terminal.
* -u file
          True if file exists and its set-user-id bit is set.
* -w file
          True if file exists and is writable.
* -x file
          True if file exists and is executable.
* -G file
          True if file exists and is owned by the effective group id.
* -L file
          True if file exists and is a symbolic link.
* -N file
          True if file exists and has been modified since it was last read.
* -O file
          True if file exists and is owned by the effective user id.
* -S file
          True if file exists and is a socket.
* file1 -ef file2
          True if file1 and file2 refer to the same device and inode numbers.
* file1 -nt file2
          True if file1 is newer (according to modification date) than file2, or if file1  exists  and file2 does not.
* file1 -ot file2
          True if file1 is older than file2, or if file2 exists and file1 does not.
* -o optname
          True  if the shell option optname is enabled.  See the list of options under the description
          of the -o option to the set builtin below.
* -v varname
          True if the shell variable varname is set (has been assigned a value).
* -R varname
          True if the shell variable varname is set and is a name reference.
* -z string
          True if the length of string is zero.
   string
* -n string
          True if the length of string is non-zero.
* string1 == string2
    * string1 = string2
          True if the strings are equal.  = should be used with the test  command  for  POSIX  conformance.
          When  used  with  the [[ command, this performs pattern matching as described above (Compound Commands).
* string1 != string2
          True if the strings are not equal.
* string1 < string2
          True if string1 sorts before string2 lexicographically.
* string1 > string2
          True if string1 sorts after string2 lexicographically.

#### Arithmetic Operators:
* `-eq`: (`==`) Is equal to   
* `-ne`: (`!=`) Not equal to   
* `-lt`: (`<`) Less Than   
* `-le`: (`<=`) Less than or equal to 
* `-gt`: (`>`) Greater than
* `-ge`: (`>=`) Greater than or equal to


## Interpreter Order of Operations
1. Command is executed
1. Results in a simple command and an optional list of args:
    1. If the command has no slashes, it looks for a shell function of that name.
    1. If no shell function is found, the shell searches for a builtin.
    1. No slashes, shell function, or builtin, shell searches for a binary in `$PATH`
        * Bash uses a hash table to remember full pathnames of binaries.
        * Full search only happens if command isn't found in the hash table.
    1. If nothing is found, shell seraches for `command_not_found_handle` function.


## Parameter Expansion (Slicing/Substitution)
60j
### Slicing
```bash
name="John"
echo "${name}"
echo "${name/J/j}"    #=> "john" (substitution)
echo "${name:0:2}"    #=> "Jo" (slicing)
echo "${name::2}"     #=> "Jo" (slicing)
echo "${name::-1}"    #=> "Joh" (slicing)
echo "${name:(-1)}"   #=> "n" (slicing from right)
echo "${name:(-2):1}" #=> "h" (slicing from right)
echo "${food:-Cake}"  #=> $food or "Cake"
length=2
echo "${name:0:length}"  #=> "Jo"
# Cutting out the suffix
str="/path/to/foo.cpp"
echo "${str%.cpp}"    # /path/to/foo
echo "${str%.cpp}.o"  # /path/to/foo.o
echo "${str%/*}"      # /path/to
# Cutting out the prefix
echo "${str##*.}"     # cpp (extension)
echo "${str##*/}"     # foo.cpp (basepath)
# Cutting out the path, leaving the filename
echo "${str#*/}"      # path/to/foo.cpp
echo "${str##*/}"     # foo.cpp

echo "${str/foo/bar}" # /path/to/bar.cpp

str="Hello world"
echo "${str:6:5}"   # "world"
echo "${str: -5:5}"  # "world"

src="/path/to/foo.cpp"
base=${src##*/}   #=> "foo.cpp" (basepath)
dir=${src%$base}  #=> "/path/to/" (dirpath)
```

### Substitution
```bash
${foo%suffix} 	Remove suffix
${foo#prefix} 	Remove prefix
${foo%%suffix} 	Remove long suffix
${foo/%suffix} 	Remove long suffix
${foo##prefix} 	Remove long prefix
${foo/#prefix} 	Remove long prefix
${foo/from/to} 	Replace first match
${foo//from/to} 	Replace all
${foo/%from/to} 	Replace suffix
${foo/#from/to} 	Replace prefix
```

### Substrings
```bash
${foo:0:3} 	    # Substring (position, length)
${foo:(-3):3} 	# Substring from the right
```

### Getting the Length of a String/Variable
```bash
${#foo} 	   # Length of $foo
```

## PS1, PS2, PS3, and PS4 Special Environment Variables
### PS1
The PS1 environment variable is used to customize the terminal prompt.  

What it does: This is the main shell prompt that you see.  
It's highly customizable and can include variables, escape sequences, and functions.
Example: `export PS1="\u@\h:\w\$ " `
See `./customizing_terminal.md`

### PS2: Secondary Prompt String
What it does: This is the prompt displayed when a command is not finished.  
For example, if you type echo "hello and don't close the quote, you'll see this prompt.
Example: `export PS2="> "`


### PS3: Prompt String for select
What it does: This is the prompt used in shell scripts for the select loop, which is used to generate menus.
Example: `export PS3="Please make a choice: "`

### PS4: Debug Prompt String
What it does: This is displayed when debugging a script.  
It's prepended to each line of output when using set -x for debugging.
Example: `export PS4='+${BASH_SOURCE}:${LINENO}:${FUNCNAME[0]}: '`


## Get bits: Zero, random or random 0/1

`/dev/zero` : returns zero  
`/dev/random` : returns random number  
`/dev/urandom` : returns random 0 or 1  


## SysAdmin Relevant - Firewall and Network commands

`service` - Run a System V init script  
`ufw` - Firewall stuff  
`iptables` - Admin took for packet filtering and NAT  
`whereis` - Find binary, source, and man page for a command.  


## Redirecting Standard Output AND Standard Error
Note that the order of redirections is significant.  For example, the command
```bash
# Correct
ls > dirlist 2>&1
```
directs both standard output and standard error to the file dirlist, while the command
```bash
# Incorrect
ls 2>&1 > dirlist
```
directs  only  the  standard output to file dirlist, because the standard error was duplicated
from the standard output before the standard output was redirected to dirlist.


##### Credit
A lot of this was taken from [devhints.io](https://devhints.io/bash).

