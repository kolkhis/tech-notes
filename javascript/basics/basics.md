
# Basics of JavaScript  

## Strings  

### Variables in Strings  
Like format strings, or fstrings in other languages, you can 
use variables directly in strings.


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
