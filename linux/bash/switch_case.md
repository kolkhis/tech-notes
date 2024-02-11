
# Switch Case in Bash  
The `case` statement itself does not directly support regex.  
It uses glob patterns for matching.  

## Syntax  
Basic syntax of switch case in bash:  
```bash  
case <value> in  
    <pattern>)  
        <command>;  
        ;;  
    (<pattern>|<other_pattern>)  
        <command>;  
        ;;  
    *)  
        printf "Default case\n";  
        ;;  
esac  
```
`case <value> in` is the beginning of the switch case.  
* The `value` is the value that will be compared to the patterns. 
* This is typically a variable, but can be any value.  
    * E.g.:  
    ```bash  
    case $1 in  
    ```

Each case starts with a pattern, which is a value or range of values.  
* The patterns can be either surrounded in parentheses `()`, or just ended  
  with a closing parenthesis `)`.  
* Multiple patterns can be given for one case, separated by `|`.  
    * E.g.:  
    ```bash  
    case $1 in  
        (1*|2*|3*)  
            echo "Starts with 1, 2 or 3";  
            ;;  
    ```
    * This can also be done by using a set (`[ ]`):  
    ```bash  
    case $1 in  
        ([123]*)  
            echo "Starts with 1, 2 or 3";  
            ;;  
    ```
    * The above cases will match any value that starts with 1, 2 or 3.  
    * The `*` is a wildcard, which matches any 
      character (see `Pattern Matching` in `man bash`).  

* Each command in a case is ended by a semicolon `;`.  
* Each case is ended by two semicolons `;;` and a newline.  


The default case is defined with `*)`, and is optional.  


## Globbing and Regex in Patterns  
The pattern matching is different from regex you'd normally use in Bash.  
You can use globbing in patterns.  
It's Bash's pattern matching (see `Pattern Matching` in `man bash`).  

Example:  
```bash  
#!/bin/bash  

input="example.txt"  

case "$input" in  
  *.txt)  
    echo "It's a text file."  
    ;;  
  *.jpg|*.png)  
    echo "It's an image file."  
    ;;  
  *)  
    echo "File type is unknown."  
    ;;  
esac  
```


### Pattern Matching Operators  

| Operator | Description 
|-|-  
| `*` | Matches any string, including the null string. (see [note](#a-note-about-in-patterns))  
| `?` | Matches any single character.  
| `[...]` | Matches any one of the enclosed characters. 

#### A note about `*` in patterns:  
When the `globstar` shell option is enabled, and `*` is used in  
a pathname expansion, two `*`s (`**`) used as a single pattern will  
match all files recursively, and zero or more directories and subdirectories.  

### Extended Pattern Matching Operators  
**Note:** This requires the `extglob` option to be enabled with `shopt -s extglob`.  
When extended pattern matching becomes available, you have access 
to more types of operators:  

* `?(pattern-list)`
    * Matches zero or one occurrence of the given patterns  
* `*(pattern-list)`
    * Matches zero or more occurrences of the given patterns  
* `+(pattern-list)`
    * Matches one or more occurrences of the given patterns  
* `@(pattern-list)`
    * Matches one of the given patterns  
* `!(pattern-list)`
    * Matches anything except one of the given patterns  

|  Operator           |  Description  
|-|-  
|  `?(pattern-list)`  |  Matches zero or one occurrence of the given patterns  
|  `*(pattern-list)`  |  Matches zero or more occurrences of the given patterns  
|  `+(pattern-list)`  |  Matches one or more occurrences of the given patterns  
|  `@(pattern-list)`  |  Matches one of the given patterns  
|  `!(pattern-list)`  |  Matches anything except one of the given patterns  


## Tips and Tricks  
Converting the value to lowercase temporarily can make things easier:  
```bash  
# Just change the value to lowercase temporarily  
case ${name,,} in  
```
* Note: This method of string manipulation (parameter expansion) is not POSIX-compliant.  

A POSIX-compliant way to do this:  
```sh  
lname=$(printf "$name" | tr '[:upper:]' '[:lower:]')  
case $lname in  
```




