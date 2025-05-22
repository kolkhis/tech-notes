# ANSI Control Sequences  

ANSI Control Sequences.  

These are used to control things in the terminal, like terminal text color, background
colors, cursor visibility, screen clearing, mouse tracking, etc.  

They're very useful for customizing how a terminal behaves under certain
circumstances.  


For colors, see [text formatting sequences](#text-formatting-sequences-sgr).  


## Types of Sequences
There are a few different types of ANSI control sequences:

1. `ESC`: Escape Sequences. Start with `ESC` (e.g., `\033`, `\x1b`)  
2. `CSI`: Control Sequence Introducer. Starts with `ESC [`, or CSI (`\x9B`)
3. `DCS`: Device Control String. Starts with `ESC P`, or DSC (`\x90`)  
4. `OSC`: Operating System Command. Starts with `ESC ]`, or OSC )`\x9D`
    * (ignore whitespace between `ESC` and `[` / `P` / `]`)

```bash
\x1b      # Escape sequence
\x1b[     # Control sequence introducer
\x1bP     # Device Control String
\x1b]     # Operating System Command
```

## ANSI Escape Sequence Syntax
You can start escape sequences a number of different ways.  

These different methods of starting ANSI control sequences are
called "Control Sequence Introducer," or "CSI" commands.  

* Standard ANSI escape sequences are prefixed with `ESC[`, where `ESC` is one of:
    - `\x1b`: Hexadecimal for `ESC`.  
    - `\033`: Octal for `ESC`.  
    - `\u001b`: Unicode for `ESC`.  
    - `` (`^[`): The actual escape control character.  
        - Typing the characters `^` and `[` will not work for this. It needs to be
          the actual `Ctrl-[` key signal.   
    - `\e`:  Interpreted as `ESC` by many programs.  
        - `\e` is not guaranteed to work in all languages/compilers.  
        - It's recommended to use octal, hexadecimal, or unicode for `ESC`.  
        - Check what's supported in your language/environment.  

```bash
\e      # Interpreted as ESC by programs
\033    # ESC in (Octal)
\x1b    # ESC in (Hexadecimal)
\u001b  # ESC in (Unicode)
      # ESC (the actual ESC control character)
```

---

The general syntax for an ANSI escape sequence is:  
```bash
printf "\e[SEQ"
# or
printf "\033[SEQ"
# or
printf "[SEQ"
# or
printf "\x1b[SEQ"
```
`SEQ` is the ANSI sequence that you're trying to access.  

* Also see: <https://en.wikipedia.org/wiki/ANSI_escape_code#Control_Sequence_Introducer_commands>

---

Some ANSI control sequences take multiple arguments. Specify multiple arguments by
using semicolons (`;`) in between them.  

For example, using a 255-color escape sequence:  
```bash
"\x1b[38;5;33m"
```

- `38`: First arg  
- `5`: Second arg
- `33`: Third arg
- `m`: The end  


## ASCII Codes
The ASCII codes here are used in some of the ANSI control sequences.  

| Name |  Decimal | Octal  | Hex    | C Escape | Ctrl-Key   | What it is
|-|-|-|-|-|-|-
| `BEL`  |    `7`   |  `007` | `0x07` |  `\a`    | `^G`     | Terminal bell
| `BS`   |    `8`   |  `010` | `0x08` |  `\b`    | `^H`     | Backspace
| `HT`   |    `9`   |  `011` | `0x09` |  `\t`    | `^I`     | Horizontal tab
| `LF`   |    `10`  |  `012` | `0x0A` |  `\n`    | `^J`     | Line feed (newline)
| `VT`   |    `11`  |  `013` | `0x0B` |  `\v`    | `^K`     | Vertical tab
| `FF`   |    `12`  |  `014` | `0x0C` |  `\f`    | `^L`     | Form feed (also: New page NP)
| `CR`   |    `13`  |  `015` | `0x0D` |  `\r`    | `^M`     | Carriage return (CR)
| `ESC`  |    `27`  |  `033` | `0x1B` |  `\e`    | `^[`     | Escape character
| `DEL`  |    `127` |  `177` | `0x7F` |  `<none>`| `<none>` | Delete character


---

## Text Formatting Sequences (SGR)
**SGR - Select Graphic Rendition**. This is used to format text.  

The ANSI color control sequences are used to change the text color  
and background color of the terminal.  

Each number in the control sequence represents a way to customize the 
foreground (text) or background.  


### Color Basic Syntax  
 
The basic syntax for an ANSI color control sequence is:  

```bash  
printf "\e[<STYLE_CODE>m"
```

* `\e` represents the escape character, which begins the sequence.  
* `<STYLE_CODE>` is a number (or series of numbers separated by semicolons) that specifies the color or style.  
* `m` indicates the end of the sequence.  

---

### Quickref

Colors:

| Number| Color
|-|-
|  `0`  |   black
|  `1`  |   red
|  `2`  |   green
|  `3`  |   yellow
|  `4`  |   blue
|  `5`  |   magenta
|  `6`  |   cyan
|  `7`  |   white


ANSI codes:

| Number | Description
|-|-
| 0      |  clear
| 1      |  bold
| 4      |  underline
| 5      |  blink
| 30-37  |  fg color
| 40-47  |  bg color
| 1K     |  clear line (to beginning of line)
| 2K     |  clear line (entire line)
| 2J     |  clear screen
| 0;0H   |  move cursor to 0;0
| 1A     |  move up 1 line

Bash Utilities:
```bash
hide_cursor() { printf "\e[?25l"; }
show_cursor() { printf "\e[?25h"; }
```



### Common Style Codes  

* Text Styles and Defaults  
    * `0`: Reset all styles to default.  
    * `1`: Bold.  
    * `4`: Underline.  
    * `5`: Blink (not widely supported).  
    * `7`: Inverse (swap foreground and background colors).  
    * `39`: Default foreground (text) color.  
    * `49`: Default background color.  

* Standard Text Colors (30-37, 90-97)  
    * `30` to `37`: Standard foreground colors.  
    * `40` to `47`: Standard background colors.  
    * `90` to `97`: Bright (or bold) mode for 16-color foreground colors.  
    * `100` to `107`: Bright (or bold) mode for 16-color background colors.  

* 256-Color Mode  
    * `38;5;<COLOR_CODE>`: Set the foreground color in 256-color mode.  
    * `48;5;<COLOR_CODE>`: Set the background color in 256-color mode.  
    * `<COLOR_CODE>` ranges from `0` to `255`.  


### Standard Colors (8 color)  
The foreground (`30-37`) and background (`40-47`) colors use 8 "standard" colors.  
 
The 8 standard colors are:  

* `0`: Black  
* `1`: Red  
* `2`: Green  
* `3`: Yellow  
* `4`: Blue  
* `5`: Magenta  
* `6`: Cyan  
* `7`: White  


### Formatting the Style Code

The style code can be formatted in several ways. 
As long as the numbers given match the ones above, the order doesn't matter  
all that much.  

---

I generally format the style code like this:
```bash  
printf "\e[<TEXT_STYLE>;<COLOR_MODE>;<COLOR>]"  
```

* `<TEXT_STYLE>` is a number that specifies the text style (`1`-`7` or `0`).  
    * There can be multiple text styles, separated by semicolons.  
* `<COLOR_MODE>` will specify the color mode (i.e., if using 256-color).  
    * This can be `38;5` or `48;5` for 256-color mode foreground and background respectively.  



#### ANSI Color Examples  
```bash  
printf "\e[1;5;31;40m---Testing a color code---\e[0m"  
```

* `\e[`: The start of the sequence  
    * This can also be `\033[`
* `1;5;`: Specifies bold and blinking text (styles `1-7`))  
* `31;`: Specifies red text (foreground `30-37`)  
* `40`: Specifies grey/black background (background `40-47`)  
* `m`: The end of the sequence  

* `\e[0m`: Resets all styles to default.  


---  


#### 256-colors  

`38;` indicates "foreground"  
`5;` indicates "256-color"  
```bash  
SYNTAX="\e[38;5;${COLOR_CODE}m"  
# or, if used in your prompt customization:  
PS1_SYNTAX="\[\e[38;5;${COLOR_CODE}m\]"  
0-7: Standard colors  
8-15: Bright colors  
16-231: 6x6x6 RGB cube  
232-255: Grayscale  
```


## Terminal Manipulation Sequences

### Cursor Manipulation

These sequences control the cursor's position on the screen.

| Sequence  | Action
|-|-
| `ESC[nA`      | Move cursor up by `n` lines
| `ESC[nB`      | Move cursor down by `n` lines
| `ESC[nC`      | Move cursor forward by `n` columns
| `ESC[nD`      | Move cursor backward by `n` columns
| `ESC[nF`      | Move cursor to beginning of line, `n` lines up
| `ESC[nG`      | Move cursor to column `n`  
| `ESC[n;fH`    | Move cursor to row `n`, column `f`
| `ESC[M`       | Move cursor one line up. Scrolls if necessary  
| `ESC[6n`      | Request cursor position (responds as `ESC[n;nR`), (literal `n`)
| `ESC[7`       | Save cursor position (DEC)
| `ESC[8`       | Restore cursor position (DEC)
| `ESC[s`       | Save cursor position (SCO)
| `ESC[u`       | Restore cursor position (SCO)

- **DEC v. SCO**
    - Some terminals (`xterm`-derived) support both SCO and DEC sequences, but they
      may have different functionality.  
    - Prefer DEC sequences over SCO.   

You can also change the cursor's shape and behavior.  
<!-- hide cursor change cursor shape change cursor type show cursor unhide cursor cursor to block cursor line cursor bar cursor underline cursor blinking -->

| Sequence |  Description
|-|-
| `ESC[0 q` | Changes cursor shape to steady block
| `ESC[1 q` | Changes cursor shape to steady block also
| `ESC[2 q` | Changes cursor shape to blinking block
| `ESC[3 q` | Changes cursor shape to steady underline
| `ESC[4 q` | Changes cursor shape to blinking underline
| `ESC[5 q` | Changes cursor shape to steady bar
| `ESC[6 q` | Changes cursor shape to blinking bar
| `ESC[?25l`| Hide the cursor
| `ESC[?25h`| Show the cursor (unhide cursor)

E.g.,:  
```bash
printf "\x1b[\x30 q" # changes to blinking block
printf "\x1b[\x31 q" # changes to blinking block
printf "\x1b[\x32 q" # changes to steady block
printf "\x1b[\x33 q" # changes to blinking underline
printf "\x1b[\x34 q" # changes to steady underline
printf "\x1b[\x35 q" # changes to blinking bar
printf "\x1b[\x36 q" # changes to steady bar

printf "\x1b[?25l"   # will hide cursor
printf "\x1b[?25h"   # will show cursor again
```


### Screen and Line Clearing

These sequences clear parts or all of the terminal screen.

| Sequence    | Action
|-|-
| `ESC[J`     | Clear from cursor to end of the screen (same as `ESC[0J`)
| `ESC[0J`    | Clear from cursor to end of the screen
| `ESC[1J`    | Clear from cursor to beginning of the screen 
| `ESC[2J`    | Clear entire screen
| `ESC[3J`    | Clear saved lines
| `ESC[K`     | Clear from cursor to end of line (same as `ESC[0K`)
| `ESC[0K`    | Clear from cursor to end of line
| `ESC[1K`    | Clear from cursor to beginning of line
| `ESC[2K`    | Clear entire line

Clearing lines won't move the cursor. The cursor will stay where it was before clearing. 
Use `\r` to move the cursor to the beginning of the line if you need to.  
Also see [cursor movement](#cursor-movement).  

### Mouse Interaction

Some terminals support mouse tracking sequences:

| Sequence      | Action
|-|-
| `ESC[?1000h`  | Enable mouse tracking
| `ESC[?1000l`  | Disable mouse tracking


### Operating System Commands (OSC)

These sequences interact with the terminal emulator's operating system features.

| Sequence          | Action
|-|-
| `ESC]0;titleBEL`  | Set window title to `title`
| `ESC]2;titleBEL`  | Set icon name to `title`

`BEL` is the bell character (`\a` or `\x07`).

### Private Modes

These are implemented in most terminals, though not explicitly defined in the ANSI
specification. 

| Sequence | Description
|-|-
| `ESC[?25l`    | Make cursor invisible
| `ESC[?25h`    | Make cursor visible
| `ESC[?47l`    | Restore screen
| `ESC[?47h`    | Save screen
| `ESC[?1049h`  | Enables the alternative buffer
| `ESC[?1049l`  | Disables the alternative buffer
| `ESC[?1004h`  | Enable reporting focus. Reports whenever terminal enters/exits focus (`ESC[I`/`ESC[O` respectively.
| `ESC[?1004l`  | Disable reporting focus.
| `ESC[ s`      | Save current cursor position (SCP, SCOSC).
| `ESC[ u`      | Restore saved cursor position (RCP, SCORC).  

## Resources
* <https://jvns.ca/blog/2025/03/07/escape-code-standards>
* <https://en.wikipedia.org/wiki/ANSI_escape_code>
* <https://invisible-island.net/xterm/ctlseqs/ctlseqs.html>
* <https://gist.github.com/fnky/458719343aabd01cfb17a3a4f7296797#screen-modes>
* <https://stackoverflow.com/questions/4416909/anyway-change-the-cursor-vertical-line-instead-of-a-box>
* <https://invisible-island.net/xterm/ctlseqs/ctlseqs.html>
