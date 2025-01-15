
# Functions
Functions in Go are pretty easy to write.  
They can be procedures, functions, or methods.  

Functions are defined with `func`.  

## Writing Functions with Parameters
Sometimes people also "Declare" functions before defining them.
Functions that take arguments must have their expected types.
If multiple variables share a type, the type can be declared after those variables.

Return value types also must be specified after specifying parameters.  
```go
func Hello(first, last string) {
    fmt.Printf("Hello, %v %v", first, last)
}

func Greet(first string, last string) {
    fmt.Printf("Hello, %v %v", first, last)
}

// A function with a return value (of type string)
func MakeGreeting(first string, last string) string {
	greeting := fmt.Sprintf("Hello, %v %v", first, last)
	return greeting
}
```
Go has LOCALLY-SCOPED variables.  
Functions have their own scope.  

If I have a variable that I want all the function in a file to use, 
You need to add the varible under the import statements (in the global scope).
Globally scoped variables cannot use the walrus operator.  

They MUST be declared AND assigned at the same time.
```go
import "fmt"
var finalpunct string = `!`  // This is only accessible from within the file
var Finalpunct string = `!`  // This is now "exported" cuz caps. Cap be used from any file.
const Finalpunct string = `!`  // This is immutable
```


## Functions with Multiple Return Values 

### Defining Variables using Return Values

Typically you'd use the walrus `:=` operator to define 2+ variables from
a function that returns multiple values.  

```go
val, err := two_return_values()
```

This is usually what you'd do.  

---

You can declare *one* of the values beforehand:
```go
var val string
val, err := two_return_values()
```

This is allowed, however if you declare the `err` variable beforehand,
you'll get an error:
```go
var name string /* One variable can be declared beforehand */
// var age int  /* But not both */
name, age := two_return_values()
```
This is because you're using the walrus operator to infer the type of the variable.  
If the variable's type is already defined, the walrus operator won't work.  

## Named Return Values vs Unnamed Return Values
You can either name all of your return values, or none of them.

For instance, this is valid:
```go
func two_return_values() (string, int) { // Good
    name := "John"
    return name, 25
}
```

This is also valid:
```go
func two_return_values() (name string, age int) {
    name := "John"
    return name, 25
}
```

This is **NOT** valid (will return an error):
```go
func two_return_values() (name string, int) { // ERROR
    name := "John"
    return name, 25
}
```

---

If you're returning two values of the same type, you can specify it as `(x, y int)`

```go
package main

import (
	"fmt"
)

func g(v int) (x, y int) {
	x = v+4
	y = v-4
	return        // notice that we are not returning any value
}

func main() {
	x, y := g(12)
	
	fmt.Println(x, y)  // 16 8
}
```


---

## Example Program

```go
package main

import "fmt"

func two_return_values() (string, int) {
    r := "John"
    return r, 25
}

func main() {
    fmt.Printf("Two return values from a function:\n")
    var name string /* One variable can be declared beforehand */
    // var age int  /* But not both */
    name, age := two_return_values()
    fmt.Printf("Name: %v\nAge: %v\n", name, age)
}
```



## Receivers

A receiver is used to associate a method with a type.  
The syntax for defining a method:
```go
func (t *Type) FuncName(arg1 string) {
    // do some stuff
}
```
This defines a method called `FuncName` for the type `Type`.  

There are two main types of receivers: pointer receivers and value receivers.  

You'll probably almost always use pointer receivers, but there are cases where value
receivers are perfectly fine.  



### Pointer Receivers in Methods

When creating methods for structs, you can use Pointer Receivers to modify the actual
struct itself.  

Ex: Task list project I'm working on:
```go
package tasks
// this is in ./internal/tasks/tasks.go

type Task struct {
    Title       string,
    Description string,
    Completed   bool
}

type TaskList struct {
    Tasks []Task
}

// Create some methods for the new objects
// Use a pointer receiver to access the variable itself
func (tl *TaskList) AddTask(title string, desc string) {
	newTask := Task{
		Title:       title,
		Description: desc,
		Completed:   false,
	}
    tl.Tasks = append(tl.Tasks, newTask)
}
```

This uses `func (tl *TaskList)`, which is a pointer receiver.  
A receiver is used to associate a method with a type.  

The receiver defines it as a method for the type `TaskList`.  

It uses the `*` in front of `TaskList` so that it can access the variable itself,
making this a **pointer receiver**.  

When using a pointer receiver, any changes made to `tl` (the `TaskList` object) 
inside the method affects the original object instead of a copy.  

This method can be called directly without explicitly passing a pointer.  
E.g.,
```go
package main
import (
    "fmt"
    t "github.com/terminal-todo/internal/tasks"
)

func main() {
    var tl t.TaskList
    tl.AddTask("Task1", "This is the task description")
    fmt.Printf("Current task: %v", tl.Tasks[0])
}
```

### Value Receivers in Methods
Value receivers create a **copy** of the object that is calling it.  

If a method doesn't need to modify anything in the object itself, you *can* use a value receiver. That doesn't necessarily mean you should.  

You should really only use a value receiver when the object is small and cheap to
copy (e.g., a small struct with a couple fields).  

### Example: Value vs Pointer Receivers
```go
type Counter struct {
    Value int
}

// Method with a value receiver (does not modify the original)
func (c Counter) IncrementValue() {
    c.Value++
}

// Method with a pointer receiver (modifies the original)
func (c *Counter) IncrementPointer() {
    c.Value++
}

func main() {
    c := Counter{Value: 10}
 
    c.IncrementValue() // Value receiver, no change to the original variable
    fmt.Println(c)  // output: 10
    
    c.IncrementPointer() // Pointer receiver, modifies the original variable
    fmt.Println(c)  // output: 11
}
```

