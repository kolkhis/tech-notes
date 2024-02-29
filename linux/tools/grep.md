

# The Grep Command  
Print lines that match patterns.  

## Table of Contents
* [The Grep Command](#the-grep-command) 
* [tl;dr](#tl;dr) 
* [Using Grep](#using-grep) 
    * [ Basic vs Extended Regular Expressions](#-basic-vs-extended-regular-expressions) 
    * [Alternation (matching any one of multiple expressions)](#alternation-matching-any-one-of-multiple-expressions) 
    * [Other Useful `grep` Options](#other-useful-grep-options) 
* [Character Classes and Bracket Expressions](#character-classes-and-bracket-expressions) 
    * [What can go inside the brackets](#what-can-go-inside-the-brackets) 
    * [Character Classes and Their Matches](#character-classes-and-their-matches) 
    * [Inverting the Matches (Match Non-Matching)](#inverting-the-matches-match-non-matching) 
* [Exmaples](#exmaples) 
    * [Count Occurrences of a Word](#count-occurrences-of-a-word) 
    * [Search Recursively in Directory](#search-recursively-in-directory) 
    * [Find Lines Not Containing the Pattern](#find-lines-not-containing-the-pattern) 
    * [Search While Ignoring Case](#search-while-ignoring-case) 
* [Note on `fgrep` (Fixed Strings)](#note-on-fgrep-fixed-strings) 
* [Grep Colors](#grep-colors) 
    * [Breakdown](#breakdown) 

## tl;dr:
Syntax:
```bash
grep -E '^expression$' [filename]
grep -n -r -E '^#?#\s\s?.*$'  # Get all markdown H1 and H2s
#
# -n: Line Numbers; -r: recusive; -E: Extended Regex
```
* `-v` will print the lines that *don't* match the pattern.
    * Matches NON-MATCHING lines.  
* `-n` will output the line number of the match.
    * No effect used with `-r`/`-R`
* `-E` will enable *Extended* regex.
* `-r` will recursively search starting from working directory. 
    * When a file is provided, this doesn't have any effect.
    * `-R` is the same as `-r` but will follow symlinks.
* `-l` will only print the filenames of files with matches.
    * `-L` will output the filenames of files WITHOUT matches.


## Using Grep  
The greps:  
```bash  
grep   # Regular grep with 
egrep  
fgrep  
rgrep 
```
* `grep`: Uses Basic Regular Expressions (BRE) by default.  
* `egrep`: Uses Extended Regular Expressions (ERE).  
    * Equivalent to `grep -E`
* `fgrep`: Treats the pattern as a fixed string, not a regular expression.  
    * Equivalent to `grep -F`
* `rgrep`: Recursively searches directories.  
    * Equivalent to `grep -r`

###  Basic vs Extended Regular Expressions:  
* Basic Regular Expressions (BRE)  
    * In basic regular expressions the meta-characters 
      `?`, `+`, `{`, `|`, `(`, and `)` lose their special meaning. 
    * Use the backslashed versions instead: `\?`, `\+`, `\{`, `\|`, `\(`, and `\)`.  

* Extended Regular Expressions (ERE)  
    * Used with `egrep` or `grep -E`
    * The meta-characters keep their special meanings  
      without needing to be escaped: `?`, `+`, `{`, `|`, `(`, and `)`.  

### Alternation (matching any one of multiple expressions)  

* The "alternation operator" or "infix operator" (`|`, the `OR` operator) 
  is used to match any one of multiple expressions.  
* It acts as an `or` operator between multiple regular expressions.  
* For example, `grep 'cat|dog' filename` will match any line containing 'cat' or 'dog'.  

### Other Useful `grep` Options  

- `-i`: Ignore case distinctions in both the pattern and the input files.  
- `-v`: Invert the sense of matching, to select non-matching lines.  
- `-c`: Count the number of lines that match the pattern.  
- `-n`: Prefix each line of output with the line number within its input file.  
- `-l`: List only the names of files with matching lines, once for each file.  
- `-r` or `-R`: Recursively search directories for the pattern.  
- `--color`: Highlight the matching text.  
- `--exclude-dir=PATTERN`: Skip any directory with a name that matches the given pattern.
    * Uses shell globbing.


## Character Classes and Bracket Expressions
##### See `man://grep 304`
A bracket expression is a `set` of characters inside square
brackets `[ ]`, which is used to match a single character.

### What can go inside the brackets
* Sets accept a single character, a range of characters, a set of characters, or a 
  combination of those.
    * E.g.: `[a]`, `[abc]`, `[a-z]`, `[A-Z]`, or `[0-9]`
    * As a combo: `[A-Z_-]` will match `A-Z` and the `-` and `_` characters.

### Character Classes and Their Matches
Character classes can also be used to specify a set of characters, using
the syntax `[:class:]`.

* `[:alnum:]`: Matches any alphanumeric character.  Same as `[a-zA-Z0-9]`.
* `[:alpha:]`: Matches any alphabetic character.  Same as `[a-zA-Z]`.
* `[:blank:]`: Matches any horizontal whitespace character, including space and tab.
* `[:cntrl:]`: Matches any control character.  
    * Control characters are non-printing characters that control how text
      is processed, like newline (`\n`), carriage return (`\r`), tab (`\t`), etc.
* `[:digit:]`: Matches any digit.  Same as `[0-9]`.
* `[:graph:]`: Matches any printable character excluding space.  
    * It includes characters that are visible and can be printed, excluding whitespace.
* `[:lower:]`: Matches any lowercase alphabetic character.  Same as `[a-z]`.
* `[:print:]`: Matches any printable character including space.  
    * It's similar to `[:graph:]` but also includes the space character.
* `[:punct:]`: Matches any punctuation character.  
    * It includes characters like `.`, `,`, `!`, `?`, `;`, `:`, and other symbols
      that are not alphanumeric.
* `[:space:]`: Matches any whitespace character. 
    * Includes spaces, tabs, newlines (`\n`), carriage returns (`\r`),
      form feeds (`\f`), and vertical tabs (`\v`).
* `[:upper:]`: Matches any uppercase alphabetic character.  Same as `[A-Z]`.
* `[:xdigit:]`: Matches any hexadecimal digit.  Same as `[0-9a-fA-F]`.

### Inverting the Matches (Match Non-Matching)
If the first character of the `set` is the caret `^`, then it matches any
character **not** in the list.  
E.g., `[^abc]` will match everything except one of `abc`.  
* Note: Using the `-v` option also has this effect: It matches everything that does not match
  the pattern.
    * This applies to the entire pattern passed to `grep`. 
    * Using the caret `^` in a `set` only inverts the matches within the `set`.  
    * Using the caret `^` with the `-v` option will have the opposite effect.  




## Exmaples  

### Count Occurrences of a Word:  
```bash  
grep -c 'word' filename  
```

---  

### Search Recursively in Directory:  
```bash  
grep -r 'pattern' /path/to/directory  
```

---  

### Find Lines Not Containing the Pattern:  
```bash  
grep -v 'pattern' filename  
```

---  

### Search While Ignoring Case:  
```bash  
grep -i 'pattern' filename  
```

---  

## Note on `fgrep` (Fixed Strings)  

`fgrep` or `grep -F` treats the pattern as a fixed string.  
It matches the literal text provided as the pattern.  

This means no regular expression is involved, making it faster for plain string matching.  
For instance, fgrep "example.com" filename will match lines containing "example.com" as a fixed string, not as a regex.  



## Grep Colors  
* Note: `-v` matches NON-MATCHING lines.  
Specifies the colors and other attributes used to highlight various parts of `grep` output.  
Its value is a colon-separated list of capabilities that defaults to:  
```bash  
# Default:  
GREP_COLORS='ms=01;31:mc=01;31:sl=:cx=:fn=35:ln=32:bn=32:se=36' 
```
The `rv` and `ne` boolean capabilities are unset / omitted (false) by default.  

Boolean capabilities have no `=...` part. 
They are unset (i.e., false) by default, and become true if they're set.  

 These substring values are integers in decimal representation and can be concatenated with  
 semicolons. 

* Common values to concatenate include 
    * 1 for bold.  
    * 4 for underline.  
    * 5 for blink.  
    * 7 for inverse.  
    * 39 for default foreground color.  
    * 30 to 37 for foreground colors.  
    * 90 to 97 for 16-color mode foreground colors.  
    * 38;5;0 to 38;5;255 for 88-color and 256-color modes foreground colors.  
    * 48;5;0 to 48;5;255 for 88-color and 256-color modes background colors.  
    * 49 for default background color.  
    * 40 to 47 for background colors.  
    * 100 to 107 for 16-color mode background colors.  

Note: `grep` takes care of assembling the result into a complete SGR sequence (`\33[...m`).  


### Breakdown  

* `cx=`: context  
    * Color for the context (lines where there's a match, but not the match itself)  
    * The default is empty (i.e., the terminal's default color pair).  

* `rv`: reverse  
    * Boolean value. Invert match and context colors. 
    * Default false, true if set.  

* `mt=01;31`: matching text  (same as `ms`?)
    * Color for matching txt in any matching line.  
    * Setting this is the same as setting `ms=` and `mc=` at once to the same value.  
    * The default is a bold red text foreground over the current line background.  

* `ms=01;31`: matching selected (matched text)  
    * Color for matches in a selected line. 
    * The effect of the `sl=` (or `cx=` if `rv`) remains active when this kicks in.  
    * The default is a bold red text foreground over the current line background.  

* `sl=`: 
    * Color for whole matching lines.  
    * The default is empty (i.e., the terminal's default color pair).  

* `mc=01;31`: matching context  
    * Color for matching text in a context line  
    * The effect of the `cx=` (or `sl=` if `rv`) capability remains active when this kicks in.  
    * The default is a bold red text foreground over the current line background.  

* `fn=35`: file names  
    * Color for filenames that come at the beginning of any line  
    * The default is a magenta text foreground over the terminal's default background.  

* `ln=32`: line numbers  
    * Color for line numbers in any line  
    * The default is a green text foreground over the terminal's default background.  

* `bn=32`:  
    * Color for byte offsets before any line  
    * The default is a green text foreground over the terminal's default background.  

* `se=36`:  
    * Color for separators between selected lines. 
        * `:` = selected lines  
        * `-` = context lines  
        * `--` = adjacent context lines  
    * The default is a cyan text foreground over the terminal's default background.  

* `ne`:  
    * Boolean value. Disables Erase in Line (`EL`).  
    * Prevents clearing to the end of line using Erase in Line (`EL`) to  
      Right (`\33[K`) each time a colorized item ends.  
    * The default is false (unset). True if set.  


