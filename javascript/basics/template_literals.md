

# Template Literals in JavaScript (Backtick Strings)  

The usage of backticks (``` ` ```) for strings in JavaScript is tied to the concept of 
template literals.

Template literals are a way to create strings that offer more functionality compared  
to strings defined with single (`'`) or double (`"`) quotes.  

Template Literals make for easy creation of dynamic strings.  
They support multi-line strings without explicit newline characters.  

## Usage  

1. **Basic Syntax**:  
   - Defined with backticks (``` ` ```).  
   - Can span multiple lines without requiring newline characters (like Go's string literals).  

2. **Interpolation with `${}`**:  
   - Variables and expressions can be embedded within the string using `${expression}` syntax.  
   - The expression inside `${}` is evaluated, and the result is converted  
     to a string and included in the template literal.  


4. **Example**:  

   ```javascript  
   let user = 'Alice';  
   let greeting = `Hello, ${user}!`;  
   console.log(greeting);  // Output: Hello, Alice!  
   ```



