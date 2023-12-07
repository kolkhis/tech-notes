#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main()
{

    int characterAge;
    characterAge = 25;

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

    double piDub = 3.14159;
    float  piFlo = 3.14;
    printf("Pi as a Double: %f\nPi as a float: %f", piDub, piFlo);


    return 0;
}
