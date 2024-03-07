
# Example Using a Channel and Goroutines


## Code

```go
package main
 
func main() {

    /***** Creating a channel and a map *****/

    /* We are creating 2 channels, one for sending and one for receiving.  */
	c, out := make(chan int), make(chan int)

    /* The map  */
	m := map[int]int{1: 2, 3: 4}


	for i, v := range m {
		go func() {
			<-c
			out <- i + v
		}()
	}
 
	close(c)
 
    /* Printing to stderr with the builtin `println` function. */
	println(<-out + <-out)
}
```


## Output

`14`

## Explanation

This Go code snippet demonstrates the use of goroutines, channels, and maps
to perform concurrent computations and communicate the results via channels.  

### Line by Line
```go
package main
```
* This line declares the package name for the current file.  
    * Every Go file belongs to a package, and `package main` is special because it 
     defines a package that can be compiled and executed.
     

```go
func main() {
```
* This line defines the `main` function, which is the entry point of a Go program.  
    * The Go runtime calls this function when the program starts.

```go
c, out := make(chan int), make(chan int)
```
* This line declares two variables, `c` and `out`, each initialized to a new channel of type `int`.  
    * The `make(chan int)` function creates a new channel for transmitting integers.  
    * Channels are a typed conduit through which you can send and receive values with the channel operator, `<-`.

```go
m := map[int]int{1: 2, 3: 4}
```
* Here, a map `m` is declared and initialized.  
    * Maps are key-value data structures, and this particular map has both keys and 
      values of type `int`.  
    * The map is initialized with two key-value pairs: `1:2` and `3:4`.


```go
for i, v := range m {
```
* This `for` loop iterates over each entry in the map `m`.  
    * The `range` keyword is used to iterate over elements in a variety of data structures.  
    * For maps, it returns two values: the key and the value of the current element.  
    * These are assigned to variables `i` (the key) and `v` (the value) for each iteration.

```go
go func() {
```
* This line starts a goroutine, which is a lightweight thread managed by the Go 
  runtime.  
    * The `go` keyword precedes the function call to run the function concurrently.  
    * The function being called is an anonymous function (a function without a name), 
      defined right there.

```go
<-c
```
* This line is a blocking receive operation on the channel `c`.  
    * The goroutine waits until it can receive a value from `c`.  
    * However, since no value is ever sent on `c` and `c` is closed before any receive 
      operation, this operation proceeds immediately without retrieving any value due to 
      the channel being closed.

```go
out <- i + v
```
* This line sends the sum of `i` and `v` into the `out` channel.  
    * `i + v` computes the sum of the key and value from the map entry being iterated 
      over in the loop.

```go
}()
```
* These characters end the anonymous function declaration and immediately invoke it.  
    * The `()` at the end calls the function right after defining it.

```go
close(c)
```
* This line closes the channel `c`.  
    * Closing a channel indicates that no more values will be sent on it.  
    * Receivers can still receive values previously sent on the channel.  
    * In this context, closing `c` allows the blocked receive operations in the 
      goroutines to proceed.

```go
println(<-out + <-out)
```
* This line receives two values from the `out` channel, adds them together, and prints the result.  
    * The `<-out` operation receives a value from `out`.  
    * Since there are two goroutines each sending a computed sum to `out`, this line adds those two sums.  
    * The order of the values received from `out` is not deterministic because goroutines run concurrently.


---

## Other Info

* Concurrency is the composition of independently executing processes, while 
  parallelism (not demonstrated here) is the simultaneous execution of (possibly 
  related) computations.

* Non-Determinism: The values read from `out` depend on the order in which goroutines 
  execute, which is non-deterministic.  
    * So, the program can produce different outputs on different runs.
* Channel Closing: Closing a channel is a signal that no more values will be sent on it.  
    * Important: Only close a channel from the sender side and to ensure no more 
      sends will happen; otherwise, the program will panic.
* Deadlock Potential: If not careful, concurrent programs can deadlock.  
    * In this case, there's no deadlock because the main goroutine waits for values from 
      `out`, and each of the spawned goroutines sends a value to `out`.  
    * However, if the logic were changed such that not enough values were sent on `out`, 
      the program would deadlock waiting on those values.


