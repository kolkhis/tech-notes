#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main()
{

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
    char* c = characterName;
    while (*c)
    {
        putchar(*c++);
    }
    printf("\n");

    /* Doubles and Floats: both store floats */
    float  piFlo = 3.14;         // 32-bit / 4 bytes
    double piDub = 3.141592;     // 64-bit / 8 bytes (double precision)
    printf("Pi as a Double: %f\nPi as a float: %f\n", piDub, piFlo);
    printf("Float: 32-bits.\nDouble: 64-bits.\n");
    printf("%f + %f = %f\n", piDub, piFlo, piDub + piFlo);

    /* MATH */
    double x = 3.14;
    double y = 2.00;
    double* yr = &y;
    double* xr = &x;
    /* Needs to be compiled with `gcc -lm` ([l]ook [m]ath) */
    double powerOfPointers = pow(*yr, *xr);
    /* Does NOT NEED to be compiled with `gcc -lm` */
    double powerOfNumbers = pow(3.14, *xr);
    printf("\nNumbers : %f to the power of %f: %f\n", x, y, powerOfNumbers);
    printf("Pointers: %f to the power of %f: %f\n", *xr, *yr, powerOfPointers);

    return 0;
}
