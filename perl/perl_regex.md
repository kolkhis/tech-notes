# Perl

## Perl Regex
Perl is noted to have the most powerful regular expression engine.  
It's usually called PCRE (Perl Compatible Regular Expression).  

### Lowercase input:

```bash
ls -alh | perl -pe '$_ = lc $_'
```
This turns all input to lowercase.  
This doesn't actually use any regular expressions, it utilizes the "default"
variable (holds the current line) and the `lc` (lowercase) perl function.  

## Special Variables
You can reference capture groups (much like `sed`) with variables:

- `$&`: Matched string in last regex.  
    - Holds the whole matched string from the last regex.  
    - Like `${BASH_REMATCH[0]}`
- `$1`, `$2`, etc.: Capture groups in Regex.  
    - Like `sed` regex captures, but instead of `\1`, it's `$1`.  



## Lookahead and Lookbehind (Lookaround)
These are zero-width assertions that match a condition but don't consume the
characters they match.  

This means they're not used for capturing, they're only used for checking if a 
condition is true.  

### Lookahead Matching
Lookaheads check if a pattern comes after another pattern.  

```perl
# positive lookahead
/foo(?=bar)/; # Match 'foo' only if it's followed by 'bar'

# negative lookahead
/foo(?!bar)/; # Match 'foo' only if it's NOT followed by 'bar'
```

#### Positive Lookahead
Using `(?=pattern)` is a positive lookahead.  
It matches a position only if it is followed by `pattern`, but it does not consume 
the characters matched by `pattern`.
```perl
my $text = "foo123bar";
if ($text =~ /foo(?=\d+)/) {
    print "Found 'foo' followed by digits!\n";
}
```
This matches `foo` only if it is followed by digits, but does not include the digits 
in the match.

#### Negative Lookahead
Negative lookahead is `?!`, meaning "only if it's **not** followed by this pattern":
```perl
if ($text =~ /foo(?!\d+)/) {
    print "Found 'foo' NOT followed by digits.\n";
}
```

### Lookbehind Matching

```perl
# positive lookbehind
/(?<=foo)bar/;  # match "bar" only if preceded by "foo"

# negative lookbehind
/(?<!foo)bar/;  # Match "bar" only if NOT preceded by "foo"
```

Lookbehinds are very useful.  
But:

- They must have a fixed width (can't be variable-width).
- That means they can not use certain multis (like `*`, `+`, etc).  
  ```perl
  /(?<=abc)\d+/;  # Good because 'abc' is fixed width
  /(?<=a{4})\d+/; # Also good because `a{4}` is fixed width
  /(?<=a+)\d+/;   # Not allowed, because 'a+' is variable width
  ```
  This is different from other regex engines (Python, .NET) which allow
  variable-width lookbehinds.  



#### Positive Lookbehind
The `(?<=pattern)` token is a positive lookbehind.  
It matches a position only if it is preceded by `pattern`, but the pattern itself is 
not included in the match.
```perl
my $text = "abc123";
if ($text =~ /(?<=abc)\d+/) {
    print "Found digits after 'abc'.\n";
}
```
This matches `123` because it's preceded by `abc`.

#### Negative Lookbehind
Negative lookbehind is `(?<!pattern)`:
```bash
if ($text =~ /(?<!abc)\d+/) {
    print "Found digits NOT preceded by 'abc'.\n";
}
```

---

## Misc Example
```perl
while (<$fh>) {
    chomp;
    next if /^#/;
    print "Valid: $_\n";
}
```

- `chomp` removes trailing `$/` characters (input record separator, default newline)
    - If `$/` is default, removes trailing newlines.  


## Character Classes in Perl
Perl has pretty much the same character classes as vim, sed, etc.  

### Bracketed Classes (sets)
Bracketed classes (sets) can specify ranges of characters.  
You can specify multiple ranges in a set.  

- `[abc]`: Matches `a`, `b`, or `c` (a standard set)
- `[a-z]`: Matches any letter `a-z` (lowercase).
- `[A-Z]`: Matches any letter `a-z` (uppercase).
- `[A-Za-z0-9_]`: Custom word class.
- `[^abc]`: Negated set. Match anything except `a`, `b`, or `c`.

### Standard POSIX-style Character Classes
The uppercase counterparts match the opposite of the lowercase character classes.  

- `\d`: Digits `[0-9]`
    - `\D`: Non-digits (`[^0-9]`)
- `\w`: Word character (`[a-zA-Z0-9_]`)
    - `\W`: Non-word characters (`[^a-zA-Z0-9_]`)
- `\s`: Whitespace (`[ \t\r\n\f]` - space, tab, CR, newline, form feed)
    - Newlines count as whitespace in perl.
    - `\S`: Non-whitespace characters (`[^ \t\r\n\f]`)


Perl supports unicode characters classes too, if using the `/u` modifier:
Perl unicode syntax:
```perl
m/\p{L}/u;  # Match any kind of letter from any language
m/\P{L}/u;  # Match any non-letter

/\p{Nd}/u;    # Decimal number digit
/\p{Greek}/u; # Greek characters
```
The `\p` class is used in conjunction with `{Unicode Class}` when using the `/u` modifier.  


## Quantifiers
Quantifiers are a way to specify how many of a character to match.  

Basic quantifiers:

- `*`: Zero or more
- `+`: One or more
- `?`: Zero or one
- `{n}`: Exactly `n`
- `{n,}`: At least `n`
- `{n,m}`: Match between `n` and `m`.  
- Note that perl does NOT support `{,m}` syntax. Use `{0,m}`.  

Quantifiers can either be greedy or non-greedy.  
Greedy quantifiers match as many of the character as 
possible, whereas non greedy quantifiers match as few as possible.  

By default, quantifiers are greedy in perl.  
To make a quantifier non greedy, just add a `?` after it.  

## Capture Groups and Non-Capture Groups
Groups are matches that go inside parentheses.  
Grouping lets you control precedence (like parentheses in math).
You'd typically use a group to capture a match, then use it later with `$1`, `$2`, etc.  

But, there are times when you want to functionality of a group but don't want to
capture it.  

### Capture Groups
Capturing a group:
```perl
my $s = '2025-04-07';
$s =~ m/(\d{4})-(\d{2})-(\d{2})/;

print "$1\n" # 2025
print "$2\n" # 04
print "$3\n" # 07
```

### Non-Capture Groups
This avoids filling `$1`, `$2`, etc.. Used for grouping without saving.  
```perl
/(?:foo|bar)/; # match foo or bar, but don't capture.  
```
This is not supported in `sed`, and only some bash regex variants and advanced
tools (`grep -P`, `ripgrep`) can use things like this.  




## Tips
### Regex Match Debugging
Add `use re 'debug';` in the script to see *exactly* how Perl evaluates your regex.  
```bash
use re 'debug';
"foobar" =~ /f.*r/;
```
This will print out the engine's step-by-step logic to stderr.  

---

A good way to test as you go is to run one-liners from the command line.  
```bash
perl -E 'say "abc123" =~ /\w+/'  # 1 (true)
perl -E 'say "   " =~ /\S/'      # undef (false)
perl -E 'say "foo123" =~ /\d+/'  # 1 (true)
```
Use `-n`  or `-p` and `-e` flasgs for inline file processing, just like `sed`.  
```bash
perl -pe 's/\d+/[number]/g' file.txt
```

### Defining a Reusable Regex
Use the `qr//` operator to define a reusable regex.  
```perl
my $date_re = qr/(\d{4})-(\d{2})-(\d{2})/;
"2025-04-07" =~ /$date_re/;
```

## Perl-Specific Regex Grouping Syntax
The syntax specific to Perl usually starts with a group `(...)`.  

If there is a question mark at the start of the group `(?...)`, then it is a
**non-capturing** group. These won't be stored in `$1`, `$2`, etc.  

- `( ... )`: This is a [capture group](#capture-groups)
- `(?: ... )`: A non-capturing group with no extra functionality.  
- `(?= ... )`: Positive lookahead. See [positive lookaheads](#positive-lookahead).  
- `(?! ... )`: Negative lookahead. See [negative lookaheads](#negative-lookahead).  
- `(?<= ... )`: Positive lookbehind. See [positive lookbehinds](#positive-lookbehind).  
- `(?<! ... )`: Negative lookbehind. See [negative lookbehinds](#negative-lookbehind).  


Formatted as a table:

| Syntax         | Meaning                            |
|----------------|------------------------------------|
| `( ... )`      | Capturing group                    |
| `(?: ... )`    | Non-capturing group                |
| `(?= ... )`    | Positive lookahead                 |
| `(?! ... )`    | Negative lookahead                 |
| `(?<= ... )`   | Positive lookbehind                |
| `(?<! ... )`   | Negative lookbehind                |
| `$1`, `$2`...  | Capture group values in Perl       |


## Substituting UTF-8/Unicode Characters with Perl
Doing this from the command line, `sed` is a better tool for this job.

You don't need to specify any special options with `sed`, you can just pass it
whatever characters you want to substitute and it will perform.  

If you're trying to substitute characters that aren't plain ASCII with Perl (like en 
dash characters, or other characters from MS Word), you need to use more options than
just `perl -pi -e`.  

### Using Hex Codes
You can set up Perl to use Hex codes instead of the actual unicode characters
themselves.  
Do this with `perl -CSDA -pi ...`:
```bash
declare EN_DASH="\x{2013}"      # –
declare OPEN_QUOTE="\x{201C}"   # “
declare CLOSE_QUOTE="\x{201D}"  # ”
declare APOSTRAPHE="\x{2019}"   # ’

declare -a FILES
read -r -d '' -a FILES < <(find ./src/ -name 'u*' -type f)

perl -CSDA -pi \
    -e "use utf8;" \
    -e "s/(${OPEN_QUOTE}|${CLOSE_QUOTE})/\"/g" \
    -e "s/${EN_DASH}/-/g" \
    -e "s/${APOSTRAPHE}/'/g" \
    "${FILES[@]}"
```

- `\x{...}`: These are the hex escape codes for the characters.  
    - If you try to use the characters themselves here, it won't work properly.  
- `-CSDA`: Sets perl's I/O streams to UTF-8 instead of ascii (avoids byte confusion).  
    - `perldoc perlrun`
- `-e "use utf8;"`: Tells perl that the actual script code (`-e <code>`) should be UTF-8.  

Then you can use UTF-8 special characters via hex codes in the commands.  

---

### Using Unicode Names
Another (cleaner) way to do this is with Unicode Names.  
```bash
perl -CSDA -Mutf8 -Mopen=:std,:encoding\(UTF-8\) -pi -e '
    use charnames ":full";  # Allow using Unicode names

    s/\N{LEFT DOUBLE QUOTATION MARK}|\N{RIGHT DOUBLE QUOTATION MARK}/"/g;
    s/\N{EN DASH}/-/g;
    s/\N{RIGHT SINGLE QUOTATION MARK}/'\''/g;
' "${FILES[@]}"
```

- `-M`: Specify a module or pragma to load and use with the code in `-e`.  
    - `-Mutf8`: Specify the `utf8` pragma. Tells perl that the source file is UTF-8.  
        - The `utf8` pragma and makes unicode characters work correctly.  
    - `-Mopen=:std,:encoding\(UTF-8\)`: Loads the `open` pragma.  
        - `:std`: Means "apply this setting to STDIN, STDOUT, and STDERR."  
        - `:encoding\(UTF-8\)`: Sets the default I/O encoding to UTF-8.  
        - This essentially makes STDIN/STDOUT use `UTF-8` automatically.  

- `use charnames ":full";`: Loads the `charnames` perl pragma.  
    - `:full`: Allows the use of full Unicode names.  
    - Allows you to use unicode names (`\N{EN DASH}`).  
    - `perldoc charnames`


Using this method, you don't have to worry about weird `\x{}` hex codes.  


---
### Using the Characters Directly
You can also just use the characters directly when using the options `-Mutf8` and
`-Mopen=:std,:encoding\(UTF-8\)`.  

Using the variables:
```bash
perl -CSDA -Mutf8 -Mopen=:std,:encoding\(UTF-8\) -pi -e "
    s/[${OPEN_QUOTE}${CLOSE_QUOTE}]/\"/g;
    s/$EN_DASH/-/g;
    s/$APOSTRAPHE/'/g;
" "${FILES[@]}"
```

Or, using the raw characters themselves:
```bash
perl -CSDA -Mutf8 -Mopen=:std,:encoding\(UTF-8\) -pi -e '
    s/[“”]/"/g;  # Replace left/right double quotes with straight quote
    s/–/-/g;     # Replace EN DASH with hyphen
    s/’/'\''/g;  # Replace apostrophe
' "${FILES[@]}"
```

### Using `sed`

You could also just use `sed`.  
```bash
declare EN_DASH="–"
declare OPEN_QUOTE='“'
declare CLOSE_QUOTE='”'
declare APOSTRAPHE="’"

declare -a FILES
read -r -d '' -a FILES < <(find ./src/ -name 'u*' -type f)

sed -i \
    -e "s/(${OPEN_QUOTE}|${CLOSE_QUOTE})/\"/g" \
    -e "s/$EN_DASH/-/g" \
    -e "s/$APOSTRAPHE/'/g" \
    "${FILES[@]}"
```


## Resources

- Unicode character resources
    - <https://unicode.org/charts/>
        - Punctuation chart: <https://unicode.org/charts/PDF/U2000.pdf>
    - <https://www.compart.com/en/unicode/>
        - [Mirrored Charsets](https://www.compart.com/en/unicode/mirrored)
        - [Unicode HTML Entities](https://www.compart.com/en/unicode/html) (shows unicode identifiers) 

