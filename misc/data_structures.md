# Introduction to Data Structures

## Introduction

Data structures are a way of organizing and storing data for efficient access and modification.  
They define the relationship between the data, and the operations that can be performed on the data.  
They are crucial for writing efficient algorithms and are a common topic in technical interviews.  

Proper data structures can make your code run faster and consume less memory.
They help in organizing your code in a cleaner and more modular way.

Knowing the right data structure to use can often lead to more efficient solutions to problems.
They are a common topic in coding interviews.

## Types of Data Structures

Data structures can be broadly classified into:

1. **Linear Data Structures**
    * Arrays
    * Linked Lists
    * Stacks
    * Queues

2. **Non-Linear Data Structures**
    * Trees
    * Graphs

3. **Hash-based Data Structures**
    * Hash Tables

4. **Other Data Structures**
    * Heaps
    * Disjoint Set
    * Trie

---


## Linear Data Structures

### Arrays

Contiguous block of memory containing elements of the same type.

Operations: Access, Insert, Delete, Search

```python
# Initialization
arr = [1, 2, 3, 4]

# Access
print(arr[0])  # Output: 1

# Insert
arr.append(5)  # [1, 2, 3, 4, 5]

# Delete
arr.pop()  # [1, 2, 3, 4]

# Search
print(2 in arr)  # Output: True
```


### Linked Lists

Collection of nodes, where each node contains a value and a reference to the next node.

Operations: Access, Insert, Delete

#### Types of Linked Lists

There are a few types of linked lists.
- Singly Linked Lists
- Doubly Linked Lists
- Circular Linked Lists (these can also be singly/doubly linked lists).  

A singly linked list is a collection of nodes with each node containing a value
and a reference to the next node.  

There are also doubly linked lists, in which each node contains two references.
One to the next node, ***and*** one to the previous node.  

Then there are circular linked lists. Both singly linked lists and doubly
linked lists can be circular.  

What makes a linked list circular is that the `Tail` node (last node) will 
contain a reference to the `Head` node (first node) in the list, rather than
just having a `null` value in the "next node" reference.  

In a circular doubly linked list, the `Head` node will also contain a reference
to the `Tail` node. 

#### Python Example of Linked List

Python doesn't support pointers/references, but this is the basic structure of it.  
```python
class Node:
    def __init__(self, data):
        self.data = data
        self.next = None

# Initialize
head = Node(1)
head.next = Node(2)  # Python doesn't have 'references', so here it is just an object (next node).

# Access
print(head.data)  # Output: 1

# Insert
new_node = Node(3)
new_node.next = head.next
head.next = new_node

# Delete
head.next = head.next.next
```

#### Go Example of Linked List

An example using Go, which *is* a language that supports references.  
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

This could also be combined with Go generics to allow linked lists of any type
to be created without rewriting it for a different type. That's a different
topic altogether, though.  

### Stacks

LIFO (Last In, First Out) data structure.

Like a stack of plates, the last one put on the stack is the first one that is 
taken off.  

- Operations: Push, Pop, Peek

Python lists are a good example of a stack, as they allow you to add and remove 
elements from the end of the list, and their `pop()` function takes the last
item added off the stack.  
```python
stack = []

# Push
stack.append(1)

# Pop
stack.pop()

# Peek
print(stack[-1])
```


### Queues

FIFO (First In, First Out) data structure.

Like people waiting in line, the first ones in line are the first ones to leave.  

- Operations: Enqueue, Dequeue, Peek

```python
from collections import deque

queue = deque()

# Enqueue
queue.append(1)

# Dequeue
queue.popleft()

# Peek
print(queue[0])
```

Queues are commonly used for job processing, message queues, web server
requests, print queues, breadth-first search, and task schedulers.  

---


#### Stacks vs. Queues

Stacks are LIFO (Last In, First Out).   
Queues are FIFO (First In, First Out).  

- Given the following values:
  ```python
  v = ["a", "b", "c"]
  ```
    - A stack will remove `"c"`, `"b"`, `"a"` (in that order)
    - A queue will remove `"a"`, `"b"`, `"c"` (in that order)




## Non-Linear Data Structures

### Trees
Hierarchical data structure with a root element and children.

Types: Binary Trees, Binary Search Trees, AVL Trees, etc.

Operations: Insert, Delete, Search, Traversal

```python
class TreeNode:
    def __init__(self, value):
        self.value = value
        self.left = None
        self.right = None

# Initialize
root = TreeNode(1)
root.left = TreeNode(2)
root.right = TreeNode(3)
```

#### Binary Search Trees

* **Basic Structure**:
  A binary search tree will branch values based on the values.  
  ```
                   (10)
                  /    \
                 /      \
              (8)        (14)
              / \        /  \
             /   \     (11)  (17)
            (5)  (9)
           /  \
          (4) (7)
  ```
  The right branch will always be a value larger than the one it is attached to.  
  The left branch will always be a value smaller than the one it is attached to.  
  How it handles deletions:
  
- If an element is deleted, it will be replaced by the next-highest 
  value element from its children.  

- So, it will look down to the left side and then right.  
- If `(8)` is deleted, it will look down to `(5)`, and find the 
  highest value of its children. In this case `(7)`.  




### Graphs

Set of nodes connected by edges.
Types: Directed, Undirected, Weighted, Unweighted
Operations: Add Node, Add Edge, Search

```python
graph = {'A': ['B', 'C'], 'B': ['A', 'D'], 'C': ['A'], 'D': ['B']}

# Add Node
graph['E'] = []

# Add Edge
graph['A'].append('E')
```





### Hash-based Data Structures
### Hash Tables

* **What**: Key-value pairs stored in an array-like structure.
* **Operations**: Insert, Delete, Search
* **Python Example**:
```python
# Initialize
hash_table = {}

# Insert
hash_table['key'] = 'value'

# Delete
del hash_table['key']

# Search
print('key' in hash_table)
```




## Other Data Structures
### Heaps

Specialized tree-based data structure.

Types: Min-Heap, Max-Heap

Operations: Insert, Delete, Peek

```python
import heapq

# Initialize
heap = []

# Insert
heapq.heappush(heap, 1)

# Delete
heapq.heappop(heap)

# Peek
print(heap[0])
```


### Disjoint Set

Data structure to keep track of a set divided into disjoint subsets.

Operations: Union, Find


### Trie

What: Tree-like data structure that stores a dynamic set of strings.
Operations: Insert, Delete, Search



## tl;dr: 
Non-linear data structures include Trees and Graphs.  
Hash-based structures like Hash Tables are key-value stores.  
Other types include Heaps, Disjoint Sets, and Tries.  
Each has its own set of operations and Python examples.  
