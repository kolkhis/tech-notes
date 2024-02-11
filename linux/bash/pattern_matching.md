
# Pattern Matching (Globbing) in Bash

Pattern matching, or globbing, is a way to match files and directories.

Relevant shell options:
* `globstar`
* `extglob`


## Quickref

### Pattern Matching Characters:
| Character     | Meaning
|-|-
| `*`           | Zero or more characters (any characters)
| `?`           | One or more characters (any characters)
| `[a-z]`       | Match a range of characters.
| `'[:lower:]'` | Match a class of characters.
| `[^a-z]`      | Negate a range (match anything except the range).
| `[Rr]`        | Match one occurence of `r` or `R`

This is the only way to do matching in certain types of shell interpreters.

---

## Extended Pattern Matching Operators
**Note:** This requires the `extglob` option to be enabled with `shopt -s extglob`.
When extended pattern matching becomes available, you have access 
to more types of operators.

* In the following table, a `pattern-list` is a list of one or 
  more patterns separated by a `|`.

|  Operator           |  Description
|-|-
|  `?(pattern-list)`  |  Matches zero or one occurrence of the given patterns
|  `*(pattern-list)`  |  Matches zero or more occurrences of the given patterns
|  `+(pattern-list)`  |  Matches one or more occurrences of the given patterns
|  `@(pattern-list)`  |  Matches one of the given patterns
|  `!(pattern-list)`  |  Matches anything except one of the given patterns


## Character Classes in Sets

Inside a set (`[ ]`), character classes can be specified using `[:class:]`
Class is one of the classes defined in the POSIX standard:

| Character Class | Description                                                      
|-----------------|-------------
| `[:alnum:]`     | Alphanumeric characters (letters and digits).                    
| `[:alpha:]`     | Alphabetic characters (letters only).                            
| `[:ascii:]`     | ASCII characters (characters in the ASCII character set).        
| `[:blank:]`     | Blank characters (space and tab).                                
| `[:cntrl:]`     | Control characters (non-printing characters).                    
| `[:digit:]`     | Digits (0-9).                                                    
| `[:graph:]`     | Graphical characters (characters that are visible, not space).   
| `[:lower:]`     | Lowercase letters.                                               
| `[:print:]`     | Printable characters (graphical characters plus space).          
| `[:punct:]`     | Punctuation (characters not in `[:alnum:]`, `[:cntrl:]`, or `[:space:]`).
| `[:space:]`     | Whitespace characters (space, tab, newline, etc.).               
| `[:upper:]`     | Uppercase letters.                                               
| `[:word:]`      | Word characters (alphanumeric characters plus underscore).       
| `[:xdigit:]`    | Hexadecimal digits (0-9, A-F, a-f).                              

---

All character classes above are availbe in Vim, in addition to:

| Character Class | Description                                                      
|-----------------|-------------
| `[:tab:]`       | The `<Tab>` character
| `[:escape:]`    | The `<Esc>` character
| `[:backspace:]` | The `<BS>` character
| `[:ident:]`     | Identifier character (same as `\i`)
| `[:keyword:]`   | Keyword character (same as `\k`)
| `[:fname:]`     | File name character (same as `\f`)


## Ranges in Sets
 
Ranges of characters can also be specified inside sets, using the syntax `[x-y]`.
`[a-Z]` is a set of characters, their numeric equivalent is what will be compared.

If the first character following the opening 
bracket `[` is a `!`  or a `^` then any character not enclosed is matched.
E.g.,
```regex
[!a-z]
[^a-z]
```
Those two patterns will match any character not in the range `a-z`.



## Recursively find all files in a directory
### `**` in patterns with `globstar`:
When the `globstar` shell option is enabled, and two `*`s (`**`) are
used as a single pattern in a pathname expansion, it'll match
all files recursively, and zero or more directories and subdirectories.


Use `globstar` to find all files in a directory:
```bash
**/*.c   # all C files in the current directory and subdirectories
**/*.go  # all Go files in the current directory and subdirectories
**/*     # all files in the current directory and subdirectories
```


git commit -m "feat: Add directory for android notes"

