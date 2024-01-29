# Hoisting

Hoisting is a JavaScript behavior, where variable and function declarations
are moved to the top of their containing scope at compile time.

## What is Hoisting?

1. **Hoisting Basics**:
    * In JavaScript, before the code is executed, the JavaScript engine moves all variable
      and function declarations to the top of their containing scope.
    * This process is known as "hoisting".
    * Only declarations are hoisted, not initializations.
    * If a variable is declared and initialized in one statement, only the declaration
      part is hoisted.

2. **Variable Hoisting**:
   * `var`: When you declare a variable with `var`, its declaration is hoisted to
     the top of its scope.
   * If it’s declared inside a function, it's hoisted to the top of the function;
     if declared outside any function, it's hoisted to the top of the global scope.
   * `let` and `const`: These are also hoisted, but they maintain a
     "temporal dead zone" from the start of the block until the
     declaration is evaluated.
   * Accessing them before the declaration results in a `ReferenceError`.

3. **Function Hoisting**:
   - Function declarations are hoisted to the top of their containing scope, so
     they can be used before they appear in the code.
   - Function expressions are not hoisted, so they cannot be used before they
     appear in the script.

## Examples

1. **`var` Hoisting**:
   ```javascript
   console.log(x); // Outputs: undefined
   var x = 5;
   ```
Here, the declaration `var x;` is hoisted to the top, but the 
initialization `x = 5` stays in place.
So `x` is `undefined` when logged.

1. **`let` and `const` Hoisting**:
   ```js
   console.log(y); // ReferenceError: Cannot access 'y' before initialization
   let y = 10;
   ```
Even though `y` is hoisted, trying to access it before its declaration
results in an error due to the "temporal dead zone".

## When to Use `var`, `let`, and `const` (Best Practices)
* Prefer `let` and `const` over `var` in modern JavaScript.
    * They provide block-level scoping, which is usually more manageable and 
      less error-prone than the function-level scoping of `var`.
* Use `let` for variables that will change over time.
* Use `const` for variables that should not change after initialization.

