

# The Grep Command
Print lines that match patterns.


## Using Grep
The greps:
```bash
grep   # Regular grep with 
egrep
fgrep
rgrep 
```
* `grep`: Uses Basic Regular Expressions (BRE) by default.
* `egrep`: Equivalent to `grep -E`, it uses Extended Regular Expressions (ERE).
* `fgrep`: Equivalent to `grep -F`, it treats the pattern as a fixed string, not a regular expression.
* `rgrep`: Equivalent to `grep -r`, it recursively searches directories.

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

* The alternation operator / infix operator (`|`) 
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




## Exmaples
Count Occurrences of a Word:
```bash
grep -c 'word' filename
```

---

Search Recursively in Directory:
```bash
grep -r 'pattern' /path/to/directory
```

---

Find Lines Not Containing the Pattern:
```bash
grep -v 'pattern' filename
```

---

Search While Ignoring Case:
```bash
grep -i 'pattern' filename
```

---

Note on fgrep (Fixed Strings)

`fgrep` or `grep -F` treats the pattern as a fixed string.
It matches the literal text provided as the pattern.

This means no regular expression is involved, making it faster for plain string matching.
For instance, fgrep "example.com" filename will match lines containing "example.com" as a fixed string, not as a regex.

