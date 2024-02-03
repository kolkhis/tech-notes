

# Functions with Multiple Return Values in Go

## Defining Variables with Return Values

Typically you'd use the walrus `:=` operator to define 2+ variables from
a function that returns multiple values.  

```go
val, err := two_return_values()
```

This is usually what you'd do.  
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

## Named vs Unnamed Return Values
You can either name all of your return values, or none of them.

For instance, this is valid:
```go
func two_return_values() (string, int) { // Good
	r := "John"
	return r, 25
}
```

This is also valid:
```go
func two_return_values() (name string, age int) {
	r := "John"
	return r, 25
}
```

This is **NOT** valid (will return an error):
```go
func two_return_values() (name string, int) { // ERROR
r := "John"
       return r, 25
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



