
# Pointers in C


* Initialization of Pointers
    * It's good practice to initialize pointers to `NULL` if they are not assigned
      any valid address initially.  
    * This avoids undefined behavior when attempting to use or print an uninitialized pointer.

* Casting Pointers for `printf` 
    * When printing a pointer with `%p`, it should be cast to `(void*)` to ensure
      portability and suppress warnings in some compilers.

* Incorrect Type Handling 
    * The assignment `anIntPtr = &anotherIntY;` and its subsequent print statement might
      cause confusion due to type mismatch.  
    * Pointing an `int32_t*` to an `int64_t` variable and then dereferencing it leads
      to undefined behavior.  


## Learn by Example

Consider the following program:
```c
int main() {
  int32_t anIntX = 69;
  int32_t *ptrToX = &anIntX;
  int32_t *anIntPtr;

  printf("anIntX: %d\n", anIntX); //prints 69, nice
  printf("ptrToX: %p\n", ptrToX); //prints a hex address
  printf("anIntPtr: %p\n", anIntPtr); //prints null or garbage since it wasn't initialized previously

  printf("Give anIntPtr a useful address\n");
  anIntPtr = &anIntX;
  printf("anIntPtr: %p\n", anIntPtr); // same address as ptrToX
  printf("anIntPtr: %d\n", *anIntPtr); // prints 69, nice

  printf("Change anIntX via the pointer\n");
  *anIntPtr = 4040;
  printf("anIntPtr: %p\n", anIntPtr); // same address again
  printf("anIntPtr: %d\n", *anIntPtr); //prints 4040
  printf("anIntX: %d\n", anIntX); // prints 4040

  int64_t anotherIntY = 4294967295 + 1;
  anIntPtr = &anotherIntY;
  printf("anotherIntY: %ld\n", anotherIntY);
  printf("anotherIntY but from the wrong type pointer: %d\n", anIntPtr);

  int32_t **ptrToPtr = &ptrToX;
  printf("X from the pointer to ptrToX: %d\n", **ptrToPtr);


  return 0;
}
```


Generally, in C, there are the right-to-left and spiral rules which works
most of the time (there are cases where it will be wrong), but these are 
post-hoc tricks to not have to go back and read what the standard says.
```c
int32_t anIntX = 10; // anIntX is an int32_t
int32_t *ptrToX = &anIntX; //ptrToX is a pointer to an int32_t so we assign it the address of anIntX
int32_t *anIntPtr;  // anIntPtr is also a pointer to an int32_t
anIntPtr = &anIntX; // anIntPtr now points to anIntX
*anIntPtr = 4040;   // dereference anIntPtr to get an lvalue, i.e. the location where anIntX is, and set that location (as an int32_t) with the value 4040
int32_t **ptrToPtr = &ptrToX; //ptrToPtr is a pointer to "a pointer to an int32_t"

int * const ptr; //ptr is constant pointer to an int: the pointer value (the address) cannot be changed, but the contents of the pointed-to memory can be changed
const int * const ptr; // ptr is a constant ptr to an int which is also constant; nothing here can be changed
const int * ptr; // ptr is pointer to an int which is constant; the int itself cannot be changed
int const * ptr; /* ptr is pointer to a const int;
this is the same as above and is annoying that const can appear on either side of the type (which relate to how the C grammar was constructed, the semantics change once the * is parsed);
the main reason for "west const" (const on left side of type) is that this is how it was done historically, but east vs west const is a stylistic difference */
```

## Double Pointers

You won't typically see a double pointer declared as a thing to use in a code block, but it's not uncommon to see it in an argument list to a function.
A couple very common use cases of double pointer:
Argument list for main: 
```c
int main(int argc, char** argv) // this is an array of pointers to char arrays
```
Inserting to head of a linked list:

```c
#include <stdio.h>
#include <stdlib.h>
// To execute C, please define "int main()"

struct node;
struct node {
  int el;
  struct node *next;
};

void insertHead(struct node **head, int element) {
  struct node * newNode = (struct node *)malloc(sizeof(struct node));
  newNode->el = element;
  newNode->next = *head;
  *head = newNode;
}

struct  node * insertAndReturnHead(struct node *head, int element) {
  struct node * newNode = (struct node *)malloc(sizeof(struct node));
  newNode->el = element;
  newNode->next = head;
  return newNode;
}


int main() {
  struct node *my_list = NULL;
  insertHead(&my_list, 123);
  insertHead(&my_list, 456);
  
  my_list = insertAndReturnHead(my_list, 789);

  struct node *el = my_list;
  while  (el != NULL) {
    printf("%d ", el->el);
    el  = el->next;
  }
  return 0;
}
```

* `insertHead` and `insertAndReturnHead` do the same thing:
    * They insert a new element to the head of a linked list. 
    * But, `insertHead` handles everything in its own function body as opposed
      to having to explicitly handle the return of `insertAndReturnHead()`.  
 
If you leave out the `my_list = ` part of `my_list = insertAndReturnHead(my_list, 789);`, 
you'd get a warning, but not an error, and would clearly produce incorrect behavior
from the programmer's perspective.  
 
Double pointers like this are more of a C thing; you wouldn't see it/use it in C++


## Helpful Info

* Right-to-Left Rule: This is a helpful heuristic for reading C declarations.  
    * Start from the variable name and move right when possible, if not, move left.  
    * This rule assists in understanding complex declarations like pointers to functions or arrays of pointers.
    
* `const` Keyword: Understanding the placement of `const` in declarations is crucial.  
    * It modifies the element directly to its left.  
    * If there's nothing on its left, it modifies the element to its right.  
    * This understanding helps in correctly interpreting constant pointers and pointers to constants.
    
* Spiral Rule: A complementary approach to the right-to-left rule, particularly useful for parsing complex declarations involving combinations of arrays, pointers, and functions.

