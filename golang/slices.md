

# Slices in Go
See [arrays](./arrays.md)

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

### Key Differences

| Aspect | Array | Slice 
|-|-|-
| Size  | Fixed at compile-time            | Dynamic, can grow and shrink 
| Type  | Value type (copies are separate) | Reference type  
| Initialization | Must specify size or use an array literal | Can use `make`, slice existing arrays, or use slice literals 
| Flexibility | Less flexible, size cannot change | More flexible, can use `append` and `copy` 
| Usage | Suitable for static, fixed-length collections | Suitable for dynamic collections or when size might change 








