

# Learn Go Week 2

Default to writing packages.

## Go Types
Go is a strongly typed language.
Every variable has a type.

In Go, ALL things must be delcared before used.

1. Declaration
2. Assignment

### Variables

Defining a variable:
```go
var name string  // Declaration
name = "Rob"  // Assignment
fmt.Println("Hello, "+ name +".") // Usage
// OR, inside of functions ONLY:
name := "Rob"  // Declaration and Assignment
fmt.Println("Hello, "+ name +".") // Usage
```

### Types
Variables in Go can be `const` or `var`.

#### Strings
Strings in Go are immutable.

##### Concatenation
```go
name = "Rob"
fmt.Println("Hello, "+ name +".")
```

## Imports
You can import packages with an alias, like `import strings as s` in Python
```go
import f "fmt"
```
This imports `"fmt"` as `f`.

`go work init`
Creates a file called `go.work`
It's going to tell the local version of go how to resolve dependencies LOCALLY.
`go work init`
`go work use .`
This makes the project use the current directory to resolve dependencies.



## Functions
Sometimes people also "Declare" functions before defining them.
Functions that take arguments must have their expected types.
If multiple variables share a type, the type can be declared after those variables.
```go
func Hello(first, last string) {
    fmt.Printf("Hello, %v %v", first, last)
}

func Greet(first string, last string) {
    fmt.Printf("Hello, %v %v", first, last)
}
```
Go has LOCALLY-SCOPED variables.
Functions have their own scope.

If I have a variable that I want all the function in a file to use, 
You need to add the varible under the import statements.
They MUST be declared AND assigned at the same time.
```go
import "fmt"
var finalpunct string = `!`  // This is only accessible from within the file
var Finalpunct string = `!`  // This is now "exported" cuz caps. Cap be used from any file.
const Finalpunct string = `!`  // This is immutable
```


## Test Cases
Go comes with its own test framework built-in.
The burden of "not using the built-in testing" is on them.
A test program by convention is named `_test.go`

Two forms of testing: 
* Example-based tests
* Unit testing

### Example-based tests.
Some teams choose to use the name `examples_test.go` and the harder tests in `say_test.go`
It will be run automatically when running `go test`.
The test functions MUST contain:
```go
// Output:
// Rob Muhlestein
```
Adding an extra `/` to the `// Output:` will make the test pass but it will still go into the
documentation.
1:29 > Testing 
In the package name at the top, append `_test` to the name of the package.
```go
package say_test
```
Once the example test is ready:
`go test run ./internal/say/`

`go test ./...` Can recursively search for tests and run them.

1:40 for the `entr` auto-testing
`entr bash -c "clear; go test -v ./..." < <(find . -name '*.go')`

Rob used:
`entr bash -c "clear; go test -v ./..." < <(ls **/*.go)` - This gave me an error



## Related
`git grep say` 

`go generate`

CI/CD: Continuious Integration / Continuious Development


next week:
cli arguments
env vars
files

