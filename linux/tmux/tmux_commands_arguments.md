# tmux Commands & Arguments  

To see all commands in a nice little table, check out the [Table of Commands](#Table-of-`tmux-list-commands`-Output).  
The options aren't explained there like they are in the [list](List-of-tmux-Commands-and-their-Options/Argumnents), but it's easier to look at.  

## List of tmux Commands and their Options/Argumnents  
`tmux list-commands`

1. attach-session (attach)  
    * -t: Target session  
    * -d: Detach other clients  

2. bind-key (bind)  
    * -T: Key table  
    * -n: No prefix key required  

3. break-pane (breakp)  
    * -d: Leave pane in detached state  
    * -n: New window name  

4. capture-pane (capturep)  
    * -S: Start line  
    * -E: End line  

5. choose-buffer  

6. choose-client  

7. choose-session  

8. choose-tree  

9. choose-window  

10. clear-history (clearhist)  

11. clock-mode  

12. command-prompt  

13. confirm-before (confirm)  
    * -p: Prompt message  

14. copy-mode  
    * -u: Scroll one page up  

15. copy-pipe  
    * command: Shell command to pipe to  

16. delete-buffer (deleteb)  
    * -b: Buffer index  

17. display-menu (menu) [-O] [-c target-client] [-t target-pane] [-T title] [-x position] [-y position] name key command ...  

17. detach-client (detach)  
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

40. lock-server (lock)  

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

60. run-shell (run)
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

### Table of `tmux list-commands` Output
This table does not explain what each option does, but it is exhaustive.  
|  Command            |Shorthand   |Options                                                 |
|---------------------|------------|--------------------------------------------------------|
| `tmux attach-session` |  `attach` | `[-dErx] [-c working-directory] [-f flags] [-t target-session]` |
| `tmux bind-key` |  `bind` | `[-nr] [-T key-table] [-N note] key [command [arguments]]` |
| `tmux break-pane` |  `breakp` | `[-abdP] [-F format] [-n window-name] [-s src-pane] [-t dst-window]` |
| `tmux capture-pane` |  `capturep` | `[-aCeJNpPq] [-b buffer-name] [-E end-line] [-S start-line] [-t target-pane]` |
| `tmux choose-buffer` | | `[-NrZ] [-F format] [-f filter] [-K key-format] [-O sort-order] [-t target-pane] [template]` |
| `tmux choose-client` | | `[-NrZ] [-F format] [-f filter] [-K key-format] [-O sort-order] [-t target-pane] [template]` |
| `tmux choose-tree` | | `[-GNrswZ] [-F format] [-f filter] [-K key-format] [-O sort-order] [-t target-pane] [template]` |
| `tmux clear-history` |  `clearhist` | `[-t target-pane]` |
| `tmux clock-mode` | | `[-t target-pane]` |
| `tmux command-prompt` | | `[-1kiNTW] [-I inputs] [-p prompts] [-t target-client] [template]` |
| `tmux confirm-before` |  `confirm` | `[-p prompt] [-t target-client] command` |
| `tmux copy-mode` | | `[-eHMuq] [-s src-pane] [-t target-pane]` |
| `tmux customize-mode` | | `[-NZ] [-F format] [-f filter] [-t target-pane]` |
| `tmux delete-buffer` |  `deleteb` | `[-b buffer-name]` |
| `tmux detach-client` |  `detach` | `[-aP] [-E shell-command] [-s target-session] [-t target-client]` |
| `tmux display-menu` |  `menu` | `[-O] [-c target-client] [-t target-pane] [-T title] [-x position] [-y position] name key command ...  `|
| `tmux display-message` |  `display` | `[-aINpv] [-c target-client] [-d delay] [-F format] [-t target-pane] [message]` |
| `tmux display-popup` |  `popup` | `[-CE] [-c target-client] [-d start-directory] [-h height] [-t target-pane] [-w width] [-x position] [-y position] [command]` |
| `tmux display-panes` |  `displayp` | `[-bN] [-d duration] [-t target-client] [template]` |
| `tmux find-window` |  `findw` | `[-CiNrTZ] [-t target-pane] match-string` |
| `tmux has-session` |  `has` | `[-t target-session]` |
| `tmux if-shell` |  `if` | `[-bF] [-t target-pane] shell-command command [command]` |
| `tmux join-pane` |  `joinp` | `[-bdfhv] [-l size] [-s src-pane] [-t dst-pane]` |
| `tmux kill-pane` |  `killp` | `[-a] [-t target-pane]` |
| `tmux kill-server` |  |    |
| `tmux kill-session` | | `[-aC] [-t target-session]` |
| `tmux kill-window` |  `killw` | `[-a] [-t target-window]` |
| `tmux last-pane` |  `lastp` | `[-deZ] [-t target-window]` |
| `tmux last-window` |  `last` | `[-t target-session]` |
| `tmux link-window` |  `linkw` | `[-abdk] [-s src-window] [-t dst-window]` |
| `tmux list-buffers` |  `lsb` | `[-F format] [-f filter]` |
| `tmux list-clients` |  `lsc` | `[-F format] [-t target-session]` |
| `tmux list-commands` |  `lscm` | `[-F format] [command]` |
| `tmux list-keys` |  `lsk` | `[-1aN] [-P prefix-string] [-T key-table] [key]` |
| `tmux list-panes` |  `lsp` | `[-as] [-F format] [-f filter] [-t target-window]` |
| `tmux list-sessions` |  `ls` | `[-F format] [-f filter]` |
| `tmux list-windows` |  `lsw` | `[-a] [-F format] [-f filter] [-t target-session]` |
| `tmux load-buffer` |  `loadb` | `[-b buffer-name] [-t target-client] path` |
| `tmux lock-client` |  `lockc` | `[-t target-client]` |
| `tmux lock-server` |  `lock`  |   |
| `tmux lock-session` |  `locks` | `[-t target-session]` |
| `tmux move-pane` |  `movep` | `[-bdfhv] [-l size] [-s src-pane] [-t dst-pane]` |
| `tmux move-window` |  `movew` | `[-abdkr] [-s src-window] [-t dst-window]` |
| `tmux new-session` |  `new` | `[-AdDEPX] [-c start-directory] [-e environment] [-F format] [-f flags] [-n window-name] [-s session-name] [-t target-session] [-x width] [-y height] [command]` |
| `tmux new-window` |  `neww` | `[-abdkPS] [-c start-directory] [-e environment] [-F format] [-n window-name] [-t target-window] [command]` |
| `tmux next-layout` |  `nextl` | `[-t target-window]` |
| `tmux next-window` |  `next` | `[-a] [-t target-session]` |
| `tmux paste-buffer` |  `pasteb` | `[-dpr] [-s separator] [-b buffer-name] [-t target-pane]` |
| `tmux pipe-pane` |  `pipep` | `[-IOo] [-t target-pane] [command]` |
| `tmux previous-layout` |  `prevl` | `[-t target-window]` |
| `tmux previous-window` |  `prev` | `[-a] [-t target-session]` |
| `tmux refresh-client` |  `refresh` | `[-cDlLRSU] [-A pane:state] [-B name:what:format] [-C XxY] [-f flags] [-t target-client] [adjustment]` |
| `tmux rename-session` |  `rename` | `[-t target-session] new-name` |
| `tmux rename-window` |  `renamew` | `[-t target-window] new-name` |
| `tmux resize-pane` |  `resizep` | `[-DLMRTUZ] [-x width] [-y height] [-t target-pane] [adjustment]` |
| `tmux resize-window` |  `resizew` | `[-aADLRU] [-x width] [-y height] [-t target-window] [adjustment]` |
| `tmux respawn-pane` |  `respawnp` | `[-k] [-c start-directory] [-e environment] [-t target-pane] [command]` |
| `tmux respawn-window` |  `respawnw` | `[-k] [-c start-directory] [-e environment] [-t target-window] [command]` |
| `tmux rotate-window` |  `rotatew` | `[-DUZ] [-t target-window]` |
| `tmux run-shell` |  `run` | `[-bC] [-d delay] [-t target-pane] [shell-command]` |
| `tmux save-buffer` |  `saveb` | `[-a] [-b buffer-name] path` |
| `tmux select-layout` |  `selectl` | `[-Enop] [-t target-pane] [layout-name]` |
| `tmux select-pane` |  `selectp` | `[-DdeLlMmRUZ] [-T title] [-t target-pane]` |
| `tmux select-window` |  `selectw` | `[-lnpT] [-t target-window]` |
| `tmux send-keys` |  `send` | `[-FHlMRX] [-N repeat-count] [-t target-pane] key ...  `|
| `tmux send-prefix` | | `[-2] [-t target-pane]` |
| `tmux set-buffer` |  `setb` | `[-aw] [-b buffer-name] [-n new-buffer-name] [-t target-client] data` |
| `tmux set-environment` |  `setenv` | `[-Fhgru] [-t target-session] name [value]` |
| `tmux set-hook` | | `[-agpRuw] [-t target-pane] hook [command]` |
| `tmux set-option` |  `set` | `[-aFgopqsuUw] [-t target-pane] option [value]` |
| `tmux set-window` | `setw`  | `-option [-aFgoqu] [-t target-window] option [value]`   |
| `tmux show-buffer` |  `showb` | `[-b buffer-name]` |
| `tmux show-environment` |  `showenv` | `[-hgs] [-t target-session] [name]` |
| `tmux show-hooks` | | `[-gpw] [-t target-pane]` |
| `tmux show-messages` |  `showmsgs` | `[-JT] [-t target-client]` |
| `tmux show-options` |  `show` | `[-AgHpqsvw] [-t target-pane] [option]` |
| `tmux show-window` |  `showw` | `-options [-gv] [-t target-window] [option]`   |
| `tmux source-file` |  `source` | `[-Fnqv] path ...  `|
| `tmux split-window` |  `splitw` | `[-bdefhIPvZ] [-c start-directory] [-e environment] [-F format] [-l size] [-t target-pane] [command]` |
| `tmux start-server` |  `start`  |   |
| `tmux suspend-client` |  `suspendc` | `[-t target-client]` |
| `tmux swap-pane` |  `swapp` | `[-dDUZ] [-s src-pane] [-t dst-pane]` |
| `tmux swap-window` |  `swapw` | `[-d] [-s src-window] [-t dst-window]` |
| `tmux switch-client` |  `switchc` | `[-ElnprZ] [-c target-client] [-t target-session] [-T key-table]` |
| `tmux unbind-key` |  `unbind` | `[-anq] [-T key-table] key` |
| `tmux unlink-window` |  `unlinkw` | `[-k] [-t target-window]` |
| `tmux wait-for` |  `wait` | `[-L\|-S\|-U] channel`|
