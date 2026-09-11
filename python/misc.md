# Miscellaneous Python Notes

## Binary Search

A binary search is a way to search for a specific value in a **sorted** array.
There's also an "over-under" technique.  


Binary searches only work on a sorted array of integers. There can be negatives
as well.  
```python
vals = [-5, -3, -2, 1, 3, 4, 5, 6]
```
As long as they're sorted in ascending order, we can apply the binary search.  

A binary search is basically just checking if a given value is in an array. 

We're going to check if the value `3` is in this array using a binary search.  
```python
target = 3
```

Implementing this requires us to take note of the index at the beginning and at
the end, or "left" and "right".

```python
vals = [-5, -3, -2, 1, 3, 4, 5, 8]
#        0   1   2  3  4  5  6  7
```
Left would be at index `0` and right would be index `7` (or `-1`).  
```python
left = 0
right = len(vals) - 1 # 7
```
Then we'd want to calculate the middle index so we can start our search.  

Calculate the middle index by doing a floor division on the number of elements 
in the array. We'll use the formula below, as that is what we need to use on
subsequent iterations of the search.  
```python
middle = (left + right) // 2
```
This will produce the number `3` (so our middle index is `3`).  

Then the value that exists at index `middle` is checked against the target.  
```python
if vals[middle] == target:
    return True
```

If that condition is `False`, then we need to check if the value at
`vals[middle]` is **larger or smaller** than the `target`.  

If it's larger, we look on the right side.  
If it's smaller, we look on the left side.  

`vals[3]` contains the value `1`. So we know the target `3` is larger than `1`.  

```python
if vals[middle] > target:
    left = middle + 1
elif vals[middle] < target:
    right = middle - 1
```

So what we do is we narrow the search space by setting the `left` to `middle + 1`.  
```python
left = middle + 1 # Left is now 4
```
This brings our search area to indices `4` through `7` (`vals[4:7]`).  
If the number was smaller, we'd instead set `right = middle - 1`.  

Then we calculate our `middle` again.  
```python
middle = (left + right) // 2 # 4 + 7 // 2 = 5
```
The middle is now `5`.  

We'd repeat this process until we eventually find the value `3` in `vals[4]`.  

---

### Different Middle Formula
The `(left + right) // 2` formula isn't the most efficient, depending on how
large the array is. You could potentially have an integer overflow depending on
the language you're working in.  

Instead of `left + right`, we can use:
```python
middle = left + (right - left) // 2
```
This formula can be used to avoid integer overflow while still producing the
same result.  



## Python HTTP Server

To spin up an http server, you can use `python3 -m http.server` to serve a 
directory over HTTP (port 80).
To specify a different port, you can use `python3 -m http.server 8080` to serve on port 8080.

## Containerizing an Application
To safely share with others, you can containerize an application.
Use `podman` or `docker` to build the image:
```Dockerfile
# Use the Python version you need
#FROM python:3.9-slim 
FROM python:3.11

# Set the working directory inside the container
WORKDIR /usr/src/app

# Copy the current directory into the container at the WORKDIR
COPY . .

# Install dependencies (expects a requirements.txt file in the current directory)
RUN pip install --no-cache-dir -r requirements.txt

# Make port 80 available to the world (for web apps)
EXPOSE 80

# Set environment variables
ENV NAME World
ENV PATH /usr/src/app

# Run the app when the container launches
RUN ["python3", "./app.py"]
```
Then build the image
```bash
podman build -t python-app .
```
and run it
```bash
podman run -p 8080:80 python-app
```

## Expanding Iterables for Function Arguments

The `*` operator can be used to expand iterables into function arguments or to
unpack elements from lists, tuples, or other iterable objects.

With dictionaries, the `**` operator can be used to unpack key-value pairs into 
function arguments.

Some examples:

```python
# Expanding a list into function arguments
numbers = [1, 2, 3]
def add(a, b, c):
    print(a + b + c)

add(*numbers) # Expands into `add(1, 2, 3)`

# Expanding a tuple into function arguments
coordinates = (4, 5)
def print_coordinates(x, y):
    print(f"Coordinates: ({x}, {y})")
print_coordinates(*coordinates) # Expands into `print_coordinates(4, 5)`

# Expanding a dictionary into function arguments
person = {'name': 'Alice', 'age': 30}
def greet(name, age):
    print(f"Hello, {name}! You are {age} years old.")

greet(**person) # Expands into `greet(name='Alice', age=30)`
```

When using a function that accepts variable-length arguments, you can
use `*args` and `**kwargs` to handle additional positional and keyword 
arguments, respectively.

```python
positional_args = (1, 2, 3)
keyword_args = {'name': 'Alice', 'age': 30}
def example_function(*args, **kwargs):
    print("Positional arguments:", args)
    print("Keyword arguments:", kwargs)

example_function(*positional_args, **keyword_args)
```





