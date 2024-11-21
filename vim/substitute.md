

# Substitution in Vim
See [regex in vim](./regex_in_vim.md) for info on regex in Vim.

The `:s` (`:substitute`) command is used to substitute a pattern with a string.
This is one of the most powerful and useful tools that you'll use in Vim.  
wtf
General syntax:
```vim
" For the current line 
:s/search/repl/flags
" For the visual selection 
:'<,'>s/search/repl/flags
" For the entire buffer 
:%s/search/repl/flags
" For the current line and all lines after it
:.,$s/search/repl/flags wtf
" For the current line and all lines before it 
:.,0s/search/repl/flags
" For the current line and 3 lines after it
:.,+3s/search/repl/flags
```

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

## Substitute String
The second string in the `:s` command is the pattern to substitute.  
This is called the "substitute string" in the docs.  
```vim
:s/this is the search/this is the substitute string/
```

## Special Characters in Substitutions
There are a few special characters that you can use in substitutions.  
When used in a substitution (`:s/`)
* `&`: Keep the flags from the previous substitute.  
    * Use in the flags to use the same flags as the last substitution.  
      ```vim
      :s/foo/bar/gc
      " Use the same flags (gc):
      :s/foo/bar/& 
      ```
    * Use as a command (`:&`) to repeat the last substitution.  
    * Use as a command with `&` (`:&&`) to repeat the last substitution, AND use the same flags.  

* `~`: The last string substituted. 
    * E.g., If you switch out `wow` with `cool`, then `~` will be `cool`
      ```vim
      " foobar
      :s/foo/bar/
      " barbar
      :s/~/foo/
      " foobar
      ```
    * Use as a command (`:~`) to repeat the last substitution, but use the last search pattern.  
    * Use as a command with `&` (`:~&`) to repeat the last substitution, but use the last 
      search pattern AND use the same flags.  

### Special Character Examples
If I search for `bar`
```vim
/bar
```
Then I can use `:~` to use `foo` instead of `bar`.  
```vim
" Substitute 'foo' with 'bar' (by default it will use the last search pattern for replacement)
:s//bar/g foo
" Substitute 'bar' with 'foo'
:s/bar/~/g
" Substitute 'bar' with 'foo'
:s/~/foo/g
```

I can use `~` to use the last substitute pattern in a substitution.  
```vim
" wowfoobar
:s/wow/foo/
" foofoobar
" Substitute 'bar' with 'foo'
:s/bar/~/g
" foofoofoo 

" Repeat the last substitution with the same pattern
:&
" Same as above, but also use the same flags
:&& 

" Repeat the last substitution, but with the last search pattern 
:~
" Same as above, but also use the same flags
:~&
```



