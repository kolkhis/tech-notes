# Debugging a Slow Vim:

You can use built-in profiling support.  
After launching vim, use the `:profile` Ex command to debug.  

```vim
:profile start profile.log
:profile func *
:profile file *
" At this point do slow actions
:profile pause
:noautocmd qall!
```

