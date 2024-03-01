#include <stdio.h>

// This global `int` is automatically zero-initialized.
int some_num;

int main() {

    for (int i = 0; i < 5; i++) {
        some_num++;
        printf("%d\n", some_num);
    }

    // This local `int` must be zero-initialized manually.
    int some_other_num = 0;
    printf("%d\n", some_other_num);
    while (some_other_num < 10) {
        // You can increment within a printf statement.  
        printf("while: %d\n", ++some_other_num);
    }

    // This is a static int. It will be automatically zero-initialized.
    static int some_static_num;
    printf("static int some_static_num: %d\n", some_static_num);
    while (some_static_num < 10) {
        printf("%d\n", ++some_static_num);
    }

    return 0;

}
