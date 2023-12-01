
# Vim Regex  


## Vim Regex and Perl Regex
|        Capability             | Vim-speak   | Perl-speak      |
|-------------------------------|-------------|-----------------|
|  force case insensitivity     |  `\c`       |   `(?i)`        |
|  force case sensitivity       |  `\C`       |   `(?-i)`       |
|  backref-less grouping        |  `\%(atom\)`|   `(?:atom)`    |
|  0-width match                |  `atom\@=`  |   `(?=atom)`    |
|  0-width non-match            |  `atom\@!`  |   `(?!atom)`    |
|  0-width preceding match      |  `atom\@<=` |   `(?<=atom)`   |
|  0-width preceding non-match  |  `atom\@<!` |   `(?<!atom)`   |
|  match without retry          |  `atom\@>`  |   `(?>atom)`    |
|  conservative quantifiers     |  `\{-n,m}`  |`*?`, `+?`, `??`, `{}?`|


### Important Help Files  
* `:h pattern-overview`
* `:h ordinary-atom`
* `:h character-classes`
* `:syn-ext-match`

## Metacharacters (Escaped Characters)  
##### `:h character-classes`  

#### Whitespace:  
| Character Class  |  Matches  |
|------------------|-----------|
| `.`| any character except new line  |
| `\s`| whitespace character  |
| `\S`| non-whitespace character  |
#### Digits:  
| Character Class  |  Matches  |
|------------------|-----------|
| `\d`| digit  |
| `\D`| non-digit  |
| `\x`| hex digit  |
| `\X`| non-hex digit  |
| `\o`| octal digit  |
| `\O`| non-octal digit  |
#### Words:  
| Character Class  |  Matches  |
|------------------|-----------|
| `\h`| head of word character (a,b,c...z,A,B,C...Z and _ )  |
| `\H`| non-head of word character  |
| `\p`| printable character  |
| `\P`| like `\p`, but excluding digits  |
| `\w`| word character  |
| `\W`| non-word character  |
| `\a`| alphabetic character  |
| `\A`| non-alphabetic character  |
| `\l`| lowercase character  |
| `\L`| non-lowercase character  |
| `\u`| uppercase character  |
| `\U`| non-uppercase character  |
#### Special Characters:  
| Character Class  |  Matches  |
|------------------|-----------|
| `\e` | matches `<Esc>` |  
| `\t` | matches `<Tab>` |  
| `\r` | matches `<CR>`  |  
| `\b` | matches `<BS>`  |  
| `\n` | matches an end-of-line |


## Tricks:  
To avoid needing to escape forward slashes `/` in a substitution,
you can use a different seperator.  
```vim  
" Syntax:  
:s:pattern:replacement:flags  
" To replace all occurrences of "vi" with "vim"  
:%s:\<vi\>:vim:g  
```
* `\%[]`: **Optionally** matches inside the collection `[ ]`

Note: inside the `[ ]` (collection), all metacharacters behave like ordinary characters.  
* If you want to include `-` (dash) in your range put it first:  
    * `/[-0-9]/`  
* Same with `[`:
    * `/[[0-9]`
---
To avoid the need for escaping a lot of things (like capture groups), set the
`very magic` flag:  
```regex
:s/\v(capture|any|of|these)/\1/g 
```
The above substitution just replaces the captures with themselves, so no changes are made.


### Ignoring Case in a Pattern
* `\c`: will force the entire pattern to ignore case 
* `\C`: will enforce case-sensitive matching for the whole pattern


### Word Boundaries in Vim Regex  
Word boundaries can be denoted by escaped angle brackets: `\<word\>`

### Matching Newlines / End-of-Line Inside a Collection 
Since `$` doesn't match newline/end-of-line in a collection,
you'll need to use one of these:  
* `\_` / `\n`: When used inside a 'collection' (`[ ]`)
    * With `\_` prepended a collection also includes the end-of-line.
    * The same can be done by including `\n` in a collection.

## Matching Literal Key Characters 
* To include a literal `]`, `^`, `-` or `\` in the collection, put a
  backslash before it:
    * `[xyz\]]`, `[\^xyz]`, `[xy\-z]` and `[xyz\\]`.
    * (Note: POSIX does not support the use of a backslash this way).

## Dealing with Accents in Unicode
* If there are unicode characters with accents, check `\Z` and `\%C`.
* `/[[=* *[==]`: An equivalence class.  
    * This means that characters are matched that
      have **almost** the same meaning, e.g., when ignoring accents.
    * This only works for Unicode, latin1 and latin9.
### Example
`[=a=]` will match characters like `a`, `à`, `á`, `â`, etc., because  
they are all variations of the base character `a` with different accents.  

---

## Range of Operation  
* `<number>`: an absolute line number  
* `.`: the current line  
* `$`: the last line in the file  
* `%`: the whole file. The same as 1,$  
* `'t`: position of mark "t"  
* `/pattern[/]`: the next line where text "pattern" matches.  
* `?pattern[?]`: the previous line where text "pattern" matches  
* `\/`: the next line where the previously used search pattern matches  
* `\?`: the previous line where the previously used search pattern matches  
* `\&`: the next line where the previously used substitute pattern matches  

---

## Capture Groups and Backreferences  
You can group parts of the pattern expression by enclosing them 
with `\(` and `\)` (escaped parentheses, unless `very magic` is set).  
```regex
\(captured\)
```

Using `\|` you can combine several expressions 
into one, matching any of its components.  
The first one matched will be used.  
```regex
\(Date:\|Subject:\|From:\)\(\s.*\)
```


Then they can be referenced in the substitute with:  
* `&`:  the whole matched pattern     
* `\0`: the whole matched pattern     
* `\1`: the matched pattern in the first pair of \(\)     
* `\2`: the matched pattern in the second pair of \(\)    
... ...       
* `\9`: the matched pattern in the ninth pair of \(\)     
* `~`: the previous substitute string     
* `\L`: the following characters are made lowercase  
* `\U`: the following characters are made uppercase  
* `\E`: end of \U and \L  
* `\e`: end of \U and \L  
* `\r`: split line in two at this point  
* `\l`: next character made lowercase  
* `\u`: next character made uppercase  



### Flags  

* `g`: Global, replaces all occurrences on each line.  
* `i`: Case insensitive.  
* `I`: Case sensitive.  
* `c`: Confirm each substitution.
* `e`: Suppress "no match" error.
* `n`: Report the number of matches, and don't actually substitute.  
* `p`: Print the line containing the last substitute.  
    * `#`: Like `p` and prepend the line number. 
    * `l`: Like `p` but print the text like `:list`.

* `&` Must be the first one. Keep the flags from the previous substitute command.  
      Examples:
    * `:&&`
    * `:s/this/that/&`

* `r`: Only useful in combination with `:&` or `:s` without arguments.  
`:&r` works the same way as `:~`:  When the search pattern is empty, use the
previously used search pattern instead of the search pattern from the
last substitute or `:global`.  If the last command that did a search
was a substitute or `:global`, there is no effect. 



### Repeating Substitutions
* `&`: Synonym for `:s` (repeat last substitute).

* `:~` Repeat last substitute with same substitute string
   but with last used search pattern.  This is like `:&r`.

* `g&`: Synonym for `:%s//~/&` (repeat last substitute with
        last search pattern on all lines with the same flags).

## Substitutions with Expressions
When the substitute string starts with `\=`,
the remainder is interpreted as an expression.  
The separation char can not be in the expression!  
|       **Substitution**      |  **Effect**   |
|------------------------|-----------------------------------------------------|
|`:s@\n@\="\r" .. expand("$HOME") .. "\r"@`|This replaces an end-of-line with a new line containing the value of `$HOME`|
|`s/E/\="\<Char-0x20ac>"/g`|This replaces each `E` character with a euro sign.|

##### *`:h <Char->`*
Examples:
* `:s@\n@\="\r" .. expand("$HOME") .. "\r"@`
    * This replaces an end-of-line with a new line containing the value of `$HOME`. >
* `s/E/\="\<Char-0x20ac>"/g`
    * This replaces each `E` character with a euro sign.  Read more in `<Char->`.

## Quantifiers, Greedy and Non-Greedy  

### Greedy  
* `*`: matches 0 or more of the preceding characters,
       ranges or metacharacters 
    * `.*` matches everything including empty line  
* `\+`: matches 1 or more of the preceding characters...  
* `\=`: matches 0 or 1 more of the preceding characters...  
* `\{n,m}`: matches from n to m of the preceding characters...  
* `\{n}`: matches exactly n times of the preceding characters...  
* `\{,m}`: matches at most m (from 0 to m) of the preceding characters...  
* `\{n,}`: matches at least n of of the preceding characters...  
               where n and m are positive integers (>0)  

### Non-Greedy  
`:h atom`
Parentheses can be used to make a pattern into an atom.  

* `\{-}`: matches 0 or more of the preceding atom, as few as possible  
* `\{-n,m}`: matches 1 or more of the preceding characters...  
* `\{-n,}`: matches at lease or more of the preceding characters...  
* `\{-,m}`: matches 1 or more of the preceding characters...  
                where n and m are positive integers (>0)  



---  

## Optionally Match Atoms
* `\%[]`: A sequence of optionally matched atoms. This always matches.
    * The longest that matches is used.
    * There can be no `\(\)`, `\%(\)` or `\z(\)` items inside the `[]` 
    * `\%[]` does not nest.
### Example
|       **Pattern**      |  **Matches**   |
|------------------------|-----------------------------------------------------|
|   `/r\%[ead]`          | matches `r`, `re`, `rea` or `read`. |
|   `/\<fu\%[nction]\>`  | matches the Ex command `function`, where `fu` is required and `nction` is optional |
|   `/\<r\%[[eo]ad]\>` | matches the words `r`, `re`, `ro`, `rea`, `roa`, `read` and `road`. |


## Match Inside the Visual Area  

* `\%V`: Match inside the Visual area. 
    * When Visual mode has already been stopped match in the area that `gv` would reselect.  
    * To make sure the whole pattern is inside the Visual area:  
        * Put it at the **start** and **just before** the end of the pattern.  
            * i.e., `/\%Vfoo.*ba\%Vr`
    * Only works for the current buffer.  

### Example  
String: `foo bar`

|       **Pattern**      |  **Matches**   |
|------------------------|-----------------------------------------------------|
|   `/\%Vfoo.*ba\%Vr`    | This works if only `foo bar` was Visually selected. |
|   `/\%Vfoo.*bar\%V`    | Would match `foo bar` if the Visual selection continues **after** the `r`. |



## Match with the Cursor Position  

* `\%#`: Matches with the cursor position.  
    * Only works when matching in a buffer displayed in a window.  


## Using Marks for Matching  

* `\%'m` Matches with the position of mark m.  
* `\%<'m` Matches before the position of mark m.  
* `\%>'m` Matches after the position of mark m.  

---  

## Line Number Matching  
### Using Line Numbers for Matching  

* `\%23l` Matches in a specific line.  
* `\%<23l` Matches above a specific line (lower line number).  
* `\%>23l` Matches below a specific line (higher line number).  

The "23" can be any line number.  The first line is 1.  

### Using the Current Line for Matching  
* `\%.l` Matches at the cursor line.  
* `\%<.l` Matches above the cursor line.  
* `\%>.l` Matches below the cursor line.  

These six can be used to match specific lines in a buffer.   

---  

## Matching with Start and End of the File  
* `\%^`: Matches start of the file. When matching with a string, matches the start of the string.  
* `\%$`: Matches end of the file. When matching with a string, matches the end of the string.  

## Matching with Columns  

* `\%23c`: Matches in a specific column.  
* `\%<23c`: Matches before a specific column.  
* `\%>23c`: Matches after a specific column.  
* `\%.c`: Matches at the cursor column.  
* `\%<.c`: Matches before the cursor column.  
* `\%>.c`: Matches after the cursor column.  



## Matching After a Pattern  
* `\@<=`: Matches with zero width if the preceding atom matches just before what  
          follows. |/zero-width|
    * Like `(?<=pattern)` in Perl, but Vim allows non-fixed-width patterns.  

### Example  
|       **Pattern**      |  **Matches**   |
|------------------------|-----------------------------------------------------|
| `\(an\_s\+\)\@<=file`  | "file" after "an" and white space or an end-of-line |



## Matching After a NON-matching pattern  
* `\@<!`: Matches with zero width if the preceding atom does NOT match just  
          before what follows.  
    * Like `(?<!pattern)` in Perl, but Vim allows non-fixed-width patterns.  
    * This can be a bit slow.  

### Example  
|      **Pattern**     |  **Matches**   |
|----------------------|---------------------------------------------|
| `\(foo\)\@<!bar`     | any "bar" that's not in "foobar" |
| `\(\/\/.*\)\@<!in`   | "in" which is not after "//" |


* `\@123<!`: Like `\@<!` but only look back 123 bytes. This avoids trying lots of  
            matches that are known to fail and make executing the pattern very  
            slow.  


---

## Match Excluding the Preceding Atom
* `\@=` (or `\&`): Matches the preceding atom with [zero width](#Zero-Width).  
    * Like `(?=pattern)` in Perl.  
### Example  
The string: `foobar`
|     **Pattern**    |    **Matches**    |
|--------------------|-------------------|
| `foo\(bar\)\@=`    | `foo` in `foobar` |
| `foo\(bar\)\&`     | `foo` in `foobar` |
| `foo\(bar\)\@=foo` |     nothing       |
* Using `\&` works the same as using `\@=`: 
    * `foo\&..` is the same as `\(foo\)\@=..`.  
    * `\&` is easier, you don't need the parentheses.  
### Use Cases
* `foo\(bar\)\@=`: Find all `foo`s that are followed by `bar`
* `foo\(bar\|baz\| bar\)\@=`: Find all `foo`s that are followed by `bar`, `baz`, or ` bar` (space
  bar)



## Zero-Width  
* `/zero-width`
    * When using `\@=` (or `^`, `$`, `\<`, `\>`) no characters are included  
      in the match.  
    * These items are only used to check if a match can be made.  
    * This can be tricky, because a match with following items will  
      be done in the same position.  
### Example
|     **Pattern**     |  **Matches**   |
|---------------------|----------------|
| `foo\(bar\)\@=foo`  | nothing        |

The example above will not match `foobarfoo`,
because it tries match `foo` in the **same** position where  
`bar` matched.  

## Setting the Start of a Match with `\zs`
* `\zs`: Matches at any position, but not inside [], and sets the start of the  
        match there: 
    * The next char is the first char of the whole match.  
    * This cannot be followed by a multi. `:h multi`
### Example  
|     **Pattern**        |  **Matches**   |
|------------------------|----------------|
| `/^\s*\zsif`           | matches an "if" at the start of a line, ignoring white space. |
| `/\(.\{-}\zsFab\)\{3}` | Finds the third occurrence of `Fab`.  |




## Setting the End of a Match with `\ze`
* `\ze`: Matches at any position, but not inside [], and sets the end of the  
 match there:
    * The previous char is the last char of the whole match.  
### Example
|     **Pattern**        |  **Matches**   |
|------------------------|----------------|
| `end\ze\(if\|for\)`    | matches the `end` in `endif` and `endfor`. |


---  

## Less Useful Patterns  

## Match if Previous Pattern Doesn't Match at the CURRENT Position  
* `\@!`: Matches with zero width if the preceding atom does NOT match at the  
         **current** position. |/zero-width|
    * Like `(?!pattern)` in Perl.  
### Example  
|         **Pattern**       |  **Matches**   |
|---------------------------|---------------------------------------------|
| `if \(\(then\)\@!.\)*$`   | `if ` not followed by `then` |
| `a.\{-}p\@!`              | `a`, `ap`, `app`, `appp`, etc. not immediately followed by a `p` |
| `/^\%(.*bar\)\@!.*\zsfoo` | `foo` in a line that does not contain `bar` |
| `foo\(bar\)\@!`           | any `foo` not followed by `bar` |

You **can't** use `\@!` to look for a non-match **before** the matching position.  

`\(foo\)\@!bar` will match `bar` in `foobar`, because  
`foo` does not match at the position where `bar` matches.  
Use `\(foo\)\@<!bar` (`\@<!`).  



## Match at the Current Position like a Single Pattern  
* `\@>` Matches the preceding atom like matching a whole pattern.  
    * Like `(?>pattern)` in Perl.  
### Example  
* The string:  `aaab`

|         **Pattern**        |  **Matches**   |
|----------------------------|---------------------------------------------|
| `\(a*\)\@>ab`  | will not match `aaab`, because the `a*` matches the `aaa` (as many "a"s as possible), thus the `ab` can't match. |
| `\(a*\)\@>a`  | nothing (the `a*` takes all the `a`'s, there can't be another one following) |


---  

## Matching Different Number Systems
* `\%d123`: Matches the character specified with a decimal number.  
    * Must be followed by a non-digit.
* `\%o40`: Matches the character specified with an octal number up to 0o377.
    * Numbers below 0o40 must be followed by a non-octal digit or a
      non-digit.
* `\%x2a`: Matches the character specified with up to two hexadecimal characters.
* `\%u20AC`: Matches the character specified with up to four hexadecimal
 characters.
* `\%U1234abcd`: Matches the character specified with up to eight hexadecimal
 characters, up to 0x7fffffff



