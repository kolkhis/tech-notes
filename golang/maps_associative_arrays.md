
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


### Example Usage  

Very basic example of using a `map` inside of a struct:  
```go  
type Person struct {
	Name    string  
	Age     int  
	Sex     string  
	Details map[string]any  
}

func NewPerson(name string, age int, sex string) {
	p := Person{
		Name: name,
		Age:  age,
		Sex:  sex,
	}
	// Make a map to store the details of the person  
	p.Details = make(map[string]any)  

	// Add the keys and values to the map  
	p.Details["name"] = p.Name  
	p.Details["age"] = p.Age  
	p.Details["sex"] = p.Sex  
}
```

Make the `map` by using `make(map[key_type]value_type)` inside of the  
struct, and then add values to it.  


A different way of doing this is to create a map variable and then 
assign it to `p.Details`.  

* Note: This is probably bad practice for performance, since it's making an entirely new map.  

```go  
    details := map[string]any{
        "name": p.Name,
        "age": p.Age,
        "sex": p.Sex,
    }
    p.Details = details  
```





