
# Method Signatures in Go
Method signatures are used for defining [interfaces](./interfaces.md) in Go.


## Table of Contents
* [Method Signatures in Go](#method-signatures-in-go) 
* [What is a Method Signature?](#what-is-a-method-signature?) 
* [Basic Structure of an Interface](#basic-structure-of-an-interface) 
* [Different Types of Method Signatures](#different-types-of-method-signatures) 
    * [1. Basic Method](#1.-basic-method) 
    * [2. Method with Parameters](#2.-method-with-parameters) 
    * [3. Method with Multiple Parameters](#3.-method-with-multiple-parameters) 
    * [4. Method with Return Value](#4.-method-with-return-value) 
    * [5. Method with Multiple Return Values](#5.-method-with-multiple-return-values) 
    * [6. Method with Named Return Values](#6.-method-with-named-return-values) 
    * [7. Method with Variadic Parameters](#7.-method-with-variadic-parameters) 
    * [Complete Greeter Interface Example](#complete-greeter-interface-example) 
* [Generics in Interfaces](#generics-in-interfaces) 
* [Generics in Method Signatures](#generics-in-method-signatures) 
    * [Basic Generic Method](#basic-generic-method) 
    * [Method with Multiple Type Parameters](#method-with-multiple-type-parameters) 
    * [Method with Type Constraints](#method-with-type-constraints) 
* [Example of a Generic Interface](#example-of-a-generic-interface) 


## What is a Method Signature?
Method signatures (function signatures) are basically blueprints for functions
that different Types can call.  
 
A function signature specifies a function name and the type of value it returns.  

Method signatures are defined inside of [Go interfaces](./interfaces.md).

## Basic Structure of an Interface
```go
type Greeter interface {
    // Method signatures go here
}
```


## Different Types of Method Signatures

### 1. Basic Method
A simple method with no parameters and no return value.
```go
Greet()
```
* `Greet`: The method name.
* `()`: Indicates no parameters.
* No return type: After the parameters, there’s nothing, indicating this method returns nothing.



### 2. Method with Parameters
A method that accepts parameters but does not return anything.
```go
GreetByName(name string)
```
* `GreetByName`: The method name.
* `(name string)`: A single parameter named `name` of type `string`.


### 3. Method with Multiple Parameters
Methods can take multiple parameters.
```go
GreetWithLanguage(name string, language string)
```
* `(name string, language string)`: Parameters. Listed in order, separated by commas.  
    * Each parameter has a name and a type.


### 4. Method with Return Value
A method that returns a single value.
```go
GetGreeting() string
```
* `GetGreeting`: The method name.
* `()`: No parameters.
* `string`: The return type, indicating this method returns a `string`.


### 5. Method with Multiple Return Values
A method that returns multiple values, often used to return a result and an error value.
```go
FetchGreeting(name string) (greeting string, err error)
```
* `FetchGreeting`: The method name.
* `(name string)`: A single parameter.
* `(greeting string, err error)`: Two return values, a `string` and an `error`.


### 6. Method with Named Return Values
Named return values can be pre-declared in the method signature, acting
as variables defined at the top of the method.
```go
GenerateGreeting() (phrase string)
```
* Named Return Value: `phrase` is the name of the `string` return value.  
    * Named return values are automatically initialized to their type's zero
      value, and will be returned if no value is explicitly returned.


### 7. Method with Variadic Parameters
A variadic parameter allows you to pass zero or more values of a specified type.
```go
GreetEveryone(names ...string)
```
* `names ...string`: A variadic parameter of type `string`.  
    * Inside the method, `names` is treated as a slice of `string`.


### Complete Greeter Interface Example
Combining all these different method signatures, our `Greeter` interface might look like this:
```go
package main
 
type Greeter interface {
    Greet()
    GreetByName(name string)
    GreetWithLanguage(name string, language string)
    GetGreeting() string
    FetchGreeting(name string) (greeting string, err error)
    GenerateGreeting() (phrase string)
    GreetEveryone(names ...string)
}
```

---------------------------------------------------------------------------


## Generics in Interfaces
See [Generics in Go](./generics.md) for more info on generics in Go.  

Generics can be used within interfaces to define method signatures that are
parameterized over types.  


## Generics in Method Signatures
To define a method signature with generics in an interface, you specify type
parameters at the method level.  


### Basic Generic Method
A method with a single type parameter.
```go
type Greeter interface {
    Greet[T any](value T)
}
```
* `Greet[T any](value T)`:
    * A generic method named `Greet` with a type parameter `T`.
    * The `[T any]` syntax specifies that `T` can be any type.
    * The method takes a parameter `value` of type `T`.


### Method with Multiple Type Parameters
Methods can have multiple type parameters, allowing them to work with
different types independently.
```go
type Transformer interface {
    Transform[T any, R any](input T) R
}
```
* `Transform[T any, R any](input T) R`
    * This method has two type parameters, `T` and `R`, meaning it can transform
      a value of type `T` into a value of type `R`.


### Method with Type Constraints
You can constrain the type parameters to specify that they must
implement a certain interface.
```go
type Comparable interface {
    CompareTo[T comparable](other T) int
}
```
* `[T comparable]`: The `comparable` constraint is a predeclared identifier in Go that
  specifies `T` must be a type for which the operators `==` and `!=` are defined.  
    * This method compares the current object with another object of the same
      type `T` and returns an `int` indicating the comparison result.


## Example of a Generic Interface

Combining the concepts of generics and interfaces, you can define an interface
that uses type parameters to create flexible and type-safe APIs.
```go
package main
 
import "fmt"
 
type Printer interface {
    Print[T any](value T)
}

type ConsolePrinter struct{}
 
func (ConsolePrinter) Print[T any](value T) {
    fmt.Println(value)
}
 
func main() {
    cp := ConsolePrinter{}
    cp.Print("Hello, Generics!") // T is inferred to be string
    cp.Print(123)                // T is inferred to be int
}
```
In this example, the `Printer` interface defines a generic 
method `Print` that can print values of any type.  
The `ConsolePrinter` struct implements the `Printer` interface by
providing a concrete implementation of the `Print` method.



