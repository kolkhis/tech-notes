Use vim filters to find the absolute or relative path of a file, and insert it into backticks for
jumping purposes.



```bash

note_files=$(find . -name '*.md')
existing=0
for f in $note_files; do
    if [[ grep -q "$f" "${NOTES_HOME}/contents.md" ]]; then
        existing += 1
        continue
        

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


./system_information_cmds.md
./learn_go/week1/notes_week1.md
./learn_go/go_interfaces.md
./learn_go/golang_ebnf.md
./hide_website_wall.md
./chmod_octal.md
./ubuntu_server_install.md
./hv_msg.md
./disk_commands.md
./misc/tmux_notes.md
./misc/subshells_subprocesses.md
./misc/core_util_notes.md
./misc/cicd_pipeline.md
./misc/windows_format_drive.md
./command_cheatsheet.md
./skilstak/beginner_boost_week14/notes_week14.md
./skilstak/beginner_boost_week9/notes_week9.md
./skilstak/beginner_boost_week11/notes_week11.md
./skilstak/beginner_boost_week19/notes_week19.md
./skilstak/beginner_boost_week17/notes_week17.md
./skilstak/beginner_boost_week18/notes_week18.md
./skilstak/topics.md
./skilstak/beginner_boost_week12/notes_week12.md
./skilstak/beginner_boost_week15/notes_week15.md
./skilstak/beginner_boost_week16/notes_week16.md
./skilstak/beginner_boost_week13/notes_week13.md
./skilstak/beginner_boost_week13/packet_types.md
./shell_cheatsheet.md
./ssh_keygen.md
./chatgpt_prompts/terminal_customization.md
./binding_ideas.md
