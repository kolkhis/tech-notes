

# Substitution in Vim
See [regex in vim](./regex_in_vim.md) for info on regex in Vim.

The `:s` (`:substitute`) command is used to substitute a pattern with a string.
This is one of the most powerful and useful tools that you'll use in Vim.  

## Regex Support

`:s` supports Basic Regular Expressions (BREs) by default (governed by 
the `'magic'` option), and Extended Regular Expressions (EREs) with `\v`.
E.g.,:
```vim
" Basic regular expression:
:s/\(capture_this\)/\1/g
" Extended regular expression:
:s/\v(capture_this)/\1/g
```
With `\v`, the parentheses don't need to be escaped in order to be treated
as a capture group.  

