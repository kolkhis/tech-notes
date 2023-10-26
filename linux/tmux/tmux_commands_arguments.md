# tmux Commands & Arguments

## List of tmux Commands and their Options/Argumnents

1. attach-session
    * -t: Target session
    * -d: Detach other clients

2. bind-key
    * -T: Key table
    * -n: No prefix key required

3. break-pane
    * -d: Leave pane in detached state
    * -n: New window name

4. capture-pane
    * -S: Start line
    * -E: End line

5. choose-buffer

6. choose-client

7. choose-session

8. choose-tree

9. choose-window

10. clear-history

11. clock-mode

12. command-prompt

13. confirm-before
    * -p: Prompt message

14. copy-mode
    * -u: Scroll one page up

15. copy-pipe
    * command: Shell command to pipe to

16. delete-buffer
    * -b: Buffer index

17. detach-client
    * -s: Target session
    * -a: All but current client

18. display-message
    * -c: Target client
    * -p: Print message to stdout

19. display-panes

20. find-window
    * -N: Search window names
    * -C: Search window contents

21. has-session
    * -t: Target session

22. if-shell
    * shell-command: Shell command to execute
    * tmux-command: Tmux command to run if shell-command succeeds

23. join-pane
    * -h: Join horizontally
    * -v: Join vertically

24. kill-pane
    * -t: Target pane

25. kill-server

26. kill-session
    * -t: Target session

27. kill-window
    * -t: Target window

28. last-pane

29. last-window

30. link-window
    * -s: Source window
    * -t: Target window

31. list-buffers

32. list-clients

33. list-commands

34. list-keys

35. list-panes

36. list-sessions
    * -F: Format

37. list-windows

38. load-buffer
    * -b: Buffer name
    * path: File path

39. lock-client
    * -t: Target client

40. lock-server

41. lock-session
    * -t: Target session

42. move-pane
    * -t: Target window

43. move-window
    * -t: Target session
    * -s: Source window

44. new-session
    * -s: Session name
    * -n: Window name
    * -c: Start directory
    * -d: Detached session

45. new-window
    * -n: Window name
    * -c: Start directory
    * -d: Detached window

46. next-layout

47. next-window

48. paste-buffer
    * -b: Buffer index
    * -t: Target pane

49. pipe-pane
    * -o: Only pipe new output
    * command: Shell command to pipe to

50. previous-layout

51. previous-window

52. refresh-client
    * -S: Save layout

53. rename-session
    * new-name: New session name

54. rename-window
    * new-name: New window name

55. resize-pane
    * -U: Resize up
    * -D: Resize down
    * -L: Resize left
    * -R: Resize right

56. resize-window
    * -U: Resize up
    * -D: Resize down
    * -L: Resize left
    * -R: Resize right

57. respawn-pane
    * -k: Kill existing pane
    * command: Command to execute

58. respawn-window
    * -k: Kill existing window
    * command: Command to execute

59. rotate-window
    * -D: Rotate down
    * -U: Rotate up

60. run-shell
    * command: Shell command to execute

61. save-buffer
    * -b: Buffer index
    * path: File path

62. select-layout
    * layout-name: Name of the layout

63. select-pane
    * -U: Up
    * -D: Down
    * -L: Left
    * -R: Right

64. select-window
    * -t: Target window

65. send-keys
    * -t: Target pane
    * -l: Literal string
    * -R: Clear pane's input buffer

66. send-prefix

67. set-buffer
    * -b: Buffer index
    * data: Data to set

68. set-environment
    * -g: Global variable
    * -u: Unset variable

69. set-hook
    * hook-name: Name of the hook
    * command: Command to run

70. set-option
    * -g: Global option
    * -w: Window option
    * -s: Server option

71. set-window-option
    * option: Window option
    * value: Value to set

72. show-buffer
    * -b: Buffer index

73. show-environment
    * -g: Show global variables

74. show-hooks

75. show-messages

76. show-options
    * -g: Global options
    * -w: Window options
    * -s: Server options

77. show-window-options

78. source-file
    * file: File to source

79. split-window
    * -h: Horizontal split
    * -v: Vertical split
    * -c: Start directory

80. start-server

81. suspend-client
    * -t: Target client

82. swap-pane
    * -s: Source pane
    * -t: Target pane

83. swap-window
    * -s: Source window
    * -t: Target window

84. switch-client
    * -n: Next session
    * -p: Previous session
    * -t: Target session

85. unbind-key
    * -T: Key table

86. unlink-window
    * -k: Kill window if becomes detached

87. wait-for
    * channel: Channel to wait for

