
# Test Cases
Go comes with its own test framework built-in.
A test program by convention is named `_test.go`.

## Table of Contents
* [Resources](#resources)
* [Key Concepts](#key-concepts)
* [Running Tests](#running-tests)
* [Automating Test Execution](#automating-test-execution)
* [Example-based Tests](#example-based-tests)
    * [File Naming](#file-naming)
    * [Package Naming](#package-naming)
    * [Writing Example Tests](#writing-example-tests)
    * [Additional Information](#additional-information)


---


## Resources:
* [Comprehensive Guide to Testing in Go](https://blog.jetbrains.com/go/2022/11/22/comprehensive-guide-to-testing-in-go/)
* [DigitalOcean Guide to Unit Testing](https://www.digitalocean.com/community/tutorials/how-to-write-unit-tests-in-go-using-go-test-and-the-testing-package)
* [Using the `testing` package to write unit tests](https://blog.alexellis.io/golang-writing-unit-tests/)


## Key Concepts

* Test Files: By convention, Go test files are named with a `_test.go` suffix.  
    * This convention helps `go test` command to easily identify and run tests.

* Testing Types:
    * Example-based tests: Demonstrates how to use the code.
        * These can be executed with `go test` and can serve as documentation.
    * Unit Tests: Focus on testing individual pieces of code in isolation from the rest.


## Running Tests
Also see [automating test execution](#automating-test-execution).

* To run tests in a Go project, you use the `go test` command.
  ```bash
  go test
  ```
    * This command will automatically find files ending 
      in `_test.go` and execute them.

* To run tests in a specific package or directory, append the package path:
  ```bash
  go test ./internal/say/
  ```

* To recursively run tests in all subdirectories:
  ```bash
  go test ./...
  ```

## Example-based tests
Example-based tests serve as documentation as well as test cases if
they include an output comment.

### File Naming

* It's common to name example test files as `examples_test.go` for general
  examples and `<name>_test.go` for more specific tests related to `<name>`.
* These will be run automatically when running `go test`.

### Package Naming

* In example test files, the package name should be appended with `_test`.
    * This ensures it's executed as an external test, which can help test the exported API
      from a user's perspective.

```bash
package say_test
```


### Writing Example Tests
 
* Example test functions should be named `Example<FunctionName>` and can
  include expected output in a comment.

```go
package say_test
  
import (
    "fmt"
    "say"
)
 
func ExampleSayHello() {
    fmt.Println(say.Hello("Rob Muhlestein"))
    // Output: Hello, Rob Muhlestein
}
```

The example test functions **MUST** contain the expected output
in a comment, in the format:
```go
// Output:
// Expected output here
```
Adding an extra `/` to the `// Output:` will *force* the test to pass, but it
will still go into the documentation.

---


### Automating Test Execution

* Using `entr` to automatically run tests upon file changes:
```bash
entr bash -c "clear; go test -v ./..." < <(find . -name '*.go')
```

* With `globstar` enabled (in bash: `shopt -s globstar` or `set -o globstar`):
```bash
entr bash -c "clear; go test -v ./..." < <(ls **/*.go)
```



## Additional Information

* Documentation: Go's example tests are not only for testing, but
  also serve as live documentation.  
    * Running `godoc -http=:6060` and navigating to your package will show
      these examples in the documentation.
* Test Coverage: You can check the test coverage of your package.
    * Using `go test -cover` or `go test -coverprofile=coverage.out`, followed
      by `go tool cover -html=coverage.out`, you can view a detailed HTML report.




