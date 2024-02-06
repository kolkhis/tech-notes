# Primary Data Types in C

The choice of data type in C significantly impacts both performance and memory usage.  
For example, using types that match the system's word size (e.g., `int` on
a 32-bit system) can enhance performance due to alignment with the CPU architecture.  

Choosing the smallest data type that can hold the required range of 
values, such as `uint8_t` for small ranges, can reduce memory usage.  

Developers might optimize memory by carefully selecting appropriate 
types, using `enum` and bit fields in `struct`s for compact storage,
and leveraging pointers and dynamic allocation to manage memory efficiently



## Main Types

Signed: Can represent both positive and negative numbers.
Unsigned: Can only represent positive numbers. Doubles max values.

1. Integer Types:
    * `int`: The most common type for representing whole numbers.
        * Size can vary based on the system but is often 4 bytes (32 bits) on modern systems.
    * `short int` (or `short`): A smaller integer type, typically 2 bytes.
    * `long int` (or `long`): A larger integer type, typically at least 4 bytes, but
      often 8 bytes on 64-bit systems.
    * `long long int` (or `long long`): An even larger integer type guaranteed to be at least 8 bytes.
    * `unsigned int`, `unsigned short`, `unsigned long`, `unsigned long long`:
        * Unsigned versions of integer types, meaning they can only represent non-negative
          numbers, doubling their maximum value.


2. Floating-Point Types:
    * `float`: Single precision floating-point type. Typically 4 bytes.
    * `double`: Double precision floating-point type. Typically 8 bytes.
    * `long double`: Extended precision floating-point type. 
        * Size and precision vary but are usually at least as long as `double`.

3. Character Type:
    * `char`: Represents single characters, such as 'A' or '3'.
        * It's typically 1 byte and can be signed or unsigned depending on the system.
        * There's also an `unsigned char` explicitly defined.

4. `Bool` Type:
    * Introduced in C99. Requires `#include <stdbool.h>` and defines `bool` as a macro expanding to `_Bool`. Represents boolean values: `true` and `false`.

5. Void Type:
    * `void`: Represents the absence of type. Used for functions that do not return a value or as a generic pointer `void*`.


## Precise Types

These types follow a naming convention that clearly indicates their size
and whether they are signed or unsigned.

This is not in the traditional C types (`int`, `short`, `long`), where the size can
vary, depending on the compiler and system architecture.

The syntax is different from traditional C types because these are 
typedefs (type definitions) provided in the `<stdint.h>` header 
file, specifying exact widths.


## Fixed-Width Integer Types
Note: Requires `<stdint.h>`.  

Here's a list of fixed-width integer types defined in `<stdint.h>`:

* Signed Integers:
    * `int8_t`: 8-bit signed integer.
    * `int16_t`: 16-bit signed integer.
    * `int32_t`: 32-bit signed integer.
    * `int64_t`: 64-bit signed integer.

* Unsigned Integers:
    * `uint8_t`: 8-bit unsigned integer.
    * `uint16_t`: 16-bit unsigned integer.
    * `uint32_t`: 32-bit unsigned integer.
    * `uint64_t`: 64-bit unsigned integer.

By using these types, you make it clear how much memory each variable should occupy, which is crucial for applications where memory layout is important, like embedded systems or when interfacing with hardware.

## Derived Data Types

1. Pointers:
    * Used to store memory addresses. Their type is defined by the type of data they point to, e.g., `int*` for a pointer to an integer.

2. Arrays:
    * A collection of elements of the same type, stored contiguously in memory, e.g., `int arr[10];` for an array of 10 integers.

3. Structures (`struct`):
    * A composite data type that groups variables of different types under a single name, e.g., structuring a student record with name, id, and GPA.

4. Unions (`union`):
    * Similar to structures, but members share the same memory location, useful for storing data that could be of multiple types.

5. Enumerations (`enum`):
    * Defines a type that can have one of a few predefined constants, improving code readability and maintainability.

## Type Qualifiers

* `const`: Specifies that a variable's value cannot be modified.
* `volatile`: Tells the compiler that a variable can be changed in ways
  not explicitly specified by the program.
* `register`: Hints to the compiler that a variable should be stored 
  in a CPU register for faster access.
* `restrict`: A pointer qualifier introduced in C99, indicating that the pointer
  is the only means by which the program will access the object it points to.

## Size and Range

The exact size and range of data types can vary based on the compiler and 
the architecture (32-bit vs. 64-bit systems).  

Use the `sizeof` operator to find the size of a type, and include `<limits.h>` 
and `<float.h>` to get constants defining the limits of the types.


### Best Practices

* Choose the appropriate type based on the data you need to store, considering both the range of values and the memory usage.
* Be cautious with type conversions and casting, especially between signed and unsigned types or between integer and floating-point types.
