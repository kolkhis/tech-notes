# Tmux Commands and Arguments

This is an **exhaustive** list of tmux commands and their arguments, with 
examples and use-cases.


## List Tmux Commands and Arguments, w/ Examles and Use-Cases


1. attach-session

    * -t: Target session
    * -d: Detach other clients

Example:
tmux attach-session -t mySession -d

Use Case:
Attach to mySession and detach other clients connected to it.


2. bind-key

    * -T: Key table
    * -n: No prefix key required

Example:


tmux bind-key -T root F1 new-session

Use Case:


Bind F1 to create a new session without needing a prefix key.


3. break-pane

    * -d: Leave pane in detached state
    * -n: New window name

Example:
tmux break-pane -d -n myWindow

Use Case:
Break the current pane into a new window named myWindow and leave it detached.


4. capture-pane

    * -S: Start line
    * -E: End line

Example:


tmux capture-pane -S -10 -E -1

Use Case:


Capture the last 10 lines of the current pane.


5. choose-buffer

Example:
tmux choose-buffer

Use Case:
Open a menu to choose a buffer to paste.


6. choose-client

Example:
tmux choose-client

Use Case:
Open a menu to choose a client to interact with.


7. choose-session

Example:
tmux choose-session

Use Case:
Open a menu to choose a session to attach to.


8. choose-tree

Example:
tmux choose-tree

Use Case:
Open a visual tree of sessions, windows, and panes to navigate through.


9. choose-window

Example:
tmux choose-window

Use Case:
Open a menu to choose a window to switch to.


10. clear-history

Example:
tmux clear-history

Use Case:
Clear the history of the current pane.


11. clock-mode

Example:
tmux clock-mode

Use Case:
Display a clock in the current pane.


12. command-prompt

Example:
tmux command-prompt

Use Case:
Open a command prompt within tmux.


13. confirm-before

    * -p: Prompt message

Example:
tmux confirm-before -p "Are you sure?" "kill-server"

Use Case:
Ask for confirmation before killing the tmux server.


14. copy-mode

    * -u: Scroll one page up

Example:
tmux copy-mode -u

Use Case:
Enter copy mode and scroll one page up.


15. copy-pipe

    * command: Shell command to pipe to

Example:
tmux copy-pipe "pbcopy"

Use Case:
Copy the selection and pipe it to pbcopy.


16. delete-buffer

    * -b: Buffer index

Example:

tmux delete-buffer -b 0

Use Case:


Delete the buffer at index 0.


17. detach-client

    * -s: Target session
    * -a: All but current client

Example:
tmux detach-client -s mySession

Use Case:
Detach from the session named mySession.


18. display-message

    * -c: Target client
    * -p: Print message to stdout

Example:
tmux display-message -p "Current window: #{window_name}"

Use Case:
Display the name of the current window and print it to stdout.


19. display-panes

Example:
tmux display-panes

Use Case:
Show pane numbers for easy selection.


20. find-window

    * -N: Search window names
    * -C: Search window contents

Example:
tmux find-window -N "myWindow"

Use Case:
Find and switch to a window named myWindow.


21. has-session

    * -t: Target session

Example:
tmux has-session -t mySession

Use Case:
Check if a session named mySession exists.


22. if-shell

    * shell-command: Shell command to execute
    * tmux-command: Tmux command to run if shell-command succeeds

Example:
tmux if-shell "test -f ~/myfile" "display-message 'File exists'"

Use Case:
Display a message if myfile exists in the home directory.


23. join-pane

    * -h: Join horizontally
    * -v: Join vertically

Example:
tmux join-pane -h

Use Case:
Join the current pane horizontally with another pane.


24. kill-pane

    * -t: Target pane

Example:


tmux kill-pane -t 1

Use Case:


Kill the pane with the ID 1.


25. kill-server

Example:
tmux kill-server

Use Case:
Kill the tmux server, ending all sessions.


26. kill-session

    * -t: Target session

Example:
tmux kill-session -t mySession

Use Case:
Kill a session named mySession.


27. kill-window

    * -t: Target window

Example:
tmux kill-window -t myWindow

Use Case:
Kill a window named myWindow.


28. last-pane

Example:
tmux last-pane

Use Case:
Switch to the last pane.


29. last-window

Example:
tmux last-window

Use Case:
Switch to the last window.


30. link-window

    * -s: Source window
    * -t: Target window

Example:
tmux link-window -s srcWindow -t tgtWindow

Use Case:
Link srcWindow to tgtWindow, effectively mirroring it.


31. list-buffers

Example:
tmux list-buffers

Use Case:
List all paste buffers.


32. list-clients

Example:
tmux list-clients

Use Case:
List all connected clients.


33. list-commands

Example:
tmux list-commands

Use Case:
List all available tmux commands.


34. list-keys

Example:
tmux list-keys

Use Case:
List all key bindings.


35. list-panes

Example:
tmux list-panes

Use Case:
List all panes in the current window.


36. list-sessions

    * -F: Format

Example:
tmux list-sessions -F "#{session_name}"

Use Case:
List all session names.


37. list-windows

Example:
tmux list-windows

Use Case:
List all windows in the current session.


38. load-buffer

    * -b: Buffer name
    * path: File path

Example:
tmux load-buffer -b myBuffer ~/myfile

Use Case:
Load the contents of myfile into a buffer named myBuffer.


39. lock-client

    * -t: Target client

Example:
tmux lock-client -t myClient

Use Case:
Lock the client named myClient.


40. lock-server

Example:
tmux lock-server

Use Case:
Lock the tmux server, requiring a password to unlock.


41. lock-session

    * -t: Target session

Example:
tmux lock-session -t mySession

Use Case:
Lock the session named mySession.


42. move-pane

    * -t: Target window

Example:
tmux move-pane -t myWindow

Use Case:
Move the current pane to a window named myWindow.


43. move-window

    * -t: Target session
    * -s: Source window

Example:
tmux move-window -s srcWindow -t tgtSession

Use Case:
Move srcWindow to a session named tgtSession.


44. new-session

    * -s: Session name
    * -n: Window name
    * -c: Start directory
    * -d: Detached session

Example:
tmux new-session -s mySession -n myWindow -c ~/myDir -d

Use Case:
Create a new detached session named mySession, with a window named myWindow, starting in the directory ~/myDir.


45. new-window

    * -n: Window name
    * -c: Start directory
    * -d: Detached window

Example:
tmux new-window -n myNewWindow -c ~/anotherDir -d

Use Case:
Create a new detached window named myNewWindow, starting in the directory ~/anotherDir.


46. next-layout

Example:
tmux next-layout

Use Case:
Cycle through available pane layouts.


47. next-window

Example:
tmux next-window

Use Case:
Switch to the next window.


48. paste-buffer

    * -b: Buffer index
    * -t: Target pane

Example:
tmux paste-buffer -b 0 -t 1

Use Case:
Paste the buffer at index 0 to the pane with the ID 1.


49. pipe-pane

    * -o: Only pipe new output
    * command: Shell command to pipe to

Example:
tmux pipe-pane -o "cat >>~/mylog"

Use Case:
Pipe new output from the current pane to ~/mylog.


50. previous-layout

Example:
tmux previous-layout

Use Case:
Switch to the previous pane layout.


51. previous-window

Example:
tmux previous-window

Use Case:
Switch to the previous window.


52. refresh-client

    * -S: Save layout

Example:
tmux refresh-client -S

Use Case:
Refresh the client and save the current layout.


53. rename-session

    * new-name: New session name

Example:
tmux rename-session newSession

Use Case:
Rename the current session to newSession.


54. rename-window

    * new-name: New window name

Example:
tmux rename-window newWindow

Use Case:
Rename the current window to newWindow.


55. resize-pane

    * -U: Resize up
    * -D: Resize down
    * -L: Resize left
    * -R: Resize right

Example:
tmux resize-pane -U 10

Use Case:
Resize the current pane 10 cells up.


56. resize-window

    * -U: Resize up
    * -D: Resize down
    * -L: Resize left
    * -R: Resize right

Example:
tmux resize-window -U 10

Use Case:
Resize the current window 10 cells up.


57. respawn-pane

    * -k: Kill existing pane
    * command: Command to execute

Example:
tmux respawn-pane -k "top"

Use Case:
Kill the current pane and replace it with a new pane running top.


58. respawn-window

    * -k: Kill existing window
    * command: Command to execute

Example:
tmux respawn-window -k "htop"

Use Case:
Kill the current window and replace it with a new window running htop.


59. rotate-window

    * -D: Rotate down
    * -U: Rotate up

Example:
tmux rotate-window -U

Use Case:
Rotate the panes in the current window up.


60. run-shell

    * command: Shell command to execute

Example:
tmux run-shell "echo Hello"

Use Case:
Run a shell command that echoes "Hello".


61. save-buffer

    * -b: Buffer index
    * path: File path

Example:
tmux save-buffer -b 0 ~/myfile

Use Case:
Save the buffer at index 0 to myfile.


62. select-layout

    * layout-name: Name of the layout

Example:
tmux select-layout even-horizontal

Use Case:
Switch to an even horizontal layout.


63. select-pane

    * -U: Up
    * -D: Down
    * -L: Left
    * -R: Right

Example:
tmux select-pane -U

Use Case:
Move to the pane above the current one.


64. select-window

    * -t: Target window

Example:
tmux select-window -t myWindow

Use Case:
Switch to a window named myWindow.


65. send-keys

    * -t: Target pane
    * -l: Literal string
    * -R: Clear pane's input buffer

Example:
tmux send-keys -t 1 "ls -la" C-m

Use Case:
Send the command ls -la followed by Enter (C-m) to pane with the ID 1.


66. send-prefix

Example:
tmux send-prefix

Use Case:
Send the prefix key to the current pane.


67. set-buffer

    * -b: Buffer index
    * data: Data to set

Example:
tmux set-buffer -b 0 "Hello"

Use Case:
Set the buffer at index 0 to contain the string "Hello".


68. set-environment

    * -g: Global variable
    * -u: Unset variable

Example:
tmux set-environment -g MY_VAR "value"

Use Case:
Set a global environment variable MY_VAR to "value".


69. set-hook

    * hook-name: Name of the hook
    * command: Command to run

Example:
tmux set-hook after-new-window "display-message 'New window created'"

Use Case:
Display a message when a new window is created.


70. set-option

    * -g: Global option
    * -w: Window option
    * -s: Server option

Example:
tmux set-option -g status off

Use Case:
Turn off the status bar globally.


71. set-window-option

    * option: Window option
    * value: Value to set

Example:
tmux set-window-option automatic-rename on

Use Case:
Automatically rename windows based on the running application.


72. show-buffer

    * -b: Buffer index

Example:
tmux show-buffer -b 0

Use Case:
Show the contents of the buffer at index 0.


73. show-environment

    * -g: Show global variables

Example:
tmux show-environment -g

Use Case:
Show all global environment variables.


74. show-hooks

Example:
tmux show-hooks

Use Case:
Show all configured hooks.


75. show-messages

Example:
tmux show-messages

Use Case:
Show client messages.


76. show-options

    * -g: Global options
    * -w: Window options
    * -s: Server options

Example:
tmux show-options -g

Use Case:
Show all global options.


77. show-window-options

Example:
tmux show-window-options

Use Case:
Show all window options.


78. source-file

    * file: File to source

Example:
tmux source-file ~/.tmux.conf

Use Case:
Reload the tmux configuration file.


79. split-window

    * -h: Horizontal split
    * -v: Vertical split
    * -c: Start directory

Example:
tmux split-window -h -c ~/splitDir

Use Case:
Split the current pane horizontally and start in the directory ~/splitDir.


80. start-server

Example:
tmux start-server

Use Case:
Start the tmux server.


81. suspend-client

    * -t: Target client

Example:
tmux suspend-client -t myClient

Use Case:
Suspend the client named myClient.


82. swap-pane

    * -s: Source pane
    * -t: Target pane

Example:
tmux swap-pane -s 1 -t 2

Use Case:
Swap pane 1 with pane 2.


83. swap-window

    * -s: Source window
    * -t: Target window

Example:
tmux swap-window -s 1 -t 2

Use Case:
Swap window 1 with window 2.


84. switch-client

    * -n: Next session
    * -p: Previous session
    * -t: Target session

Example:
tmux switch-client -t anotherSession

Use Case:
Switch to another session named anotherSession.


85. unbind-key

    * -T: Key table

Example:
tmux unbind-key -T root F1

Use Case:
Unbind F1 from the root key table.


86. unlink-window

    * -k: Kill window if becomes detached

Example:
tmux unlink-window -k

Use Case:
Unlink the current window and kill it if it becomes detached.


87. wait-for

    * channel: Channel to wait for

Example:
tmux wait-for myChannel

Use Case:
Wait for a signal on myChannel.


## Tips for Increasing Productivity with Tmux

1. Session Management

Example:
Create a script that automatically sets up a development environment with multiple windows and panes.

2. Pane Layouts

Example:
Use tmux select-layout to quickly switch between different pane layouts like even-horizontal, even-vertical, main-horizontal, and main-vertical.

3. Quick Commands

Example:
Bind Ctrl+b, Ctrl+e to open your preferred text editor.

4. Clipboard Integration

Example:
Use tmux-yank plugin for seamless clipboard integration between tmux and your system.

5. Status Bar Customization

Example:
Show the current Git branch in the status bar.

