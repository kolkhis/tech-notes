# Big-O

Big-O is a notation used to describe how well an algorithm performs.  

It describes the time complexity of an algorithm as the number of inputs to that
algorithm increases.  

> Definition: "Simplified analysis of an algorithm's efficiency."

## The Premise
You usually see Big-O notation as `O(n)`

* The `O` stands for `O`rder of complexity 
* The `n` stands for the `n`umber of inputs.  

As we add more inputs to the algorithm, there are two things that can potentially
grow in complexity.

- Time complexity: It may take longer to run the algorithm as more inputs are added.  
- Space complexity: It may require more space to compute the algorithm.  


## Overview
An overview of the typical Big-O notations:

- `O(1)`: Constant complexity.  
    - It will always take the same amount of time.  
    - E.g., looking up an element of an array by its index.  
- `O(log n)`: Logarithmic complexity.  
    - The complexity scales by the logarithm of the number of inputs.  
    - E.g., a binary search function over an array.  
- `O(n)`: Linear complexity. 
    - The complexity scales with a `1:1` ratio to the number of inputs.  
    - E.g., looping over the elements of an array.  
- `O(n²)`: Quadratic complexity.  
    - The complexity scales with a `1:1²` ratio to the number of inputs.  
    - This happens with nested `for` loops while looping over two separate arrays.  
- `O(2ⁿ)`: Exponential complexity.  
    - The complexity scales exponentially with the number of inputs.  


## Examples

### Example 1: Constant Complexity `O(1)`
```python
def get_first_element(arr):
    return arr[0]
```

Constant complexity has a time complexity of `O(1)` because it will always take 
the same amount of time to return the first element of an array, regardless of 
the size of the array.

Fetching a single element from an array by its index is a constant time operation.
The same can be said for fetching a single element from a hash map/dictionary.  

### Example 3: Logarithmic Complexity `O(log n)`
```python
def binary_search(arr, target):
    left, right = 0, len(arr) - 1
    while left <= right:
        mid = (left + right) // 2
        if arr[mid] == target:
            return mid
        elif arr[mid] < target:
            left = mid + 1
        else:
            right = mid - 1
    return -1
```

The binary search algorithm has a complexity of `O(log n)` (logarithmic complexity).  

Logarithmic complexity has a time complexity of `O(log n)` because with each iteration,
the search space is halved. This means that the number of operations grows logarithmically
with respect to the number of inputs.

Note that using binary search only works against **sorted data**. It requires
the numbers to be in sequence:
```python
l = [1, 2, 3, 4, 5, 6, 7] # Suitable for binary search
l = [2, 8, 3, 9, 7, 6, 5] # Not suitable for binary search
```

### Example 3: Linear Complexity `O(n)`
```python
def linear_search(arr, target):
    for i in range(len(arr)):
        if arr[i] == target:
            return i
    return -1
```

Linear search has a time complexity of `O(n)` because in the worst case, it may 
have to check every element in the array to find the target.

### Example 4: Quadratic Complexity `O(n²)`

Quadratic time complexity means the work grows roughly with the square of the
input size.  

The algorithms with this time complexity would include:
- Bubble sort
- Selection sort
- Insertion sort

Bubble sort repeatedly walks neighboring pairs and swaps them when they're in
the wrong order.  
```python
def bubble_sort(values):
    n = len(values)

    for end in range(n-1, 0, -1):
        swapped = False
        for i in range(end):
            if values[i] > values[i + 1]:
                values[i], values[i + 1] = values[i + 1], values[i]
                swapped = True
        if not swapped:
            break
    return values
```


Selection sort:
```python
def selection_sort(values):
    n = len(values)

    for i in range(n):
        smallest = i
        for j in range(i + 1, n):
            if values[j] < values[smallest]:
                smallest = j
        values[i], values[smallest] = values[smallest], values[i]

    return values
```



