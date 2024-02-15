
# Misc Golang Notes


## Table of Contents
* [What is Platform Engineering?](#what-is-platform-engineering?) 
* [The Defer Keyword](#the-defer-keyword) 
* [File Structure for `main.go`](#file-structure-for-main.go) 
* [Zero Values](#zero-values) 


## What is Platform Engineering?
Platform engineering is creating systems that other developers can use to develop applications,  
which are then used by users.  
You'll write things that are used by other development teams.  
Golang is a popular language for platform engineering.  

## The Defer Keyword

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


"n to m" is a "many to many" mapping


## Zero Values
The zero value for a type is the value that is assigned to a variable of that type
when it is declared.

```go
var some_number int
fmt.Println(some_number)  // 0
```
The `some_number` variable is declared, but not initialized. Go automatically assigns it the
zero-value of its type (in this case, `0`).


| Type        | Zero Value
|-|-
| `string`    | An empty string `""`
| `int`       | `0`
| `float64`   | `0.0`
| `struct`    | A struct with all fields set to their zero value.
| `array`     | An array with all elements set to their zero value.
| `pointer`   | `nil`
| `slice`     | `nil`. A nil slice has a length and capacity of `0` and no underlying array.
| `map`       | `nil`. A nil map has no keys nor can keys be added.
| `channel`   | `nil`
| `interface` | `nil`, indicating no value and no concrete type.
| `bool`      | `false`
| `function`  | `nil`, indicating a function with no definition.




