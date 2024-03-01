
# Static Variables in C


In C, the `static` keyword has multiple uses, but fundamentally, it affects the
**storage duration** and **linkage** of a variable or function.  

When you declare a variable with `static` inside a function or globally, you're
influencing these aspects:

### Storage Duration

* Static Storage Duration: Variables declared as `static` have a lifespan that 
  extends across the entire runtime of the program.  
    * This is different from automatic variables (those declared without `static` inside
      functions), which are created and destroyed each time the function is called.  
    * This means `static` variables maintain their value between function calls.

### Linkage

* Internal Linkage: When `static` is used with global variables or 
  functions, it restricts their visibility to the file in which they
  are declared.  
    * This means they cannot be accessed or linked from other files, which helps
      in encapsulating the code and avoiding name conflicts across different files.

### Zero-Initialization
 
```c
#include <stdio.h>
 
int main() {
    static int some_num;
    printf("%d\n", some_num);  // 0
    return 0;
}
```

* `static` variables are automatically zero-initialized if they're not explicitly initialized.
    * This includes those defined inside functions.  

* This ensures that they start from a known state, which is useful for variables
  that are meant to maintain their state across function calls or throughout 
  the program's execution.

