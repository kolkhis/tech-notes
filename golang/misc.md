
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




## Map Declaration and Initialization
```go
	m := map[int]int{1: 2, 3: 4}
```
* `m`: Declares a variable `m`.
* `map[int]int`: Declares a map with both keys and values of type `int`.
* `{1: 2, 3: 4}`: Initializes the map with two key-value pairs: `1` maps to `2` 
  and ` 3` maps to `4`.

### Looping Over a Map
```go
	for i, v := range m {
```
* `for`: Starts a loop.
* `i, v :=`: Declares two variables, `i` (the key from the map) and `v` (the corresponding value).
* `range m`: `range` is used to iterate over elements in a variety of data structures.  
    * Here, it iterates over the map `m`, returning each key-value pair.

## Channels
### Channel Creation
```go
	c, out := make(chan int), make(chan int)
```
* `c, out`: This declares two variables, `c` and `out`.  
    * Both variables are channels that can transport integers (`int`).
* `:=`: The short variable declaration operator.  
    * It declares new variables and assigns them with the values on the right.
* `make(chan int)`: This creates a new channel for transporting `int` values.  
    * `make` is a built-in function that initializes slices, maps, and channels.  
    * Here, it's used to create two channels: `c` for synchronization and `out` for 
      outputting the results.

### Closing a Channel
```go
	close(c)
```
* `close(c)`: Closes the channel `c`.  
    * Closing a channel indicates that no more values will be sent on it.  
    * This unblocks any receive operations (`<-c`) in the goroutines.


## Goroutines
### Launching a Goroutine
```go
		go func() {
			<-c
			out <- i + v
		}()
```
* `go`: When `go` comes before a function call, it starts a new goroutine, a 
  lightweight thread managed by the Go runtime.
* `func() {}()`: Defines and immediately invokes an anonymous function.  
    * This function first tries to receive a value from channel `c` (which blocks until 
      `c` is closed), then calculates `i + v` and sends the result to the `out` channel.


### Receiving Results and Output
```go
	println(<-out + <-out)
```
* `<-out`: Receives a value from the `out` channel.  
* `println`: Built-in function that prints its arguments to standard error.  
    * Here, it prints the sum of the two values received from `out`.


## Import Statement
 
If your program doesn't explicitly import any packages, it can only use builtin
functions and types (`make`, `chan`, `map`, `for`, `range`, `go`, `func`, `close`, 
and `println`), which do not require an import statement.

