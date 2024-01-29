
# Basics of JavaScript  


- [Basics of JavaScript](#basics-of-javascript)
  - [Strings](#strings)
    - [Variables in Strings](#variables-in-strings)
    - [Backticks / Template Literals](#backticks--template-literals)
  - [Wipe Packages with npm](#wipe-packages-with-npm)
  - [Variables](#variables)
  - [Variable Declarations and Keywords](#variable-declarations-and-keywords)
    - [`var`](#var)
    - [`let`](#let)
    - [`const`](#const)

## Strings  

### Variables in Strings  
Like format strings, or fstrings in other languages, you can 
use variables directly in strings.
In JS, there are three primary ways to declare variables: 
* `var`
* `let`
* `const`
Each of these has different behavior in terms of scope, hoisting, and reassignment. 

### Backticks / Template Literals

* Backticks
    * Use backticks (`) to define the string.
* `${variable}`
    * Place your variable inside `${}` to embed its value within the string.
* Multi-line Strings
    * Template literals also support multi-line strings without the need for special newline characters.
* Expression Embedding
    * You can embed expressions, not just variables.
    * For example, `Sum: ${a + b}` is valid.

To use variables in strings, you need to use the `${}` syntax.  
The string should be defined with backticks instead of quotes.  
```js
var name = "John"
console.log(`This guy's name is ${name}`)
```


## Wipe Packages with npm

To clear all packages, run `npm cache clean --force`.

## Variable Declaration Best Practices in JS
## Keywords
### `var`
Using `var` is generally frowned upon in modern JavaScript. This is because
`var` declares a variable globally or locally, depending on where it is declared.

- **Scope**
    * `var` declares a function-scoped or globally-scoped variable, depending
      on where it is declared.
    * If declared inside a function, it's function-scoped; if declared outside any
      function, it's global-scoped.
- **Hoisting** (See [hoisting](./hoisting.md))
    * Variables declared with `var` are hoisted to the top of their scope, but 
      not initialized.
    * This means they are accessible in their enclosing scope from the start of 
      the block, but undefined until the line where they are defined.
- **Reassignment and Redeclaration**
    * Allowed. You can reassign and redeclare a variable declared with `var`.
- **Usage**
    * Generally, the use of `var` is now discouraged in favor of `let` and `const` due
      to its less intuitive scope rules and hoisting behavior.

    ```javascript
    if (true) {
        var x = 5;
    }
    console.log(x);  // Outputs: 5
    ```

### `let`
Using `let` is generally preferred over `var` because it's block-scoped, so
it behaves more like a variable declaration in C/C++.

- **Scope**
    * `let` introduces block-scoped variables.
    * The variable is confined to the block in which it's declared.
        * e.g., loop, if-statement, etc.

- **Hoisting** (See [hoisting](./hoisting.md))
    * Like `var`, `let` declarations are hoisted to the top of their block
      but are not initialized.
    * Accessing them before the declaration results in a `ReferenceError`.
- **Reassignment and Redeclaration**
    * You can reassign a `let` variable but cannot redeclare it within the same scope.
- **Usage**
    * Use `let` when you need a variable with block scope or when the variable's
      value will change over time.
      ```javascript
      for (let i = 0; i < 5; i++) {
          // 'i' is only accessible within this loop
      }
      // console.log(i); // ReferenceError
      ```

### `const`

- **Scope**
    * Similar to `let`, `const` is block-scoped.
- **Hoisting** (See [hoisting](./hoisting.md))
    * `const` declarations are hoisted to the top of their block but are not initialized.
- **Reassignment and Redeclaration**
    * Neither reassignment nor redeclaration is allowed.
    * However, if a `const` variable references an object or array, the object
      or array's contents can be altered.
        * e.g., `const arr = [1, 2, 3]; arr.push(4);`
- **Usage**
    * Use `const` when declaring variables that should not be reassigned.
    * i.e., constants or references that should always point to the same 
      object or array.
      ```javascript
      const PI = 3.14;
      // PI = 3.15; // TypeError
      ```


## When to Use `var`, `let`, and `const` (Best Practices)
* Prefer `let` and `const` over `var` in modern JavaScript.
    * They provide block-level scoping, which is usually more manageable and 
      less error-prone than the function-level scoping of `var`.
* Use `let` for variables that will change over time.
* Use `const` for variables that should not change after initialization.


- **Temporal Dead Zone**
    * Both `let` and `const` have a "temporal dead zone" from the start of the block until the declaration is evaluated. Accessing them before declaration results in a `ReferenceError`.
- **Global Scope**
    * Avoid declaring global variables when possible. If necessary, `var` declares a true global variable when used outside of any function, while `let` and `const` do not.
- **Best Practices**:
    * Prefer `const` by default, especially for values that should not change
      and for ensuring references to objects and arrays remain constant.
    * Use `let` for variables whose values are expected to change over time.
    * Avoid `var` in modern JavaScript to prevent issues related to its function
      scoping and hoisting behavior.

---

## Related
* [Hoisting](./hoisting.md)
* [Closures](./closures.md)

