
# Dynamic Strings in JavaScript  

Creating strings that are dynamic can be done a couple different ways.
This doesn't include template literals. (See [Template Literals](template_literals.md)).

### 1. Concatenation Using Plus Operator (`+`)  

The most basic method for creating dynamic strings is using the `+` operator to concatenate strings with variables or other strings.  

* **Example**:  
  ```javascript  
  let user = 'Alice';  
  let greeting = 'Hello, ' + user + '!';  
  console.log(greeting);  // Output: Hello, Alice!  
  ```

### 2. `concat()` Method  

The `concat()` method concatenates two or more strings and returns a new string.  
This is a method of the String object.  

```js
let str1 = 'Hello, ';
let str2 = 'Alice';
let str3 = '!';
let greeting = str1.concat(str2, str3);
console.log(greeting);  // Output: Hello, Alice!
```

### 3. `join()` Method with Arrays

You can create an array of string elements and then use `join()`
to concatenate them into a single string.

```js
let words = ['Hello', 'Alice', '!'];
let greeting = words.join(' ');
console.log(greeting);  // Output: Hello Alice !
```

### 4. String replace() Method

The `replace()` method can be used to create dynamic strings by 
replacing parts of a string with dynamic values.
It's especially useful for templating.

```js
let template = 'Hello, {user}!';
let greeting = template.replace('{user}', 'Alice');
console.log(greeting);  // Output: Hello, Alice!
```



