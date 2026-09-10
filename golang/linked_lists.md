# Linked Lists in Go

A linked list is a linear data structure where each element (node) contains a
reference (link) to the next node in the sequence. Linked lists are dynamic in
size, allowing for efficient insertion and deletion of elements.

## Types of Linked Lists

1. **Singly Linked List**: Each node contains a single link to the next node.
2. **Doubly Linked List**: Each node contains two links, one to the next node 
   and one to the previous node.
3. **Circular Linked List**: The last node points back to the first node, forming a circle.
    - Singly and Doubly Linked Lists can also be circular by having the last node 
      point back to the first node.


## Example Implementation of a Singly Linked List in Go

```go
package main
import "fmt"

type Node struct {
    Value int
    Next *Node
}

type LinkedList struct {
    Head *Node
    size int
}

// Constructor fn that creates a new (empty) linked list
func NewLinkedList() *LinkedList {
    return &LinkedList{}
}
```

