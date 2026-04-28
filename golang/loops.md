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
- `i++` defines an action to perform on each iteration (increment var `i` by 1).  
 





