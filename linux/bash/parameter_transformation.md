
# Bash Parameter Transformation
`man://bash 1500`
Parameter transformation is a way to perform a transformation on a parameter before it is used.
Syntax:
```bash
${parameter@operator}
```
Each operator is a single letter

## Parameter Transformation Operators
* `U`: Converts all lowercase letters in the value to uppercase.
* `u`: Capitalizes only the first letter of the value.
* `L`: Converts all uppercase letters in the value to lowercase.
* `Q`: Quotes the value, making it safe to reuse as input.
* `E`: Expands escape sequences in the value (like `$'...'` syntax).
* `P`: Expands the value as a prompt string.
* `A`: Generates an assignment statement to recreate the variable with its attributes.
* `K`: Produces a quoted version of the value, displaying arrays as key-value pairs.
* `a`: Returns the variable's attribute flags (like `readonly`, `exported`).


## Multiple Parameter Transformation Operators
Just like using `$@` or `$*`, you can use parameter transformation on multiple 
positional parameters or arguments at once by using `${@}` or `${*}`.  

* `${@}`: Treats each positional parameter as a separate item and applies transformations to each individually.
* `${*}`: Treats all positional parameters as a single, combined string. 
    * Transformations apply to the entire combined string, not each parameter individually.

When you use `${@}`, Bash treats each positional parameter (e.g., command-line 
arguments) one by one, applying the transformation to each.
The output is a list with each item transformed according to the specified operator.

With `${*}`, it combines all postitional arguments into a
space-separated string and applies the transformation to that string.  
The output is a single string with the transformation applied to the entire string.  


If you use `${array[@]}` or `${array[*]}`, Bash applies the transformation to each element of the array, one by one. The result is also a list with each array item transformed individually.

If enabled, the final transformed output might go through word splitting (separating by spaces) 
and pathname expansion (turning wildcard characters like `*` into matching filenames),
so the result could expand further into multiple words or paths.  


| Syntax       | Description           | Example Output (for `hello world bash`)   |
|--------------|-------------------------------------------------|--------------------
| `${@^}` | Capitalizes each parameter                            | `Hello World Bash`
| `${*^}` | Capitalizes only the first letter of the combined string | `Hello world bash`
| `${@^^}`| Uppercases each parameter completely                  | `HELLO WORLD BASH`
| `${*^^}`| Uppercases the entire combined string                 | `HELLO WORLD BASH`
| `${@,}` | Lowercases the first character of each parameter      | `hello world bash`
| `${*,}` | Lowercases only the first character of the combined string | `hello world bash`
| `${@Q}` | Quotes each parameter individually                    | `'hello' 'world' 'bash'`
| `${*Q}` | Quotes the entire combined string                     | `'hello world bash'`

* Typically `*` will combine the parameters into one string, whereas `@` will split the parameters into an array.  

* Both `${@^^}` and `${*^^}` make everything uppercase, but `${@^^}` applies it to each parameter individually.
* `${@^}` applies the uppercase transformation to each argument individually.
* `${*^}` treats all arguments as a single string and capitalizes only the first character of that combined string.

## Parameter Transformation Examples  

Parameter transformation on variables, arrays, and associative arrays:
```bash
# Example variable for demonstration
var="hello world"
array_var=("one" "two" "three")
declare -A assoc_array_var=([key1]="value1" [key2]="value2")

# U: Convert all lowercase letters to uppercase
echo "${var@U}"        # Output: HELLO WORLD

# u: Capitalize only the first letter
echo "${var@u}"        # Output: Hello world

# L: Convert all uppercase letters to lowercase
var="HELLO WORLD"
echo "${var@L}"        # Output: hello world

# Q: Quote the value, safe for reuse as input
echo "${var@Q}"        # Output: 'HELLO WORLD' (or "HELLO WORLD" depending on context)

# E: Expand escape sequences (e.g., newline, tab)
esc_var=$'hello\nworld'
echo "${esc_var@E}"    # Output: hello
                       #         world

# P: Expand as a prompt string (useful for prompt formatting)
PS1="[\u@\h \W]\$ "    # Set the prompt
echo "${PS1@P}"        # Output: [user@host directory]$

# A: Generate an assignment statement that recreates the variable
echo "${var@A}"        # Output: declare -- var="HELLO WORLD"

# K: Quoted version of the value, with arrays as key-value pairs
echo "${array_var@K}"          # Output: 'one' 'two' 'three'
echo "${assoc_array_var@K}"    # Output: [key1]="value1" [key2]="value2"

# a: Display attributes of the variable (flags)
declare -r readonly_var="test"
echo "${readonly_var@a}"       # Output: r (indicates readonly)
```

Examples of using parameter transformation with positional parameters and arrays
using the `^` and `@` operators:
```bash
# Positional parameters example
set -- "hello" "world"
echo "${@^}"   # Each positional parameter capitalized: "Hello World"

# Array example
array=("one" "two" "three")
echo "${array[@]^}"   # Capitalize each array element: "One Two Three"

# Word splitting and pathname expansion example
files=("file1.txt" "*.sh")
echo "${files[@]^}"   # Expands "*.sh" to match any shell scripts in the directory

# Using ${@} with U
echo "${@^}"       # Capitalizes each argument: "Hello World Bash"

# Using ${*} with U
echo "${*^}"       # Capitalizes the first letter of the combined string: "Hello world bash"

# Using ${@} with U for full uppercase
echo "${@^^}"      # Outputs: "HELLO WORLD BASH"

# Using ${*} with U for full uppercase
echo "${*^^}"      # Outputs: "HELLO WORLD BASH" (treated as a single string but still fully uppercase)

# Using ${@} with L
echo "${@,}"       # Converts first character of each argument to lowercase

# Using ${*} with L
echo "${*,}"       # Converts only the first character of the combined string to lowercase

# Using ${@} with Q
echo "${@Q}"       # Quotes each argument individually, e.g., "'hello' 'world' 'bash'"

# Using ${*} with Q
echo "${*Q}"       # Quotes the entire combined string: "'hello world bash'"

```

