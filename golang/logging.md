
# Logging in Golang
Logging is important.  
Logging is really important.  
Always be logging.  

## Using the `log` Package
##### Official docs [here](https://pkg.go.dev/log)
The `log` package defines the `Logger` type.  
This type has methods for formatting output.

The output functions have the same variations.
* `log.Print`: The base function.
* `log.Printf`: The format string variation.
* `log.Println`: The newline variation.  

The same goes for:
* `log.Fatal[f|ln]`
* `log.Panic[f|ln]`

---

The `Fatal` functions call `os.Exit(1)` after writing the log message.
The `Panic` functions call `panic()` after writing the log message.

## Creating a Logger

Create a new logger with `log.New`.
```go
func New(out io.Writer, prefix string, flag int) *Logger
```

## Logger Methods
### `log.SetOutput`
`SetOutput` sets the output destination for the standard logger.
It takes an `io.Writer` as an argument.  

You can also call `log.Writer` to *get* the current output destination.  


### `log.SetPrefix`
`SetPrefix` sets the output prefix for the standard logger.  
i.e., the prefix is prepended to each log message.  


### `log.Print[f|ln]`
`Print` calls `Output` to print to the standard logger.  

`Printf` and `Println` do the same. 
They handle arguments just like `fmt.Printf`/`fmt.Println`.  


### `log.Fatal`
`log.Fatal` is equivalent to `Print` followed by a call to `os.Exit(1)`.

