
# Function Signatures in Go
Function signatures are used for defining [interfaces](./interfaces.md) in Go.

## What is a Function Signature?
Function signatures are basically blueprints for functions that different Types can use.  
 
A function signature specifies a function name and the type of value it returns.  


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
* GreetByName: The method name.
* (name string): A single parameter named `name` of type `string`.


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
    * Named return values are automatically initialized to their zero
      values and will be returned if no value is explicitly returned.


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


