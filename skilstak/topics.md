### Week 11:
Screen/Tmux: `./beginner_boost_week11/notes_week11.md` 


### Week 12:
Lynx, configuring and installing.: `./beginner_boost_week12/notes_week12.md` 
ChatGPT with ??


### Week 13:
Networking: `./beginner_boost_week13/notes_week13.md`  
(packets, ports, network layers), network monitoring/diagnostic tools
* `ipconfig`
* `tracepath`
* `traceroute`
* `mtr`
* `ping`
* `netstat`
* `nmap`
* `ncat` - Make your own servers that do whatever you want if you can get
* `strace -p` - sniff the communications of a particular process
* `ufw status verbose` - firewall
* `dig` (is this in there?) - DNS info


### Week 14:
Finding files and vulnerabilities like a hacker: `./beginner_boost_week14/notes_week14.md` 
```bash
lsof
find -ls
find ~ -name somefile -type f -ls -printf %a  # (%a is last accessed time)
chmod
```


### Week 15:
POSIX vs Bash: `./beginner_boost_week15/notes_week15.md` 
(tl;dr: *try* to be POSIX-compliant. bash is cool.)
Shellcheck
Tripwire script (lots of `find` and `grep` examples)
`find -mmin`
`entr`:
    posix:
    `entr bash -c 'clear; shellcheck tripwire' < <(ls tripwire)`
    bash:
    `entr bash -c 'clear; shellcheck tripwire' <<< tripwire`


### Week 16:
Git, repos, and SSH with GitHub: `./beginner_boost_week16/notes_week16.md`
`ssh-keygen`
`KeePassXC` - Check it out
    Extremely secure. A hacker's tool.
    Has a built-in SSH agent, allows you to have passphrases on your keys and automatically inputs them.


### Week 17:
Intro to scripting: `./beginner_boost_week17/notes_week17.md`
Shell injection attack (reassigning env vars)
* AWESOME TIP: 
> Putting a space at the front of a command on the command line will make it not show up in your bash history.


### Week 18:
Procedures and functions: `./beginner_boost_week18/notes_week18.md`
Bash scripting - arguments, $#, $@ vs $*

```bash
$* 
# separated  by  the first character of the IFS special variable.
# That is, "$*" is equivalent to "$1c$2c...",
# where c is the first character of the value of the IFS variable.
# If IFS is unset, the parameters are separated by spaces.
# If IFS is null, the parameters are joined without intervening separators.

$@ # Expands to all the parameters, seperated into their own vars. "$1", "$2"

$#: 
# Expands to the number of positional arguments passed as a decimal.

$- # a hyphen.
# Expands to the current option flags as specified upon invocation,
# by the set builtin command, or those set by the shell itself (such as the -i option).
```
rfcdate (`date --rfc-3339 seconds`)
`entr`
`shfmt`


### Week 19:
Bash and POSIX scripting `./beginner_boost_week19/notes_week19.md`
Conditionals
* `if`/`elif`/`else` statements:
    * POSIX: Single brackets 
    ```sh
    if [ condition ]; then  # MUST have spaces around the brackets.
        echo something
    fi
    ```
    * Bash: Double Brackets
    ```bash
    if [[ condition ]]; then
        echo something
    fi
    ```
* `switch`/`case` statements
Switch/Case statements are in sh/bash, C, Go.
Each case has a value, then `)`, then the code to run
The `*)` is the catch-all if no cases were matched (the `else`).
```bash
case $name in 
    "Lancelot") echo "Hello Lancelot";;  # if
    "Robin")  # elif
        echo "Hello Robin";;
    "Arthur") # elif
        echo "hello there arthur";
        echo "How ya doin";
        echo "Third line";;
    *)  # else
        echo "I don't know your name"
```




`namecheap.com` check for domains
