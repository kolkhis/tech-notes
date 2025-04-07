# Perl Regex Cheat Sheets

## Table of Contents
* [Character Classes](#character-classes) 
* [Quantifiers](#quantifiers) 
* [Regex Modifiers](#regex-modifiers) 
* [Anchors](#anchors) 
* [Special Syntax](#special-syntax) 

## Character Classes
| Pattern | Meaning                         |
|---------|----------------------------------|
| `\d`    | Digit `[0-9]`                    |
| `\D`    | Not digit                        |
| `\w`    | Word char `[a-zA-Z0-9_]`         |
| `\W`    | Not word char                    |
| `\s`    | Whitespace `[ \t\r\n\f\r]`       |
| `\S`    | Non-whitespace                   |
| `.`     | Any char except newline (unless `/s`) |
| `[...]` | Character set                    |
| `[^...]`| Negated character set            |
| `\p{L}` | Unicode letter (needs `/u`)      |
| `\P{L}` | Not a Unicode letter             |

---

##  Quantifiers
| Pattern     | Meaning                       |
|-------------|-------------------------------|
| `*`         | `0` or more                   |
| `+`         | `1` or more                   |
| `?`         | `0` or `1`                    |
| `{n}`       | Exactly `n`                   |
| `{n,}`      | `n` or more                   |
| `{n,m}`     | Between `n` and `m`           |
| BAD: `{,m}` | (Invalid in Perl!)            |

**Non-greedy** versions: add `?`  
Examples: `.*?`, `.+?`, `{1,5}?`

---

##  Regex Modifiers
Modifiers come at the end of the pattern, after the last `/`, or whatever delimiter
is being used.  
| Modifier | Meaning                                |
|----------|-----------------------------------------|
| `/i`     | Case-insensitive                        |
| `/g`     | Global match                            |
| `/m`     | Multiline (changes `^`/`$` behavior)    |
| `/s`     | "Single line" — `.` matches newlines    |
| `/x`     | Free-spacing mode (whitespace ignored)  |
| `/u`     | Unicode semantics (essential for `\p{}`)|

---

## Anchors
| Pattern | Meaning               |
|---------|------------------------|
| `^`     | Start of string (or line with `/m`) |
| `$`     | End of string (or line with `/m`)   |
| `\A`    | Start of string only     |
| `\Z`    | End of string only       |
| `\b`    | Word boundary            |
| `\B`    | Not a word boundary      |

---

## Special Syntax
| Syntax         | Meaning                            |
|----------------|-------------------------------------|
| `( ... )`      | Capturing group                    |
| `(?: ... )`    | Non-capturing group                |
| `(?= ... )`    | Positive lookahead                 |
| `(?! ... )`    | Negative lookahead                 |
| `(?<= ... )`   | Positive lookbehind                |
| `(?<! ... )`   | Negative lookbehind                |
| `$1`, `$2`...  | Capture group values in Perl       |


