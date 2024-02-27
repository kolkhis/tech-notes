# Closures in JavaScript

The concept of closures in JavaScript allows functions to remember and access
variables from their lexical scope, even when the function is executed
outside that scope.

### What is a Closure?

* **Definition**
    * A closure is a function that has access to its own scope, the scope of
      the outer function, and the global scope.
* **Key Characteristic**
    * The inner function retains access to the variables and parameters of
      the outer function even after the outer function has returned.

### How Closures Work

1. **Creating a Closure**:
   * A closure is created every time a function is created.
   * The inner function retains access to the variables and scope of the outer function.

2. **Lexical Scoping**:
   * Lexical scoping means that a function's scope is defined by its physical
     position in the code.
   * The closure has access to variables in three scopes:
       * Local scope (variables defined between its curly brackets)
       * Outer function's scope
       * Global scope

3. **Variables Retention**:
   * The inner function retains the variables of the outer function even after the outer function has finished executing.
   * This retained scope is what makes a closure.

### Example

```javascript
function outerFunction() {
    let outerVariable = 'I am from the outer function!';

    function innerFunction() {
        // Inner function accessing the outer function's variable
        console.log(outerVariable);
    }

    return innerFunction;
}

const myClosure = outerFunction(); // outerFunction has returned, but the closure is alive
myClosure(); // Outputs: I am from the outer function!
```

