
# Interfaces in Golang  

In Go, an interface is a Type. 

It defines a set of [method signatures](./method_signatures.md), but does not provide the
implementation of those methods.  
 
Interfaces are used to specify a "contract" that a concrete type must adhere to.  

They allow you to write polymorphic code by decoupling the code that
uses an interface from the specific `type`s that implement that interface.  
 
They also allow to share function names across different types.  

## Basics of Go Interfaces 

* An interface in Go is a Type definition that specifies a set 
  of method signatures (behavior).  
    * It doesn’t provide the implementation of these methods (i.e., the functions themselves).  
    * Instead, it defines a "contract" that any Type using the interface must fulfill.
    * The "contract" is fulfilled by implementing the methods described by the interface.  
* Think of an interface as a promise.  
    * A type that implements the interface promises to provide implementations of
      the methods defined by the interface.
    * If a type implements all the methods an interface requires, it 
      implicitly "satisfies" the interface.  



## Characteristics of Go Interfaces  

* Decoupling
    * Interfaces help reduce dependencies between code components, making
      your code easier to manage and test.  
 
* Polymorphism 
    * They enable you to write functions that can accept any type that 
      satisfies the interface.  


## Key Concepts and Examples  
 
### Defining and Implementing Interfaces  
Basics of how to use interfaces in Go:  


* Implicit Implementations:
    * An interface is implemented implicitly by a `type` when `type` has methods that match
      the interface's method set.  
    * That means there's no need to declare that a `type` implements an interface,
      you only need to give that `type` the correct methods.  

* You can explicitly declare that a type implements an interface once
  it "satisfies" the interface (see [example of interface satisfaction](#example-of-interface-satisfaction)).
    * Declare a new variable of the Type of the interface.
    * Initialize it with the type that implements the interface.
    * ```go
      var speaker MyInterface = MyType{}
      ```
    * This is only possible if `MyType` already implicitly satisfies
      `MyInterface` by implementing its methods.


If the type has methods that match the interface's method set,
then it implements the interface.  

Define interfaces with `type Name interface { ... }`.
```go  
package main
 
import "fmt"
 
// Define an interface
type Greeter interface {
	Greet() string
}
 
// Define a type that implicitly implements the interface
type EnglishSpeaker struct{}
 
// Method that matches the Greeter interface signature
func (EnglishSpeaker) Greet() string {
	return "Hello!"
}

// A function that takes the Greeter interface
func sayHello(g Greeter) {
	fmt.Println(g.Greet())
}
 
func main() {
	var speaker EnglishSpeaker
	sayHello(speaker) // EnglishSpeaker implicitly implements Greeter
 
    var speaker2 Greeter = EnglishSpeaker{} // Explicitly implements Greeter
    sayHello(speaker2) // EnglishSpeaker implements Greeter
	speaker.Speak()
}
```

### Example of Interface Satisfaction:

```go
// Define an interface
type Greeter interface {
    Greet() string
}
 
// Define a type
type EnglishSpeaker struct {}
 
// Implement the Greeter interface implicitly
func (EnglishSpeaker) Greet() string {
    return "Hello!"
}
 
// Demonstrate that EnglishSpeaker satisfies Greeter
var speaker Greeter = EnglishSpeaker{}
```

### Different Ways of Implementing Interfaces  

* Value Receivers
    * Methods can be implemented on Value types (the object itself).  
```go  
type MyStruct struct {
    ...  
}
func (ms MyStruct) Method1() { ... }
```

---

* Pointer Receivers
    * Methods can be implemented on Pointer Types (a pointer to the object).  
```go  
func (ms *MyStruct) Method2() { ... }
```

---

* Combining Interfaces
    * Interfaces can be composed of other interfaces.  
```go  
type ReadWriter interface {
    Reader  
    Writer  
}
```

---

* Type Switches:
    * Interface types can be used in type switches to distinguish 
      between different types at runtime.  
```go  
func doSomething(i interface{}) {
    switch v := i.(type) {
        case int:  
            fmt.Println("Int", v)  
        case string:  
                fmt.Println("String", v)  
        default:  
                    fmt.Println("Unknown Type")  
    }
}
```

---

* Implementing Multiple Interfaces
    * A type can implement multiple interfaces.  
```go  
// Define Interface1 with a single method Method1
type Interface1 interface {
    Method1()
}

// Define Interface2 with a single method Method2
type Interface2 interface {
    Method2()
}
 
// MyType struct definition
type MyType struct {}
 
// Implement Method1 for MyType, satisfying Interface1
func (mt MyType) Method1() {
    fmt.Println("Method1 called")
}

// Implement Method2 for MyType, satisfying Interface2
func (mt MyType) Method2() {
    fmt.Println("Method2 called")
}
 
func main() {
    var mt MyType

    // Declare an Interface1 variable and assign mt to it
    var i1 Interface1 = mt
    i1.Method1()
 
    // Declare an Interface2 variable and assign mt to it
    var i2 Interface2 = mt
    i2.Method2()
    // MyType implements both Interface1 and Interface2
}
```

---

* Anonymous Interfaces: You can declare interfaces inline for quick use,
  especially in function arguments.  
```go  
func foo(bar interface {
        Baz()  
        }) {
    bar.Baz()  
}
```

---

* Empty Interface
    * `interface{}` can hold values of any type.  
    * It's useful for passing types that are unknown at compile time.  
```go  
func printAnything(v interface{}) {
    fmt.Println(v)  
}
```

---

* Mocking in Tests: Interfaces are extremely useful in unit testing for mocking dependencies.  
```go  
type MockLogger struct {}
func (m MockLogger) Log(message string) {
    // Mock logging  
}
```

---

* Decoupling: Interfaces help in writing decoupled code which enhances 
  testability and maintainability.  
```go  
type Logger interface {
    Log(message string)  
}
type Service struct {
    logger Logger  
}
// Service can use any Logger implementation  
// i.e., Service.Log()
```

* Dependency Injection: Passing interfaces to functions allows for more 
  flexible and testable code.  
```go  
func process(logger Logger) {
    logger.Log("processing...")  
}
```




### Interface Composition  

* Interfaces can be "composed" of other interfaces using embedding.
    * This can help make the code more modular and organized.  
```go  
type Reader interface {
    Read(p []byte) (n int, err error)  
}
 
type Closer interface {
    Close() error  
}

// Compose interfaces  
type ReadCloser interface {
    Reader  
    Closer  
}
```


### Type Assertions and Type Switches  

* Type Assertions
    * Allow you to retrieve the concrete type of an interface variable.  
* Type Switches
    * Enable you to perform actions based on the concrete type of an interface variable.  

```go  
var i interface{} = "hello"  
 
/* Example of type assertion */
s := i.(string) // Type assertion  
fmt.Println(s)  

/* Example of type switch */
switch v := i.(type) { // Type switch  
    case string:  
        fmt.Println("String:", v)  
    case int:  
        fmt.Println("Int", v)  
    default:  
        fmt.Println("Unknown type")  
}
```


## Details about interfaces in Go  
 
1. Method Signatures: 
    * An interface defines a list of method signatures without  
      specifying the actual code for those methods.  
    * These method signatures describe the behavior that types  
      implementing the interface must provide.  

2. Implementation: 
    * A concrete type (a struct, for example) can implement an interface  
      by providing the necessary method implementations that match the  
      method signatures defined in the interface.  
    * i.e., a type defines a function for itself that matches the function
      signatures defined in the interface.  


3. Implicit Implementation: 
    * Unlike some languages, Go doesn't require an explicit declaration 
      that a type implements an interface.  
    * As long as a type provides the methods required by an interface,
      it is considered to implement that interface.  
    * E.g., the following code snippet defines a type `ConsoleWriter` that
      implements the `Writer` interface.
      ```go  
      type Writer interface {
          Write([]byte) (int, error)  
      }
       
      type ConsoleWriter struct {}
       
      // ConsoleWriter implicitly implements Writer  
      func (cw ConsoleWriter) Write(data []byte) (int, error) {
          n, err := fmt.Println(string(data))  
              return n, err  
      }
      ```


4. Polymorphism: 
    * Interfaces enable polymorphism in Go.  
    * You can write functions or methods that accept interfaces as parameters,
      making it possible to work with different types that implement the same 
      interface without knowing their concrete types.  
 
5. Empty Interface: 
    * In Go, the empty interface `interface{}` is an interface with no methods.  
    * It can be used to represent any type, making it a powerful tool for working  
      with values of unknown types, similar to dynamic typing in other languages.  





## Resources  
* The Go Programming Language Specification  
    * For detailed information on how interfaces are represented and work internally.  
* Effective Go  
    * Offers best practices and idiomatic ways to use interfaces in your Go programs.  
* Go by Example  
    * Contains hands-on examples for various Go concepts including interfaces.  


## Text-based Example  
You might have a function that creates and connects a REAL TCP socket  
You also have another function that does the same, but PRETENDS to make the connection.  

So, two behaviours, a real one, and a fake one.  

When you run unit testing, we use the fake one.  
When you run the real program, you use the real one.  

