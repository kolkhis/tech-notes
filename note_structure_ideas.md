
# Ideas for organizing a notes system  


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
grep -r -n -E -A 3 '^#?#\s\s?.*$'  
```
* `-r`: recursive  
* `-n`: include line numbers  
* `-E`: use extended regular expressions  
* `-A 3`: includes the next 3 lines after the match in the output



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


`topics.md`

`.bash_aliases`

binding_ideas.md  
`chatgpt_prompts`
chmod_octal.md  
command_cheatsheet.md  
disk_commands.md  
hide_website_wall.md  
hv_msg.md  
learn_go  
misc  
shell_cheatsheet.md  
skilstak  
ssh_keygen.md  
system_information_cmds.md  
ubuntu_server_install.md  


bash  
coding  
copy_packages.txt  
LICENSE  
lynx  
notes  
nvim  
packages.md  
README.md  
scripts  
tmux  
vim  
w3m  
youtube-dl  



```bash  
# Exclude '.git' from find:  
find . -type d -name '.git' -prune -o -print  
```
* `-type d`: specifies that you're looking for directories.  
* `-name '.git'`: specifies the name of the directory you want to exclude.  
* `-prune`: tells find to prune (skip) the directory when it's encountered.  
* `-o`: is the OR operator.  
* `-print`: specifies that any other files or directories that don't match the exclusion criteria should be printed.  

./README.md  
./lambda.md  
./hide_website_wall.md  
./ubuntu_server_install.md  
./hax  
./hax/sql_injections.md  
./hax/thm  
./hax/thm/offsec_intro.md  
./misc  
./misc/binary_octal_hexadecimal.md  
./misc/cicd_pipeline.md  
./misc/cool_characters.md  
./misc/windows_format_drive.md  
./misc/w3m.md  
./learn_containers  
./learn_containers/syllabus.md  
./learn_containers/lesson_one.md  
./javascript  
./javascript/thirty_days.md  
./linux  
./linux/system_information_cmds.md  
./linux/cron.md  
./linux/subshells_subprocesses.md  
./linux/tmux  
./linux/tmux/tmux_commands_arguments.md  
./linux/tmux/verbose_tmux_commands_arguments.md  
./linux/tmux/overview_tmux.md  
./linux/bash_cheatsheet.md  
./linux/chmod_octal.md  
./linux/disk_commands.md  
./linux/core_util_notes.md  
./linux/customizing_terminal.md  
./linux/shell_options.md  
./data_structures.md  
./vim  
./vim/misc_vim_notes.md  
./vim/no_plugins.vim  
./vim/nvim_commands.md  
./vim/your_problem_with_vim_is_that_you_dont_grok_vi.md  
./vim/regex_in_vim.md  
./vim/vimscript  
./vim/vimscript/colors.vim  
./vim/vimscript/debug_vim.vim  
./vim/vimscript/no_plugins.vim  
./vim/vimscript/vimrc_example.vim  
./vim/vimscript/cheatsheet.vim  
./vim/vimscript/yank_highlight.vim  
./vim/vimscript/presentation_config.vim  
./skilstak  
./skilstak/beginner_boost_week14  
./skilstak/beginner_boost_week14/notes_week14.md  
./skilstak/beginner_boost_week9  
./skilstak/beginner_boost_week9/notes_week9.md  
./skilstak/beginner_boost_week11  
./skilstak/beginner_boost_week11/notes_week11.md  
./skilstak/beginner_boost_week19  
./skilstak/beginner_boost_week19/notes_week19.md  
./skilstak/beginner_boost_week19/scripts  
./skilstak/beginner_boost_week19/scripts/bridgekeeper  
./skilstak/beginner_boost_week17  
./skilstak/beginner_boost_week17/notes_week17.md  
./skilstak/beginner_boost_week17/week_17_scripts  
./skilstak/beginner_boost_week21  
./skilstak/beginner_boost_week21/scripts  
./skilstak/beginner_boost_week21/scripts/badgers  
./skilstak/beginner_boost_week21/scripts/refactored_badger  
./skilstak/beginner_boost_week21/notes_week21.md  
./skilstak/beginner_boost_week20  
./skilstak/beginner_boost_week20/scripts  
./skilstak/beginner_boost_week20/scripts/bridgekeeper  
./skilstak/beginner_boost_week20/notes_week20.md  
./skilstak/beginner_boost_week18  
./skilstak/beginner_boost_week18/scripts  
./skilstak/beginner_boost_week18/scripts/greet  
./skilstak/beginner_boost_week18/scripts/shfmt_wrapper  
./skilstak/beginner_boost_week18/notes_week18.md  
./skilstak/topics.md  
./skilstak/beginner_boost_week12
./skilstak/beginner_boost_week12/notes_week12.md  
./skilstak/beginner_boost_week15  
./skilstak/beginner_boost_week15/notes_week15.md  
./skilstak/beginner_boost_week16  
./skilstak/beginner_boost_week16/notes_week16.md  
./skilstak/beginner_boost_week13
./skilstak/beginner_boost_week13/notes_week13.md  
./skilstak/beginner_boost_week13/packet_types.md  
./ssh  
./ssh/ssh_commands.md  
./ssh/hardening_ssh.md  
./ssh/monitoring_ssh_logs.md  
./ssh/ssh_keygen.md  
./chatgpt_prompts  
./chatgpt_prompts/terminal_customization.md  
./chatgpt_prompts/awesome_chatgpt_prompts.csv  
./chatgpt_prompts/container_teacher.md  
./chatgpt_prompts/helpful_prompt_additions.md  
./binding_ideas.md  
./rsync_usage.md  
