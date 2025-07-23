# Regex

---

Perl is noted to have one of the most powerful regular expression engines.  
It's usually referenced as PCRE in documentation, which stands for Perl-Compatible Regular Expressions.  

---

## Special Variables
You can reference capture groups (much like `sed`) with variables:

- `$1`, `$2`, etc.: Capture groups in Regex.  
    - Like `sed` regex captures, but instead of `\1`, it's `$1`.  
    - When using from the command line, you can use `\1`, `\2`, etc., but it's not perl's 
      way of doing it.  


- `$&`: Matched string in last regex.  
    - Holds the whole **matched** string from the last successful regex.  
    - Does not hold the whole *input* string, only the *matched part* of the input
      string.
    - Like `${BASH_REMATCH[0]}`
- ``` $` ```: Holds the text **before the match**. 
- `$'`: Holds the text **after the match**.  

Those last 3 variables are a little controversial. They're omitted from any scripts
for performance reasons.  

From `perlre`:

> Once `$&`, `$'`, or ``` $` ``` are used anywhere in the program, Perl has to save 
> all that extra information for every regex match -- even ones that don’t use it.

So using `$1`, `$2` etc. with capture groups is generally preferred for performance.  

That said, if you're doing one-liners, it doesn't matter.  


## Lookahead and Lookbehind (Lookaround)
These are zero-width assertions that match a condition but don't consume the
characters they match.  

This means they're not used for capturing, they're only used for checking if a 
condition is true.  

Any characters matched by a lookahead or lookbehind (or "lookarounds") are not
captured and are not accounted for when performing substitutions.  

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
- That means they can not use certain multis/quantifiers (like `*`, `+`, etc).  
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

### All Character Classes

- `[...]`: Custom class. Also called a "bracketed character class" or a "set."  
    - Match a character within the custom class.  
- `[[:...:]]`   Match a character according to the POSIX character class `...` (e.g., `[[:space:]]`.  
- `(?[...])`: Extended bracketed character class
- `\w` Match a "word" character 
    - Alphanumeric + `_` + other connector punctuation chars + Unicode marks
- `\W`: Match a non-word character (opposite of `\w`)
- `\s`: Match a whitespace character
- `\S`: Match a non-whitespace character
- `\d`: Match a decimal digit character
- `\D`: Match a non-digit character

- `\pP`: Match `P`, the named property.  Use `\p{Prop}` for longer names
- `\PP`: Match non-`P`
- `\X`: Match Unicode "eXtended grapheme cluster"
- `\1`: Backreference to a capture group or buffer. '1' may actually be any positive integer.
- `\g1`: Backreference to a specific or previous group.  
    - `\g{-1}`: The number may be negative indicating a relative previous group and may 
      optionally be wrapped in curly brackets for safer parsing.
    - This is another way to access capture groups.  
- `\g{name}`: Named backreference
- `\k<name>`: Named backreference
- `\k'name'`: Named backreference
- `\k{name}`: Named backreference

- `\K`: Keep the stuff left of the `\K`, don't include it in `$&` 
    - `$&` is the variable that holds the entire string matched by the regex.  

- `\N`: Any character but `\n`.  Not affected by the `/s` modifier
    - When of the form `\N{NAME}`, it matches the character or character sequence whose 
      name is `NAME`.  
    - When of the form `\N{U+hex}`, it matches the character whose Unicode code point is `hex`.  
- `\v`: Vertical whitespace
- `\V`: Not vertical whitespace
- `\h`: Horizontal whitespace
- `\H`: Not horizontal whitespace
- `\R`: Linebreak

## Quantifiers
Quantifiers are a way to specify how many of a character to match.  

Basic quantifiers:

- `*`: Zero or more
- `+`: One or more
- `?`: Zero or one
- `{n}`: Exactly `n`
- `{n,}`: At least `n`
- `{,n}`: At most `n`
    - If you have trouble with this one, just use `{0,n}`
- `{n,m}`: Match between `n` and `m`.  

Quantifiers can either be greedy or non-greedy.  
Greedy quantifiers match as many of the character as 
possible, whereas non greedy quantifiers match as few as possible.  

You can explicitly set greedy or non-greedy quantifiers using the **quantifier
modifiers**, `+` and `?`.  

### Non-Greedy Quantifiers
By default, quantifiers are greedy in perl.  
To make a quantifier non greedy, just add a `?` after it.  

- `*?`: Match `0` or more times, non-greedy
- `+?`: Match `1` or more times, non-greedy
- `??`: Match `0` or `1` time, non-greedy
- `{n}?`: Match exactly `n` times, non-greedy (redundant)
- `{n,}?`: Match at least `n` times, non-greedy
- `{,n}?`: Match at most `n` times, non-greedy
- `{n,m}?`: Match at least `n` but not more than `m` times, non-greedy

### Possessive Quantifiers

The opposite of non-greedy quantifiers, you can make quantifiers **explicitly greedy** 
by adding a `+` at the end of the quantifier. This is called the **possessive
quantifier modifier** in Perl.    

- `*+`: Match `0` or more times and give nothing back
- `++`: Match `1` or more times and give nothing back
- `?+`: Match `0` or `1` time and give nothing back
- `{n}+`: Match exactly `n` times and give nothing back (redundant)
- `{n,}+`: Match at least `n` times and give nothing back
- `{,n}+`: Match at most `n` times and give nothing back
- `{n,m}+`: Match at least `n` but not more than `m` times and give nothing back


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

## MetaCharacters
Perl has some metacharacters that hold special meaning and are not interpretted
literally.  

Some of the metacharacters only *count* as metacharacters in certain situations.  

The metacharacters: `{}[]()^$.|*+?-#\`  

| Character | Purpose 
|-|-
| `\`  | Escape the next character
| `^`  | Match the beginning of the string (or line, if `/m` is used)
| `^`  | Negate the `[]` class when used as the first char `[^...]`
| `.`  | Match any single character except newline (if using `/s`, includes newline)
| `$`  | Match the end of the string
| `\|`  | Alternation (OR)
| `()`  | Grouping
| `[`  | Start Bracketed Character class
| `]`  | End Bracketed Character class
| `*`  | Matches the preceding element 0 or more times
| `+`  | Matches the preceding element 1 or more times
| `?`  | Matches the preceding element 0 or 1 times
| `{`  | Starts a quantifier that gives number(s) of times the preceding element can be matched
| `{`  | When following certain escape sequences, starts a modifier to the meaning of the sequence
| `}`  | End sequence started by `{`
| `-`  | Indicates a range in `[]` sets
| `#`  | Beginning of comment, extends to line end (Only with the `/x` modifier)

Some of these (like the quantifiers and anchors) won't count as metacharacters when 
inside a set (`[...]`).  

## Modifiers

Modifiers, as the name suggests, modifies how a regex processes its input.  
These change the behavior of matching in how it handles the interpretation of the
pattern.  

Modifiers come at the end of the match, after the last `/` (or whatever other
delimiter you're using), e.g., `m/(pattern)/<MODIFIERS>`.  

You can use as many modifiers as you want in each match.  


- `/m`: Multi-line modifier. Treats the string being matched as multiple lines.  
- `/s`: Single-line modifier. Opposite of `/m`. Treats the string as a single line.    
    - This changes `.` to match any character, including newlines.  
- `/i`: Case-insensitive modifier. Turns off case sensitivity.  

- `/x` (and `/xx`): Extends legibility. This modifier enables whitespace and comments.  

    - `/x`: Tells the regex parser to ignore any whitespace that isn't escaped or in a 
      set (`[ ]`). Also enables comments with `#`, which runs to either the end of line or 
      the closing delimiter of the pattern.    
        - Does not apply inside sets (aka bracketed character classes, `[...]`).   
        - You can use the `(?#text)` syntax to make a comment that ends earlier than EOL
          or end of pattern.  
            - The comment's `text` can't include the pattern delimiter unless it's escaped.  
        - If you're using this and you want to match actual whitespace or `#` characters,
          they either need to be escaped or in a set (e.g., `[ #]`), or encode them with
          octal/hex

    - `/xx`: Does everything that `/x` does, but also ignores non-escaped tabs or space
      characters in sets/bracketed character classes (`[ ]`).  
        - An example of using `/xx` to add whitespace for readability:
          ```perl
          # With `/xx`:
          / [d-e g-i 3-7]/xx
          /[ ! @ " # $ % ^ & * () = ? <> ' ]/xx
          # Without using `/xx`:
          /[d-eg-i3-7]/
          /[!@"#$%^&*()=?<>']/
          ```
        - The `/xx` modifier is new in Perl 5.26. 

- `-p`: Preserves the string matched.  
    - This is ignored in Perl 5.20 and later.  

- `/n`: Non-capturing groups. Stops capture groups `()` from capturing.  
    - Equivalent to using `(?:)` in all your capture groups.  
    - New in Perl 5.22.  
    - You can disable the `/n` modifier for certain capture groups by nesting capture
      groups inside a `(?-n:)` group.  
      ```perl
      "hello" =~ /(?-n:(hi|hello))/n  # $1 captures "hello"
      ```
      An example in bash:
      ```bash
      perl -ne 'print $1 if m/(?-n:(test))/n' <<< 'test'
      ```

- `/g`: Global modifier. Match the pattern repeatedly in the string.  

- `/c`: Keeps the current position during repeated matching.  
    - If a substitution fails to match, the search position will be reset.  
    - `/c` preserves the position where the last match left off, without resetting it, so 
      you can continue matching later.
    - With `/c` you're basically telling perl, "I'm scanning sequentially, so don't jump backwards."  
    - Used in conjunction with `\G`, which specifies that the match must start at the
      current position.  
      ```bash
      my $str = "123-456+789";
      while ($str =~ /\G(\d{3})-?/gc) {
          print "Got: $1\n";
      }
      print "Left: ", substr($str, pos($str)), "\n";
      ```
        - `\G`: Anchors the match to the **curent pos** in the string.  
        - Try running this example without the `/c` modifier and see what happens.  

---

- `/a`, `/d`, `/l`, `/u`: Character set modifiers. New in Perl 5.14. You usually
  won't need to use these.    
    - `/a`: Sets the charset to unicode, but adds several restrictions for ASCII-safe
      matching.  
        - Allows code that is to work mostly on ASCII data to not have to concern itself with 
          Unicode.  
    - `/l`: Sets the charset to the machine's locale.  
    - `/u`: Sets the charset to unicode.  
    - `/d`: "Old, problematic, pre-5.14 Defualt charset behavior". Forces old behavior. Probably exists for legacy reasons.  
    - These aren't really useful, mostly used internally for Perl. The `/a` modifier
      might be useful if you're working with ASCII that contains Unicode.  

---

There are also some substitution-specific modifiers. 
They can only be used in substitutions (e.g., `s/old/new/<MODIFIERS>`)

- `/e`: Evaluate the right-hand side as an expression.  
    - Allows you to run perl code on the replacement side of a substitution.  
    - An example, evaluating some arithmetic:
      ```perl
      my $x = "2 + 2";
      $x =~ s/.+/$&/e;  # $& is "2 + 2" and gets evaluated
      print $x;         # output: 4
      ```
        - The `$&` variable holds the **entire string matched** by the last **successful** regex.  
        - It does not hold the whole *input string*, only the *matched part* of that string.  
    - Another example, capitalizing the first letter:
      ```perl
      my $name = "connor";
      $name =~ s/\w+/\u$&/e;  # The \u capitalizes the first letter
      print $name;            # "Connor"
      ```
    - The RHS can be math, conditionals, function calls, any valid perl code.  

- `/ee`: Evaluate the right-hand side a string, then `eval` the result.  
    - This is a rare one to use, and can be a bit dangerous. But it might be useful
      if you're dynamically generating code in a DSL or in a templating situation.  
- `/o`: "Pretend to optimize your code, but actually introduce bugs" - `man perlre`
    - This is hilarious.  
- `/r`: Perform non-destructive substitutions and return the new value.  
    - This means it doesn't modify the original string. It returns a **new** string.  
    - This is useful if you need to preserve the old string.  
    - An example of this:
      ```perl
      my $str = "hello, world.";
      my $new = $str =~ s/world/friend/r;
      print $str; # hello, world.
      print $new; # hello, friend.
      # As opposed to:
      $str =~ s/world/universe/;  # destructive, changes $str directly
      ```

Some modifiers (`/imnsxadlup`) can be embedded inside the regex itself, rather than
specified at the end, by using the `(?+n)` grouping syntax. The modifiers will only
apply to the patterns inside that group.  


## Escape Sequences in Patterns

`man perlre /^\s*Escape sequences`

When patterns are evaluated in Perl, they're treated as double-quoted strings.  
That means all escape sequences are expanded properly. Newlines (`\n`), tabs (`\t`),
etc. all work inside patterns.  

- `\t`: Tab                   (HT, TAB)
- `\n`: Newline               (LF, NL)
- `\r`: Return                (CR)
- `\f`: Form feed             (FF)
- `\a`: Alarm (`bell`)          (BEL)
- `\e`: Escape (think `troff`)  (ESC)
- `\cK`: Control char          (example: VT)
- `\x{}` or `\x00`: Match a character by its hexadecimal number 
- `\N{name}`: Named Unicode character or character sequence
- `\N{U+263D}`  Unicode character (example: FIRST QUARTER MOON)
- `\o{}` or `\000`: Match a character by its octal number
- `\l`: Lowercase next char (just like in vi/vim)
- `\u`: Uppercase next char (just like in vi/vim)
- `\L`: Lowercase all chars until `\E` (just like in vi/vim)
- `\U`: Uppercase all chars until `\E` (just like in vi/vim)
- `\Q`: Quote (disable) pattern metacharacters until `\E`
- `\E`: End either case modification or quoted section, as in `vi`/`vim`

---

There are also zero-width assertions (anchors) that can be used in patterns:

- `\b{}`: Match at Unicode boundary of specified type
- `\B{}`: Match where corresponding `\b{}` doesn't match
- `\b`: Word bounary. Match a `\w\W` or `\W\w` boundary
- `\B`: Non-word boundary. Match except at a `\w\W` or `\W\w` boundary
- `\A`: Match only at beginning of string
- `\Z`: Match only at end of string, or before newline at the end
- `\z`: Match only at end of string
- `\G`: Match only at `pos()` (e.g. at the end-of-match position of prior `m//g`)



## Resources

- `man perlre`

- `man perlretut`

- Unicode character resources
    - <https://unicode.org/charts/>
        - Punctuation chart: <https://unicode.org/charts/PDF/U2000.pdf>
    - <https://www.compart.com/en/unicode/>
        - [Mirrored Charsets](https://www.compart.com/en/unicode/mirrored)
        - [Unicode HTML Entities](https://www.compart.com/en/unicode/html) (shows unicode identifiers) 

