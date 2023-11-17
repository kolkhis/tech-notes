
# Netrw Default Functions

## Main Netrw Functions
> ##### *:h netrw-call* | *netrw-expose* | *netrw-modify*
Three important netrw functions are:
* Use `netrw#Expose("varname")`          to access netrw-internal (script-local) variables.  
* Use `netrw#Modify("varname",newvalue)` to change netrw-internal variables.  
* Use `netrw#Call("funcname"[,args])`    to call a netrw-internal function with specified arguments.  

These are especially useful when creating custom mappings for netrw (see `./usermaps.md`)

Example: Get a copy of netrw's marked file list:  
```vim
let netrwmarkfilelist= netrw#Expose("netrwmarkfilelist")
```

Example: Modify the value of netrw's marked file list:  
```vim
call netrw#Modify("netrwmarkfilelist",[])
```

Example: Clear netrw's marked file list via a mapping on `gu`:  
```vim
fun! ExampleUserMap(islocal)
    call netrw#Modify("netrwmarkfilelist",[])
    call netrw#Modify('netrwmarkfilemtch_{bufnr("%")}',"")
    let retval= ["refresh"]
    return retval
endfun
let g:Netrw_UserMaps= [["gu","ExampleUserMap"]]
```

*g:Netrw_funcref*

