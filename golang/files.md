
# Reading and Writing to Files in Go

## Reading a File
The standard way to read from a file is with the `os.Open` function.
```go
filepath := "./input.txt"
file, err := os.Open(filepath)
if err != nil {
    log.Fatal("os.Open(): Problem opening file: ", err)
}
defer file.Close()
```
It returns a `*os.File` object (a pointer to the `os.File` object),
or an error if there was an error.  

The `defer file.Close()` statement will run `file.Close()` at the end of
the function that it's put in.  
E.g., if you put that code in `func main()`, it will run `file.Close()` at the end
of the `main` function.  

## Reading a file line by line with Go
In order to read the contents of the `*os.File`, you need to make a `NewScanner` object from
the `bufio` package, which is part of the Go stdlib.  

```go
package main
import (
	"fmt"
	"log"
	"os"
    "bufio"
)

func main() {
    var filename := "input.txt"
    file, err := os.Open(filename)  // Opens the file as *os.File object
    if err != nil {
        log.Fatal("Problem opening file: ", err)
    }
    defer file.Close()  // Does not close the file yet
    fmt.Println(file)   // Print the memory address of the os.File object   

    scanner := bufio.NewScanner(file)  // Needed to read the file
    // Read the file line by line
    for scanner.Scan() {
        fmt.Prinln(scanner.Text())
    }

    // Check for scanner errors
    if err := scanner.Err(); err != nil {
        log.Fatal("Error with the scanner: ", err)
    }
    // End of the function, now file.Close() will run.
}
```

This reads the file `input.txt` line by line.  
1. Open the file `file, err := os.Open(filename)`
1. Check for errors and call [`defer file.Close()`](https://www.digitalocean.com/community/tutorials/understanding-defer-in-go)
1. Make a new scanner object from the file 
    * [`scanner := bufio.NewScanner(file)`](https://pkg.go.dev/bufio#Scanner)
1.  Iterate over the lines of the file.
    * Call [`scanner.Scan()`](https://pkg.go.dev/bufio#Scanner.Scan) to iterate over the lines.
    * ```go
      for scanner.Scan() { 
          fmt.Println(scanner.Text())
      }
      ```
1. Check for scanner errors 
    * ```go
        if err := scanner.Err(); err != nil {
            log.Fatal("Scanner error: ", err)
        }
      ```
1. At the end of the function, `file.Close()` will be called.


## Creating Files in Go

Creating files is pretty much the same as opening existing files.  
But, instead of `os.Open()`, we use `os.Create()`.  

```go
package main

import (
	"io"
	"log"
	"os"
)

func main() {
	if err := write("readme.txt", "This is a readme file"); err != nil {
		log.Fatal("failed to write file:", err)
	}
}

func write(fileName string, text string) error {
	file, err := os.Create(fileName)
	if err != nil {
		return err
	}
	defer file.Close()
	_, err = io.WriteString(file, text)
	if err != nil {
		return err
	}

	return file.Close()
}
```




