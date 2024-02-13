

# Slices in Go
See [arrays](./arrays.md).

## Table of Contents
* [Slices vs. Arrays](#slices-vs.-arrays) 
    * [Arrays](#arrays) 
    * [Slices](#slices) 
    * [When to Use Arrays](#when-to-use-arrays) 
    * [When to Use Slices](#when-to-use-slices) 
    * [Key Differences](#key-differences) 
* [Appending an Element to a Slice](#appending-an-element-to-a-slice) 
* [Slices are Reference Types](#slices-are-reference-types) 
    * [Example Highlighting a Slice's Reference Type](#example-highlighting-a-slice's-reference-type) 

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

Changes made through one slice are visible through another slice
that references the same array.

### Example Highlighting a Slice's Reference Type

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









