# Built-in Functions in Go  

Go provides several built-in functions.  

The builtin functions `make()` and `cap()` are particularly useful for working  
with `slices`, `maps`, `channels`, and more.  

## Table of Contents  
* [The `make()` Built-in Function](#the-make()-built-in-function) 
    * [Syntax for `make()`](#syntax-for-make()) 
    * [Basic Usage of `make()`](#basic-usage-of-make()) 
        * [Slices](#slices) 
        * [Maps](#maps) 
        * [Channels](#channels) 
    * [Defining a Slice with a Specific Capacity](#defining-a-slice-with-a-specific-capacity) 
* [The `cap()` Built-in Function](#the-cap()-built-in-function) 
    * [Syntax for `cap()`](#syntax-for-cap()) 
    * [Usage](#usage) 
    * [Additional Tips](#additional-tips) 
    * [Practical Examples](#practical-examples) 
        * [Appending to a Slice](#appending-to-a-slice) 
        * [Reading from a Buffered Channel](#reading-from-a-buffered-channel) 

## The `make()` Built-in Function  

The `make()` function is pivotal for creating slices, maps, or channels,
providing a way to initialize these data structures.  

### Syntax for `make()`

```go  
func make(t Type, size ...IntegerType) Type  
```

* `t`: Specifies the type to create (`slice`, `map`, or `chan`).  
    * i.e., `[]int`, `map[string]int`, or `chan int`.  
* `size...`: Specifies the size and, optionally for slices, the capacity.  

```go  
make([]int, 5, 10)   // Creates a slice of `int`s with a length of `5` and a capacity of `10`.  
make(map[string]int, 10)  // Creates a map of `string`s to `int`s with a capacity of `10`.  
make(chan int, 10)  // Creates a channel of `int`s with a buffer size of `10`.  
```


### Basic Usage of `make()`

#### Slices  

```go  
// Declaring and initializing a slice in a single line:  
slice1 := make([]int, 5)  
```

This statement creates a slice of `int`s with a length and capacity of `5`.  

* Length vs. Capacity: The first integer argument after the type specifies  
  the length of the slice, and an optional second argument specifies its capacity.  
    * If the capacity argument is omitted, it defaults to the specified length.  

#### Maps  

```go  
// Creating a map to map strings to integers:  
myMap := make(map[string]int)  
```

* Maps created with `make()` have no initial entries.  
    * The size argument is optional and specifies an initial allocation size.  

#### Channels  

```go  
// Creating a channel of integers with a buffer size of 10:  
myChan := make(chan int, 10)  
```

* The optional integer argument specifies the buffer size for the channel.  

### Defining a Slice with a Specific Capacity  

```go  
emptySlice := make([]any, 0, 10)  
```

This creates a slice with a length of `0` and a capacity of `10`.  
The slice initially contains no elements but has space allocated for 10 elements, allowing for efficient `append` operations up to its capacity.  

## The `cap()` Built-in Function  

The `cap()` function returns the maximum capacity of its argument, which  
can vary based on the type of the argument.  

### Syntax for `cap()`
```go  
func cap(v Type) int  
```

### Usage  

* Slices and Arrays: Returns the maximum number of elements the slice can hold.  
* Channels: Returns the channel buffer capacity, i.e., the number of elements the  
  channel can hold.  

```go  
// Extending an `int` slice to its full capacity with zero values:  
emptyIntSlice := make([]int, 0, 10)  
fullIntSlice := emptyIntSlice[:cap(emptyIntSlice)] // Fills the slice with 10 zero values  

// Extending an `any` slice to its full capacity with nil values:  
emptySlice = make([]any, 0, 10)  
fullSlice := emptySlice[:cap(emptySlice)] // Fills the slice with 10 nil values  

```

* This pattern is used to extend a slice to its full capacity, with the zero-value of  
  the slice's type.  
    * See [Zero Values](./misc.md#zero-values) for more info.  

 
* For slices of interface types, like `any`, the elements will be `nil`.  
 
* When extended like this, slices of non-interface types (`int`, `struct{}`, etc.) will  
  be filled with the zero value of the element type, not `nil`.  


### Additional Tips  

* Initializing Maps and Channels: 
    * While `make()` is essential for slices, maps, and channels, note that  
      maps and channels can also be declared and used without `make()`, but  
      they'll be `nil` and unusable for storing data or communication until  
      `make()` initializes them.  
* Zero Values and `nil`:  
    * Understand the difference between a slice's zero value (`nil`) and an empty  
      slice (e.g., `make([]T, 0)`).  
    * The latter is a slice with allocated space but no elements.  


### Example Using a Channel  
#### Appending to a Slice  

```go  
nums := make([]int, 0, 5) // Slice of ints with capacity 5  
for i := 1; i <= 5; i++ {
    nums = append(nums, i)  
}
```

This example demonstrates initializing a slice with a specific capacity and appending elements up to that capacity, which is an efficient way to grow a slice.  

### Example Using a Channel  
#### Reading from a Buffered Channel  

```go  
messages := make(chan string, 2)  
messages <- "hello"  
messages <- "world"  

fmt.Println(<-messages) // Prints: hello  
fmt.Println(<-messages) // Prints: world  
```

This shows creating a buffered channel, sending messages without needing a concurrent receiver ready, and then receiving the messages.  

By understanding and utilizing built-in functions like `make()` and `cap()`, you can write more efficient and idiomatic Go code.  

