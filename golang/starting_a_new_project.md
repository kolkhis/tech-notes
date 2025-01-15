# Starting a project in Go

Go is considered the industry standard for writing code in Kubernetes and Cloud Native. (per Rob, 2023)


## Table of Contents
* [Getting Help](#getting-help) 
* [Go and Git](#go-and-git) 
* [Downloading the Go Source Code](#downloading-the-go-source-code) 
* [Starting a Go Project](#starting-a-go-project) 
    * [Command Projects](#command-projects) 
    * [Library Projects](#library-projects) 
* [Basic Directory Structure](#basic-directory-structure) 
* [Writing a Package](#writing-a-package) 
* [Internal Packages](#internal-packages) 
    * [How to export for certain files only (making it "internal" to a module)](#how-to-export-for-certain-files-only-making-it-internal-to-a-module) 
    * [Running a Package](#running-a-package) 
* [Vendor Code Instead of Using External Dependencies](#vendor-code-instead-of-using-external-dependencies) 
* [Building Executables for Other Operating Systems](#building-executables-for-other-operating-systems) 
* [Generator Line](#generator-line) 
* [Backticks vs Double Quotes](#backticks-vs-double-quotes) 
    * [Backticks](#backticks) 
    * [Double Quotes](#double-quotes) 
* [Single Quotes](#single-quotes) 
* [Running Go Code](#running-go-code) 
    * [Using `go run`](#using-go-run) 
    * [Using `go build`](#using-go-build) 
    * [Using `go generate`](#using-go-generate) 
    * [`go install` vs `exec go install`](#go-install-vs-exec-go-install) 
    * [Key Differences](#key-differences) 
* [Environment Variables](#environment-variables) 
* [Related](#related) 
* [Automatic Running](#automatic-running) 
    * [Interpret (`go run`)](#interpret-go-run) 
    * [Compile (`go build`)](#compile-go-build) 
        * [Compiling](#compiling) 
    * [main.go notes from writing a command.](#maingo-notes-from-writing-a-command) 
* [Resources](#resources) 




Reading the Go documentation and the Go stdlib is the best way to learn Go.  

## Getting Help
Getting help with Go commands from the command line is easy with `go help`.  
```bash
go help 
go help <cmd>
```
`<cmd>` can be any of the go commands. 
```bash
go help install
go help mod
```

## Go and Git  
Go is integrated with Git, in that it uses Git and GitHub as a package manager.  
The developers of Go said "Let's just use Git" for Package Manager.  

## Downloading the Go Source Code
Download the Go source code and read it.  
```bash  
get_go_source_code(){
    mkdir -p ~/coding/go/source_code  
    cd ~/coding/go/source_code  
    git clone git@github.com:golang/go.git  
}
```

## Starting a Go Project  

Every single project starts with `go mod init`:
```bash
go mod init github.com/Kolkhis/learn-go
```
The last argument will be the GitHub repo of your new project.  
This will generate a `go.mod` file with the name of your project.  


This is a popular naming convention for modules since GitHub is essentially the
package manager for Go.  

---

All Go projects are called "modules."  
Anything with a `go.mod` file is a module.  

---

A module can be either a command or a library (also called a package).
Once the module is created, you need to answer the following question:  
* Am I writing a library, or am I writing a command?  
This will determine how you structure your project.  

### Command Modules
Specifically means you have a `main()` function and a `main` package.  

Typically your `main.go` file would go in `cmd/learn-go/main.go` (where `learn-go` is
the project name).  


### Library Modules
Libraries (also called packages) are used as external libraries.  

A library is designed to be imported and used in another project, exports reusable
functions, types, interfaces, etc.

It has no `main()` function and is not meant to be run directly.  

Most of the code here will go in the `pkg/project-name` directory.  

* Some people use the naming convention of `lib.go` if they're writing a package/module.  
* These projects usually *won't* have a `main()` function in its main file.  

* You can make your package run like a command with a `./cmd/package_name/main.go` file, but this is kind of an anti-pattern.  
    * This will essentially be its own command "project" that uses the package you're writing.

## Basic Directory Structure
The best practice for Go project structure:  
```bash
project/
├── cmd/
│   └── project-name/
│       └── main.go   # Entry point for the "project-name" command
│
├── internal/         # Non-exported application logic
│   └── somepackage/
│       └── file.go
│
├── pkg/              # Reusable exported code
│   ├── somepkg/
│   └── someotherpkg/
├── go.mod
└── go.sum
```

## Writing a Package  
* Naming a package `util` is a **big anti-pattern** in the Go world.  
Use a name that "makes sense" to what the code does.  

Go to your project directory  
```bash  
mkdir -p ./cmd/greet  
vim cmd/greet/main.go  
```
With `vim-go` will automatically populate this file with `package main` and `func main()`.  

This will be the file that acts as the command.  

Now, in your project directory, if your Go code is named `main.go`, change it to another name.  
`greet.go` in this case.  
Inside that file, you can export functions by capitalizing the first letter of the function name.  

```go  
package main  
import "fmt"  
func Greet(){
    fmt.Println("Hello, Friend.")  
}
```
This exports the function.  

It's generally not a bad idea to export most functions internally (using the `internal` directory).  


## Internal Packages  
### How to export for certain files only (making it "internal" to a module)  
How to hide those functions in a way that does not break code:  
* Make a directory called `internal`
* Make a Go file in the `internal/` directory or any of its subdirectories.  
* Put anything you want to stay internal there.  
* Done.  

You can export everything in these files and use them throughout your project, and they will be  
inaccessible to other people who use your package.  
```bash  
cd project_root_directory  
mkdir -p ./internal/say  
nvim ./internal/say/say.go  
```
If you want it exported and made publicly available, remove it from the "internal" namespace.  
Put it in a different package/file   
You can move it without breaking anything. (The paths will change tho, that will technically break it)  
If you do move something out of `internal`, you'll only need to change the import statement for any file(s) that depend on that code.  

Anything in here can then be run in your `./cmd/greet/main.go`!  
```go  
package main  

import "github.com/Kolkhis/go-week1/internal/say"  

func main() {
    say.Hello("Kolkhis")  
}
```

### Running a Package  
Running a package should be done from a `cmd/package_name` subdirectory.  
That's where you will put your `main.go`  
```bash  
# Use the directory, not the file  
go run ./cmd/greet  
go build ./cmd/greet  
go install ./cmd/greet  
```
You don't pass the Go files themselves in order to run, you use the directory.  


## Vendor Code Instead of Using External Dependencies  
Find code under a permissive license, copy/paste, put it in your codebase (UNDERSTAND IT THO) and  
give attribution to the author. This reduces build time, and external dependencies = bad  
Don't import code without knowing what the code is doing!  


Package names should be idiomatic.  
Basically it should be intuitive.  
Use the package name as a part of the identifier.  
IT IS NOT IDIOMATIC TO CHAIN DOTS (like `string.strip.replace.smth` etc). This is an anti-pattern in Go.  


## Building Executables for Other Operating Systems  
```bash  
GOOS=windows go build ./cmd/greet/  
```
This will compile an executable for windows!!!  

Can embed all the resources for an application to use the system's default web browser as the GUI.  
Can add suffixes to files (`_win`) that get compiled automatically for the target systems.  

## Generator Line  
There is also a build directive (Generator Line) that will only build on certain machines:  
```go  
go:build !aix && !js && !cavl && !plan9 && !windows && !android && !solaris  
```
This goes at the top of the file. This will prevent building on all the OS 
types listed (`!android` = not android)  
This is called a "Generator Line."  


## Backticks vs Double Quotes  

### Backticks  

Backticks are kind of the same as single quotes in shell. 
They print the LITERAL string, ignoring  
any escape sequences.  
```go  
println(`Hello\nFriend!`)  
```
That will print the string literal:   
`Hello\nFriend!`  

---  

Backticks are great for printing multiple lines:  
```go  
var stuff = `
This is a line.  
Second line.  
`
println(stuff)  
```
This will print:  
```
This is a line.  
Second line.  
```

```go  
import "strings"  
println(strings.TrimSpace(stuff))  
```
This will print it while trimming the whitespace around it (same as `string.strip()` in Python).  


### Double Quotes  
Double quotes will print the string expanded.  
This is the most commonly used method for using strings in Go.  
```go  
println("Hello\nFriend!")  
```
This will print:  
```
Hello  
Friend!  
```



## Single Quotes  
Single quotes cannot be used for strings.  
Single quotes are only for `runes` (Unicode code points).  
```go  
println('!')  
```
That will print:  
`33`  

---  

You can put emojis in there too and it'll output the number associated 
with the emoji/character in Unicode.  

If you cast an emoji to a string it will print the emoji itself:  
```go  
println(string('😊'))  
```
This will print the emoji you put in:  
😊  


## Running Go Code  

Go code can be run in "interpreted mode" or "compiled mode".  

* Interpreted mode will run the code without compiling a binary  
    * `go run`

* Compiled mode will compile an executable binary to run the code: 
    * `go build`
    * `go install`

### Using `go run`
Go code can be run without compiling, using `go run main.go`. This is alright for testing.  
Not usually used.  
* This will run it in "interpreted mode", like how Python is interpreted. 
  But it's faster than Python.  
* This only works if all the dependencies can be resolved from the same system.  


### Using `go build`
This is how you compile Go code. 
Like `make` in C. 
Running `go build` will, by default, compile a binary that matches the name of the directory.  
> **The parent directory is what determines the name!!!**  
Go automatically infers the name of everything.  
To choose a different name for the binary:  
`go build -o other_name`
This will compile the current directory's Go project into a binary called `other_name`.  


### Using `go generate`
This is going to be covered down the line.  


### `go install` vs `exec go install`
* `go install` compiles and installs your Go package, then returns control to the shell.  
* `exec go install` replaces the shell with the `go install` process and terminates the shell once done.  

### Key Differences:  
* Shell Persistence: Running `go install` will return control to the shell  
  after execution, while `exec go install` will terminate the shell after 
  the command finishes.  

* Resource Efficiency: `exec go install` is slightly more resource-efficient  
  because it replaces the shell process, thereby using one less process.  

* Use Cases: Generally, you'd use `go install` during development  
  and testing.  
    * `exec go install` is less commonly used unless you have a specific  
      reason to replace the shell process, like in a startup script for 
      a Docker container.  

`exec` is generally less commonly used unless you have a specific need to replace the shell process.  


## Environment Variables  
* It's recommended to set `GOBIN`.  
    * This is where `go build` or `go install` will put the compiled binary.  
      ```bash
      export GOBIN="$HOME/.local/bin/"
      ```
    * This will install any `go build` binaries into your PATH.  

* It's also recommended to set `CGO_ENABLED=0` 
    * This avoids writing things with C dependencies, to keep cross-platform  
      compile compatibility.  
      ```bash
      export CGO_ENABLED=0
      ```

* `GOPRIVATE` allows you to disable pulling down the repos from the internet.
    * This will force Go to look at libraries in GitHub instead of downloading them.  
      ```bash
      export GOPRIVATE="github.com/$GITUSER/*,gitlab.com/$GITUSER/*"
      ```



## Related  
Go allows you to write inline C code 
* This must be done in a specific way though, by declaring it (look it up).  
* This makes it dependant on a C compiler.
    * This is an anti-pattern if you're trying to write cross-platform  
      compilation code (one of Go's great strengths)  

To install Go code remotely with a URL:  
```bash
go install github.com/asdf/package
# or
go install github.com/asdf/package@latest
```

## Automatic Running  
### Interpret (`go run`)
This will use interpreted mode to run your Go code on every change.  
```bash
entr -c bash "go run main.go" <<< main.go  # Using a herestring
# or, for POSIX Compatibility:
entr -c bash "go run main.go" < <(find . -name 'main.go') # Using process substitution
```

### Compile (`go build`)
Be careful when using `go build` for testing. It will overwrite your existing binary.
To avoid this, use the `-o` option:  
```bash
entr -c bash -c "go build -o testbin; ./testbin" < <(ls main.go)
```
This will re-compile and run the compiled binary on every change.  


#### Compiling  

Go code will not compile if there are unused lines: vars, imports, etc  

`makefiles` are dumb and frowned upon. Don't make `make` files.  
* `build.sh` or `build.ssh` are fine.  




### main.go notes from writing a command.  
```go  

package main  
// `package main` is a special package ONLY used by things that get 
// turned into executable commands 
    // (not packages/modules/libs)  

import "fmt"  

// import "strings"  
var stuff=`
This is a line.  
Second line.  
`

// Writing a simple function  
func greet() {
    fmt.Println("Hello, friend") // This is the standard way to do it.  
}

func main() {
    // Backticks work, they print the string literal.  
    // println is a keyword - unreserved and unsupported, but it's there.  
    // Backticks are kind of the same as single quotes in shell. They print the LITERAL string.  
    println(`Hello, Friend!`)  
    println(stuff)  
    // string.TrimSpace() will strip whitespace and newlines from each side of the string.  
    println(strings.TrimSpace(stuff))  
    

    fmt.Println("Hello, friend") // This is the standard way to do it.  
    greet()  
}
```

---

```go 
func main() {
    println("Hello, Friend 1.")  // prints to stderr  
    log.Println("Hello, Friend 2.")  // prints to stderr  
    fmt.Println("Hello,Friend 3.")  // prints to stdout  
}
```

## Resources  
* Go 101 (book)  
* Effective Go  
* How to write Go code  
* tourGo  
* Source code of Go  
* Go review comments?  
* EBNF Programming language specification  
* The Go source code  
* EBNF specification for the Go Standard Library  
* Go Slack mailing list  

Always use resources that are:  
1. Online
1. Free
1. Resourced by the Go community  




Hyperfine: A benchmarker tool. `sudo apt install hyperfine`

