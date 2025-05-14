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


## String Operators

### String Comparison Operator (`cmp`)
The operator `cmp`, short for "compare", compares two strings lexographically
(alphabetically).  

- `cmp`: String comparison operator. It determines which is "greater"
  lexographically.  
    - Returns `-1` if left is less than right (lexographically)
    - Returns `0` if equal
    - Returns `1` if greater (lexographically)
    - It's the string version of `<=>` (spaceship operator), which is for comparing numbers.  

## References
Perl supports the use of references.  
You'll mostly only need to use references
Referencing is done mainly on arrays, hashes, and code (subroutines).  

Shorthand for these references are:

- arrayref
- hashref
- coderef

### Referencing
Creating a reference in Perl is simple.  
You just need to add a backslash before the variable to create a reference:
```perl
my @arr = (1, 2, 3);
my $arr_ref = \@arr;
```
Now you have an array reference.  

### Dereferencing
There are two ways to dereference in Perl:

- `->`: The array operator. Prefer this method.  
    - Usually called the "arrow operator" or "method/dereference" operator.  
    - It serves two purposes:
        - Dereferences a reference (array, hash, or code) and accesses a memeber. 
          ```perl
          $hashref->{key};   # dereference a hashref
          $arrayref->[0];    # dereference an arrayref
          $coderef->();      # dereference and call a coderef
          ```
        - Also calls methods on objects (in OOPerl).  

- Sigil (`@{}`/`${}`/`&{}`) syntax (or "manual dereferencing"). Not as easy or readable as `->`.  
    - `&{ ... }` syntax dereferences a **coderef**
    - `@{ ... }` syntax dereferences a **arrayref**
    - `%{ ... }` syntax dereferences a **hashref**
    - `${ ... }` syntax dereferences a **scalarref**
    - If you're just trying to access one element of an array or hash reference, the
      `${ ... }` syntax is *usually* what you want to use, since it's probably a
      scalar.


The table below shows how to use sigil syntax to dereference different types of
references:

| Ref Type | Sigil Syntax | Meaning
|-|-|-
| Array     | `@{ $arrayref }`    | Dereference to full array
| Hash      | `%{ $hashref }`     | Dereference to full hash
| Code      | `&{ $coderef }()`   | Dereference and Call the subroutine
| Scalar    | `${ $scalarref }`   | Dereference scalar
| Array el  | `${ $arrayref }[0]` | Dereference, then access index
| Hash val  | `${ $hashref }{a}`  | Dereference, then access key

Or, more condensed:

| Sigil |   Used for |  Example
|-|-|-
| `$`   | Scalars    |  `${ $ref }`, `${ $ref }[0]`
| `@`   | Arrays     |  `@{ $ref }`
| `%`   | Hashes     |  `%{ $ref }`
| `&`   | Subroutines (code) | `&{ $ref }()`




When dereferencing code to run, you simply add `()` to call the code.  

```perl
# Create a hash
my %stuff = (
    name    => "Kolkhis",
    score   => 42,
    colors  => ['red', 'green'],        # Anonymous Array reference, technically a scalar
    nested  => { admin => 1 },          # Anonymous Hash reference, technically a scalar
    action  => sub { print "Hello\n" }, # Anonymous Code reference, technically a scalar
);

# Create another hash, nest the first one in it
my %otherstuff = (
    stuff => \%stuff,  # Store reference to the `%stuff` hash
    some_code => sub { print "Hi!\n"; },
);

# Call the code in `some_code` (arrow style)
$otherstuff{some_code}->();

# Call the code in `action` (arrow style)
$otherstuff{stuff}->{action}->();

# Call the code in `action` (sigil style / manual dereferencing)
&{ ${ $otherstuff{stuff} }{action} }();
```

