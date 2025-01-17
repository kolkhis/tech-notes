# Working with JSON in Go

Using JSON to store and retrieve data is a common practice in go.  

It's usually done by using the `encoding/json` library.  

## Marshaling

To "marshal" is to convert a data structure to another type of data.  
In this case, marshalling would be converting a Go data structure into JSON.  
You'd use `json.Marshal` or `json.MarshalIndent` to convert a struct into JSON.  



### Converting a struct to JSON
Convert a Go struct to JSON:
* You need to include the JSON keys for each item in the `struct`. 

```go
type Task struct {
	Title       string `json:"title"`
	Description string `json:"description"`
	Completed   bool   `json:"completed"`
	Id          int    `json:"id"`
}

type TaskList struct {
    Tasks []Task `json:"tasks"`
}
```
* The ``json:"title"`` strings are struct field tags.
    * These map the exact json attributes to the fields in the struct.  
* Without struct field tags, Go uses the same title cased attribute names as are 
  present in the case insensitive JSON properties.
    * e.g., the `Title` attribute in the `Task` struct will map to `title`, `Title` or
      `TiTle` JSON property



Doing this will allow you to define how you access the data from json, as well as
allow you to marshal your data into JSON.  

Then, you can define the struct and convert it into json:
```go
func main() {
    // define the data
    taskList := TaskList{
        Tasks: []Task{
            {Title: "Task1", Descritpion: "First task", Completed: false, Id: 1},
            {Title: "Task2", Descritpion: "Second task", Completed: false, Id: 2},
            {Title: "Task3", Descritpion: "Third task", Completed: false, Id: 3},
        }
    }

    // Convert the struct to JSON (Marshalling)
    jsonData, err := json.MarshalIndent(taskList, "", "    ")
}
```
* `json.MarshalIndent(taskList, "", "    ")`: Converts and formats the data into
  json.
    * The first argument is the data you want to convert into json.  
    * The second argument is a "prefix", which will be applied to the beginning
      of every line in the json data.  
    * The third argument is the indentation -- I used 4 space indenting here.  

## Unmarshaling

To "unmarshal" is to convert JSON (or another type of data) into a data structure in Go.  

The JSON encoder won't work with struct elements that aren't exported.  
They must also be mapped in the same way.  
```go
type Task struct {
	Title       string `json:"title"`
	Description string `json:"description"`
	Completed   bool   `json:"completed"`
	Id          int    `json:"id"`
}

type TaskList struct {
    Tasks []Task `json:"tasks"`
}
```


