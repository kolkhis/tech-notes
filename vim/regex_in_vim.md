
# Vim Regex

### Important Help Files
`:h pattern-overview`
`:h ordinary-atom`
`:h character-classes`
`:syn-ext-match`

## Metacharacters (Escaped Characters)
`:h character-classes`
Note: inside the `[ ]` all metacharacters behave like ordinary characters.
If you want to include "-" (dash) in your range put it first:
`/[-0-9]/`
`\%[]`: Optionally matches inside the `[ ]`

#### Whitespace
* `.`: any character except new line
* `\s`: whitespace character
* `\S`: non-whitespace character
#### Digits
* `\d`: digit
* `\D`: non-digit
* `\x`: hex digit
* `\X`: non-hex digit
* `\o`: octal digit
* `\O`: non-octal digit
#### Words
* `\h`: head of word character (a,b,c...z,A,B,C...Z and _)
* `\H`: non-head of word character
* `\p`: printable character
* `\P`: like \p, but excluding digits
* `\w`: word character
* `\W`: non-word character
* `\a`: alphabetic character
* `\A`: non-alphabetic character
* `\l`: lowercase character
* `\L`: non-lowercase character
* `\u`: uppercase character
* `\U`: non-uppercase character


### Tricks:
To avoid needing to escape forward slashes `/` in a substitution,
you can use a different seperator.
```vim
" Syntax:
:s:pattern:replacement:flags
" To replace all occurrences of "vi" with "vim"
:%s:\<vi\>:vim:g
```

### Word Boundaries in Vim Regex
Word boundaries can be denoted by escaped angle brackets: `\<word\>`


### Range of Operation

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


## Capture Groups and Backreferences
You can group parts of the pattern expression by enclosing them 
with `\(` and `\)` (escaped parentheses).
`\(captured\)`

Using `\|` you can combine several expressions 
into one which matches any of its components.
The first one matched will be used.
`\(Date:\|Subject:\|From:\)\(\s.*\)`


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

* `g`: Global, replaces all occurrences on each line
* `i`: Case insensitive


## Quantifiers, Greedy and Non-Greedy

### Greedy
* `*`: matches 0 or more of the preceding characters, ranges or metacharacters .* matches everything including empty line
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



