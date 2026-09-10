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

## Example Using `any` Type

Using `any` allows for arbitrary types in the `Value` field.  

However, when using `any`, the `Value` node must hold a single type for the entire linked list.  
For example, if you create a linked list of `int`, all nodes must hold `int` values.  
If you create a linked list of `string`, all nodes must hold `string` values.

This is useful when several Linked Lists are needed for different types (e.g., one Linked
List for `int`s and one for `string`s).  

```go
package main
import "fmt"

// Node[T any] means Node is generic over a type T, and T can be any type
type Node[T any] struct {
    Value T
    Next  *Node[T]
}

// LinkedList is also generic over the same type T
type LinkedList[T any] struct {
    Head *Node[T]
    size int
}
```

Then the `Append`, `Prepend`, `Delete`, and `Find` methods would also be updated to use the generic type `T` instead of `int`.
```go
// NewLinkedList[T] creates and empty list for a specific type (T).  
// The [T any] here declares the type parameter for this function.  
func NewLinkedList[T any]() *LinkedList[T] {
    return &LinkedList[T]{}
}

// Methods use the receiver's type parameter, no need to redeclare [T any]
func (l *LinkedList[T]) Append(value T) {
	newNode := &Node[T]{Value: value}

	if l.Head == nil {
		l.Head = newNode
		l.size++
		return
	}

	current := l.Head
	for current.Next != nil {
		current = current.Next
	}
	current.Next = newNode
	l.size++
}

func (l *LinkedList[T]) Prepend(value T) {
	newNode := &Node[T]{Value: value, Next: l.Head}
	l.Head = newNode
	l.size++
}

// Delete needs a way to compare values. "comparable" is required here,
// not "any" — see note below.
func (l *LinkedList[T]) Delete(value T) bool {
	if l.Head == nil {
		return false
	}

	if any(l.Head.Value) == any(value) {
		l.Head = l.Head.Next
		l.size--
		return true
	}

	current := l.Head
	for current.Next != nil {
		if any(current.Next.Value) == any(value) {
			current.Next = current.Next.Next
			l.size--
			return true
		}
		current = current.Next
	}
	return false
}

func (l *LinkedList[T]) Size() int {
	return l.size
}

func (l *LinkedList[T]) String() string {
	result := ""
	current := l.Head
	for current != nil {
		result += fmt.Sprintf("%v -> ", current.Value)
		current = current.Next
	}
	result += "nil"
	return result
}

```

Then they can be put to use.  
```go
func main() {
    // Explicit type argument is needed when creating the LL when using generics
    intList := NewLinkedList[int]()
    intList.Append(1)
    intList.Append(2)
    intList.Append(3)
    fmt.Println("Int list:", intList)

    // Lists of strings work the same way
    strList := NewLinkedList[string]()
    strList.Append("Hello")
    strList.Append("world")
    fmt.Println("String list: ", strList)

    // Custom structs can also be used
    type Coordinates struct{ x, y int}
    coordList := NewLinkedList[Coordinates]()
    coordList.Append(Coordinates{1, 2})
    coordList.Append(Coordinates{3, 4})
    fmt.Println("Coordinate list: ", coordList)
}
```

