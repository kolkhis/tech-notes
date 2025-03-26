# `sed`: Stream Editor

The `sed` tool is a hallmark in Linux systems.  
It's used to manipulate text using regular expressions.  


## Table of Contents
* [Common Options](#common-options) 
* [Edit a file in-place](#edit-a-file-in-place) 
* [Matching a Line, then Performing a Substitution](#matching-a-line-then-performing-a-substitution) 
* [Editing from Stdout with Pipes](#editing-from-stdout-with-pipes) 
* [Capture Groups](#capture-groups) 
* [Different Commands](#different-commands) 
    * [Delete Whole Lines](#delete-whole-lines) 
    * [Change Whole Lines](#change-whole-lines) 
* [Case-insensitive Matching](#case-insensitive-matching) 


## Common Options
* `-E`: Use extended regex instead of basic regex.  
    * This prevents the need for escaping a lot of things (like capture group parentheses).  
* `-i`: Edit the file in place.  
    * Optionally specify a suffix for a backup file:
        * `-i_old`/`--in-place=_old`: Will make a backup with the name `filename_old`.  
        * If this isn't specified then no backup will be made.  
* `-e`: Specify a command for `sed`.  
    * This can be used multiple times to perform several edits with one command.  
* `-n`: Suppress output.  
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

## Different Commands
The most popular command used in `sed` is the `s` (substitute) command.  
```bash
sed -i '/pattern/s/old/new' file.txt
```
* This will replace `old` with `new` on any lines that match `pattern`.  

But you can use other commands, like `d` (delete) to remove lines or `c` to change lines.  

### Delete Whole Lines
```bash
sed -i '/pattern/d' file.txt
```
* `'/pattern/d'` This will delete any lines that match the pattern.  

### Change Whole Lines
To change a whole line that matches a pattern:
```bash
sed -i '/pattern/c New text for the line' file.txt
```
* This will match the line containing `pattern`, delete that line, then add the text
  that comes after `c`.  
* Any whitespace between the `c` and the start of the text will not be used.  

### Append Text to Lines
Append text to lines by using the `a` command with `sed`:
```bash
sed -i '/pattern/a Text to append' file.txt
```
The end of each `a` command inserts a newline.

E.g., if you wanted to use `sed` to append text to the end of a file:
```bash
sed -i "\$a This text will go at the end of the file"
```
- The `$` is escaped so that it is not read as a variable. 
    - Necessary with double quotes.
- If you were to use `$` as the `pattern`, it would append text to the end of every
  line instead of the EOF.

### Inserting Text
Opposite of appending, you can insert text above a given line.  

Ex: insert text above a line: 
```bash
sed -i '/pattern/i This text will go above the line containing the pattern' file.txt
```

Without specifying a `pattern`, the `i` command will insert text above **every** line
in the stream.  

`sed` inserts a newline at the end of each `i` command. 

### Append Text from a File
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
