# Heredocs/Herestrings

Heredocs are a way to treat a block of text as a file within bash.  

Herestrings do the same thing, but for a single line.  

## Heredoc Operators

* `cat << limit_string`: [Basic heredoc](#basic-heredoc)
    * Basic heredoc. Passes everything until the `limit_string` is repeated.  
    * Note: Spaces are not allowed after the `limit_string`.  
    * When the `limit_string` is unquoted, everything inside the heredoc (variable 
      substitution, command substitution, and escape sequences) are enabled in the heredoc.  
* `cat << 'limit_string'`: [Literal heredoc](#printing-literals)
    * When the `limit_string` is quoted, nothing is expanded, and backslashes aren't interpreted as escape sequences.  
    * Only the first `limit_string` needs to be quoted, not the one that ends the heredoc.  
* `cat <<- limit_string`: [Remove tabs](#handling-tab-characters)
    * Heredoc, but ignores leading **tabs** (not spaces) in the heredoc.  
    * This can be combined with literal heredocs by quoting the `limit_string`


* `cat <<< word`
    * Here String. Redirects a single-line string as input.  
        * This can only be a **single line**. 
    * The `word` is expanded, anything except pathname expansion (aside from `~`, which is expanded).  
    * This passes the expanded `word` as a single string to the command.  
    * Herestrings do not use `limit_string`s.  
      ```bash
      ls -alh <<< "$(which ls)"
      ```

Some examples:
```bash
cat << EOF
This is a basic heredoc. 
$USER will be expanded
Current time: $(date) - will be evaluated
EOF

cat << 'EOF'
	This is a literal heredoc.
	$VARIABLE and $(command) are not expanded.
EOF

cat <<- 'EOF'
	All leading TABS (not spaces) will be removed.
	This is a literal heredoc.
	$VARIABLE and $(command) are not expanded.
EOF


cat <<- 'EOF' >> outfile.sh
	printf 'This is a literal heredoc.\n'
	printf 'This literal output will be put in "outfile.sh"\n'
	printf 'All leading TABS (not spaces) will be removed.\n'
	printf '$VARIABLE and $(command) are not expanded.\n'
EOF
```

## Quickref

* Use a Heredoc as a multi-line string literal. (see [this page](https://ioflood.com/blog/bash-multiline-string/))
```bash
cat >>- my_script.sh << 'EOF'
    #!/bin/bash
    # my_script.sh
    printf "This is a multi-line string.\n"
    printf "This code will end up in my_script.sh.\n"
    printf "Since heredocs are mult-line, I can write scripts like this.\n"

    # This won't be evaluated.  
    export SOMEVAR="$(head -1 "$XDG_CONFIG_HOME/secret_key")"

EOF
```

This will make (or append to) the file `my_script.sh`, and will contain
the code in the heredoc:
```bash
#!/bin/bash
# my_script.sh
printf "This is a multi-line string.\n"
printf "This code will end up in my_script.sh.\n"
printf "Since heredocs are mult-line, I can write scripts like this.\n"

# This won't be evaluated.  
export SOMEVAR="$(head -1 "$XDG_CONFIG_HOME/secret_key")"
```

---


* Wrap the first heredoc limit string in single quotes to disable expansion.
    * That means any bash code in the heredoc won't be evaluated.
    * It will be interpreted as a raw string literal.
```bash
cat << 'EOF'
    NOT_A_VAR="$(printf "This won't be expanded.")"
EOF
```


* Append a `-` minus sign to the heredoc operator to strip leading tabs
    * This will **not** strip spaces.
```bash
cat <<- 'EOF'
	This won't be indented.
EOF
```




## Basic Principles of Here Documents  
You can use here documents on the command line and in scripts.  
Heredocs can shove standard input(`stdin`) into a command  
from within a script.  
```bash  
COMMAND << limit_string  
.  
data  
.  
variables  
.  
text  
.  
limit_string  
```

* `COMMAND`: This can be any Linux command that accepts redirected input.  
    * Note, the `echo` command doesn't accept redirected input.  
    * If you need to write to the screen, you can use the `cat` command, which does.  

* `<<`: The redirection operator.  
* `limit_string`: This is a label.  
    * It can be whatever you like as long as it doesn't appear in the content of the heredoc.  
    * It is used to mark the end of the heredoc (text, data, and variables list).  
    * There can be NO whitespace after the `limit_string`s, neither the first nor second.  

* Data List: A list of data to be fed to the command.  
    * It can contain commands, text, and variables.  
    * The contents of the data list are fed into the command one  
      line at a time until the `limit_string` is encountered.  

## Examples  
### Basic Heredoc  
```bash  
#!/bin/bash  
cat << _end_of_text
Your user name is: $(whoami)  
Your current working directory is: $PWD  
Your Bash version is: $BASH_VERSION  
_end_of_text
```
The output of the `whoami` cmd will be printed, since it  
was run in a subshell (command substitution).  

### Printing Literals  
Wrapping the `limit_string` in quotes will have it return everything verbatim.  
It won't expand variables, and it won't do command substitution.  
```bash  
#!/bin/bash  
cat << "_end_of_text"  
Your user name is: $(whoami)  
Your current working directory is: $PWD  
Your Bash version is: $BASH_VERSION  
_end_of_text  
```


### Handling Tab Characters  
Tabs in the Data List are preserved by default.  
When handling tabs or working with tab characters,
you can add a `-` (dash) to the redirection operator.  

* This will ignore all leading tab characters.  

```bash  
#!/bin/bash  
cat <<- _end_of_text  
Your user name is: $(whoami)  
Your current working directory is: $PWD  
Your Bash version is: $BASH_VERSION  
_end_of_text  
```
If your here document is contained in an indented section of a script,
using a dash `-` with the redirection operator removes formatting 
issues caused by the leading tab characters.  


### Redirecting to a File  
The output from the command used with the 
here document can be redirected into a file.  
Redirect it like any other command, putting the  
redirection operator after the `limit_string`.  
```bash  
#!/bin/bash  
cat << _end_of_text > session.txt  
Your user name is: $(whoami)  
Your current working directory is: $PWD  
Your Bash version is: $BASH_VERSION  
_end_of_text  
```

### Piping the output to another command  

The output from the command used (`cat` in these examples) in  
a heredoc can be piped as the input to another command.  
The pipe operator `|` comes after the `limit_string`.  
```bash  
#!/bin/bash  
cat << _end_of_text | sed 's/a\|y/e/g'  
d  
a  
y  
z  
_end_of_text  
```

### Passing Parameters to a Function  

```bash  
#!/bin/bash  

# the set_car_details() function  

set_car_details () {
read make  
read model  
read new_used  
read delivery_collect  
read location  
read price  
}

# The here document that passes the data to set_car_details()  
set_car_details << _mars_rover_data  
NASA  
Perseverance Rover  
Used  
Collect  
Mars (long,lat) 77.451865,18.445161  
2.2 billion  
_mars_rover_data  

# Retrieve the vehicle details  
echo "Make: $make"  
echo "Model: $model"  
echo "New or Used: $new_used"  
echo "Delivery or Collection: $delivery_collect"  
echo "Location: $location"  
echo "Price \$: $price"  
```

### Creating and Sending an Email  

You can use the Linux `mail` command to send an email  
through the local mail system to a user account.  
The -s (subject) option allows us to specify the subject for the email.  
```bash  
#!/bin/bash  
connection="$SSH_CONNECTION"  

mail -s 'Update' kolkhis << _ssh_report  
User name: $(whoami)  
update on the current SSH connection  
State: $connection  
_ssh_report  
```
Then check mail with the `mail` command.  




## Using Heredocs with SSH  
If you have SSH key authorization set up keys between the two computers,
the login process will be automatic, no need for a password.  
If you don't, you'll need to enter your remote user's password to run this.  

You can use the -T (disable pseudo-terminal allocation) option  
because you don't need an interactive pseudo-terminal to be 
assigned to you.  

```bash  
#!/bin/bash  

ssh -T kolkhis@remote-pc.local << _remote_commands  
# Execute commands on the remote machine here  
# Update the log  
echo $USER "-" $(date) >> /home/kolkhis/ssh_log/script.log  
_remote_commands  
```



