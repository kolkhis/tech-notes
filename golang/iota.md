
# The `iota` Keyword in Go

Iota is used to create a sequence of values.


## Basics

When the `iota` keyword is used in a constant declaration, it will
increment by 1 for each following identifier (variable).

By default, `iota` starts at 0 (zero).

E.g.,
```go
const (
    a = iota
    b
    c
)
```
This will assign `a := 0`, `b := 1`, and `c := 2`.


Iota's incrementations can be skipped using a blank identifier (an underscore `_`).

```go
const (
    a = iota
    _
    b
    c
)
```
This will output:
```go
0
2
3
```
The underscore (`_`) will make iota increment, but it will not be saved into any value.




For example, this program:
```go
package main

import "fmt"

const (
	a = iota
	b
	c
	_
	d
)

func main() {
	var vals []int = []int{a, b, c, d}
	for i := 0; i < len(vals); i++ {
		fmt.Printf("%d\n", vals[i])
	}
	fmt.Printf("End of incrementations of constants.\n")
}
```
This will output:
```plaintext
0
1
2
4
End of incrementations of constants.
```

