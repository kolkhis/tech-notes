# Reading User Inputs in Go

## Table of Contents
* [Managing Modules](#managing-modules) 
* [Command Line Arguments & Environment Variables](#command-line-arguments--environment-variables) 
* [Pointers and Getting User Input](#pointers-and-getting-user-input) 
    * [Pointers](#pointers) 
    * [Example: Using a pointer to modify a variable directly](#example-using-a-pointer-to-modify-a-variable-directly) 
* [Getting User Input](#getting-user-input) 
* [Switch vs. If/Else](#switch-vs-ifelse) 
    * [BAD GO CODE (if/else if chains)](#bad-go-code-ifelse-if-chains) 
    * [GOOD GO CODE (swich case)](#good-go-code-swich-case) 
    * [Type Switch](#type-switch) 

## Managing Modules
Can have multiple modules within a single Git repository.

Create a new module for each project. You can keep them all in one repository,
creating a monorepo with all your projects.  
`go mod init github.com/kolkhis/learn-go/new-go-project`

* `go run` - run the code
* `go install` - build a binary in the `$GOBIN` path
* `go build` - builds a binary in the current directory``
* `go install -o ./testbin` - will output to the specified path/name


## Command Line Arguments & Environment Variables
In go, the `os` module can be used to get command line arguments.  
Use `os.Args` to get the CLI arguments.  

`~/Repos/github.com/kolkhis/learn-go/hi`
```go
package main

import (
	"fmt"
	"os"
)

func main() {
    // os.Getenv()
    // First in Args is always the name of the program
    name := "Friend"
    if n := os.Getenv("USER"); len(n) > 0 {
        name = n
    }
    if len(os.Args) > 1 {
        name = os.Args[1] 
    }
    fmt.Println("Hi, " + name + ".")
}
```

The `if` check for `n := os.Getenv("USER"); len(n) > 0` checks if the length of `n` is greater than zero. 
This method is faster than checking for an empty string (`n == ""`)
First item in Args is always the name of the program, 

## Pointers and Getting User Input
See [pointers](./pointers.md)
### Pointers

Similar to C, but not as complicated as pointers in C.
```go
    fmt.Println("What is your name? ${white}")
    var name string
    fmt.Scanln(&name)  // This will be a pointer dereference
    // This is passing-by-reference. 
```
`fmt.Scanln` reads from standard input. Stops reading at newline or end of file.
Strings are usually not passed by reference, but other types are.
In this case, strings and integers must be passed by reference.

Since `fmt.Scanln` needs to modify the **value** of the `name` variable, the only way
to do this is to pass a Pointer to the function - its memory address (`&name`).  

* `&name` passes the memory address of the `name` variable (a pointer) to `fmt.Scanln`.  
* `fmt.Scanln` dereferences the pointer (accesses the value stored at the memory
  address) and modifies the actual `name` variable.  
Why a pointer is needed here:
* `fmt.Scanln` needs to assign the user input to the `name` variab.e  
* Without passing its address, `fmt.Scanln` would only work with a **copy** of `name`
  and wouldn't be able to modify the original variable.  


So, if you need to pass a variable to a function in order to modify its value, use a pointer.  

### Example: Using a pointer to modify a variable directly
```go
package main
import ("fmt")

func ChangeAge(age *int) newage int {
    *age = newage
}
func main() {
    var age int = 30
    fmt.Println("Your age:", age)
    ChangeAge(&age, 33)
    fmt.Printf("New age: %v\n", age)
}
```

If you called `ChangeAge` without referencing `&age`, it would only pass the *value*
of `age` (`30`). 
```go
ChangeAge(age, 33)
// is the same as:
ChangeAge(30, 33)
```
It won't know about the variable, because it's only receiving the value.  



## Getting User Input
`fmt.Scanln` might be okay for one-word/one-time inputs.
```go
// Make a scanner (it's buffered), pass a reference to stdin
scanner := bufio.NewScanner(os.Stdin)  // This is supported on all platforms. 
fmt.Println("Enter a line of text: ")
// Does a scan until the first EOL (\n or \r\n)
scanner.Scan() 
// Truncates the EOL
text := scanner.Text()  
fmt.Println("You entered:", text)
```

But reading input is generally done with a `bufio.NewScanner` object, which takes
either a file or `os.Stdin` as an argument.  
```go
scanner := bufio.NewScanner(os.Stdin) // Can replace `os.Stdin` with any input (files)
scanner.Scan() 
// Truncates the EOL
text := scanner.Text()  
```

`ScanLines` is the default. Strips trailing and EOL marker. EOL marker is optional carriage return
followed by one mandatory newline. Automatically truncates. Don't use ReadLines.
Always use `bufio.NewScanner(os.Stdin)`

## Switch vs. If/Else
It's generally considered better form to use switch cases instead of if/else chains
when you have multiple conditions.  

Switches are more versatile too in that you can use a "Type Switch" to check for
types if you need to do that.  

### BAD GO CODE (if/else if chains):
BAD GO: `else if` statements.
```go
    if name == "Robin" {
        fmt.Println("What is your capital of Assyria?")
    } else if name == "Lancelot" {
        fmt.Println("What is your favorite colour?")
    } else if name == "Arthur" {
        fmt.Println("What is the air speed velocity of an unladen swallow?")
        fmt.Println("How do you know so much about swallows?")
        fmt.Println("Well, as a King you have to know these things, you know.")
    }
```

### GOOD GO CODE (swich case):
In Go, switch statements are the preferred idiomatic way for conditionals.
```go
    switch strings.ToLower(name) {
        // The {surrounding braces} for `case` statements are options
        case "robin": { fmt.Println("What is your capital of Assyria?") } 
        fallthrough
        case "lancelot": { fmt.Println("What is your favorite colour?") } 
        case "arthur": {
            fmt.Println("What is the air speed velocity of an unladen swallow?")
            fmt.Println("How do you know so much about swallows?")
            fmt.Println("Well, as a King you have to know these things, you know.")
        }
```
The breaks are implied. At the end of each `case`, in C, it's required to use `break;`.
The Go equivalent in the `fallthrough` keyword.

### Type Switch
Also see [type switches with interfaces](./interfaces.md)
```go
var myvar int
switch v := myvar.(type) {  // .(type) can only be used in type switches and type assertions
    case int:  
        fmt.Println("Int", v)  
    case string:  
        fmt.Println("String", v)  
    default:  
        fmt.Println("Unknown Type")  
}
```

