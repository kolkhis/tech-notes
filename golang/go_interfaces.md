

# Interfaces in Golang  
Interfaces are one of the key things to learn in Go.  

https://github.com/rwxrob/awesome-go  

## Go interfaces  
What's an interface?  
* An interface in Go is a type definition that specifies a set 
  of method signatures (behavior).  
    * It doesn’t provide the implementation of these methods.  
    * Also known as a trait in other languages  
* Interfaces allow you to not "tightly couple" your code  
* They allow you to pass / create structs on interfaces.  

* Interfaces are used to achieve polymorphism in Go.  
* They allow you to write functions that can operate on any type that 
implements a certain set of methods, without needing to know  
the specifics of that type.  


## How Interfaces are Implemented  

An interface is implemented implicitly by a type.  
That means there's no need to declare that a type implements an interface.  

If the type has methods that match the interface's method set (both name and signature),
then it implements the interface.  

### Examples
```go
type Writer interface {
    Write([]byte) (int, error)
}

type ConsoleWriter struct {}

func (cw ConsoleWriter) Write(data []byte) (int, error) {
    n, err := fmt.Println(string(data))
        return n, err
}
// ConsoleWriter implicitly implements Writer
```

## Specific Use Cases for Interfaces 

* **Decoupling**: Interfaces help in writing decoupled code which enhances 
  testability and maintainability.
```go
type Logger interface {
    Log(message string)
}
type Service struct {
    logger Logger
}
// Service can use any Logger implementation
```


* **Dependency Injection**: Passing interfaces to functions allows for more 
  flexible and testable code.
```go
func process(logger Logger) {
    logger.Log("processing...")
}
```


* **Mocking in Tests**: Interfaces are extremely useful in unit testing for mocking dependencies.
```go
type MockLogger struct {}
func (m MockLogger) Log(message string) {
    // Mock logging
}
```

* **Standard Library Interfaces**: `io.Reader`, `io.Writer`, `fmt.Stringer` are some
  commonly used standard library interfaces.
```go
type MyReader struct {
    src string
        currentIndex int
}

func (mr *MyReader) Read(p []byte) (n int, err error) {
    // Implementation
}
```


* **Empty Interface**: `interface{}` can hold values of any type.
    * It's used for types unknown at compile time.
```go
func printAnything(v interface{}) {
    fmt.Println(v)
}
```

---

## Different Ways of Implementing Interfaces

* **Value Receivers**: Implement methods on value types.
```go
type MyStruct struct {
    ...
}
func (ms MyStruct) Method1() { ... }
```


* **Pointer Receivers**: Implement methods on pointer types.
```go
func (ms *MyStruct) Method2() { ... }
```


* **Combining Interfaces**: Interfaces can be composed of other interfaces.
```go
type ReadWriter interface {
    Reader
        Writer
}
```


* **Type Switches**: Interface types can be used in type switches to distinguish 
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


* **Implementing Multiple Interfaces**: A type can implement multiple interfaces.
```go
type MyType struct {}
func (mt MyType) Method1() { ... }
func (mt MyType) Method2() { ... }
// MyType implements both Interface1 and Interface2
```


* **Anonymous Interfaces**: You can declare interfaces inline for quick use,
  especially in function arguments.
```go
func foo(bar interface {
        Baz()
        }) {
    bar.Baz()
}
```



---


* let's say you are creating an application that uses a database  
    * you chose to use Postgres as your DB  
    * Design everything using Postgres and all of that 
    * BUT let's say down the line, you want to use DynamoDB instead.  
    * Using interfaces make this transition almost seamless.  

DynamoDB is a key value store:  
* you should not be doing scans on ddb  
* instead you query using the partition keys for fast retrievals 




## ChatGPT Explanation of Interfaces  

In Go, an interface is a type that defines a set of method signatures but  
does not provide the implementation of those methods.  
Interfaces are a fundamental concept in Go and are used to specify a contract  
that a concrete type must adhere to.  
They allow you to write more flexible and polymorphic code by decoupling  
the code that uses an interface from the specific types that implement that interface.  

## Some key points about interfaces in Go  

1. Method Signatures: 
    * An interface defines a list of method signatures without  
      specifying the actual code for those methods.  
    * These method signatures describe the behavior that types  
      implementing the interface must provide.  

2. Implementation: 
    * A concrete type (a struct, for example) can implement an interface  
      by providing the necessary method implementations that match the  
      method signatures defined in the interface.  

3. Implicit Implementation: 
    * Unlike some languages, Go doesn't require an explicit declaration 
      that a type implements an interface.  
    * As long as a type provides the methods required by an interface,
      it is considered to implement that interface.  

4. Polymorphism: 
    * Interfaces enable polymorphism in Go.  
    * You can write functions or methods that accept interfaces as parameters,
      making it possible to work with different types that implement the same 
      interface without knowing their concrete types.  

5. Empty Interface: 
    * In Go, the empty interface `interface{}` is an interface with no methods.  
    * It can be used to represent any type, making it a powerful tool for working  
      with values of unknown types, similar to dynamic typing in other languages.  


