

# Awk (Advanced Worlking)  

Awk is a programming language for text processing and data wrangling 
(sometimes called data munging).  


[Learn X in Y Minutes](https://learnxinyminutes.com/docs/awk/) where `X = awk`



## Table of Contents  

* [Syntax](#syntax)  
* [Simple Examples](#simple-examples)  
    * [Print the First Column of a Text File](#print-the-first-column-of-a-text-file)  
    * [Searching for a Pattern in the Entire Line](#searching-for-a-pattern-in-the-entire-line)  
    * [Modifying an Entire Line](#modifying-an-entire-line)  
* [Field and Record Separators](#field-and-record-separators)  
* [Built-in Variables in awk](#built-in-variables-in-awk)  
* [Line Variables (Field Variables)](#line-variables-field-variables)  
* [Patterns and Actions](#patterns-and-actions)  
* [Useful Builtin Functions](#useful-builtin-functions)  
* [Control Structures (Conditionals) in awk](#control-structures-conditionals-in-awk)  
* [Passing External Variables](#passing-external-variables)  
* [Builtin Functions](#builtin-functions)  
    * [Awk String Functions](#awk-string-functions)  
    * [Awk Numeric Functions](#awk-numeric-functions)  
    * [Awk Time Functions](#awk-time-functions-gnu-awk)  

## Syntax  
The basic syntax of using `awk`:  
```bash  
awk [options] 'program' input-file(s)  
```

* `options`: Command-line options, such as `-f` to specify a file containing an `awk` script.  
* `program`: A set of instructions for `awk` to execute, typically enclosed in single quotes.  
* `input-file(s)`: The file(s) `awk` will process. If omitted, `awk` reads from the standard input.  


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



## Field and Record Separators  
Awk recognizes two types of separators:  

1. The field separator, which is the character or string that 
   separates **fields** (columns) in a record.  

2. The record separator, which is the character or string that  
    separates **records** (lines) in a file.  

* By default, `awk` uses any whitespace as the field separator 
  and a newline as the record separator.  
* You can specify a field separator using the `-F` option:  
```bash  
awk -F: '{print $1}' /etc/passwd  
```

## Built-in Variables in awk  
These are builtin variables in awk:  
* `FS`: Field separator variable (default is whitespace).  
* `OFS`: Output field separator (default is a space).  
* `NR`: Number of the current record.  
* `NF`: Number of fields in the current record.  

## Line Variables (Field Variables)  

`awk` processes text data as a series of records, which are, by  
default, individual lines in the input text.  

* Each record is automatically split into fields based on a field 
  separator, whitespace by default, can be changed with the `-F` option.  
    * Can also be changed with the `FS` variable from inside `awk`.  
* Fields within a record are accessed using `$1`, `$2`, `$3`, etc., where `$1` is the first field, `$2` is the second field, and so on.  

* `$1`, `$2`, etc., allow you to work with individual pieces of data within a line. 
* `$0` lets you work with the whole line.  


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

### Example  
Print the length of the second field:  
```bash  
awk '{print length($2)}' file.txt  
```

## Control Structures (Conditionals) in awk  

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

## The Begin Keyword
The `BEGIN` keyword is used to initialize variables, perform 
initialization tasks, and to perform any other tasks that need to be 
done before the first record is processed.

* Purpose: The `BEGIN` block in `awk` is executed once before any input lines are processed.
    * It's the perfect place to initialize variables or print headers in your output.
* Usage: You might use `BEGIN` to set the Field Separator (`FS`) to parse CSV files or to print a title row for a report.

### Examples Using `BEGIN`

Loop over the fields of a line and perform a substitution on each field:  
```bash  
awk 'BEGIN {FS=" "} /^#/ for(i=0;i<=NF;i++) {
    gsub("a", "x", $i)  
    print($i);  
    }
}' ./conditionals_in_bash.md 
```
Replaces all occurrences of `a` with `x` in each field, then prints that field.  


Let's add some conditionals:  
```bash  
awk 'BEGIN {FS=" "} /^#/ { for(i=0;i<=NF;i++) {
    if ( i == 1 ) {
        print("-X-")  
    }
    else{
        gsub("a", "x", $i)  
        print($i);  
    }
}
}' ./conditionals_in_bash.md 
```
Does the same thing as before, but prints `-X-` instead of the first field.  

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


