
# Ideas for organizing a notes system  
Sturgeon's Law - "Ninety percent of everything is crap."  

## Main idea  
* Make a "table of contents" file to hold headers and filepaths/names  
    * This will act as a centralized file  
* Use vim filters to find the absolute or relative path of a file, 
    * insert filename/path into "table of contents"  
        * jump to it using `gf` in vim/neovim.  
* Use a script to get the headers in each note file  
    * Put the headers in the "table of contents" 
    * Organize it so the filename appears as a header in "table of contents", 
      and the headers from the files are bullet points underneath that header.  

* Use absolute paths for filenames (easier for `gf` to find the files).  
    * Add headers (1s and 2s) sequentially underneath the filename.  
    * Add empty lines between files and their headers  
    * Add command line tool that auto-greps the specified term/phrase  

* Idea: Use vim's builtin folding to add a few lines after each title, folded  
        so it doesn't take up too much room.  

* In bashrc, add autocmd keybind for `contents.md` gf: `?/notes/<CR>gf`
```vim  
au! BufEnter contents.md nnoremap gf ?/notes/<CR>gf 
```
^ Try that?  


### Note Formatting Vim Regex Patterns  
Add two spaces (linebreak) at the end of each line that doesn't already have two spaces,
isn't a comma, and isn't the end of a codeblock (3 backticks):  
```regex  
:%s/\([^,\| \{2}\|`\{3}]$\)/\1  /  
```
Assume in all greps that headers and sentences will end with two spaces  

---  

## Grepping for Matches  
Using the `-n` option for `grep` will output the line number of the match.  

### Get all headers  
```bash  
grep -r -n -E -A 3 '^#?#\s\s?.*$'    # H1s and H2s  
grep -r -n -E -A 3 '^#{1,}\s\s?.*$'  # All Headers  
```
* `-r`: recursive  (`-r(ecursive)`)  
* `-n`: include line numbers  (`-n(umbers)`) 
* `-E`: use extended regular expressions  (`-E(xtended)`)  
* `-A 3`: includes the next 3 lines after the match in the output (`-A`fter)  


### Grepping for a Specific Header  
Grep for a header of any type that contains `Substitute` or `Substitution`:  
```bash  
grep -r -E '^#{1,}\s+.*Substitut.*'  
```

---

## Open a File with Vim to a Particular Line Number
```bash
vim filename + 34
```
This will open to line 34.  
This won't work if vim remembers the last line number and plans to enter on
that line. In that case, vim will open the file to that line + 34.  

---  

Idea: Add vim/nvim integration.  
* nvim: Use floating windows with a fzf or something to preview the file @ line  

## Marksman (Markdown LSP)  
Marksman supports user-level and project-level configuration:  
1. User-level configuration is read from:  
    * `$HOME/.config/marksman/config.toml` on Linux and MacOS,
    * `$HOME\\AppData\\Roaming\\marksman\\config.toml` on Windows.  
1. Project-level configuration is read from `.marksman.toml` located in the project's root folder.  
For each configuration option the precedence is: project config > user config > global default.  
Here's an [example config](https://github.com/artempyanykh/marksman/blob/main/Tests/default.marksman.toml).  


---  

## Looping over files in notes directory  

```bash  
note_files=$(find . -name '*.md')  
existing=0  
while read -r f; do  
    if [[ grep -q "$f" "${NOTES_HOME}/contents.md" ]]; then  
        existing += 1  
        continue  
done < <(find ~/notes -name '*.md')  
```

```bash  
# Exclude '.git' from find:  
find . -type d -name '.git' -prune -o -print  
```
* `-type d`: specifies that you're looking for directories.  
* `-name '.git'`: specifies the name of the directory you want to exclude.  
* `-prune`: tells find to prune (skip) the directory when it's encountered.  
* `-o`: is the OR operator.  
* `-print`: specifies that any other files or directories that don't match the exclusion criteria should be printed.  





