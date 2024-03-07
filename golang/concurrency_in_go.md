
# Concurrency in Go
###### Tour of concurrency in the [docs](https://go.dev/tour/concurrency)

## Table of Contents
* [Goroutines](#goroutines) 
* [Channels](#channels) 
* [Buffered Channels](#buffered-channels) 


## Goroutines
A goroutine is a lightweight thread managed by the Go runtime.
```go
go f(x, y, z)
```
starts a new goroutine running
```go
f(x, y, z)
```

* The evaluation of `f`, `x`, `y`, and `z` happens in the current goroutine
* The execution of `f` happens in the new goroutine.

Goroutines run in the same address space, so access to shared memory must be 
synchronized.

The sync package provides useful primitives, although you won't need them
much in Go as there are other primitives.

```go
package main

import (
	"fmt"
	"time"
)

func say(s string) {
	for i := 0; i < 5; i++ {
		time.Sleep(100 * time.Millisecond)
		fmt.Println(s)
	}
}

func main() {
	go say("world")
	say("hello")
}
```

## Channels

Channels are a typed conduit through which you can `send` 
and `receive` values with the channel operator (`<-`).

```go
ch <- v    // Send v to channel ch.
v := <-ch  // Receive from ch, and assign value to v.
```
* The data flows in the direction of the arrow.

Like maps and slices, channels must be created before use:
```go
ch := make(chan int)
```

By default, `send`s and `receive`s block until the other side is ready.  
This allows goroutines to synchronize without explicit locks or condition variables.

### Channels with Goroutines Example
```go
package main
 
import "fmt"
 
func sum(s []int, c chan int) {
	sum := 0
	for _, v := range s {
		sum += v
	}
	c <- sum // send sum to c
}

func main() {
	s := []int{7, 2, 8, -9, 4, 0}
 
	c := make(chan int)
	go sum(s[:len(s)/2], c)  // sum up the first half of the slice
	go sum(s[len(s)/2:], c)  // sum up the second half of the slice
	x, y := <-c, <-c  // receive from c (blocking, waits for both goroutines to finish)
 
	fmt.Println(x, y, x+y)
}
```
This sums the numbers in a slice, distributing the work between two goroutines.  
Once both goroutines have completed their jobs, it calculates the final result. 

Because sends and receives are blocking, `x, y := <-c, <-c` will not return
until both goroutines have completed.  


## Buffered Channels

Channels can be buffered.  

Provide the buffer length as the second argument to `make` to 
initialize a buffered channel:

```go
ch := make(chan int, 100)
```

Sends (`ch <- v`) to a buffered channel block only when the buffer is full.  
Receives (`v <- ch`) block when the buffer is empty.

Modify the example to overfill the buffer and see what happens.





