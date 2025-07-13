# Non-Printable Characters

## Common Types of Non-Printable Characters

| Character | Name                        | Unicode   | Notes
| --------- | --------------------------- | -------   | -----
| `\n`      | Line feed (newline)         | `U+000A`  | Most common, used for new lines.
| `\r`      | Carriage return             | `U+000D`  | Occasionally shows up, esp. in Windows-style line endings (`\r\n`).
| `\t`      | Tab                         | `U+0009`  | Used when outputting tabbed data.
| `\x00`    | Null byte                   | `U+0000`  | Never intentionally output. Might appear in binary-encoded data.
| `\u200B`  | Zero-width space (ZWSP)     | `U+200B`  | Occasionally shows up when formatting text invisibly.
| `\uFEFF`  | BOM (Byte Order Mark)       | `U+FEFF`  | Rare, but might appear if I'm mimicking UTF-encoded files.  
| `\x1B`    | ESC (for ANSI escape codes) | `U+001B`  | Only appears if I'm explicitly showing terminal coloring examples.  

## Seeing Non-Printable Characters

If you want to inspect a file to see if there are any non-printable characters
present, you can use `cat -A` (which shows all characters).  
```bash
cat -A file.txt
```

Alternatively, you can use the `od` (octal dump) command with the `-c` option.  
```bash
od -c file.txt
```
This will print out the byte offset (on the left, in octal), and the character 
representation of each byte on the right.  

This will output escaspe sequences for non-printable characters, such as `\n` for
newlines, `\0` for null bytes, `\033` or `\e` for the ESC character.  

For example, this string:
```bash
printf "hi\tthere\nbye" > somefile.txt 
od -c somefile.txt
```
The `printf` will automatically interpolate the escape sequences there (`\t` will
expand to tab, etc.).  

The output will look like this:
```bash
0000000   h   i  \t   t   h   e   r   e  \n   b   y   e  \n
0000015
```

If you were to see something like this:
```bash
0000000  \357 \273 \277   # (UTF-8 BOM)
```
This is a Byte Order Mark (BOM) from UTF-8, which is usually invisible in text
editors.  


You can also print out characters by name.  
```bash
od -a ./somefile.txt
```
This will output `sp` for spaces, `nl` for newlines, etc.  

---

If you want to remove the byte offset from the output:
```bash
od -c -A n ./somefile.txt
```

If you want to see the byte offset in decimal, octal, hexadecimal:
```bash
od -c -A x ./somefile.txt # hexadecimal offset
od -c -A d ./somefile.txt # decimal offset
od -c -A o ./somefile.txt # octal offset
od -c -A n ./somefile.txt # no offset
```

