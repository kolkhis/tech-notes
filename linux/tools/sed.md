# `sed`: Stream Editor

The `sed` tool is a hallmark in Linux systems.  
It's used to manipulate text using regular expressions.  


## Common Options

* `-E`: Use extended regex instead of basic regex.  
    * This prevents the need for escaping a lot of things (like capture group parentheses).  
* `-i`: Edit the file in place.  
    * Optionally specify a suffix for a backup file:
        * `-i_old`/`--in-place=_old`: Will make a backup with the name `filename_old`.  
        * `-i.bak`/`--in-place=.bak`: Will make a backup with the name `filename.bak`.  
        * The suffix is optional. If there is no suffix then no backup will be made.  
* `-e`: Specify a command for `sed`.  
    * This can be used multiple times to perform several edits with one command.  
* `-n`: Quiet. Suppresses output.  
    * `--quiet`/`--silent`
* `-s`: Treat multiple files as separate files rather than one long stream.  

## Edit a file in-place
Editing a file in-place means that it will modify the file direcly instead of
outputting the changes to `stdout`.  
Use the `-i` flag with `sed` to edit a file inplace.  
```bash
sudo sed -i 's/old/new/g' /etc/fstab
```

* `sed -i`: Edit the file in place
* `'s/old/new/g'`: Replaces all occurrences of `old` with `new`.  
* `/etc/fstab`: The file to edit.  

## Matching a Line, then Performing a Substitution
You can perform substitutions on a file that only match a specific line.  
The first pattern started with `/` will match a line.  
Then you can specify `s/` to start a substitution.  

Basic syntax:
```bash
sed -i '/pattern/s/old/new/' file.txt
```

* `'/pattern/s/old/new/`: Replace `old` with `new`, ONLY on lines that match `pattern`.  

---

```bash
sed -i -E '/find this/s/find/change/g' somefile.txt
```

* `/find this/`: Specifies the pattern to match.  
* `s/find/change/g`: This is the substitution.  

You can specify multiple patterns with `-e`.  
```bash
sed -i_old -E -e '/find this/s/find/change/g' -e '/ this/s/this/that/g'
```

* `-e '/find this/s/find/change/g`: Match lines containing the text "`find this`",
  then replace "`find`" with "`change`".  
* `-e '/ this/s/this/that/g'`: Match a line containing "` this`" (including the
  space), then replace all occurences of "`this`" with "`that`"

## Editing from Stdout with Pipes
A common use case for `sed` is editing the output of another command.  
`somefile.txt` has a bunch of lines that just contain "old"
```bash
cat somefile.txt 
# old
# old
# old

cat somefile.txt | sed -E 's/old/new/g'
# new
# new
# new
```

## Capture Groups
If you're familiar with vim regex at all, you can use the same concepts with `sed`.  
You capture with parentheses (escaped if not using `-E`xtended regex), then reference
the captures with `\1`, `\2`, etc.  
```bash
cat somefile.txt | sed -E 's/(old)/\1new/g'
# oldnew
# oldnew
# oldnew
```

## Other Sed Commands
The most popular command used in `sed` is the `s` (substitute) command.  
```bash
sed -i '/pattern/s/old/new' file.txt
```

* This will replace `old` with `new` on any lines that match `pattern`.  

But you can use other commands, like `d` (delete) to remove lines or `c` to change lines.  

### Delete Lines (`d`)
```bash
sed -i '/pattern/d' file.txt
```

* `'/pattern/d'` This will delete any lines that match the pattern.  

### Change Lines (`c`)
To change a whole line that matches a pattern:
```bash
sed -i '/pattern/c New text for the line' file.txt
```

* This will match the line containing `pattern`, delete that line, then add the text
  that comes after `c`.  
* Any whitespace between the `c` and the start of the text will not be used.  

### Appending Lines (`a`)
Append text to lines by using the `a` command with `sed`:
```bash
sed -i '/pattern/a New line text' file.txt
```
The beginning and end of each `a` command inserts a newline. This create a new line
with the text `New line text` after any lines containing the `pattern`.  

E.g., if you wanted to use `sed` to append text to the end of a file:
```bash
sed -i "\$a This text will go at the end of the file" file.txt
```

* The `$` is escaped so that it is not read as a variable. 
    - Necessary with double quotes.
    - If using single quotes, the `\` is not needed.
      ```bash
      sed -i '$a This t5ext will go at the end of the file' file.txt
      ```
* If you were to use `$` as the `pattern`, it would append text to the end of every
  line instead of the EOF (e.g., `/$/a ... `).

### Inserting Lines (`i`)
Opposite of appending, you can insert text above a given line.  

```bash
sed -i '/pattern/i This text will go above the line containing the pattern' file.txt
```

Without specifying a `pattern`, the `i` command will insert text above **every** line
in the stream.  

`sed` inserts a newline at the end of each `i` command. 

### Insert from a File (`r`)
You can use `sed`'s `r` command to append text to a file from another file.  

Ex, to append the contents of `file2.txt` to `file.txt`:
```bash
sed -i 'r file2.txt' file.txt
```


## Case-insensitive Matching
The Linux version of `sed` allows for case insensitive matching with the `i` flag at
the end of the pattern.  
```bash
sed -i 's/sometxt/replacement/i' file.txt
```

## Range Commands
Using the `,` command specifies a range command.  
```bash
sed '/start pattern/,/end pattern/...'
```

* `/start pattern`: The start pattern. The range will start here.
* `/,/`: Indicates a range, `sed` will expect an end pattern.  
* `end pattern/`: The end pattern.
* `...`: The command to run on the range.  
    - This can be a single command (e.g., `s/`) or a block of commands (`{ ... }`)
    - This command will only apply to the range instead of the whole input stream.


### Range Example: Finding the First Empty Line after a Pattern

Say you want to insert a link under a markdown header, but not directly below it --
at the first empty line that appears after that markdown header.  

`sed` doesn't support lookaheads since it doesn't have a full regex engine like
Perl (no `(?=foo)` lookaheads). But, range patterns can be used to accomplish this.

```bash
sed -i '/^## Pattern/,/^$/ {/^$/ a\
New line goes here.
}' file.md
```

* `/^## Pattern/`: Start matching from this pattern.
* `/,/`: Indicates the start of a range pattern (start pattern).  
    - From the start pattern (`## Pattern`) to the next pattern.
* `/^$/`: The ending pattern. Match ends here.
    - Matches a blank line.

* `/ {/^$/ a\ }`: When inside the range, if the current line is blank (`/^$/`), 
  use `a\` to append text below that blank line.
    * The `{` opens a block of commands. The `a\` command appends the given text only 
      when a blank line is found inside the range.
    * The closing `}` always needs to go on a new line.


That example puts the new line *under* the blank line, which is probably not what you
want.  
To insert the new line *above* the blank line, use `i` instead of `a`:
```bash
sed -i '/^## Pattern/,/^$/ {/^$/ i New line goes here 
}' file.md
```

* This does the same thing as above, but instead puts the line above instead of
  below.  

