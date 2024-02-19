
# C Language Notes

Other C notes:
* [Types](./types.md)
* [memory management](memory_management.md)
* [pointers](pointers.md)
* [primary data types](primary_data_types.md)
* [stdint.h types](stdint.h_types.md)
* [types](types.md)


## Table of Contents
* [C Language Notes](#c-language-notes) 
* [The `main()` Function](#the-main()-function) 
* [Scoping](#scoping) 
* [Typedef](#typedef) 
* [Imports](#imports) 
* [Printf Format Specifiers](#printf-format-specifiers) 
* [Floats vs Doubles](#floats-vs-doubles) 
* [Loops in C](#loops-in-c) 
* [Compiling a C Program](#compiling-a-c-program) 


## The `main()` Function
The `main()` function is the entry point of a C program.

```c
int main(int argc, char **argv);
```
* `int argc`: The number of command line arguments.
* `int **argv`: The command line arguments as an array of strings.


## Scoping
* `->`: Member access operator.
    * This is used for accessing members of a pointer.
* `.`: Member access operator.
    * This is used for accessing members of a struct.

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
    /* int budget; */
} grocery_list_t;
```
Syntax broken down:
* `typedef struct this_is_optional`:
    * This declares a struct type.
    * The `this_is_optional` is the name of the struct type.
        * This is optional, the actual name goes at the end of the block.
    * The struct members are defined inside the braces `{ }`.
    * After the closing brace, we can define the name of the struct type.
        * In this case, `grocery_list_t`.
        * The `_t` is a naming convention for custom types.  


## Imports
Instead of `#include <iostream>` (C++), we can use `#include <stdio.h>` (C).  

* `stdio.h` is the library for IO (input/output).
* `stdlib.h` is the library for memory (dynamic memory allocation).  
* `string.h` is the library that contains string functions.
* `assert.h` is the library that contains the `assert()` function.


---

## Printf Format Specifiers

For C programming:
v_gF -> (man://printf(3))

| Control Sequence | Produces              |
|------------------|-----------------------|
|       `\n`       |    newline            |
|       `\l`       |    line-feed          |
|       `\r`       |    return             |
|       `\t`       |    tab                |
|       `\b`       |    backspace          |
|       `\f`       |    form-feed          |
|       `\s`       |    space              |
|  `\E` and `\e`   | escape character      |
|      `^x`        |`control-x` (`x`=char) |


## Floats vs Doubles
Floats and Doubles both store floating point values.  
Floats allow for 4 bytes (or 32 bits), while doubles are 8 bytes (or 64 bits).

| Floats  |  Doubles  |
|---------|-----------------------|
| 4 bytes (32 bits) | 8 bytes (64 bits)
| 7 decimal digits precision  | 15 decimal digits precision |
| possible precision errors with big numbers | won't get precision errors with big numbers |
| Format specifier `%f` | Format specifier `%lf` |



## Loops in C
```c
int count = 10;
for (int i = 0; i < count; i++) {
    for (int j = 0; j < length; j++) {
        repeated_str[i + length + j]
    }
}
```


## Compiling a C Program
To compile a C program, we need to use the `gcc` compiler.
For example, to compile `hello.c`, we would run:
```c
gcc hello.c -o hello
```
* `gcc hello.c`: This passes `hello.c` to the compiler.  
* `-o`: Tells gcc to output an executable binary named `hello`.




