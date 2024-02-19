

# Memory Management in C


## Core Functions for Memory Management
Functions defined in header `<stdlib.h>`:
* [`malloc`](https://en.cppreference.com/w/c/memory/malloc):
    * allocates memory
* [`calloc`](https://en.cppreference.com/w/c/memory/calloc):
    * allocates and zeroes memory
* [`realloc`](https://en.cppreference.com/w/c/memory/realloc):
    * expands previously allocated memory block
* [`free`](https://en.cppreference.com/w/c/memory/free):
    * deallocates previously allocated memory
* [`free_sized`](https://en.cppreference.com/w/c/memory/free_sized):
    * deallocates previously allocated sized memory
* [`free_aligned_sized`](https://en.cppreference.com/w/c/memory/free_aligned_sized):
    * deallocates previously allocated sized and aligned memory
* [`aligned_alloc`](https://en.cppreference.com/w/c/memory/aligned_alloc):
    * allocates aligned memory 

### Memory Allocation in C
The most basic function to allocate memory is `malloc()`
```c
void *malloc( size_t size );
```
This allocates `size` butes of uninitialized storage (memory).  
If the allocation succeeds, it returns a pointer to the allocated memory.  
* The pointer is a `void*` type, which means it can be cast to any other type.  
    * The type that you're casting it to must have [functional alignment](https://en.cppreference.com/w/c/language/object#Alignment).  

* If `size` is zero, the behavior of malloc is implementation-defined.  
    * For example, a null pointer may be returned.  
    * Alternatively, a non-null pointer may be returned; but such
      a pointer should not be dereferenced, and should be passed to `free` to avoid memory leaks.

### Alignment
Every complete object type has a property called alignment requirement

* [Obj]











---

```c
// Designated initializer
coordinate_t c1 = {.x = 1, .y = 1, .z = 1}
coordinate_t c2 = {.x = 2, .y = 2, .z = 2}
int count = 5;
```
* A designated initializer is a way to initialize a variable with multiple values.  


## Getting Memory Back in C
```c
// Designated initializer
coordinate_t c1 = {.x = 1, .y = 1, .z = 1}
coordinate_t c2 = {.x = 2, .y = 2, .z = 2}
int count = 5;

char *repeated_str = malloc(strlen(str) * count);
// Gotcha moment: This is not big enough!


char x[] = "hello";
char *repeated = repeat_string(x, count);

// THIS IS BAD. REALLY BAD.
for (int i = 0; i < 1000000; i++) {
    repeat_string(x, count)
}
// In a language with a garbage collector, this wouldn't be a problem.  

// But... How does the computer get the memory back?
//      How can we do what happens in Python?
//      In Python, we don't have to do anything explicitly to get the memory back. 


/* We need to free the memory. */
char *allocated_string = repeat_string("<This is allocated>", 3);
free(allocated_string);
// Always double check your work!
free(allocated_string);


```
