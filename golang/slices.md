

# Slices in Go
See [arrays](./arrays.md).


## Table of Contents
* [Slices in Go](#slices-in-go) 
* [Slices vs. Arrays](#slices-vs-arrays) 
    * [Arrays](#arrays) 
    * [Slices](#slices) 
    * [When to Use Arrays](#when-to-use-arrays) 
    * [When to Use Slices](#when-to-use-slices) 
    * [Key Differences](#key-differences) 
* [Comparing Two Slices](#comparing-two-slices) 
* [Appending an Element to a Slice](#appending-an-element-to-a-slice) 
* [Slices are Reference Types](#slices-are-reference-types) 
    * [Example Highlighting a Slice's Reference Type](#example-highlighting-a-slice's-reference-type) 
* [The make() Builtin Function](#the-make-builtin-function) 
    * [Syntax for `make()`](#syntax-for-make) 
    * [Return Value of `make()`](#return-value-of-make) 
    * [Basic Usage of `make()` with Slices](#basic-usage-of-make-with-slices) 
    * [Defining a Slice with a High Capacity](#defining-a-slice-with-a-high-capacity) 
    * [`make()` with Slices Example](#make-with-slices-example) 
    * [`make()` with Maps Example](#make-with-maps-example) 
* [The cap() Builtin Function](#the-cap-builtin-function) 
    * [Syntax for `cap()`](#syntax-for-cap) 


## Slices vs. Arrays
Slices and Arrays are both used to store sequences of elements, but
they are significantly different in terms of functionality.  

Slices are a **reference** to an underlying array.

### Arrays

* Fixed Size: An array has a fixed size.
    * The size is part of the array's type, meaning the size must be known at compile time.
* Value Type: Arrays are value types.
    * When you assign an array to another variable, or pass an array to
      a function, the entire array is copied.
* Declaration: You specify the size of the array within its type declaration.
    * For example, `var a [5]int` declares an array of five integers.

```go
var myArray [3]int = [3]int{10, 20, 30}
```

### Slices

* Dynamic Size
    * Slices are dynamically-sized, flexible view into the elements of an array.
    * You can think of slices as references to arrays.
    * A slice does not store any data itself; it just describes a section of an underlying array.
* Reference Type
    * Slices are reference types.
    * When you assign a slice to another variable, both variables refer to the same
      underlying array.
    * If you change the elements of the slice, the changes are visible through
      other slices that share the same underlying array.
* Declaration and Initialization
    * Slices can be created with the built-in `make` function, by slicing an
      existing array, or using a slice literal.
    * Their size can change dynamically with operations like `append`.


```go
var mySlice []int = []int{10, 20, 30}
// or simply
mySlice := []int{10, 20, 30}
```

### When to Use Arrays
Use Arrays when you need a fixed-size collection of elements, and
the size will not change, or when you want to pass data by value
rather than by reference.

### When to Use Slices
Use Slices for most other situations, especially when you need a 
dynamically-sized sequence of elements, or when working with functions
that expect slice parameters.



### Key Differences

| Aspect | Array | Slice 
|-|-|-
| Size  | Fixed at compile-time            | Dynamic, can grow and shrink 
| Type  | Value type (copies are separate) | Reference type  
| Initialization | Must specify size or use an array literal | Can use `make`, slice existing arrays, or use slice literals 
| Flexibility | Less flexible, size cannot change | More flexible, can use `append` and `copy` 
| Usage | Suitable for static, fixed-length collections | Suitable for dynamic collections or when size might change 


## Comparing Two Slices
As of Go 1.21, you can just use `slices.Equal` to compare two slices.
There's also a `reflect.DeepEqual` functions that compares to slices.
```go
import (
	"fmt"
	"reflect"
)
func main() {
	slice1 := []int{1, 2, 3}
	slice2 := []int{1, 2, 3}
	fmt.Println(reflect.DeepEqual(slice1, slice2))  // true
	fmt.Println(slices.Equal(slice1, slice2))       // true
}
```


## Appending an Element to a Slice
To append an element to a slice, use the built-in `append` function.

```go
mySlice := []int{1, 2, 3, 4, 5}
fmt.Println(mySlice) // [1 2 3 4 5]
 
mySlice = append(mySlice, 6) 
fmt.Println(mySlice) // [1 2 3 4 5 6]
```



## Slices are Reference Types

Slices in Go are reference types, meaning they point to the same underlying array.

```
Changes made through one slice are visible through another slice
that references the same array.
```

### Example Highlighting a Slice's Reference Type
Here's an example that demonstrates the fact that 
slices are reference types, rather than value types:
```go
package main
 
import "fmt"
 
func main() {
    // Initialize a slice
    originalSlice := []int{1, 2, 3, 4, 5}

    // Create a new slice by slicing the original slice.
    newSlice := originalSlice[1:4] // newSlice references elements 2, 3, and 4 of originalSlice
 
    // Modify an element through newSlice
    newSlice[0] = 999 // Changes the second element of originalSlice to 999
 
    // Output will show the change made through newSlice
    fmt.Println("originalSlice:", originalSlice) 
 
    fmt.Println("newSlice:", newSlice)           // Output: [999 3 4]
 
    // Append to newSlice; this may or may not affect originalSlice depending on capacity.
    newSlice = append(newSlice, 6)
 
    // Print slices after appending to newSlice
    fmt.Println("After appending to newSlice")
    fmt.Println("originalSlice:", originalSlice) // Contents might change if newSlice had enough capacity
 
    fmt.Println("newSlice:", newSlice)           // Output: [999 3 4 6]
 
    // Demonstrate that slices are references by making a function call that modifies a slice
    modifySlice(newSlice)
    fmt.Println("newSlice after modifySlice call:", newSlice) // newSlice modified by the function
}
 
// modifySlice takes a slice and modifies its first element
func modifySlice(s []int) {
    if len(s) > 0 {
        s[0] = -1 // This change will be visible to the caller of modifySlice
    }
}
```



## The make() Builtin Function
The `make()` function can be used to create slices, maps, or channels.  

### Syntax for `make()`

```go
func make(t Type, size ...IntegerType) Type
```
* `t`: The type.
* `size…`: The size and capacity.

`make()` is a built-in function that is used to allocate and initialize an
object of type `slice`, `map`, or `chan` (only these three types).  

It accepts two or more arguments (`t Type, size ...IntegerType`) and
returns the same type as `t`.


### Return Value of `make()`

The return value depends on the first argument, `t Type`.  

* Slice (`[]any`)
    * The `size` argument specifies the length.  
    * The capacity of the slice is equal to its length.  
    * A second integer argument may be provided to specify a different capacity.
        * It must be no smaller than the length.
    * For example, `make([]int, 0, 10)` allocates an underlying array of size `10` and
      returns a `slice` of length `0` and capacity `10` that is backed
      by this underlying array.
 
* Map (`map[string]any`)
    * An empty map is allocated with enough space to hold the specified number of elements.  
    * The size may be omitted, in which case a small starting size is allocated.
 
* Channel (`chan int`)
    * The channel's buffer is initialized with the specified buffer capacity.  
    * If zero, or the size is omitted, the channel is unbuffered.

 
### Basic Usage of `make()` with Slices
```go
/* Declaring a slice */
var slice1 []int

/* Initializing the slice with a 
   max capacity of 5 elements */
slice1 = make([]int, 5)

/* This can be done in a single line */
var slice2 []int = make([]int, 5)

/* or simply: */
slice3 := make([]int, 5)
```
* This creates a slice with length `5` and capacity `5`.  
* The capacity of the slice is equal to its length.  
* A second integer argument can be given to specify a different capacity.
    * It must be no smaller than the length.


### Defining a Slice with a High Capacity
To define a slice with a length of 0, and a capacity of 10 elements:
```go
empty_slice := make([]any, 0, 10)
```
This will create a slice with a length of `0`, and a capacity of `10`.  
* There will be no elements in the slice by default.
* The slice will be able to store 10 elements. Add elements by using `append`.  

### `make()` with Slices Example: 

Go program to demonstrate using `make()` with slices:
```go
package main
  
import ("fmt")
 
func main() {
a := make([]int, 5)
    fmt.Printf("a: Type: %T, Length: %d, Capacity: %d\n",
            a, len(a), cap(a))
    fmt.Println("value of a:", a)
 
    b := make([]int, 10, 20)
    fmt.Printf("b: Type: %T, Length: %d, Capacity: %d\n",
            b, len(b), cap(b))
    fmt.Println("value of b:", b)

    c := make([]int, 0, 5)
    fmt.Printf("c: Type: %T, Length: %d, Capacity: %d\n",
            c, len(c), cap(c))
    fmt.Println("value of c:", c)
}
```

Output:
```plaintext
a: Type: []int, Length: 5, Capacity: 5
value of a: [0 0 0 0 0]
b: Type: []int, Length: 10, Capacity: 20
value of b: [0 0 0 0 0 0 0 0 0 0]
c: Type: []int, Length: 0, Capacity: 5
value of c: []
```

### `make()` with Maps Example
Go program to demonstrate using `make()` with maps:
```go
package main
import (
    "fmt"
)
 
func main() {
    // Creating a map using make()
    var student = make(map[string]int)
 
    // Assigning
    student["Alvin"] = 21
    student["Alex"] = 47
    student["Mark"] = 27

    // Printing the map, its type and lenght
    fmt.Println(student)
    fmt.Printf("Type: %T, Length: %d\n",
        student, len(student))
}
```

Output:
```plaintext
map[Alex:47 Alvin:21 Mark:27]
Type: map[string]int, Length: 3
```


## The cap() Builtin Function
Get the maximum `cap`acity of a slice, array, or channel.  

### Syntax for `cap()`

```go
cap(v Type) int
```
* `v` can be a `slice`, `array`, `*array`, or `chan`.
    * If `v` is `nil`, `cap(v)` is zero.
    * `v` is a `slice`:
        * Returns the maximum length the slice can reach when resliced.  
    * `v` is an `array` or `*array`:
        * Does the same as using `len(v)` (returns the number of elements in `v`).
    * `v` is a `chan`: 
        * Returns the channel buffer capacity, in units of elements.


```go
empty_slice := make([]any, 0, 10)
fmt.Println(cap(empty_slice)) // 10
```
* `cap(empty_slice)` returns the maximum capacity of `empty_slice`.  

```go
empty_slice = empty_slice[:cap(empty_slice)]
```


---







