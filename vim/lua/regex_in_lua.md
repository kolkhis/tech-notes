
# Regex in Lua

Lua has its own support for regular expressions ().
This gives another option aside from Vim's built-in regex support.

## Table of Contents
* [`string.match`](#string.match) 
    * [Usage](#usage) 
* [Get Multiple Captures from One Regex](#get-multiple-captures-from-one-regex) 
* [Using gsub](#using-gsub) 
    * [`gsub` Syntax](#gsub-syntax) 
* [Another example using a function](#another-example-using-a-function) 

## `string.match`  
### Usage
Using `string.match` is the easiest way to extract text from a string with regex.
 
If the regex matches, `string.match` returns the captures from the pattern,
otherwise it returns `nil`.
If the regex doesn't have any capture groups, then the whole match is returned.

```lua
local captures = line:match('^(#+) (.+)')
local entire_match = line:match('^#+ .+')
```
Since it returns `nil` as a match, it can be useful for `if` statements.

```lua
if line:match('^(#+)') then
    local level = line:match('^(#+)')
    local title = line:match('^#+ (.+)')
end
```


## Get Multiple Captures from One Regex

Each capture group in the regex returns a string.
To get multiple capture groups:
```lua
local line = vim.fn.getline('.')
local capture1, capture2 = line:match('^(#+) (.+)')
vim.print(("First capture: %s, Second capture: %s"):format(capture1, capture2))
```


## Using gsub
See [lua patterns](./patterns.md).  
Using `gsub` is another way to use regex in Lua.  
It accepts Lua "patterns." 


### `gsub` Syntax
```lua
string.gsub({string}, {pattern_to_replace}, {replace_with} [, {n}])
```

The patterns use `%` as the escape character instead of `\`.
i.e., `%1` - `%9` for capture groups, and `%0` for the entire match.


The `replace_with` field can be a string, a table, or a function.
If you specify a function, it'll be called for each match.

If `replace_with` is a string, then it is used as a replacement.
```lua
local text = "I love Lua!"
local newText = string.gsub(text, "Lua", "programming")
print(newText)  -- Output: I love programming!
```

---

If `replace_with` is a table, then `gsub` queries the table with each
capture group, and when a matching key is found, it uses that as a replacement.
```lua
local text = "I love Lua and Python."
local replacements = { Lua = "Go", Python = "C" }
local newText = string.gsub(text, "(Lua) and (Python)", replacements)
print(newText)  -- Output: I love Go and C.
```
If the pattern has no captures, then the whole match is used as the key.

---

If `replace_with` is a function, then it is called with the capture groups.
This function is called every time a match occurs, and all captured
substrings are passed as arguments (in order).
```lua
local text = "3 chickens, 5 cows, and 2 ducks"
local newText = string.gsub(text, "%d+", function(n) return tonumber(n) * 2 end)
print(newText)  -- Output: 6 chickens, 10 cows, and 4 ducks
```
If the pattern specifies no captures, then the whole match is
passed as a single argument.

---


## Another example using a function:
```lua
x = string.gsub("4+5 = $return 4+5$", "%$(.-)%$", function (s)
     return loadstring(s)()
end)
```

The pattern:
```regex
"%$(.-)%$"
```
* `%$` Matches literal dollar signs (`$`)  
* `(.-)` is a non-greedy quantifier. This "lazy" matches as few characters as possible.  

This pattern matches and captures any substring that starts
and ends with a `$` character.  
 
The match is then passed to the replacement function, which takes the
captured substring as an argument.


* The Replacement Function:
    * Instead of a simple replacement string, a function is provided
      as the replacement argument.  
    * Lua calls this function for every match, passing the captured string
      as the argument `s`.
    * In this case, `s` will receive the string `"return 4+5"` from 
      between the `$` signs.


* `loadstring` Function:
    * `loadstring(s)` is a function that compiles a string containing Lua code
      into a Lua function.  
    * In this context, `s` is `"return 4+5"`.
    * Note: In Lua 5.2 and later, `loadstring` is replaced by `load`.
      However, the behavior is similar.


* Executing the Compiled Code:
    * The `()` immediately following `loadstring(s)` invokes the compiled function.  
    * Since `s` is `"return 4+5"`, this compiled function, when
      called, evaluates the expression and returns `9`.


* Final Outcome:
   * The final value of `x` after executing this snippet 
     is `"4+5 = 9"`, and the embedded Lua code within `$...$` is
     evaluated and replaced in the output string.


