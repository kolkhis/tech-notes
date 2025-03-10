
# Misc Golang Notes

Golang is a popular language for platform engineering.  
Writing CLI tools, web services, middleware, APIs, etc., are common use cases.  



## Table of Contents
* [Printing Lines](#printing-lines) 
* [The Defer Keyword](#the-defer-keyword) 
* [File Structure for `main.go`](#file-structure-for-maingo) 
* [Zero Values (Zero Initialization)](#zero-values-zero-initialization) 
* [Map Declaration and Initialization](#map-declaration-and-initialization) 
    * [Looping Over a Map](#looping-over-a-map) 
* [Channels](#channels) 
    * [Channel Creation](#channel-creation) 
    * [Closing a Channel](#closing-a-channel) 
* [Goroutines](#goroutines) 
    * [Launching a Goroutine](#launching-a-goroutine) 
    * [WaitGroups](#waitgroups) 
        * [`WaitGroup` Example](#waitgroup-example) 
    * [Receiving Results and Output](#receiving-results-and-output) 
* [Import Statement](#import-statement) 
* [Pain Point](#pain-point) 
* [Creating a New Project in Go](#creating-a-new-project-in-go) 
* [Misc](#misc) 



## Printing Lines
* `println`: Prints to stderr
* `fmt.Println`: Prints to stdout


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


## Zero Values (Zero Initialization)
Go supports zero-initialized variables by default.  
Any time a variable is declared, it's given a zero-value by default.  
The zero value given depends on the type of the variable.  
 
The zero value for a type is the value that is assigned to a variable of that type
when it is declared.

```go
var some_number int
fmt.Println(some_number)  // 0
```
The `some_number` variable is declared, but not initialized with a value.  
Go automatically assigns it the zero-value of its type.  
In this case, it's an `int`, so the zero-value is `0`.


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

### WaitGroups
Wait Groups are a concurrency mechanisms in Go used for coordinating the execution
of multiple goroutines.  
They let your program wait for a  collection of goroutines to finish before
continuing. 

WaitGroups should *only* be passed to functions as **pointers**.  

WaitGroups are a part of the `sync` package.  

A waitgroup essentially acts as a counter.  
* You add to the counter when you start goroutines.
* Each goroutine *signals* (or decrememnts the counter) when it completes.  
* The program waits until the counter reaches zero before moving on.  
* The goroutine should call the `Done()` method when it finishes.  
  ```go
  defer wg.Done()
  ```

#### `WaitGroup` Example
Example of using a waitgroup to execute multiple goroutines:
```go
func worker(id int, wg *sync.WaitGroup) {  // Dereference the wg when it is received
    defer wg.Done()
    fmt.Printf("Starting job ID: %v\n", id)
    // pretend to do some work
    time.Sleep(2 * time.Second)

    fmt.Printf("Job done: %v\n", id)
}

func main() {
    var wg sync.WaitGroup

    // Start 3 worker Goroutines
    for i := 1; i < 3; i++ {
        wg.Add(1)
        go worker(i, &wg) // Pass it in as a pointer
    }
    wg.Wait() // Wait for all workers to finish
    fmt.Println("All goroutines have finished~!")

}
```
* `var wg sync.WaitGroup()`: Initialize the `WaitGroup` object.  
* `wg.Add(1)`: Add to the goroutine counter when starting a goroutine.  
* `go worker(i, &wg)`: Start a goroutine. Each goroutine receives a pointer to the `WaitGroup`.  
* `defer wg.Done()`: Run the `wg.Done()` method at the **end** of the function.  
* `wg.Wait()`: Block the execution of the rest of the program until the counter reaches `0`.  



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


## Pain Point

Go modules are the biggest pain point of Go.  
`go mod tidy` doesn't do what it's supposed to do. 
Managing dependencies sometimes needs to be done manually in a `go.mod` file.  

## Creating a New Project in Go

```bash
go mod init github.com/kolkhis/<name>
```
This makes a new `go.mod` file and shows the Go version.  

This is a popular naming convention for modules since GitHub is essentially the
package manager for Go.  


If you were going to install this program:
```bash
go install github.com/kolkhis/<name>@latest
```

## Misc

* How you structure the project will depend on what kind of project it is (cmd or pkg).  

---

* You can't use the walrus operator in the global scope, only inside functions.  

---

* It's safer to default to private (non-exported), so you're not committed to maintaining it.

---

* You **cannot** export anything from `main`.  

---

* `testdata` is special directory that is not recursed during compilation.  

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

