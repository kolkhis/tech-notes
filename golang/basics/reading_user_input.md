
# Learn Go - Week 3

## Managing Modules
Can have multiple modules within a single Git repository.


Create a new module for each week (keeping them in one repository)
`go mod init github.com/Kolkhis/learn-go/week3`

* `go run` - run the code
* `go install` - build a binary in the `$GOBIN` path
* `go build` - builds a binary in the current directory``
* `go install -o ./testbin` - will output to the specified path/name


## Command Line Arguments & Environment Variables
In go, the `os` module can be used to get command line arguments.

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
``
The `if` check for `n := os.Getenv("USER"); len(n) > 0` checks if the length of `n` is greater than zero. 
This method is faster than checking for an empty string (`n == ""`)
First item in Args is always the name of the program, 

## Pointers and Getting User Input

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


### Getting User Input
`fmt.Scanln` might be okay for one word inputs.
```go
// Make a scanner (it's buffered), pass a reference to stdin
scanner := bufio.NewScanner(os.Stdin)  // This is supported on all platforms. 
fmt.Println("Enter a line of text: ")
// Does a scan until the first EOL (\n or \r\n)
scanner.Scan() 
// Truncates the EOL
text := scanner.Text()  
fmt.println("You entered:", text)
```

```go
scanner := bufio.NewScanner(os.Stdin) // Can replace `os.Stdin` with any input (files)
scanner.Scan() 
// Truncates the EOL
text := scanner.Text()  
```

`ScanLines` is the default. Strips trailing and EOL marker. EOL marker is optional carriage return
followed by one mandatory newline. Automatically truncates. Don't use ReadLines.
Always use `bufio.NewScanner(os.Stdin)`

## BAD GO CODE (if/else if chains):
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
## GOOD GO CODE (swich case):
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


## Types
Go is a STRICTLY TYPED language.

In most projects BEGINNERS work on, types probably don't matter all that much.
Simple projects, it's fine to write code however you want. Using types could be too complex.

When you're working on something to maintain and scale, types are important.
If it's something you might still be working on in 5 years, where there are
parts of code you haven't looked at in a while, it makes sense to have types.

One of the most important things about writing code is making it self-documenting. 
If you can see the type, you know so much more about what it's supposed to represent.


## Printing Lines
* `println` - Prints to stderr
* `fmt.Println` - Prints to stdout

