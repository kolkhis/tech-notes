
# Maps (Associative Arrays) in Go
Dictionaries in Golang.

Go has a built-in `map` type, which are associative arrays.

## Defining a Map

### Basic Map Syntax
The basic syntax for defining a map:
```go
var myMap map[key_type]value_type
```
First you call `map` to indicate that you're making a dictionary.  
Then, you declare the key and value types.
* Declare the key type inside the square brackets.
* Declare the value type after the square brackets.


`map[string]int` will create a dictionary that maps strings to integers.
* E.g., `{ "a": 1 }`

### Example Map

This is a very basic example of implementing a `map`:
```go
myMap := map[string]int{
    "key1": 1,
    "key2": 2,
}
 
fmt.Println(myMap["key1"]) // 1
fmt.Println(myMap["key2"]) // 2
```







