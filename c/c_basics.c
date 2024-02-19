#include <stdio.h>  /* The C standard library for IO (input and output) */
#include <math.h>   /* The C standard library for math */
#include <stdlib.h> /* The C standard library for memory management */
#include <string.h> /* The C standard library for strings */


/* char* repeat_string(char[] s, int n) */
/* { */
/*     for (i = 0; i < ) */
/*     char[] result = malloc(n * sizeof(char)); */
/*     return result; */
/* } */

int main()
{

    /******************  Strings and Loops  ******************/
    int characterAge;
    characterAge = 25;

    /* Single quotes for chars */
    char someChar = 'b';
    /* Double quotes for strings (char arrays) */
    char characterName[] = "John"; 

    printf("There's some guy named %s.\n", characterName);
    printf("He was %d years old.\n", characterAge);

    /* Looping over the name with strlen (<string.h>) */
    for (int i=0; i<strlen(characterName); i++) 
    {
        printf("%c", characterName[i]);
    }

    printf("\n");

    
    /* Using sizeof (<stdlib.h>) */
    for (int i = 0; i < sizeof(characterName); i++) 
    {
        printf("%c", characterName[i]);
    }

    printf("\n");

    /* Taking advantage of null-termination: */
    /* In C, strings are null-terminated. */
    /* You iterate while the read character is not the null character. */
    /* *c++ increments c and returns the dereferenced old value of c. */
    char *c = characterName;
    while (*c)
    {
        putchar(*c++);
    }
    printf("\n");

    /******************  Doubles and Floats  ******************/
    /** Doubles and Floats both store floating point numbers. **/
    float  piFlo = 3.14;         // 32-bit / 4 bytes
    double piDub = 3.141592;     // 64-bit / 8 bytes (double precision)
    printf("Pi as a Double: %f\nPi as a float: %f\n", piDub, piFlo);
    printf("Float: 32-bits.\nDouble: 64-bits.\n");
    printf("%f + %f = %f\n", piDub, piFlo, piDub + piFlo);

    /******************  MATH  ******************/
    double x = 3.14;
    double y = 2.00;
    double* yr = &y;
    double* xr = &x;
    /* Needs to be compiled with `gcc -lm` ([l]ook [m]ath) */
    /* double powerOfPointers = pow(*yr, *xr); */
    /* Does NOT NEED to be compiled with `gcc -lm` */
    double powerOfNumbers = pow(3.14, 2.00);
    printf("\nNumbers : %f to the power of %f: %f\n", x, y, powerOfNumbers);
    /* printf("Pointers: %f to the power of %f: %f\n", *xr, *yr, powerOfPointers); */


    /******************  Strings and Memory  ******************/

    // IMPORTANT:
        /* Must allocate 1 additional byte for the null terminator. */
    char *allocated_string = malloc(strlen("<this is allocated>")+1);
    if(allocated_string) {
        strcpy(allocated_string, "<this is allocated>");
    }
    for (int i = 0; i < strlen(allocated_string); i++) {
        printf("%c", allocated_string[i]);
    }
    printf("\n");

    // How does the computer get the memory back?
    //      How can we do what happens in Python?
    //      In Python, we don't have to do anything explicitly to get the memory back. 
    //  Use the `free()` function from stdlib.h
    /* We need to free the memory. */
    free(allocated_string);
    // Always double check your work!
    printf("The memory is now free.\nThe string: %c", allocated_string[0]);

    return 0;
}
