# Operators
Coming from Bash/Python/Go, Perl has some wild operators. 

Many of them are the same normal operators you'd see in most other languages.  
Some of them, however, are not.  

Let's start with the normal ones.  

## Perl Comparison Operators

## Quote-like Operators
Perl has some "quote-like" operators that utilize slashes and regex.  
The slashes can be another delimiter of your choice.  

- `q//`: Single-quoted string. 
  ```perl
  q/this is 'one' string/
  ```

- `qq//`: Double-quoted string.
  ```perl
  qq/this is "a" string\n/
  ```
- `qx//`: Run a shell command. 
  ```perl
  qx/ls -alh/
  ```
    - This can also be done with backticks in perl. 
    - All of these are equivalent:
      ```perl
      my $out = `hostname`;      # Backticks
      my $out = qx/hostname/;    # qx operator
      my $out = qx(hostname);    # same, easier with shell pipes
      ```

    - Use `qx()` when your shell command includes quotes, pipes, etc:
      ```perl
      my $out = qx(echo "hello" | tr a-z A-Z);
      ```

- `qw//`: : A list of quoted words.
  ```perl
  qw/red green blue/  # ("red", "green", "blue")
  ```
- `qr//`: Compiled regular expression.
  ```perl
  qr/^\d+$/
  ```
- `m//`: Regex match. 
  ```perl
  if ($str =~ m/abc/) { ... }
  ```
    - Since `=~` is the regex operator, the `m` isn't necessary. But, it's useful if
      you want to use a different delimiter. E.g., `m|/usr/bin/env|`.  

- `s///`: Substitution. Just like in sed or vim, or `${var//}` in bash.
  ```perl
  my $line = "foo bar";
  $line =~ s/foo/bar/;
  ```
    - The `s///` command modifies the string in-place.
    - So, using `$line =~ s/foo/bar/`, even though you're using the regex comparison
      operator, the `$line` variable will still be modified.  
    - You can also use this to check if a substitution occurs:
      ```perl
      if ($line =~ s/foo/bar/) {
          print "Substitution occurred!\n"
      }
      ```

- `tr///`: Transliteration. Like `tr` in bash.
  ```perl
  my $s = 'hello';
  $s =~ tr/a-z/A-Z/; # lower to upper
  ```
    - Like `s///`, `tr///` modifies the line in-place.   
    - You can capture the number of characters translated:
      ```perl
      my $count = ($s =~ tr/a-z/A-Z/);
      ```
      So this isn't a comparison, it's a mutation, just like `s///`.


Note that each of these operators let you choose your own demlimiters. They don't
need to be slashes `/`.  
They can also be parentheses or braces.  
```perl
m/foo/; # works
m|foo|; # same
m(foo); # same
m{foo}; # same
```

Useful when the pattern contains slashes.
```perl
m|/usr/bin/perl|
```
Same goes for `s`, `qr`, etc..

### Some Examples of Quote-Like Operators

```perl
my $cmd_output = qx/hostname/;  # Run a command, like `hostname`

my $quote = q/He said, 'hello.'/;     # Single-quoted, no interpolation
my $quote2 = qq/He said, "$name!"/;   # Double-quoted, with variables

my @colors = qw/red green blue/;      # List of words

```

---
Regex tools:
```perl
my $regex = qr/^Error:/;

if ($line =~ $regex) {
    print "Matched error line\n";
}

$line =~ s/foo/bar/;  # Substitute
$line =~ tr/a-z/A-Z/; # Transliterate lowercase to uppercase
```

## Perl Operator Comparisons, Shell Style

| Perl             | Bash Equivalent                | Notes |
|------------------|--------------------------------|-------|
| `qx/ls -l/`      | ``ls -l`` or `$(ls -l)`        | You can also use backticks in Perl |
| `` `ls -l` ``    | Same as above                  | Less readable with complex commands |
| `qx(...)`        | More readable w/ parens        | Especially for shell pipelines |
| `m/.../`         | `[[ $str =~ regex ]]`          | Pattern match |
| `s/foo/bar/`     | `${var//foo/bar}` or `sed`     | Mutates the string |
| `tr/a-z/A-Z/`    | `tr a-z A-Z`                   | Mutates string (like `tr`) |
| `@list = qw/.../`| `("a" "b" "c")`                | Word list, like Bash arrays |

