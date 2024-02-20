
# Arrays in Golang  
See [maps](./associative_arrays_maps.md) for associate arrays.  
Also see [slices](./slices.md) for more flexible data structures.  

## Table of Contents  
* [Arrays in Golang](#arrays-in-golang) 
* [Description of Arrays](#description-of-arrays) 
* [Basic Syntax](#basic-syntax) 
    * [Declare an Array](#declare-an-array) 
    * [Defining an Array](#defining-an-array) 
    * [Partially Defining an Array](#partially-defining-an-array) 
* [Arrays are Value Types](#arrays-are-value-types) 


## Description of Arrays  

Unlike other languages like Python, arrays in Go have a fixed size that  
is determined at declaration time (technically at compile time).  
 
Trying to assign more elements than the declared size will result in a runtime panic.  
 
To create a collection that can vary in length, use [slices](./slices.md) instead.  
Slices provide a view of an underlying array and can grow and shrink dynamically.  
Unlike arrays, slices are reference types.  


* Arrays are value types, not references.  
* Assigning an array to a new variable will copy all elements.  
* Arrays can be iterated over with the `range` keyword.  
```go  
arr := [3]int{1, 2, 3}

for idx, val := range arr {
  fmt.Println(i, v)  
}

// You can also use a C-style for-loop for this:  
for i := 0; i < len(arr); i++ {
    fmt.Println(i, arr[i])  
}
```


## Basic Syntax  
### Declare an Array  
To declare an array in Go, use the following syntax:  
```go  
var array_name [length]type  
```
If `length` is not specified, you'll be declaring a [slice](./slices.md) 
instead of an array.  

An array of `int`s:  
```go  
/* Declare an array of ints with a fixed size of 3 */  
var my_array [3]int  
```
Declaration and assignment can be done at the same time with 
the walrus operator (`:=`).  


### Defining an Array  
You can define an array in Go in the following ways:  
```go  
/* Define an array of ints with a fixed size of 3 */  
var my_array []int = [3]int{1, 2, 3}
// or  
var my_array = [3]int{1, 2, 3}
// or  
my_array := [3]int{1, 2, 3}
```


### Partially Defining an Array  
If you specify the size of the array as longer than the number of  
values you assign to it, the rest of the values will be set to the  
zero value of the type.  

E.g.,:  
```go  
vals := [6]int{4, 2, 9, 3}
 
fmt.Println("Examples of using the `iota` keyword.")  
for i := range vals {
    fmt.Printf("%d\n", vals[i])  
}
```

This will output:  
```plaintext  
4  
2
9  
3
0  
0  
```

## Arrays are Value Types  

Arrays in Go are value types, not references to a collection.  
For reference types, use [slices](./slices.md) instead.  
This means when they are assigned to a new variable, the entire array is copied.  
Changes to one array will not be reflected in the other.  

For example:  

```go  
arr1 := [3]int{1, 2, 3}
arr2 := arr1  
arr2[0] = 7  

fmt.Println(arr1) // [1 2 3] (not updated) 
fmt.Println(arr2) // [7 2 3]  
```

