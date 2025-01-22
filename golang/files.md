
# Reading and Writing to Files in Go

## Table of Contents
* [Reading a File](#reading-a-file) 
* [Reading a file line by line with Go](#reading-a-file-line-by-line-with-go) 
* [Creating Files in Go](#creating-files-in-go) 

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


## Creating a File in Go
Use `os.Create` to create a new regular file in Go.  
```go
func main() {
    path := "/home/kolkhis/somefile.txt"
    os.Create(path)
}
```
There is no path expansion by default in Go.  

So you can't use `~` to represent `$HOME` here.  

You'll have to get the user's home directory via the `$HOME` environment variable.  
```go
func main() {
    newFilePath := os.Getenv(`HOME`)+"/.config/somefile.txt"
    os.Create(newFilePath)
}
```
* `os.Getenv(`HOME`)`: Resolves the the environment variable `HOME` for the current user.
    * e.g., `/home/kolkhis`
* `+"/.config/somefile.txt`: Concatenates the rest of the string to the `newFilePath` variable.  


### Example: Creating a New File in Go

Creating files is pretty much the same as opening existing files.  
But, instead of `os.Open()`, we can use `os.Create()`.  

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


## Creating a Directory in Go
To create a single directory, use `os.Mkdir`.
```go
func main() {
    newDirPath := os.Getenv(`HOME`)+"/.config/somedir"
    os.Mkdir(newDirPath, 0755)
    os.Mkdir(newDirPath, os.FileMode(0755))
}
```
* `newDirPath`: The path to the directory.  
    * `/home/kolkhis/.config/somedir`
* `0755`: The permission bits to set for the directory, in octal format.  
    * The constant `fs.ModePerm` is just `0777` (octal).  
    * The constant `os.ModePerm` is `511` (`0777` equivalent in decimal format).  

If you wanna create multiple directories (i.e., `mkdir -p`) use `os.MkdirAll`:
```go
func main() {
    newDirPath := os.Getenv(`HOME`)+"/.config/somedir/someotherdir"
    os.MkdirAll(path, 0755)
}
```
This will create any directories that don't exist on the way to the target directory.  

## Checking if a File Exists
Using the `os.Stat` function will allow you to check for the existence of a file,
as well as gather more information about the file if you need to.  
```go
func main() {
    filePath := "/home/kolkhis/.config/somedir"
    fileInfo, err := os.Stat(filePath)
    if err != nil {
        fmt.Println("The file does not exist.")
    } else {
        fmt.Printf("The file exists!")
    }
}
```

### Checking if a file is a directory
You can use the object returned from `os.Stat` to check if a file is
a directory by using the `.IsDir()` method.  
```go
func main() {
    filePath := "/home/kolkhis/.config/somedir"
    fileInfo, err := os.Stat(filePath)
    if err != nil {
        fmt.Println("The file does not exist.")
    } else if fileInfo.IsDir() {
        fmt.Printf("The file exists and is a directory!")
    }
}
```



## `os.NewFile()`
You can use the `os.NewFile` function to create a new `os.File` object.  
You need to provide a file descriptor when doing this.  

You could provide `1` (`stdout`) as the `fd`, and when calling `.Write()` on that
file, the contents of that file will be written to the terminal.  

