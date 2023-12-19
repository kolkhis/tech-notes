
# Using fzf (Fuzzy Finder) on Linux  


## Default Options for fzf  

* By default, fzf will start in "Extended Search Mode"  
    * This allows regex-like pattern matching.  
    * You can use `^` and `$` anchors in the patterns.  
    * Prefixing a pattern with a `'` (single quote) will make it an "Exact Match" (non-fuzzy).  
    * Prefixing a pattern with a `!` (exclamation) will make it *exclude* lines that match the  
      pattern.  
        * This makes it perform an exact match by default.  
You can specify multiple, space-delimited patterns. E.g.,  
```regex  
'wild ^music .mp3$ sbtrkt !rmx  
```
Use escaped spaces (`\ `) to match spaces.  

---  

A pipe char `|` acts as an `OR` operator.  
```regex  
^core go$ | rb$ | py$  
```

## Key Bindings / Event Bindings  
Keybinds can be set using the `--bind` option.  
`--bind` takes a comma-separated list of binding expressions.  
Example of keybinding expressions:  
```bash  
fzf --bind=ctrl-j:accept,ctrl-k:kill-line  
```

### Availble keys for fzf keybinding: `man fzf` -> `/AVAILBLE KEYS`

The ones that involve the `CTRL` key:  
* `Ctrl-[a-z]`
* `Ctrl-space`
* `Ctrl-\`
* `Ctrl-]`
* `Ctrl-^` (`Ctrl-6`)  
* `Ctrl-/` (`Ctrl-_`)  
* `Ctrl-Alt-[a-z]`

Some other common keys:  
* `tab`
* `btab` (`Shift-tab`)  
* `esc`
* Cursor Key 
* `Shift-CursorKey`
* Any single character  

### Available Events:  
* `change`
    * Triggered whenever the query string is changed  
    * E.g., Move cursor to the first entry whenever the query is changed:  
    ```bash  
    fzf --bind change:first  
    ```

* `backward-eof`
    * Triggered when the query string is already empty and you try to delete it backward.  
    * e.g.  
    ```bash  
    fzf --bind backward-eof:abort  
    ```


## Available Actions  

| Action                    | Default Bindings (Notes) |
|---------------------------|--------------------------|
| `abort`           | `Ctrl-c` `Ctrl-g` `Ctrl-q` esc  
| `accept`          | `Enter`  double-click  
| `accept-non-empty`| (same as accept except that it prevents fzf from exiting without selection)  
| `backward-char`   | `Ctrl-b` left  
| `backward-delete-char`    | `Ctrl-h` bspace  
| `backward-delete-char/eof`| (same as `backward-delete-char` except aborts fzf if query is empty)  
| `backward-kill-word`      | `Alt-bs`
| `backward-word`           | `Alt-b` shift-left  
| `beginning-of-line`       | `Ctrl-a` home  
| `cancel`                  | (clear query string if not empty, abort fzf otherwise)  
| `change-preview(...)`     | (change `--preview` option)  
| `change-preview-window(...)`| (change `--preview-window` option; rotate through the multiple option sets separated by `\|`)  
| `change-prompt(...)` | (change prompt to the given string)  
| `clear-screen` | `Ctrl-l`
| `clear-selection` | (clear multi-selection)  
| `close` | (close preview window if open, abort fzf otherwise)  
| `clear-query` | (clear query string)  
| `delete-char` | `del`
| `delete-char/eof` | `Ctrl-d` (same as `delete-char` except aborts fzf if query is empty)  
| `deselect` | 
| `deselect-all` | (deselect all matches)  
| `disable-search` | (disable search functionality)  
| `down` | `Ctrl-j` `Ctrl-n` down  
| `enable-search` | (enable search functionality)  
| `end-of-line` | `Ctrl-e` end  
| `execute(...)` | (See man page)  
| `execute-silent(...)` | (See man page)  
| `first` | (move to the first match)  
| `forward-char` | `Ctrl-f` right  
| `forward-word` | `Alt-f` shift-right  
| `ignore` | 
| `jump` | (EasyMotion-like 2-keystroke movement)  
| `jump-accept` | (jump and accept)  
| `kill-line` | 
| `kill-word` | `Alt-d`
| `last` | (move to the last match)  
| `next-history` | (`Ctrl-n`on `--history`)  
| `page-down` | pgdn  
| `page-up` | pgup  
| `half-page-down` | 
| `half-page-up` | 
| `preview(...)` | (See man page)  
| `preview-down` | shift-down  
| `preview-up` | shift-up  
| `preview-page-down` | 
| `preview-page-up` | 
| `preview-half-page-down` | 
| `preview-half-page-up` | 
| `preview-bottom` | 
| `preview-top` | 
| `previous-history` | (`Ctrl-p`on `--history`)  
| `print-query` | (print query and exit)  
| `put` | (put the character to the prompt)  
| `refresh-preview` | 
| `reload(...)` | (See man page)  
| `replace-query` | (replace query string with the current selection)  
| `select` | 
| `select-all` | (select all matches)  
| `toggle` | (right-click)  
| `toggle-all` | (toggle all matches)  
| `toggle+down` | `Ctrl-i` (tab)  
| `toggle-in` | (`--layout=reverse* ? toggle+up : toggle+down`)  
| `toggle-out` | (`--layout=reverse* ? toggle+down : toggle+up`)  
| `toggle-preview` | 
| `toggle-preview-wrap` | 
| `toggle-search` | (toggle search functionality)  
| `toggle-sort` | 
| `toggle+up` | `btab`  (`shift-tab`)  
| `unbind(...)` | (unbind bindings)  
| `unix-line-discard` | `Ctrl-u`
| `unix-word-rubout` | `Ctrl-w`
| `up` | `Ctrl-k` `Ctrl-p` up  
| `yank` | `Ctrl-y`


Multiple actions can be chained using `+` separator.  
```bash  
fzf --multi --bind 'ctrl-a:select-all+accept'  
fzf --multi --bind 'ctrl-a:select-all' --bind 'ctrl-a:+accept'  
```

## Replacements for Parentheses
An action denoted with (`...`) suffix takes an argument.  
```bash  
fzf --bind 'ctrl-a:change-prompt(NewPrompt> )'  
fzf --bind 'ctrl-v:preview(cat {})' --preview-window hidden  
```
If the argument contains parentheses, fzf may fail to parse the expression.  
In that case,you can use any of the following alternative notations to avoid parse errors.  

* `action-name[...]`  
* `action-name~...~`  
* `action-name!...!`  
* `action-name@...@`  
* `action-name#...#`  
* `action-name$...$`  
* `action-name%...%`  
* `action-name^...^`  
* `action-name&...&`  
* `action-name*...*`  
* `action-name;...;`  
* `action-name/.../`  
* `action-name|...|`  
* `action-name:...`  

The last one is the special form that frees you from parse errors; it doesn't expect  
the closing character.  
The catch is that it should be the last one in the comma-separated list of key-action pairs.  

## Running commands from fzf  
With `execute(...)` action, you can execute arbitrary commands without leaving fzf. For example,
you can turn fzf into a simple file browser by binding enter key to less command like follows.  

```bash  
fzf --bind "enter:execute(less {})"  
```

## Previewing with fzf  
With `preview(...)` action, you can specify multiple different preview commands in addition to  
the default preview command given by `--preview` option.  

* Show the contents of the file in the preview window by default:  
```bash  
fzf --preview 'cat {}'  
```
 
* Default preview command with an extra preview binding  
```bash  
fzf --preview 'file {}' --bind '?:preview:cat {}'  
```

* A preview binding with no default preview command  
    * i.e., the preview window is initially empty  
```bash  
fzf --bind '?:preview:cat {}'  
```

* Preview window hidden by default, it appears when you first hit '?'  
```bash  
fzf --bind '?:preview:cat {}' --preview-window hidden  
```

---  

## Changing the Preview Window's Attributes  

The `change-preview-window` action can be used to change the properties of the preview window.  
Unlike the `--preview-window` option, you can specify multiple sets of options 
separated  by  `|` characters.  

* Rotate through the options using `CTRL-/`
```bash
fzf  --preview  'cat  {}' --bind 'ctrl-/:change-preview-window(right,70%|down,40%,border-horizontal|hidden|right)'
```


