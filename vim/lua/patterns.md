

# Patterns and Pattern Matching in Lua  

Lua uses its own pattern matching.  
The default character used for character classes and escaping is the `%` sign.  

This differs from regex, which uses a backslash (`\`) for 
character classes and escaping.  


## Character Classes  
Lua character classes are similar to regex character classes.  
That is, the same letters are generally used.  

| Character Class | Matches  
|-|-  
| `x`  | (where `x` is not a magic character `^$()%.[]*+-?$`) matches the character `x` itself (1)
| `.`  | (a dot) matches all characters  
| `%w` | all alphanumeric characters  
| `%a` | all letters  
| `%l` | all lowercase letters  
| `%u` | all uppercase letters  
| `%d` | all digits  
| `%s` | all space characters  
| `%c` | all control characters  
| `%p` | all punctuation characters  
| `%x` | all hexadecimal digits  
| `%z` | the character with representation `0` (2)  
| `%x` | (where `x` is any non-alphanumeric character) represents the character `x` (3)  

For all classes represented by single letters (`%a`, `%c`, etc.), the  
corresponding uppercase letter represents the opposite of the class. 
i.e., `%U` matches all non-uppercase letters, `%S` represents all non-space characters, etc.  

Notes:  
1. The characters `^` and `$` are only magic characters when they appear at
   the beginning or end of a pattern respectively. Otherwise they match themselves literally.
2. A pattern cannot contain embedded zeros.  Use `%z` instead.  
3. This (`%x`) is the standard way to escape the magic characters (`^$()%.[]*+-?`).  
   Any punctuation character (even the non-magic) can be  
   preceded by a `%` when used to represent itself in a pattern.  


## Sets
Sets in lua patterns work the same way as regex sets:
* `[set]`: represents all characters in `set`. 
* `[^set]`: represents the opposite of `set` (matches characters not in the set).  

## Capture Groups  
A lua pattern can contain sub-patterns in parentheses to create capture groups. 

Captures are numbered according to their left parentheses. 
i.e., The first opening parenthesis has number 1, the second has number 2, etc.  

For example:  
* `"(a*(.)%w(%s*))"`:  
    1. `"a*(.)%w(%s*)"` is stored as the first capture (number 1);  
    2. `.` is captured with number 2
    3. `%s*` has number 3

### Empty Captures
As a special case, the empty capture `()` captures the current string position (a number). 
For example, use the pattern `"()aa()"` on the string `"flaaap"`,
there will be two captures: 3 and 5 (the positions of the first and last `a`).  

### Accessing Captures
Accessing the captured strings is done with the `%n` operator, where `n` is
the number of the capture.
* `%1` - `%9` matches the corresponding capture group.



