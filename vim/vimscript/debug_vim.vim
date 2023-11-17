
" DEBUGGING SLOW VIM:
You can use built-in profiling support: after launching vim do

:profile start profile.log
:profile func *
:profile file *
" At this point do slow actions
:profile pause
:noautocmd qall!

