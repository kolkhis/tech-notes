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
```
This is what the data structure looks like.  

The `Node` struct represents a single node in the linked list, containing a 
value and a pointer to the next node.  

The `LinkedList` struct contains a pointer to the head of the list and a size 
variable to keep track of the number of nodes in the list.

Carrying on with the previous example, there are some basic operations that
should be implemented for a linked list.  
```go
// Constructor fn that creates a new (empty) linked list
func NewLinkedList() *LinkedList {
    return &LinkedList{}
}

// Append a new node to the end of the list
func (l *LinkedList) Append(value int) {
    newNode := &Node{Value: value}

    // If this is the first node, set it as the head of the list and return
    if l.Head == nil {
        l.Head = newNode
        l.size++
        return
    }

    // Traverse the Linked List to find the last node and append the new node
    current := l.Head
    // Loop until we reach the last node (where Next is nil)
    for current.Next != nil {
        current = current.Next
    }
    current.Next = newNode
    l.size++
}

// Prepend a new node to the beginning of the list
func (l *LinkedList) Prepend(value int) {
    // Set `Next` to the current head of the list
    newNode := &Node{Value: value, Next: l.Head}

    // Set the new node as the head of the list
    l.Head = newNode
    l.size++
}

// Delete a node with a specific value from the list
func (l *LinkedList) Delete(value int) {
    // If the linked list is empty, return
    if l.Head == nil {
        return
    }

    // If the head node is the one to delete, update the head, decrement the
    // size, and return
    if l.Head.Value == value {
        l.Head = l.Head.Next
        l.size--
        return
    }

    // Traverse the list to find the node to delete
    current := l.Head
    for current.Next != nil {
        if current.Next.Value == value {
            // Bypass the node to delete it
            current.Next = current.Next.Next
            l.size--
            return
        }
        current = current.Next
    }
}

// Find a node with a specific value in the list
func (l *LinkedList) Find(value int) *Node {
    current := l.Head
    for current != nil {
        if current.Value == value {
            return current
        }
        current = current.Next
    }
    // Return `nil` if a node with the specified value wasn't found
    return nil
}

// Helper method to return the number of nodes in the list
func (l *LinkedList) Size() int {
    return l.size
}
```
A good handful of basic operations are implemented here.

- `NewLinkedList`: Constructs a new empty `LinkedList` object and returns it.
- `Append`: Adds a new node with the specified value to the end of the list.
- `Prepend`: Adds a new node with the specified value to the beginning of the list and sets itself as the Linked List's `Head`.
- `Delete`: Removes the first node with the specified value from the list.
- `Find`: Searches for a node with the specified value and returns it if found, 
  otherwise returns `nil`.
- `Size`: Returns the number of nodes in the list.

