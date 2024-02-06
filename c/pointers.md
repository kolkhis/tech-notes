
# Pointers in C


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
