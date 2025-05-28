
# Week 20, more Bash Scripting


## More Advanced Conditionals (Parameter Expansion)

How to force the case into upper or lower for the comparison only?


There are three methods.


## Method 1
### String manipulation (Bash only)
Use a parameter expension, then add two commas after the variable name. This will lowercase the
whole string.
> This method of string manipulation is not available in POSIX shell parameter expansion!
```bash
# Just change the value to lowercase temporarily
case ${name,,} in
```


## Method 2
### String Manipulation in POSIX Shell
Since we can't do that in shell, we have to take a different approach.
Capture the output of a command into a variable.

```sh
lname=$(printf "$name" | tr '[:lower:]' '[:upper:]')
case $lname in
```

Translate/convert characters in a string.
* Using the `tr` command
* `echo "variable" | tr '[:upper:]' '[:lower:]'` - This will change all uppercase to lowercase.
* `tr` requires the first argument and second argument to be the same length, if they're plain strings.
[a-Z] is a set of characters, their numeric equivalent is what will be compared.

```sh
variable="HELLO"
variable=$(printf "$variable" | tr '[:upper:]' '[:lower:]')
echo "$variable"
```

## Method 3
### Globbing (using Pattern Matching)
`help case`
`man bash` then search `/pattern matching`, `/Case modification`

```sh
case $name in
    robin|rob)
        printf "Hello Rob, or Robin";;

```
The colons (` '[:lower:]' `) are NAMED SETS (classes of characters) in pattern matching.
> Extended Globbing is not covered.

* Pattern Matching Characters
    * `*` - Zero or more characters
    * `?` - One or more characters
    * `[a-z]` - Match a range of characters.
    * `'[:lower:]'` - Match a class of characters.
    * `[^a-z]` - Negate a range
    * `[Rr]` - Match one occurence of `r` or `R`
* This is the only way to do matching in certain types of shell.

### Not doing the comparison at all!

#### Bash does not support *extended* regular expression matching

Q. How does the * in pattern matching compare to its Regular Expression equivalent? 
A. `.*` 


### POSIX-compliant printing: Use `printf` instead of `echo`
Use `printf`: This will let bash use the POSIX shell escape sequences.
DO NOT USE `echo -e` (in a script) - It is not supported in some versions of Linux.


## Ascii
`man ascii`

Letter, character, and rune

* Letter = reference to a letter (a, b, c, etc.)

* Character
    * Anything in the ascii charset (limited to 7 bits)
    * Every letter, number, special character (`#`, `{`, `_`, etc) is a `character`
    * `char` has a very specific meaning in `C`
    * `[a-z]` is a set of characters, their numeric equivalent is what will be compared.

* rune = The short name for "Unicode Code Point"
* A rune can be WAY longer than 7 bits long


## Clearing the screen and repositioning the cursor
```bash
clear="\e[H\e[2J"
#  \e[H clears all pixels
#  \e[2J repositions to the top left of the screen
```

## Related
Go back and watch.
Regular Expressions:
    basic
    extended
    perl compatible

Pattern matching in `man bash`
Regex in `man 7 regex`

### Don't confuse pattern matching with regular expression matching.
Use Python/Perl - Perl's regular expression library is the standard.

## Homework
Make a test
1:08:00 - commenting with a command
in double brackets there is no expansion whatsoever, but regex can be used.
Whereas regex does not work in single brackets.
```bash
if [[ $name =~ [Rr]ob(in)? ]]; then
    echo yes
fi
```
`? regular expression case insensitive` - adding switches to regex
`(?i:robin)`
Write the whole thing in bash using `if`/`elif` using regex.

