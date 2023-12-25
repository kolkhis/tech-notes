
# Format Strings (f-strings)  

f-strings were (formatted string literals) were introduced in Python 3.6.  
Along with standard format specifiers, f-strings support a set of modifiers  
that affect how the values are represented.  
Here's a breakdown of these modifiers:  

f-string modifiers (`!s`, `!r`, `!a`) control how values are converted to strings.  

## String Casting Modifier - `!s`
* `!s {string}`: Applies `str()` to the variable.  
    * It's used to convert the value to a string.  

```python  
x = 10  
print(f"{x!s}")  # '10' as a string (no quotes)
```

## Repr Modifier - `!r`

* `!r (representation)`: Applies `repr()` to the variable. 
    * This is used to get the string representation of the value in a way  
      that is usually valid Python syntax.  
    * It shows the quoted string or the precise representation of the object.  

```python  
x = "Hello"  
print(f"{x!r}")  # 'Hello' (with quotes)
```

## ASCII Modifier (Escaping Non-ASCII characters) - `!a`

* `!a (ASCII)`: Applies `ascii()` to the variable.  
    * Similar to `!r` but escapes the non-ASCII characters in the string returned by `repr()`.  

```python  
x = "Café"
print(f"{x!a}")  # 'Caf\xe9' (unicode is escaped)
```

---

## Format Specifications  

In addition to the modifiers, f-strings allow for detailed formatting specifications.  
You can control width, alignment, padding, number formatting, and more. Here are some examples:  

## Padding and Alignment:  
* `{value:10}`: Right-aligns the value in a field 10 characters wide.  
* `{value:<10}`: Left-aligns the value in a field 10 characters wide.  
* `{value:^10}`: Centers the value in a field 10 characters wide.  
* `{value:_<10}`: Left-aligns the value, padding with underscores.  

## Number Formatting:  
* `{value:.2f}`: Formats a floating-point number to two decimal places.  
* `{value:+.2f}`: Formats a floating-point number to two decimal places, including the sign.  
* `{value:,.2f}`: Includes a comma as a thousand separator.  

## Date and Time Formatting:  
* `{datetime_variable:%Y-%m-%d}`: Formats a datetime object in 'YYYY-MM-DD' format.  

## Percentages and Exponents:  
* `{value:.2%}`: Formats a number as a percentage.  
* `{value:.2e}`: Formats a number in scientific notation.  


