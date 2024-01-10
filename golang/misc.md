
# Misc Golang Notes


## What is Platform Engineering?
Platform engineering is creating systems that other developers can use to develop applications,  
which are then used by users.  
You'll write things that are used by other development teams.  
Golang is a popular language for platform engineering.  

## Defer

The `defer` keyword will run whatever comes after it at the *end* of the function.  
If `defer fmt.Println("bye")` is called in `func main()`, it will print `bye` when the
program exits.  

```go
package main

import "fmt"

func main() {
	defer fmt.Println("world")
	fmt.Println("hello")
}
```
Will output `hello world`


## File Structure for `main.go`

Most common practice is to make a `cmd` directory, and then another
subdirectory named after the current project, i.e., `cmd/my-project`, and 
put your `main.go` file in there.




