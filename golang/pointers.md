# Pointers
Pointers are mainly used to access variables directly inside functions.  


Similar to C, but not as complicated as pointers in C.


Starting with this example; reading user input to get their name.  
```go
    fmt.Println("What is your name? ${white}")
    var name string
    fmt.Scanln(&name)  // This is the memory address (a pointer)
    // This is passing-by-reference. 
```
`fmt.Scanln` reads from standard input (user input on the CLI).  
It stops reading at newline (`<CR>`) or end of file.

---

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

## Example: Using a pointer to modify a variable directly
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

## Pointer Receivers in Functions (Methods)

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

This uses `func (tl *TaskList)`, which is called a receiver.  
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
