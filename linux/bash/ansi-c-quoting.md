# ANSI-C Quoting

---

ANSI-C quoting is a bash feature with special syntax that allows you to use backslash
escape sequences (like in C) and represent non-printable characters cleanly. It also
allows for writing characters using octal/hex notation.  

---

## Syntax
The syntax for ANSI-C quoting is:
```bash
$'...'
```
It's just a single-quoted string with a dollar sign before it.  

This acts like a single-quoted string, but escape sequences are interpreted like in
the C language.  

---

## Why use them?

These types of strings allow you to use certain characters/escapes in variables that
would otherwise be interpreted incorrectly.  

For instance, if you were trying to use a newline in a variable:
```bash
newline="\n"
printf "Test%s" "$newline"
# Output:
# Test\n
```
You won't get a newline at the end.

However, if you ANSI-C quote the string:
```bash
newline=$'\n'
printf "Test%s" "$newline"
# Output:
# Test
```
The newline is expanded properly.  

This goes for any other escape sequence you're trying to use in a variable.  

## Common Escape Sequences

Some of the most common escape sequences that would go in an ANSI-C quoted string:

- `\n`: newline
- `\t`: Tab
- `\a`: Alert (bell)
- '\\': A literal backslash
- `\'`: A literal single quote

You can also use hexadecimal/octal values here.  



## Examples

You can use ANSI-C quoting to embed byte values directly.  

For example, using hexadecimal and octal values:
```bash
printf $'\x48\x65\x6c\x6c\x6f\n' # Hexadecimal
# Output:
# Hello

printf $'\101\102\103\n'    # Octal
# Output:
# ABC
```

ANSI-C quoting can also be used to strip characters (i.e., newlines) from strings.  

```bash
output=$(printf "Hello\n\n")
clean="${output//$'\n'/}"
```

> **Note**: Using ANSI-C quoted strings inside parameter expansions requires 
> the `extquote` shell option to be enabled (this is enabled by default though).  
> If it's not enabled, you can enable it with `shopt -s extquote`




