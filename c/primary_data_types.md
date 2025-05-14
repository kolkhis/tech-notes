# Primary Data Types in C

The choice of data type in C significantly impacts both performance and memory usage.  
For example, using types that match the system's word size (e.g., `int` on
a 32-bit system) can enhance performance due to alignment with the CPU architecture.

Choosing the smallest data type that can hold the required range of
values, such as `uint8_t` for small ranges, can reduce memory usage.

Developers might optimize memory by carefully selecting appropriate
types, using `enum` and bit fields in `struct`s for compact storage,
and leveraging pointers and dynamic allocation to manage memory efficiently


### NOTE: The use of the `_t` suffix is not POSIX-compliant
The `_t` suffix is reserved by POSIX. 

So, if you create a typedef in your program with `_t`, it may end 
up conflicting with a `typedef` in a header in the future

You can zero initialise a struct with an empty `{}` as of C23.  


## Table of Contents

- [Type Qualifiers](#type-qualifiers)
- [Size and Range](#size-and-range)
- [Standard Types in C](#standard-types-in-c)
    - [Standard Integer Types](#standard-integer-types)
        - [Signed](#signed)
        - [Unsigned](#unsigned)
    - [Standard Floating-Point Types](#standard-floating-point-types)
    - [Character Type](#character-type)
    - [`Bool` Type](#bool-type)
    - [Void Type](#void-type)
- [Floats vs Doubles](#floats-vs-doubles)
- [Precise Types](#precise-types)
- [Derived Data Types](#derived-data-types)
- [Typedef](#typedef)
- [Fixed-Width Integer Types](#fixed-width-integer-types)
    - [Usage](#usage)
    - [Signed Fixed-Width Integer Types](#signed-fixed-width-integer-types)
    - [Unsigned Fixed-Width Integer Types](#unsigned-fixed-width-integer-types)
    - [Minimum-Width Integer Types](#minimum-width-integer-types)
    - [Fastest Minimum-Width Integer Types](#fastest-minimum-width-integer-types)
    - [Pointer-Sized Integer Types](#pointer-sized-integer-types)
    - [Maximum-Width Integer Types](#maximum-width-integer-types)
    - [Best Practices for Fixed-Width Integer Types](#best-practices-for-fixed-width-integer-types)

## Type Qualifiers

- `const`: Specifies that a variable's value cannot be modified.
- `volatile`: Tells the compiler that a variable can be changed in ways
  not explicitly specified by the program.
- `register`: Hints to the compiler that a variable should be stored
  in a CPU register for faster access.
- `restrict`: A pointer qualifier introduced in C99, indicating that the pointer
  is the only means by which the program will access the object it points to.

## Size and Range

The exact size and range of data types can vary based on the compiler and
the architecture (32-bit vs. 64-bit systems).

Use the `sizeof` operator to find the size of a type, and include `<limits.h>`
and `<float.h>` to get constants defining the limits of the types.

## Standard Types in C

### Standard Integer Types

The standard C integer types have two versions:

1. Signed: Can represent both positive and negative numbers.
2. Unsigned: Can only represent positive numbers. Doubles max value.

#### Signed:

1.  `int`:

    - Typical Size: 4 bytes (32 bits)
    - Range: -2,147,483,648 to 2,147,483,647

2.  `short int` (`short`):

    - Typical Size: 2 bytes (16 bits)
    - Range: -32,768 to 32,767

3.  `long int` (`long`):

    - Typical Size: 8 bytes (64 bits) on 64-bit systems
    - Range: -9,223,372,036,854,775,808 to 9,223,372,036,854,775,807

4.  `long long int` (`long long`):

    - Typical Size: 8 bytes (64 bits)
    - Range: -9,223,372,036,854,775,808 to 9,223,372,036,854,775,807

#### Unsigned:

1.  `unsigned int`:

    - Typical Size: 4 bytes (32 bits)
    - Range: 0 to 4,294,967,295

2.  `unsigned short`:

    - Typical Size: 2 bytes (16 bits)
    - Range: 0 to 65,535

3.  `unsigned long`:

    - Typical Size: 8 bytes (64 bits) on 64-bit systems
    - Range: 0 to 18,446,744,073,709,551,615

4.  `unsigned long long`:
    - Typical Size: 8 bytes (64 bits)
    - Range: 0 to 18,446,744,073,709,551,615

### Standard Floating-Point Types:

1.  `float`:

    - Size: 4 bytes (32 bits)
    - Precision: Typically provides ~7 decimal digits of precision.
    - Range: Approximately ±3.4E±38 (IEEE 754 standard for single precision).

2.  `double`:

    - Size: 8 bytes (64 bits)
    - Precision: Typically provides ~15 decimal digits of precision.
    - Range: Approximately ±1.7E±308 (IEEE 754 standard for double precision).

3.  `long double`:
    - Size and Precision: Vary by system; usually at least as long
      as `double`, potentially 12, 16 bytes or more.
    - Range and Precision: Greater than `double`, specifics depend on the
      compiler and architecture.
    - It may provide up to ~19 to 34 decimal digits of precision, with
      a correspondingly wider range than `double`.

### Character Type:

1.  `char`:
    - Size: 1 byte (8 bits).
    - Range (Signed): -128 to 127.
    - Range (Unsigned): 0 to 255.
    - The signedness of `char` is implementation-defined; it can either be signed or unsigned by default.
    - `unsigned char`: Explicitly defines a character type that can
      only hold non-negative values (0 to 255).

### `Bool` Type:

- `bool`:
    - Introduced in the C99 standard.
    - Size: Implementation-defined, often 1 byte.
    - Values: `true` (1) and `false` (0).
    - To use `bool`, `#include <stdbool.h>` is required, which defines `bool` as  
      a macro expanding to `_Bool`, a built-in type introduced in C99.

### Void Type:

`void`: Represents the absence of type.  
Used for functions that do not return a value or as a generic pointer `void*`.

- `void`:
    - Does not represent any data type and thus does not have a size.
    - Usage:
        - As the return type of functions that do not return a value.
        - As a generic pointer type (`void*`), which can point to any data type, but  
          cannot be dereferenced without casting to another type first.

## Floats vs Doubles

Floats and Doubles both store floating point values.  
Floats have a size of 4 bytes (or 32 bits).  
Doubles have a size of 8 bytes (or 64 bits).

| Floats                                     | Doubles                                     |
| ------------------------------------------ | ------------------------------------------- |
| 4 bytes (32 bits)                          | 8 bytes (64 bits)                           |
| 7 decimal digit precision                  | 15 decimal digit precision                  |
| possible precision errors with big numbers | won't get precision errors with big numbers |
| Format specifier `%f`                      | Format specifier `%lf`                      |


## Precise Types

These types follow a naming convention that clearly indicates their size
and whether they are signed or unsigned.

This is not in the traditional C types (`int`, `short`, `long`), where the size can
vary, depending on the compiler and system architecture.

The syntax is different from traditional C types because these are
typedefs (type definitions) provided in the `<stdint.h>` header
file, specifying exact widths.

## Derived Data Types

1. Pointers:

    - Used to store memory addresses.
    - Their type is defined by the type of data they point to, e.g., `int*` for a pointer to an integer.

2. Arrays:

    - A collection of elements of the same type, stored contiguously in
      memory.
    - E.g., `int arr[10];` for an array of 10 integers.

3. Structs (`struct`):

    - A composite data type that groups variables of different types under a single name, e.g., structuring a student record with name, id, and GPA.

4. Unions (`union`):

    - Similar to structures, but members share the same memory location, useful
      for storing data that could be of multiple types.

5. Enumerations (`enum`):
    - Defines a type that can have one of a few predefined constants, improving
      code readability and maintainability.

## Typedef

Declaring a type alias and/or custom struct type is done with the `typedef` keyword.  
Example of a custom struct type:

```c
typedef struct this_is_optional {
    int num_needed;
    char **needed;
    // Or:
    /* int *needed[]; */
 
    int spent;
} grocery_list_t;
```

Syntax broken down:

- `typedef struct this_is_optional`:
    - This declares a struct type.
    - The `this_is_optional` is the name of the struct type.
        - This is optional, the actual name goes at the end of the block.
    - The struct members are defined inside the braces `{ }`.
    - After the closing brace, we can define the name of the struct type.
        - In this case, `grocery_list_t`.
        - The `_t` is a naming convention for custom types.

## Fixed-Width Integer Types

These types allow for declaring integers of a specific size (width).

These types are useful anywhere that the precise size of an integer is critical for  
the program, like embedded systems programming or cross-platform development.

### Usage

To use these types, include the `stdint.h` header file at the  
beginning of your source file:

```c
#include <stdint.h>
/* or, in C++ */
#include <cstdint> // C++ only.
```

Most of the time, we'll use the `int32_t` type.

To use the unsigned variant of one of these types,
just prepend `u` to the type name (e.g., `uint32_t`).

The `_t` syntax is a naming convention for types made with `typedef`.

### Signed Fixed-Width Integer Types

- **`int8_t`, `int16_t`, `int32_t`, `int64_t`**:
    - These types represent signed integers of 8, 16, 32, and 64 bits, respectively.
    - **Ranges**:
        - `int8_t`: -128 to 127
        - `int16_t`: -32,768 to 32,767
        - `int32_t`: -2,147,483,648 to 2,147,483,647
        - `int64_t`: -9,223,372,036,854,775,808 to 9,223,372,036,854,775,807

### Unsigned Fixed-Width Integer Types

- **`uint8_t`, `uint16_t`, `uint32_t`, `uint64_t`**:
    - These types represent unsigned integers of 8, 16, 32, and 64 bits, respectively.
    - **Ranges**:
        - `uint8_t`: 0 to 255
        - `uint16_t`: 0 to 65,535
        - `uint32_t`: 0 to 4,294,967,295
        - `uint64_t`: 0 to 18,446,744,073,709,551,615

### Minimum-Width Integer Types

These are the smallest types that have **at least** the specified bit width.

- Minimum-width types (`int_least*` and `uint_least*`):
    - Offer at least the specified bit width, potentially more, depending  
      on what's most efficient for the platform.
    - Useful for saving memory while ensuring a minimum capacity for data representation.

### Fastest Minimum-Width Integer Types

These are the fastest types with **at least** the specified bit width.

- Fastest minimum-width types (`int_fast*` and `uint_fast*`):
    - These prioritize speed over exact size, providing the fastest type  
      with at least the specified width.
    - Ideal for performance-critical applications where operation speed is more  
      important than minimizing data size.

### Pointer-Sized Integer Types

These are signed and unsigned integer types capable of storing a pointer.

- `intptr_t` and `uintptr_t`:
    - Capable of storing a pointer, thus aligning with the machine's address width.
    - Essential for scenarios requiring the manipulation or arithmetic of pointers  
      and integers interchangeably.
    - Useful for integer-pointer conversions without loss of information.

### Maximum-Width Integer Types

These are the **largest** signed and unsigned integers supported.

- `intmax_t` and `uintmax_t`:
    - Represent the largest signed and unsigned integers supported by the implementation.
    - Useful for operations that need to accommodate the widest range of integer values possible.

### Best Practices for Fixed-Width Integer Types

- General-purpose programming
    - Continue using Standard C types (`int`, `unsigned int`, etc.) when the  
      exact size is not **critical**.
    - These are suitable for most purposes and are optimized for native architecture speed.
- Predictable, exact-size integers
    - Fixed-width types should be used when precise control over integer size  
      and consistent behavior across platforms are necessary.
