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
- `O(1)`: Constant complexity.  
    - It will always take the same amount of time.  
    - E.g., looking up an element of an array by its index.  


