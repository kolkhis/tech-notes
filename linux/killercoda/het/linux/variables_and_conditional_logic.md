
# Variables and Conditional Logic

1. Check your bash environment vars
```bash
env
printenv

declare -p          # Declare -p(rint)  Prints all declared variables
declare -p | wc -l  # Get the number of declared variables there are

set         # Also prints environment variables
```

* Is there a difference between the above commands?
```bash
printenv | wc -l    # 18
env | wc -l         # 18
declare -p | wc -l  # 64
set | wc -l         # 66
```

Both `printenv` and `env` print the same number of variables; but
`set` and `declare -p` output many more variables.  

* Test the output of a variable named `$name`

```bash
echo "$name"
```





2. Create some variables with system data

* Populate that variable with some info
```bash
uname
name=$(uname)
```

* Can you capture whether or not processes are running? Test for `httpd` and `sshd`

```bash
ps -ef | grep -i [h]ttpd
httpd_check=$(echo $?)

ps -ef | grep -i [s]shd
sshd_check=$(echo $?)
```

* Can you verify that they're correct? Which one is running and which one isn't?

httpd isn't running, sshd is running.


## Decision Structures

There are 3 types of decision structures. They are:
1. Single Alternatives
2. Dual Alternatives
3. Multiple Alternatives

* Test each of these structures with the variables you 
  have from the previous step.


Three primary types of errors:
1. Syntax Error
1. Runtime Error (race conditions etc)
1. Logic



Single Alternatives
```bash
if [ $httpd_check -eq "1" ]; then echo "httpd isn't running"; fi
if [ $sshd_check -eq "1" ]; then echo "sshd isn't running"; fi
```

Dual Alternatives
```bash
if [ $httpd_check -eq "1" ]; then echo "httpd isn't running"; else echo "httpd is running"; fi
if [ $httpd_check -eq "0" ]; then echo "sshd is running"; else echo "sshd isn't running"; fi
```

Multiple Alternatives
```bash
case "$sshdCheck" in  0) echo "sshd is running" ;; 1) echo "sshd is not running" ;; **) echo "something is really wrong" ;; esac
```


### Inclusive "or", Exclusive "and"

#### AND
The `and` (`-a`) logic requires both conditions to be true in order to evaluate to true

```bash
if [ $httpd_check -eq "1" -a $sshd_check -eq "0" ]; then echo "This system is good"; fi
```

#### OR
The `or` (`-o`) logic requires only one condition to be true in order to evaluate to true
```bash
if [ $httpd_check -eq "1" -o $sshd_check -eq "1" ]; then echo "This system is good"; fi
```

