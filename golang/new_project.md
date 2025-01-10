# Creating a New Project in Go


```bash
go mod init github.com/kolkhis/<name>
```
This makes a new `go.mod` file and shows the Go version.  



If you were going to install this program:
```bash
go install github.com/kolkhis/<name>@latest
```

How you structure this project will depend on what kind of project it is.  
## Is it a command or is it a library?  

A module can be either a command or a library.  
A module is just a Go project with a `go.mod` file.  

* A library is designed to be imported and used in another project, exports reusable
  functions, types, interfaces, etc.
    * It has no `main()` function and no ``

* A command has a `main` package and a `main()` function.  

Command and libraries can be in the same module.  



---

You can't use the walrus operator in the global scope, only inside functions.  

---

It's safer to default to private (non-exported), so you're not committed to
maintaining it.

---

You **cannot** export anything from `main`.  

---

testdata - special directory that is not recursed during compilation.  

---

```bash
go get -u  # Download dependencies
```

---

The `COMP_LINE` environment variable is set when bash is doing completion.  

To enable self-completion:  
```bash
complete -C 'script-name' script-name
```

---

Do, Def, or Cmds 
Cmds is a list of commands underneath the Cmd
Def is default

---

Create "stubs", a place to put those cmds.  
