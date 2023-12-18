
# Formats in tmux

### 1. `b:` and `d:` (Basename and Dirname)

* Purpose: Extracts the basename (filename) and dirname (directory path) from a file path.
* Examples:
    * Basename `(b:)`:
        * Given: `#{b:/usr/local/bin/tmux}`
        * Result: `tmux` (extracts just the filename).
    * Dirname `(d:)`:
        * Given: `#{d:/usr/local/bin/tmux}`
        * Result: `/usr/local/bin` (extracts the directory path).

### 2. `q:` (Escape Special Characters)

* Purpose: Escapes shell special characters; q:h escapes hash characters.
* Examples:
    * Escape Special Characters `(q:)`:
        * Given: `#{q:This` # is special}
        * Result: Escapes the # to be interpreted literally.
    * Escape Hash `(q:h)`:
        * Given: `#{q:h#}`
        * Result: `##` (makes # become ##).

### 3. `E:` (Double Expansion)

* Purpose: Expands the format twice, useful for nested formats.
* Example:
    * Given: `#{E:status-left}`
    * Result: Expands the content of the `status-left` option rather than the option itself.

### 4. `T:` (Time Expansion)

* Purpose: Similar to `E:`, but also expands `strftime` time specifiers.
* Example:
    * Given: `#{T:%Y-%m-%d %H:%M:%S}`
    * Result: Shows the current date and time.

### 5. `S:`, `W:`, `P:` (Looping Formats)

* Purpose: Loops over sessions, windows, or panes and applies the format to each.
* Examples:
    * Windows Looping `(W:)`:
        * Given: `#{W:#{window_index} ,#{window_active}}`
        * Result: Lists window indices, with a special format for the active window.

### 6. `N:` (Existence Check)

* Purpose: Checks if a named window or session exists.
* Example:
    * Given: `#{N/w:foo}`
    * Result: Replaced with `1` if a window named `foo` exists, otherwise `0`.

### 7. `s/foo/bar/:` (Substitution)

* Purpose: Substitutes `foo` with `bar` in the string.
* Examples:
    * Basic Substitution:
        * Given: `#{s/foo/bar/:foobar}`
        * Result: `barbar` (replaces `foo` with `bar`).
    * Regex and Case-Insensitive:
        * Given: `#{s/a(.)/\1x/i:abABab}`
        * Result: `bxBxbx` (applies regex substitution).

### 8. `#()` (Shell Command Output)

* Purpose: Inserts the output of a shell command.
* Example:
    * Given: `#(uptime)`
    * Result: Inserts the system's uptime.

### 9. `l:` (Literal Interpretation)

* Purpose: Interprets a string literally without expansion.
* Example:
    * Given: `#{l:#{?pane_in_mode,yes,no}}`
    * Result: `#{?pane_in_mode,yes,no}` (treated as a literal string).

## Use Cases and Additional Examples

* Dynamic Status Line
    * Using `#{W:...}` to create a custom status line that shows different formats for active and inactive windows.
* Custom Information Display
    * Using `#(uptime)` to display system uptime in the status bar.
* Conditional Formatting
    * Using `#{?pane_in_mode,yes,no}` with `#{l:...}` to display whether the current pane is in a specific mode.
* File Path Manipulation
    * Displaying *just* the directory or filename of a path in a pane title with `#{b:...}` and `#{d:...}`.
* Data Transformation
    * Using `#{s/foo/bar/:}` to dynamically change displayed text based on certain conditions or input.

Each of these formatting options allows for a high degree of customization in how information is displayed and managed within tmux,
providing a powerful toolkit for enhancing your terminal experience.




