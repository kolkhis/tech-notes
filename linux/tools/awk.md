# Awk (Advanced Worlking)  

Awk is a programming language for text processing and data wrangling 
(sometimes called data munging).  
A great resource: [Learn X in Y Minutes](https://learnxinyminutes.com/docs/awk/) where `X = awk`

* A note on examples:  
Some of the examples in these notes will assume that awk is being run from the command line.  
E.g.,:  
```bash
awk 'pattern {action;}' file.txt  
```
The starting command `awk`, input file, and single quotes will be assumed.  
If there's an example that doesn't start with `awk`, this applies.  



## Table of Contents
* [Syntax](#syntax) 
    * [Basic Syntax of an Awk on the Command Line](#basic-syntax-of-an-awk-on-the-command-line) 
    * [Basic Syntax of an Awk Script](#basic-syntax-of-an-awk-script) 
* [Field and Record Separators](#field-and-record-separators) 
* [Simple Examples](#simple-examples) 
    * [Print the First Column of a Text File](#print-the-first-column-of-a-text-file) 
    * [Searching for a Pattern in the Entire Line](#searching-for-a-pattern-in-the-entire-line) 
    * [Modifying an Entire Line](#modifying-an-entire-line) 
* [Variables in Awk](#variables-in-awk) 
    * [Built-in Variables](#built-in-variables) 
    * [Line Variables (Field Variables)](#line-variables-field-variables) 
    * [Declaring Variables](#declaring-variables) 
* [Patterns and Actions](#patterns-and-actions) 
* [Useful Builtin Functions](#useful-builtin-functions) 
    * [Basic Usage Example](#basic-usage-example) 
* [Control Structures in Awk](#control-structures-in-awk) 
    * [Example: Loop over the fields of a line](#example-loop-over-the-fields-of-a-line) 
* [Conditionals in Awk](#conditionals-in-awk) 
    * [1. Relational Operators](#1-relational-operators) 
    * [Conditionals Examples](#conditionals-examples) 
* [Logical Operators](#logical-operators) 
    * [Logical Examples](#logical-examples) 
* [Regular Expression Match](#regular-expression-match) 
    * [Regex Examples](#regex-examples) 
* [Conditional (Ternary) Operator](#conditional-ternary-operator) 
    * [Ternary Examples](#ternary-examples) 
* [The BEGIN Keyword](#the-begin-keyword) 
* [The END Keyword](#the-end-keyword) 
* [Examples Using `BEGIN` and `END`](#examples-using-begin-and-end) 
    * [Output the Number of Headers in a Markdown File](#output-the-number-of-headers-in-a-markdown-file) 
    * [Loop Over the Fields of a Line](#loop-over-the-fields-of-a-line) 
    * [Loop over the fields of header lines in a markdown file](#loop-over-the-fields-of-header-lines-in-a-markdown-file) 
* [Passing External Variables](#passing-external-variables) 
* [Builtin Functions](#builtin-functions) 
    * [Awk String Functions](#awk-string-functions) 
    * [Awk Numeric Functions](#awk-numeric-functions) 
    * [Awk Time Functions (GNU `awk`)](#awk-time-functions-gnu-awk) 
    * [Function Examples](#function-examples) 
* [Using Awk as an Interpreter](#using-awk-as-an-interpreter) 



## Syntax  
### Basic Syntax of an Awk on the Command Line
The basic syntax of using `awk` on the command line:  
```bash  
awk [options] 'program' input-file(s)  
```

* `options`: Command-line options (e.g., `-f` to specify a file containing an `awk` script).  
* `program`: Instructions for `awk` to execute, typically enclosed in single quotes.  
* `input-file(s)`: The file(s) `awk` will process. 
    * If no files are given, `awk` reads from the standard input.  


### Basic Syntax of an Awk Script
Awk is also an **interpreter** for a programming language.  
That means it can be used in the shebang line of a script.  

The structure of an Awk script:
```awk
#!/bin/awk -f
 
# This is a comment
 
BEGIN { print "START" }
      { print         }
END   { print "STOP"  }
```

* Notice the `-f` option following `#!/bin/awk`. 
    * The `-f` option specifies the Awk file containing the instructions.
    * This is used in the command line when you use Awk to execute a file 
      directly (`awk -f filename`).  
* The `BEGIN` and `END` blocks are optional.  
1. `BEGIN { ... }`: Executed before processing the first line of input.  
2. `      { ... }`: The **pattern** and **action** blocks to execute for each line of input.  
3. `END   { ... }`: Executed after processing the last line of input.  


## Field and Record Separators  
Awk recognizes two types of separators:  

1. The field separator, which is the character or string that 
   separates **fields** (columns) in a record.  
    * Also called the delimiter.  

2. The record separator, which is the character or string that  
    separates **records** (lines) in a file.  

* By default, `awk` uses any whitespace as the field separator 
  and a newline as the record separator.  
* You can specify a field separator using the `-F` option:  
```bash  
awk -F: '{print($1)}' /etc/passwd  
```
**Note**: Parentheses are optional for the `print` function.  

* You can also specify a new field separator or delimiter from within the `awk` program, using 
  the `BEGIN` block:  
    ```bash  
    awk 'BEGIN { FS=":" } {print($1)}' /etc/passwd  
    ```
  


## Simple Examples  
### Print the First Column of a Text File:  
```bash  
awk '{print $1}' file.txt  
```

* `{print $1}` is the `awk` program that instructs `awk` to print the  
  first field (`$1`) of each record (typically, a line in the file).  

### Searching for a Pattern in the Entire Line:  
```bash  
awk '/pattern/ {print $0}' file.txt  
```

### Modifying an Entire Line  
```bash  
awk 'BEGIN {FS=":"} {print $1, $2}' /etc/passwd  
```


## Variables in Awk

### Built-in Variables
These are builtin variables in awk:  

* `FS`: Field separator variable (default is whitespace).  
* `OFS`: Output field separator (default is a space).  
* `NR`: Number of the current record (line).  
* `NF`: Number of fields in the current record.  
    * This can be used to print the last field in a line when we don't know how many
      fields there are.
      ```bash
      cat somefile | awk '{ print $NF }'
      ```
      If there are 7 fields, `NF` holds the value 7. So, `$NF` is equivalent to `$7`.  


### Line Variables (Field Variables)  

`awk` processes text data as a series of records, which are, by  
default, individual lines in the input text.  

* Each record is automatically split into fields based on a field 
  separator, whitespace by default, can be changed with the `-F` option.  
    * The separator can also be changed with the `FS` variable from inside `awk`.  
* Fields in a record are accessed using `$1`, `$2`, `$3`, etc.
    * `$1` is the first field, `$2` is the second field, and so on.  
    * `$0` is the entire line.

### Declaring Variables 
When you use a variable in `awk`, it is automatically initialized.  
That means it does not need to be explicitly declared.  
```bash
awk 'BEGIN {var = "value"} {print(var)}'
```


## Patterns and Actions  

`awk` programs follow a pattern-action model:  
```bash  
pattern { action }
```
The action is performed on lines that match the pattern.  

E.g., to print lines where the first field is greater than 10:  
```bash  
awk '$1 > 10 {print}' file.txt  
```

## Useful Builtin Functions  
See [builtin functions](#builtin-functions)  

* `printf()`: Prints a format string to stdout.  
* `length()`: Returns the length of a string.  
* `split()`: Splits a string into an array.  
* `substr()`: Returns a substring of a string.  

### Basic Usage Example  
Print the length of the second field:  
```bash  
awk '{print length($2)}' file.txt  
```

## Control Structures in Awk  

`awk` supports common control structures like `if-else`, `while`, `for`, and `do-while`.  

Example: Print fields greater than 10:  
```bash  
awk '{for (i = 1; i <= NF; i++) if ($i > 10) print $i}' file.txt  
```
This program iterates over each field in the current record.  
The iterator uses `NF` (number of fields/columns) as its max index.  
When the index is greater than 10 (i.e., columns 10+), it prints the 
field at the current index.  

### Example: Loop over the fields of a line 
Use a `for` loop to print each field in a line:  
```bash  
awk '{ for(i=1; 1<=NF; i++) print($i); }' file.txt  
```

---


## Conditionals in Awk

### Relational Operators

Relational operators compare two values or expressions.  
awk supports the following relational operators: 

* `<`  
* `<=`  
* `==`  
* `!=`  
* `>=`  
* `>`
* `~` (regex match) 
* `!~` (regex not match)


### Conditionals Examples:

* **Numeric Comparison**:
```bash
awk '$1 > 100 { print $0 }' data.txt
```
* This prints lines where the value in the first field is greater than 100.


* **String Equality**:
```bash
awk '$2 == "admin" { print $0 }' /etc/passwd
```
* This prints lines from the `/etc/passwd` file where the second field is "admin".

    
* **Not Equal**:
```bash
awk 'NF != 5 { print $0 }' data.txt
```
This prints lines that don't have exactly 5 fields.


---


## Logical Operators

Logical operators are used to combine multiple conditions. `awk` supports logical AND (`&&`), OR (`||`), and NOT (`!`).

### Logical Examples:

1. **Logical AND**:
```bash
awk '$1 > 100 && $2 < 200 { print $0 }' data.txt
```

* This prints lines where the first field is "John" or the second field is 50 or more.
    
* **Logical NOT**:
```bash
awk '!($1 == "admin") { print $0 }' /etc/passwd
```
This prints lines where the first field is not "admin".


---


## Regular Expression Match

Regex in awk is available: the `~` (match) and `!~` (not match)
operators are used with regular expressions to test if a field or
string matches or doesn't match a given pattern.

### Regex Examples:
    
1. **Regular Expression Match**:
```bash
awk '$1 ~ /^admin/ { print $0 }' /etc/passwd
```

* This prints lines where the first field starts with "admin".
    
* **Regular Expression Not Match**:
```bash
awk '$1 !~ /^root/ { print $0 }' /etc/passwd
```

* This prints lines where the first field does not start with "root".
    
* **Field Match**:
```bash
awk '$3 ~ /[0-9]+/ { print $0 }' data.txt
```
This prints lines where the third field contains one or more digits.


---


## Conditional (Ternary) Operator

The ternary operator `?:` is used to choose between two values based on a condition.  
It is the only ternary operator in `awk`.  

### Ternary Examples:

1. **Inline Conditions**:
```bash
awk '{ print ($1 > 50) ? "High" : "Low" }' data.txt
```

* This prints "High" if the first field is greater than 50, and "Low" otherwise.

* **Field Selection**:
```bash
awk '{ print ($1 > $2) ? $1 : $2 }' data.txt
```

* This prints the larger of the first two fields.

* **Adjust Output Based on Conditions**:
```bash
awk '{ printf("%s - %s\n", $1, ($2 > 100) ? "Expensive" : "Cheap")}' prices.txt
```
This prints each item's name and categorizes it as "Expensive" or "Cheap" based on the second field.


---  


## The BEGIN Keyword  
The `BEGIN` keyword is a block of code that is executed before the main program starts processing  
input.  
It's used to initialize variables, perform initialization tasks, and to perform any 
other tasks that need to be done before the first record is processed.  

* Purpose: The `BEGIN` block in `awk` is executed one time, before any input lines are processed.  
    * It's the perfect place to initialize variables or print headers in your output.  
* Usage: You might use `BEGIN` to set the Field Separator (`FS`) to parse CSV files or to print a title row for a report.  

Example:  
```bash  
awk 'BEGIN {FS=" "; count=0;} { count++; printf("Line number: %d", count) }' myfile  
```
This prints the line number of each line in the file.  

## The END Keyword  
The `END` keyword is similar to `BEGIN`, but happens at the end of the program.  
It's used to perform any cleanup tasks after all the input lines have been processed.  

* Purpose: The `END` block is executed one time, after all input lines have been processed.  
    * It's ideal for summarizing data, such as calculating averages or totals.  
* Usage: Use `END` to perform actions that should only occur after all input has been read.  
    * E.g., displaying a total count of processed records.  

Example:  
```bash  
awk '{ count++ } END { printf("Total Records: %d", count)}' myfile  
```

* Here, the `count` variable is *implicitly* initialized to 0.  
    * This means that variable declaration is not required 
    * While declaration is not required, it is encouraged.  
* Then when the input is finished being processed, the `END` block is run.  
    * Here, it prints the total number of records processed (the number of lines).  

## Examples Using `BEGIN` and `END`

### Output the Number of Headers in a Markdown File  
Using a pattern to count the number of headers in a markdown file:  
```bash  
awk 'BEGIN {FS=" "; count=0;} /^#/ {count++} END {print(count)} ' ./conditionals_in_bash.md  
```
Output the current count each time a header line is found:  
```bash  
awk 'BEGIN {count = 0;} 
    /^#/ {
        count++; 
        print("Header number " count " found.");  
    } 
    END {print(count);  
    } ' ./conditionals_in_bash.md 
```
When using multiple lines, the opening brace (`{`) must be on the same line as their  
corresponding block declaration.  i.e., the `BEGIN` or `END` keyword, patterns, etc.  
If they're not, the block will be treated as the main program.  

---  

### Loop Over the Fields of a Line  
Loop over the fields of a line and perform a substitution on each field.  
Set the field separator to a space (which is default but for example purposes):  
```awk  
BEGIN {FS=" "} 
/^#/ { for(i=0;i<=NF;i++) {
        gsub("a", "x", $i);  
        print($i)  
    }
}  "./conditionals_in_bash.md" 
```
Replaces all occurrences of `a` with `x` in each field, then prints that field.  


Let's add some conditionals:  
```awk  
BEGIN {FS=" "} /^#/ { 
for(i=0;i<=NF;i++) {
    if ( i == 1 ) {
        print("-X-")  
    }
    else {
        gsub("a", "x", $i)  
        print($i);  
    }
} 
} "./conditionals_in_bash.md" 
```
Does the same thing as before, but prints `-X-` instead of the first field.  

---  


### Loop over the fields of header lines in a markdown file  

Loop over the fields of header line and perform a substitution on each field.  
Keep track of how many header lines are found, and how many substitutions are made:  
```awk  
BEGIN {
FS=" "; headers=0; subs=0;  
} 
/^#/ { 
    for(i=0;i<=NF;i++) {
        subs+=gsub("a", "x", $i);  
        printf("Header: %d - %s Subs: %d\n", count, $i, subs)  
    }
    headers++  
}
END {
printf("Total Substitutions: %d\nTotal Headers: %d\n", subs, headers)  
} "./conditionals_in_bash.md" 
```


## Passing External Variables  

Use the `-v` option to pass external variables to `awk`:  
```bash  
awk -v var="value" '{print var, $1}' file.txt  
```


## Builtin Functions  
Anything in square brackets `[ ]` is optional.  

### Awk String Functions  

1. `gsub(r, s [, t])`: Globally substitutes `s` for each match of the regular  
   expression `r` in the string `t`.  
    * If `t` is not supplied, operates on `$0`.  
    * Several chars/strings can be given to `r` with the OR `|` operator: `"a|b"`
2. `index(s, t)`: Returns the index of the substring `t` in the string `s`.  
    * Returns `0` if `t` is not provided.  
3. `length([s])`: Returns the length of string `s`.  
    * Returns the length of `$0` if `s` is not provided.  
4. `match(s, r)`: Tests if the string `s` contains a substring matched by the regex `r`.  
    * Returns the index of the first match.  
5. `split(s, a [, r])`: Splits the string `s` into the array `a` on the regex `r`.  
    * Returns the number of fields.  
6. `sprintf(fmt, ...)`: Returns the string resulting from formatting the arguments  
   according to the C-style format string `fmt`.  
    * `printf` can be used to print format string directly.  
7. `sub(r, s [, t])`: Substitutes `s` for the first match of the regular expression `r` in the string `t`.  
    * If `t` is not specified, operates on `$0`.  
8. `substr(s, i [, n])`: Returns the substring of `s` starting at index `i`, with length `n`.  
    * If `n` is not supplied, returns the substring from `i` to the end of `s`.  
9. `tolower(s)`: Returns an all-lowercase copy of the string `s`.  
10. `toupper(s)`: Returns an all-caps copy of the string `s`.  


### Awk Numeric Functions  

1. `atan2(y, x)`: Returns the arctangent of `y/x` in radians.  
2. `cos(x)`: Returns the cosine of `x`, where `x` is in radians.  
3. `exp(x)`: Returns the exponential of `x`.  
4. `int(x)`: Returns the integer part of `x`, truncating towards zero.  
5. `log(x)`: Returns the natural logarithm of `x`.  
6. `rand()`: Returns a random number `n`, where `0 <= n < 1`.  
7. `sin(x)`: Returns the sine of `x`, where `x` is in radians.  
8. `sqrt(x)`: Returns the square root of `x`.  
9. `srand([x])`: Sets the seed for `rand()` to `x` and returns the previous seed. 
    * If `x` is omitted, uses the system time to set the seed.  

### Awk Time Functions (GNU `awk`)  

1. `strftime([format [, timestamp]])`: Formats the timestamp according to `format`.  
    * Without arguments, formats the current time.  
2. `systime()`: Returns the current time as a timestamp (number of seconds 
   since the "epoch", `1970-01-01 00:00:00 UTC`).  


### Function Examples

For example, to get only the numbers (IP, day, port number, etc.) from invalid SSH attempts:
```bash
journalctl -u ssh | grep invalid | awk 'BEGIN {FS=" "} { gsub("[^0-9 \.]", "", $0); print($0);}'
```
To get only the IP and port numbers from there:
```bash
journalctl -u ssh | 
    grep invalid | 
    awk '
    BEGIN {FS=" "} 
    { 
        gsub("[^0-9 \.]", "", $0); 
        printf("IP Address: %s - Port: %d\n", $4, $5); 
    }'
```


## Looping over a Single Line
Use a `for` loop to loop over a single line when piping through `awk`:
```bash
echo "$thing" | awk -F '[ =]' '{
    for(i=1; i< NF; i++) 
    if($i == "ansible_host") print $(i+1) }'
```

* `-F '[ =]`: Use **either** a space or equals sign as the field separator.  


### Example: Extracting the Node IP from an Ansible Host file
```bash
while read -r l; do
# E.g., Extracting the node IP from an ansible host file:
    NODE=$(printf "%s" "$l" | awk -F '[ =]' '{ for(i=1; i< NF; i++) if($i == "ansible_host") print $(i+1) }')
done < ./hosts
```

* `-F '[ =]`: Use **either** a space or equals sign as the field separator.  
* `{ for (i=1; i<NF; i++)`: 
    - The `{` opens the main block meaning it will start processing the input. 
    - `for(i=1; i<NF; i++)`: A C-style loop that will go from `1` to the number of
      fields there are (separated by either spaces or `=`).  
* `if($i == "ansible_host")`: Checks if the current field (held at `$i`) is `"ansible_host"`.  
    * `print $(i+1)`: Print the field right after `"ansible_host"`.  

## Using Awk as an Interpreter
 
When running `awk` without feeding it any input, either via pipe or file, it will run the 
program given as a script.
 
It will process user input as records (lines), as if it were reading from a file.
 
E.g.:
```bash
awk 'BEGIN {FS=" "} {gsub("a|e|i", "x", $0); printf("%s - %d\n", $0, length($0))}'
```
This will wait for input, and will replace each 
occurrence of `a`, `e`, or `i` with `x`, and
output the result.

## Removing Duplicate Lines with Awk

You can use `awk` to remove all duplicate lines from a file by using an associative
array and creating keys out of the lines.  


```bash
awk '!seen[$0]++' file > file.deduped
```

- `seen[$0]`: This uses the entire line as a key in the associate array `seen`.  
- `++`: Increment the count for that line (from `0` to `1`).  
- `!`: Check if the condition is false.  
- `!seen[$0]++`: Returns `true` only for the **first time** a line is seen (before
  incrementing).  
    - This will print only the **first** occurrence of each unique line.  

By default, when using a condition like this, awk will print the whole line (`$0`) if
there are no other arguments.  

If you wanted to provide arguments to this condition, then you could do so:
```bash
awk '!seen[$0]++ { print $1 }'
```
This will do the same thing, but only print the first column of unique lines.  

This follows the same `pattern { action }` format that any other awk program does.  




