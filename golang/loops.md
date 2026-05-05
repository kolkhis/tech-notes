# Loops in Go

Go is unique in that it only uses a single keyword (`for`) for all looping constructs.

The `for` loop can be implemented in several different ways.  

- Standard loop (a C-style `for` loop)  
  ```go
  for i := 0; i < 5; i++ { ... }
  ```

- While-style loop  
  ```go
  for i < 5 {...}
  ```

- Infinite loop  
  ```go
  for { ... }
  ```

- Range-based loop  
  ```go
  for idx, value := range collection { ... }
  ```
    - The `range` keyword is the idiomatic way to iterate over most data
      structures.  

## Standard Loops

The standard loop in Go is the C-style `for` loop.  

```go
for i := 0; i <= 10; i++ {
    fmt.Printf("Current iteration: %v\n", i)
}
```

- `i := 0` defines a temporary variable to use as the iterator.  
- `i <= 10` sets a condition for the loop to continue (using the temp var).  
- `i++` defines an action to perform after each iteration (increment var `i` by 1).  
 

## While-Style Loops

Go does not have a `while` keyword, but you can achieve the same effect using a
`for` loop without the initialization and post statements.  

You simply define a condition for the loop to run, just as in `while` loops in
many languages.  
```go
var i int = 0
for i < 5 {
    fmt.Printf("Loop iteration: %v\n", i) 
    i++
}
```
This example achieves the same functionality as the standard loop, but it can
be used in any other way.  



