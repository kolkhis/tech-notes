
# Python Special Function Parameters


## Table of Contents  

- [tl;dr](#tldr)  
- [Enforcing Keyword Arguments in Python](#enforcing-keyword-arguments-in-python)
- [Using an Asterisk in Python Function Parameters:](#using-an-asterisk-in-python-function-parameters)  
    - [Example](#example)  
- [`*args` and `**kwargs`](#args-and-kwargs)  
    - [Using an Asterisk (`*`) for Keyword-Only Arguments](#using-an-asterisk--for-keyword-only-arguments)  
    - [Using `*args` for Variable Positional Arguments](#using-args-for-variable-positional-arguments)  
    - [Using `**kwargs` for Variable Keyword Arguments](#using-kwargs-for-variable-keyword-arguments)  



## tl;dr  

- **Enforcing Keyword Arguments** with `*,`
    * The single asterisk parameter (`*`) enforces keyword-only arguments that 
      come after it in the function's parameter list.  
- **Capturing Positional Arguments** with `*args`
    * `*args` captures any additional positional arguments as a tuple.  
    * Has the same effect as the `*` parameter in addition to capturing positional args.  
        * It also enforces the use of keyword arguments for any arguments  
          that come after it in the function's parameter list.  
- **Capturing Keyword Arguments** with `**kwargs`
    * `**kwargs` captures any additional keyword arguments as a dictionary.  


## Enforcing Keyword Arguments in Python  

The use of an asterisk (`*`) in a function definition in Python indicates that  
all following parameters must be specified using keyword arguments.  
So, any argument following the `*,` cannot be a positional argument.  

```python  
def my_fn(first, *, second, third):  
    print(f"arg1: {first}, arg2: {second}, arg3: {third}")  

my_fn(1, second=2, third=3) 
```

This is a feature introduced in Python 3 to improve readability and 
prevent possible errors from incorrectly ordered arguments.  

## Using an Asterisk in Python Function Parameters:  

- **Keyword-Only Arguments** 
    * When an asterisk (`*`) is used in a function's parameter list, it specifies that all the  
      arguments that come after it *must* be passed using keyword syntax, making 
      them keyword-only arguments.  

- **Improves Code Readability and Clarity** 
    * This enforces the usage of keyword arguments, making it clear what each value  
      represents when a function is called.  
    * It enhances readability, especially for functions with a lot of parameters or 
      when the meaning of arguments is not obvious.  

- **Prevents Errors** 
    * By forcing certain arguments to be specified by their names, it reduces the risk  
      of passing arguments in the wrong order.  

### Example  

```python  
def some_fn(arg1, *, arg2):  
    print(f"arg1: {arg1}, arg2: {arg2}")  

some_fn(10, arg2=20)  
# This works fine. Output: arg1: 10, arg2: 20  

some_fn(10, 20)  
# This raises a TypeError, as arg2 must be specified as a keyword argument.  
```

## `*args` and `**kwargs`
The asterisk (`*`) in function parameters, `*args`, and `**kwargs` are parameters in Python that deal with variable numbers of arguments.  
Each serves a different purpose in function definition and argument handling.  

### Using an Asterisk (`*`) for Keyword-Only Arguments  

Placing an asterisk (`*`) in a function's parameter list specifies that the following arguments can only be passed as keyword arguments.  
This is used to enforce clearer code and prevent errors that can arise from incorrectly ordered arguments.  

- **Syntax**: `def function(arg1, *, arg2):`
- **Usage**: Ensures that arguments following the `*` are passed as keyword arguments.  
- **Example**:  
    ```python  
    def func(a, *, b):  
        return a, b  
    
    # Valid call  
    func(1, b=2)  
    
    # Invalid call:  
    # func(1, 2)  # TypeError  
    ```

### Using `*args` for Variable Positional Arguments  

`*args` is used in function definitions to handle a variable number of positional arguments.  
Arguments passed to `*args` are accessible as a tuple inside the function.  

- **Syntax** 
    * `def function(*args):`
- **Usage**  
    * Captures additional *positional* arguments not specified in the function signature.  
    * They are captured in a tuple.  
- **Example**  
   * ```python  
     def func(*args):  
         for arg in args:  
             print(arg)  
     
     # Call with variable number of arguments  
     func(1, 2, 3, 'a')  
     ```
    * Output:  
      ```py  
      1  
      2
      3
      a  
      ```

### Using `**kwargs` for Variable Keyword Arguments  

`**kwargs` (keyword arguments) is similar to `*args`, but it handles variable numbers  
of *keyword* arguments instead of positional arguments.  
In the function, `**kwargs` is a dictionary with the names and values of the arguments.  

- **Syntax** 
    * `def function(**kwargs):`
- **Usage** 
    * Captures additional keyword arguments as a dictionary.  
- **Example**  
    * ```python  
      def func(**kwargs):  
          for key, value in kwargs.items():  
              print(f"{key}: {value}")  
      
      # Call with variable keyword arguments  
      func(a=1, b=2, c='three')  
      ```


### Differences between `*args`, `**kwargs`, and `*`

- **Enforcing Keyword Arguments** with `*,`
    * The single asterisk parameter (`*`) enforces keyword-only arguments that 
      come after it in the function's parameter list.  
- **Capturing Positional Arguments** with `*args`
    * `*args` captures any additional positional arguments as a tuple.  
    * Has the same effect as the `*` parameter in addition to capturing positional args.  
        * It also enforces the use of keyword arguments for any arguments  
          that come after it in the function's parameter list.  
- **Capturing Keyword Arguments** with `**kwargs`
    * `**kwargs` captures any additional keyword arguments as a dictionary.  


These provide flexibility in function definitions, allowing functions to handle a  
varying number of arguments.  




