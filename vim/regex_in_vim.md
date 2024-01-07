
# Vim Regex and Pattern Matching  

## Very Magic  

Using `\v` means that after it, all ASCII characters except `0-9`, `a-z`,
`A-Z` and `_` have special meaning: "very magic".  
This means that none of the special characters need to be escaped.  
Using `\V` ("very nomagic") means that they ALL need to be escaped.  

 
|    `\v`  |   `\m`  |    `\M`   |   `\V`    | Matches                          |
|----------|---------|-----------|-----------|----------------------------------|
|'v.Magic' | 'Magic' |  'NoMagic'|'v.NoMagic'|                                  |
|     `a`  |   `a`   |    `a`    |   `a`     | Literal `a`                      |
|     `\a` |   `\a`  |    `\a`   |   `\a`    | Any alphabetic character         |
|     `.`  |   `.`   |    `\.`   |   `\.`    | Any character                    |
|     `\.` |   `\.`  |    `.`    |   `.`     | Literal dot                      |
|     `$`  |   `$`   |    `$`    |   `\$`    | End-of-line                      |
|     `*`  |   `*`   |    `\*`   |   `\*`    | Any number of the previous atom  |
|     `~`  |   `~`   |    `\~`   |   `\~`    | Latest substitute string         |
|     `()` |   `\(\)`|    `\(\)` |   `\(\)`  | Group as an atom                 |
|     `\|` |   `\\|` |    `\\|`  |   `\\|`   | Nothing: separates alternatives (logical `OR`)|
|     `\\` |   `\\`  |    `\\`   |   `\\`    | Literal backslash                |
|     `\{` |   `{`   |    `{`    |   `{`     | Literal curly brace              |

## Vim Regex and Perl Regex  
|        Capability             | Vim-speak   | Perl-speak      |
|-------------------------------|-------------|-----------------|
|  force case insensitivity     |  `\c`       |   `(?i)`        |
|  force case sensitivity       |  `\C`       |   `(?-i)`       |
|  Non-capturing grouping       |  `\%(atom\)`|   `(?:atom)`    |
|  0-width match                |  `atom\@=`  |   `(?=atom)`    |
|  0-width non-match            |  `atom\@!`  |   `(?!atom)`    |
|  0-width preceding match      |  `atom\@<=` |   `(?<=atom)`   |
|  0-width preceding non-match  |  `atom\@<!` |   `(?<!atom)`   |
|  match without retry          |  `atom\@>`  |   `(?>atom)`    |
|  conservative quantifiers     |  `\{-n,m}`  |`*?`, `+?`, `??`, `{}?`|

* Vim beginnings and ends:  
    * Vim's `^` and `$` always match at embedded newlines, and you get two separate atoms. 
    * With `\%^` and `\%$`, you only match at the very start and end of the text.  

* Perl beginnings and ends:  
    * In Perl, `^` and `$` only match at the beginning and end of the text by default.  
        * But, you can set the `m` flag, which lets them match at embedded newlines as well.  


### Unique to Vim  
* Changing the magic-ness of a pattern:  `\v` `\V` `\m` `\M`
   (very useful for avoiding backslashitis)  
* Sequence of *optionally* matching atoms:  `\%[atoms]`
* `\&` (which is to `\|` what "and" is to "or";  it forces several branches  
   to match at one spot)  
* Matching lines/columns by number:  `\%5l` `\%5c` `\%5v`
* Setting the start and end of the match:  `\zs` `\ze`

### Unique to Perl  
* Execution of arbitrary code in the regex:  `(?{perl code})`
* Conditional expressions:  `(?(condition)true-expr|false-expr)`


### Important Help Files  
* `:h pattern-overview`
* `:h ordinary-atom`
* `:h character-classes`
* `:syn-ext-match`

---  

## Metacharacters (Escaped Characters) and Character Classes  
##### `:h character-classes`  

### Whitespace:  
|  Character Class  |  Matches                      |
|-------------------|-------------------------------|
| `.`               | Any character except new line |
| `\s`              | Any whitespace character      |
| `\S`              | non-whitespace character      |

### Digits:  
|  Character Class  |  Matches          |
|-------------------|-------------------|
|  `\d`             | digit             |
|  `\D`             | non-digit         |
|  `\x`             | hex digit         |
|  `\X`             | non-hex digit     |
|  `\o`             | octal digit       |
|  `\O`             | non-octal digit   |
|  `\%d`            | Decimal (base10)  |
|  `\%o`            | Octal (base8)     |
|  `\%x`            | Hexadecimal (base16) up to 2 hexadecimal characters  |
|  `\%u`            | Hexadecimal (base16) up to 4 hexadecimal characters  |
|  `\%u`            | Hexadecimal (base16) up to 8 hexadecimal characters  |

>#### NOTE: With `%\o`, Octal numbers below `0o40` must be followed by a *non-octal digit* or a *non-digit*.  

### Letters:  
|  Character Class  |  Matches                                      |
|-------------------|-----------------------------------------------|
| `\h`              | head of word character (`a-z`, `A-Z` and `_`) |
| `\H`              | non-head of word character                    |
| `\p`              | printable character                           |
| `\P`              | like `\p`, but excluding digits               |
| `\w`              | word character                                |
| `\W`              | non-word character                            |
| `\a`              | alphabetic character                          |
| `\A`              | non-alphabetic character                      |
| `\l`              | lowercase character                           |
| `\L`              | non-lowercase character                       |
| `\u`              | uppercase character                           |
| `\U`              | non-uppercase character                       |

### Special Characters:  
|  Character Class  |  Matches                      |
|-------------------|-------------------------------|
| `\e`              | matches `<Esc>`               |  
| `\t`              | matches `<Tab>`               |  
| `\r`              | matches `<CR>`                |  
| `\b`              | matches `<BS>`                |  
| `\n`              | matches an `EOL` (end-of-line)|


## Tricks:  
To avoid needing to escape forward slashes `/` in a substitution,
you can use a different seperator.  
```vim  
" Syntax:  
:s:pattern:replacement:flags  
" To replace all occurrences of "vi" with "vim"  
:%s:\<vi\>:vim:g  
```
* `\%[]`: *Optionally* matches inside the collection/set `[ ]`

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

## Including End-of-Line (EOL) and Start-of-Line (SOL) in Pattern Matches  
### Matching a Character Class *and* End of Line  
Adding an underscore `_` between the backslash and character  
for a character class will make it also include end-of-line.  
For example:  
```
/\_s  
```
will match whitespace, blank lines, and end-of-line.  

## Matching Start-of-Line *after* Another Atom  
* `\_^`: Matches start-of-line.  
Example:  
```regex  
\_s*\_^foo  
```
This matches white space, end-of-lines, and blank lines, then "foo" at start-of-line.  

### Word Boundaries in Vim Regex  
Word boundaries can be denoted by escaped angle brackets: `\<word\>`

## Overview of Multi Items  
* `pattern-overview`

|   `\m`  |    `\M`   | Matches                                     |
|---------|-----------|---------------------------------------------|
| Magic   | No Magic  |                                             |
|  `\_^`  | `\_^`     | start-of-line (used anywhere) `/zero-width` |
|  `\_$`  | `\_$`     | end-of-line (used anywhere) `zero-width`    |
|  `\<`   | `\<`      | beginning of a word `zero-width`            |
|  `\>`   | `\>`      | end of a word `zero-width`                  |
|  `\zs`  | `\zs`     | anything, sets start of match               | 
|  `\ze`  | `\ze`     | anything, sets end of match                 | 
|  `\%^`  | `\%^`     | beginning of file `zero-width`              |
|  `\%$`  | `\%$`     | end of file `zero-width`                    | 
|  `\%V`  | `\%V`     | inside Visual area `zero-width`             |
|  `\%#`  | `\%#`     | cursor position `zero-width`                |
|  `\%'m` | `\%'m`    | mark m position `zero-width`                |
|  `\%23l`| `\%23l`   | in line 23 `zero-width`                     |
|  `\%23c`| `\%23c`   | in column 23 `zero-width`                   |
|  `\%23v`| `\%23v`   | in virtual column 23 `zero-width`           |


### Greedy Multis  
|   `\m`  |    `\M`   | Matches of the Preceding Atom               |
|---------|-----------|---------------------------------------------|
| Magic   | No Magic  |     Greedy                                  |
| `*`     | `\*`      | 0 or more,   as many as possible            |
| `\+`    | `\+`      | 1 or more,   as many as possible            |
| `\=`    | `\=`      | 0 or 1,      as many as possible            |
| `\?`    | `\?`      | 0 or 1,      as many as possible            |
| `\{n,m}`| `\{n,m}`  | `n` to `m`,  as many as possible            |
| `\{n}`  | `\{n}`    | `n`, exactly                                |
| `\{n,}` | `\{n,}`   | at least `n`,as many as possible            |
| `\{,m}` | `\{,m}`   | 0 to `m`,   as many as possible             |
| `\{}`   | `\{}`     | 0 or more, as many as possible (same as `*`)|  

### Non-Greedy Multis  
|   `\m`  |    `\M`   | Matches of the Preceding Atom               |
|---------|-----------|---------------------------------------------|
| Magic   | No Magic  |  Non-Greedy                                 |
|`\{-n,m}`|`\{-n,m}`  | `n` to `m`,      as few as possible         |
|`\{-n}`  |`\{-n}`    | `n`           exactly                       |
|`\{-n,}` |`\{-n,}`   | at least `n`  as few as possible            |
|`\{-,m}` |`\{-,m}`   | 0 to `m`      as few as possible            |
|`\{-}`   |`\{-}`     | 0 or more   as few as possible              |

* Remember: 
    * If a dash (`-`) appears immediately after the opening brace,
     `{`, then the *shortest match first* algorithm is used.  
    * i.e.,  `\{-...}` = Non-Greedy  

### Non-greedy `pattern-multi-items`:  
|   `\m`  |    `\M`   | Matches of the Preceding Atom               |
|---------|-----------|---------------------------------------------|
|   `\@>` |     `\@>` | 1, like matching a whole pattern  
|   `\@=` |     `\@=` | nothing, requires a match `zero-width`
|   `\@!` |     `\@!` | nothing, requires NO match `zero-width`
|   `\@<=`|     `\@<=`| nothing, requires a match behind `zero-width`
|   `\@<!`|     `\@<!`| nothing, requires NO match behind `zero-width`

It's recommended to use `\zs` instead of `\@<=` with the new regex engine.  


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

## Capture Groups and Backreferences with Substitutions and Other Pattern Commands  
##### Commands: `:s`, `:g`, `:v`   
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
* `&`:  The whole matched pattern     
* `\0`: The whole matched pattern     
* `\1`, ..., `\9`: The matched pattern in the `n`'th capture group (`\(...\)`)  
    * The numbering is done based on which `\(` comes first in the pattern (left to right).  
* `~`: The previous substitute string  
* `\L`: The following characters are made lowercase  
* `\U`: The following characters are made uppercase  
* `\E`: End of `\U` and `\L`  
* `\e`: End of `\U` and `\L`  
* `\r`: Split line in two at this point  
* `\b`: Insert a `<BS>`  
* `\l`: Next character made lowercase  
* `\u`: Next character made uppercase  
* `<CR>`: Split line in two at this point (Type the `<CR>` as `CTRL-Q <Enter>`\*)  
* `\<CR>`: Insert a carriage-return (`CTRL-M`) (Type the `<CR>` as `CTRL-Q <Enter>`\*)  
* `\n`: Insert a `<NL>` (`<NUL>` in the file) (does NOT break the line)  
* `\t`: Insert a `<Tab>`  
* `\\`: Insert a single backslash  
* `\x`: Is any character not mentioned above: Reserved for future expansion  

\* *Some systems support `CTRL-V <Enter>` to insert the literals*  


## Flags  

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
* `:&r` works the same way as `:~`:  
    * When the search pattern is empty, use the  previously used search pattern  
      instead of the search pattern from the last `:s` or `:global`.  
    * If the last command that did a search was a `:s` or `:global`, there is no effect. 

---  
### Two and Three Letter `:substitute` Commands  
You can use flags directly in the in the commands so you don't need to specify them at the end:  
|   |  c |  e |  g |  i |  I |  n |  p |  l |  r  
|---|----|----|----|----|----|----|----|----|---  
| g | `:sgc` | `:sge` | `:sg`  | `:sgi` | `:sgI` | `:sgn` | `:sgp` | `:sgl` | `:sgr`
| I | `:sIc` | `:sIe` | `:sIg` | `:sIi` | `:sI`  | `:sIn` | `:sIp` | `:sIl` | `:sIr`
| c | `:sc`  | `:sce` | `:scg` | `:sci` | `:scI` | `:scn` | `:scp` | `:scl`
| r | `:src` |        | `:srg` | `:sri` | `:srI` | `:srn` | `:srp` | `:srl` | `:sr`
| i | `:sic` | `:sie` |        | `:si`  | `:siI` | `:sin` | `:sip` |        | `:sir`
| e  
| n  
| p  
| l  

Exceptions:  
* `:scr`  is  `:scriptnames`
* `:se`   is  `:set`
* `:sig`  is  `:sign`
* `:sil`  is  `:silent`
* `:sn`   is  `:snext`
* `:sp`   is  `:split`
* `:sl`   is  `:sleep`
* `:sre`  is  `:srewind`
 


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
* `\+`: matches 1 or more of the preceding characters.  
* `\=`: matches 0 or 1 more of the preceding characters.  

* `\{n}`: matches exactly n times of the preceding characters.  
* `\{n,m}`: matches from n to m of the preceding characters.  
* `\{,m}`: matches at most m (from 0 to m) of the preceding characters.  
* `\{n,}`: matches at least n of of the preceding characters.  
               where n and m are positive integers (>0)  

### Non-Greedy  
`:h atom`
Parentheses can be used to make a pattern into an atom.  

* `\{-}`: matches 0 or more of the preceding atom, as few as possible  
* `\{-n,m}`: matches 1 or more of the preceding characters.  
* `\{-n,}`: matches at lease or more of the preceding characters.  
* `\{-,m}`: matches 1 or more of the preceding characters.  
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


## Matching Decimal, Octal, and Hexadecimal Number Systems  

* `\%d`: Matching Decimal (base10)  
* `\%o`: Matching Octal (base8)  
* `\%x`: Matching Hexadecimal (base16)  
    * Up to 2 hexadecimal characters  
* `\%u`:  Matching Hexadecimal (base16)  
    * Up to 4 hexadecimal characters  
* `\%U`:  Matching Hexadecimal (base16) 
    * Up to 8 hexadecimal characters  

### Examples  
* `\%d123`:     Matches the character specified with a decimal number.  
    * Must be followed by a non-digit.  
* `\%o40`:      Matches the character specified with an octal number up to `0o377`.  
    * Numbers below `0o40` must be followed by a *non-octal digit* or a *non-digit*.  
* `\%x2a`:      Matches the character specified with up to *two* hexadecimal characters.  
* `\%u20AC`:    Matches the character specified with up to *four* hexadecimal characters.  
* `\%U1234abcd`: Matches the character specified with up to *eight* hexadecimal characters, up to `0x7fffffff`

---  

* `/[[=`/`[==]`
    - An equivalence class. Match accented `a` characters (i.e., `â`, `ã`, `å`, etc.)  

* `[..]`
    - A collation element.  
    - This currently simply accepts a single  
      character in the form: `[.a.]`

## Collections / Sets  
* `[]`: A Collection (sometimes called a 'set') - Matches any single character in the collection. 
    * Think of this as a custom character class. A set will only match a single character.  
    * `\%[]`  A sequence of optionally matched characters. This always matches.  
        * The longest match is used with this.  
    * `\_[]`: A collection that also matches end-of-line.  
    * `[\n]`: With `\_` *prepended* the collection OR `\n` *in* the collection also  
              includes the end-of-line.  
Starting a collection with `^` will make it match  
everything BUT what is in the collection:  
```regex  
^[^\d]  
```
The above will match a line that does NOT start with  
a digit character.  

### Collection Limitations / Caveats  


There can be no `\(\)`, `\%(\)` or `\z(\)` items inside the `[]`, and `\%[]` does not nest.  

### Collection Examples  
```regex  
/index\%[[[]0[]]]  
```
Matches `index`, `index[`, `index[0`, and `index[0]`.  


## Good Ones to Remember  
* `\%(\)`: A pattern enclosed by escaped parentheses.  
    * Just like `\(\)`, but without counting it as a capture (no backref).  
    * This allows using more groups and it's a little bit faster.  

* `~`/`\~`:  Matches the last given substitute string.  
* `\<`: Matches the beginning of a word: The next char is the first char of a word.  
* `\>`: Matches the end of a word: The previous char is the last char of a word.  

* `\_.`: Matches any single character or end-of-line.  
* `\_^`: Matches start-of-line.  
Example:  
```regex  
\_s*\_^foo  
```
This matches white space, end-of-lines, and blank lines, then "foo" at start-of-line.  

---  

* `\@<=`: Matches everything after the previous atom  
    * It's recommended to use `\zs` instead of `\@<=` with the new regex engine.  

* `\zs`: Matches at any position, but not inside `[]`, and sets the start of the  
        match there.  

```regex  
:s/\(everything\)\@<=after the previous  
:s/\(everything\)\zsafter the previous  
```
The two above essentially do the same thing.  

### Make it Non-Greedy  
When using the brace notation (`\{1,}`), you can easily make it non-greedy.  
* If a dash (`-`) appears immediately after the opening brace,
 `{`, then the *shortest match first* algorithm is used.  
    * i.e.,  `\{-...}` = Non-Greedy  

So:  
* `\{-}` is a non-greedy version of `*`
* `\{-1}` is a non-greedy version of `+`



