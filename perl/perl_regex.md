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



## Lookahead Matching
### Positive Lookahead
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

### Negative Lookahead
Negative lookahead is `?!`, meaning "only if it's **not** followed by this pattern":
```perl
if ($text =~ /foo(?!\d+)/) {
    print "Found 'foo' NOT followed by digits.\n";
}
```

## Lookbehind Matching

### Positive Lookbehind
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

### Negative Lookbehind
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


