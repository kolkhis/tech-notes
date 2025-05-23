# `rbash` - Restricted Bash

`rbash` is a shell available on Linux systems.  
It's a variant of Bash (**restricted mode bash**) that restricts user actions.  



## Restrictions
When `rbash` is invoked, it disallows certain things:

- Disallows changing `$PATH`, `$SHELL`, `$BASH_ENV`.  
- Disallows using `cd`, `exec`, `set +r`, and `unset` of certain vars.  
- Disallows using redirection (redirecting output anywhere).  

