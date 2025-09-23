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


### Stacks

LIFO (Last In, First Out) data structure.

* Operations: Push, Pop, Peek


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

Operations: Enqueue, Dequeue, Peek


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

---






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
