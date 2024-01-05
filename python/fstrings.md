
# Format Strings (f-strings)  

f-strings (formatted string literals) were introduced in Python 3.6.  
Along with standard format specifiers, f-strings support a set of modifiers  
(`!s`, `!r`, `!a`) that affect how the values are converted to strings.  


## String Casting Modifier - `!s`
* `!s` (string): Applies `str()` to the variable.  
    * It's used to convert the value to a string.  

```python  
x = 10  
print(f"{x!s}")  # Equivalent to str(x)  
# Output: 
10  
```

## `repr` Modifier - `!r`

* `!r` (representation): Applies `repr()` to the variable. 
    * This is used to get the string representation of the value in a way  
      that is usually valid Python syntax.  
    * It shows the quoted string or the precise representation of the object.  

```python  
x = "Hello"  
print(f"{x!r}")  # Equivalent to repr(x)  
# Output:  
'Hello' 
```

## ASCII Modifier (Escaping Non-ASCII characters) - `!a`

* `!a` (ASCII): Applies `ascii()` to the variable.  
    * Similar to `!r` but escapes the non-ASCII characters in the string returned by `repr()`.  

```python  
x = "Café"  
print(f"{x!a}")  # Equivalent to ascii(x)  
# Output:  
'Caf\xe9'  
```

---  

## Format Specifications  

In addition to the modifiers, f-strings allow for detailed formatting specifications.  
You can control width, alignment, padding, number formatting, etc. 
  

## Padding and Alignment:  

Padding and alignment are done by specifying the width of the field in the format specification.  
The syntax is `f"{variable:*^x}"`, where:  
* `*` is the character to be used for padding (optional, default is space `' '`).  
* `^` is the alignment specifier (one of `>`, `<`, `^`).  
* `x` is the desired field width (length of the final result).  

### Alignment Specifiers:  
The following modifiers are available:  
* `{value:>10}`: Right-aligns the value in a field 10 characters wide.  
* `{value:<10}`: Left-aligns the value in a field 10 characters wide.  
* `{value:^10}`: Centers the value in a field 10 characters wide.  

### Custom Padding Characters:  
* Any of the alignment specifiers (`>`, `<`, `^`) can be preceded by a  
  character for custom padding.  
* Default padding character is a space.  
* Examples: 
  ```python  
  value = "Python"  
  print(f"{value:_>10}")  # Left-aligns value in a field 10 characters wide, padding with '_' 
  # Output:  
  ____Python  
  
  print(f"{value:*^12}")  # Centers value in a field 12 characters wide, padding with '*'  
  # Output:  
  ***Python***  
  ```

### Side notes on Padding and Alignment:  
* **Sign Awareness**: The padding and alignment take into account the sign of **numbers**.  
    * For example, `{number_var:*>+10}` will right-align and pad a 
      number (using the `*` character), preserving its sign (`+` or `-`) at the left.  
    * See [Number Formatting](#number-formatting) below.  
    
* **String and Number Formatting**: These techniques work with both strings and numbers.  
    However, with numbers, additional formatting options can also be specified.  
    * See [Number Formatting](#number-formatting) below.  
    
* **Escaping Braces**: If you need to include literal braces (`{` or `}`) in the  
  output, they can be escaped by doubling them: `{{` or `}}`.  
    * ```python
      print(f"{{ {value:*^12} }}")
      # Output:
      { ***Python*** }
      ```

### More Alignment and Padding Examples:  
```python  
# Right-align in 10 characters width  
my_string = "Python"  
print(f"{my_string:>10}")  
# Output: '    Python'  
    
# Left-align in 10 characters width  
print(f"{my_string:<10}")  
# Output: 'Python    '  
    
# Center in 10 characters width  
print(f"{my_string:^10}")  
# Output: '  Python  '  
    
# Left-align with underscore padding in 10 characters width  
formatted = f"{my_string:_<10}"  
print(f"{my_string:_<10}")  # Output: 'Python____'  
```


## Number Formatting:  
* `{value:.2f}`: Formats a floating-point number to two decimal places.  
* `{value:+.2f}`: Formats a floating-point number to two decimal places, including the sign.  
* `{value:,.2f}`: Includes a comma as a thousand separator.  
  
Examples:
```python
# Floating-point formatting to two decimal places
value = 3.14159
print(f"{value:.2f}")  
# Output: 
3.14
    
# Floating-point with sign formatting to two decimal places
print(f"{value:+.2f}")  
# Output: 
+3.14
    
# Floating-point with comma as a thousand separator
value = 1234567.89
print(f"{value:,.2f}")  
# Output: 
1,234,567.89
```



### Additional Points:

1. **Precision**: Precision in floating-point formatting (`:.2f`) can be adjusted. For instance, `:.3f` would format the number to three decimal places.

2. **Sign Handling**: The `+` sign specifier forces the display of the sign for both positive and negative numbers. Without it, only negative numbers display a sign by default.

3. **Padding with Zeroes**: For numeric values, you can also combine width and precision, optionally padding with zeroes. For example, `f"{value:08.2f}"` would result in a width of 8 characters, including 2 decimal places, padded with zeroes if necessary.

4. **Date and Time Flexibility**: The formatting of `datetime` objects in f-strings is highly versatile, supporting a wide array of format codes for different components of the date and time.


---


## Date and Time Formatting:  
* `{datetime_variable:%Y-%m-%d}`: Formats a datetime object in `YYYY-MM-DD` format.  
Examples:
```python
from datetime import datetime
    
datetime_variable = datetime(2023, 3, 14)
    
# Standard format
print(f"{datetime_variable:%Y-%m-%d}")  
# Output: 
2023-03-14
 
# Alternative formats
print(f"{datetime_variable:%D}")  # Equivalent to %m/%d/%y (or %x)
# Output:
03/14/23
 
print(f"{datetime_variable:%m-%d-%Y}")  
# Output: 
03-14-2023
 
print(f"{datetime_variable:%m/%d/%Y}")
# Output: 
03/14/2023
```


## Percentages and Exponents:  
* `{value:.2%}`: Formats a number as a percentage.  
* `{value:.2e}`: Formats a number in scientific notation.  
Example:
```python
# Formatting as a percentage
value = 0.123
formatted = f"{value:.2%}"
print(formatted)  # Output: '12.30%'
    
# Formatting in scientific notation
value = 12345.6789
formatted = f"{value:.2e}"
print(formatted)  # Output: '1.23e+04'
```





---  

## C-style `printf` String Formatting  
String objects have one unique built-in operation: the `%` operator (modulo).  
This is also known as the "string formatting"/"interpolation" operator.  

A conversion specifier at least two characters. 
It has the following components, which must occur in this order:  

1. Required: The `%` character, which marks the start of the specifier.  
2. Optional: Mapping key, consisting of a string of chars in parentheses  
    * For example, `%(somename)`.  
3. Optional: Conversion flags, which affect the result of some conversion types.  
    * For example, `%(somename)0d`.  
    * The following table lists the conversion flags:  
    * See [Conversion Flags](#conversion-flags)  

4. Optional: Minimum field width. 
    * If specified as an `*` (asterisk), the actual width is read from the next 
      element of the tuple in values, and the object to convert comes after the 
      minimum field width and optional precision.  
5. Optional: Precision, given as a `.` (dot) followed by the precision.  
    * If specified as `*` (an asterisk), the actual precision is read from the next  
      element of the tuple in values, and the value to convert comes after the precision.  
6. Optional: Length modifier.  
7. Conversion type.  


## Conversion Types  
The conversion type needs to come at the end (as listed above).  
E.g., a simple string conversion would look like this: 
`%s` (where `s` is the conversion type).  

| Conversion | Meaning | Notes  
|-|-|-  
| `'d'` | Signed integer decimal.  
| `'i'` | Signed integer decimal.  
| `'o'` | Signed octal value. | (1)  
| `'u'` | Obsolete type – it is identical to `'d'`.|  (6)  
| `'x'` | Signed hexadecimal (lowercase). | (2)  
| `'X'` | Signed hexadecimal (uppercase). | (2)  
| `'e'` | Floating point exponential format (lowercase). | (3)  
| `'E'` | Floating point exponential format (uppercase). | (3)  
| `'f'` | Floating point decimal format. | (3)  
| `'F'` | Floating point decimal format. | (3)  
| `'g'` | Floating point format. Uses lowercase exponential format if exponent is less than -4 or not less than precision, decimal format otherwise. | (4)  
| `'G'` | Floating point format. Uses uppercase exponential format if exponent is less than -4 or not less than precision, decimal format otherwise. | (4)  
| `'c'` | Single character (accepts an `int` or single-character `str`).  
| `'r'` | String (converts any Python object using `repr()`). | (5)  
| `'s'` | String (converts any Python object using `str()`). | (5)  
| `'a'` | String (converts any Python object using `ascii()`). | (5)  
| `'%'` | No argument is converted, results in a literal `%` character.  

* Notes:  
1. The alternate form causes a leading octal specifier (`0o`) to be inserted before  
   the first digit.  
2. The alternate form causes a leading `0x` or `0X` (depending on whether  
   the `x` or `X` format was used) to be inserted before the first digit.  
3. The alternate form causes the result to always contain a decimal point,
   even if no digits follow it.  
4. The precision determines the number of digits after the decimal point and 
   defaults to 6.  
5. The alternate form causes the result to always contain a decimal point, and  
   trailing zeroes are not removed as they would otherwise be.  
6. The precision determines the number of significant digits before and after  
   the decimal point and defaults to 6.  
7. If precision is `N`, the output is truncated to `N` characters.  
8. See PEP 237.  

---  
### Examples of using the conversion types  
You can use this to format strings without using f-strings.  
The syntax is `%x` where `x` is a format specifier.  
The format specifier specifies the type of the value (e.g., `%s` for strings).  
```python  
# Dictionary  
print("%(name)s" % {"name": "Jeff"})  
# Single Value  
print("%s" % "Jeff")  
# Tuple  
print("%s" % ("Jeff",))  
```

### More Examples with Conversion Flags  
You can name the variables you want to use in the string by 
using `%(varname)_`, where `_` is a format specifier. This requires passing  
in a dictionary with the variable names as keys.  
* E.g., `s` for strings, `d` (or `i`) for integers, `f` for floats, etc. 
* See [Conversion Types](#conversion-types) for full list.  
```python  
# Using multiple named values:  
print('%(language)s has %(number)03d quote types.' %  
      {'language': "Python", "number": 2})  

print("%(name)s" % {"name": "Jeff"})  
print("%(number)d" % {"number": 3})  
print("%(decimal)f" % {"decimal": 3.14})  

print("%s %d" % ("I'm a string", 77))  

print("%s %i %.05f" % ("Jeff", 33, 3.14159))  


# Pad LHS with zeroes  
# Shows at least 5 characters (decimal `.` counts as one), including 2 decimal places. 
>>> print('The first 5 digits of pi are %05.2f' % (3.14159,))  
# Out: The first 5 digits of pi are 03.14  

# Pad the LHS with spaces:  
>>> print('The first 5 digits of pi are %8.4f' % (3.14159,))  
# Out: The first 5 digits of pi are   3.1416  

# Pad LHS with 1 space if number is positive, show the minus if it's negative:  
>>> print('The first 5 digits of pi are % .4f' % (3.14159,))  
# Out: The first 5 digits of pi are  3.1416  
```

You pass in either a single value, a dictionary, or a tuple.  
* If you name a variable in the string, you **must** use a dictionary, 
  using the same name as a key in the dictionary.  

When using a tuple, the values are assigned to the variables in the order they appear.  


## Conversion Flags  

The following table shows a list of the available conversion flags.  

| Flag | Meaning  
|-|-  
| `#`  | The value conversion will use the "alternate" form ([Conversion Types](#conversion-types)).  
| `0`  | The conversion will be zero padded for numeric values.  
| `-`  | The converted value is left adjusted (overrides the `0` flag if both are given).  
| ` `  | (space) Leaves a blank before a positive number (or empty string) produced by a signed conversion.  
| `+`  | Shows if number is positive or negative (`+` or `-`). No effect on strings. (overrides ` ` (space) flag).  

## Examples: Conversion Types with Flags  

### `#` (Alternate Form):  
---  
The `#` flag changes the output based on the conversion type used. 
It's used to specify an "alternate form" for the output.  

* For `o` (octal) conversions, it ensures the output starts with `0`.  
* For `x` and `X` (hexadecimal) conversions, it adds a 0x or 0X prefix respectively.  
* For `f`, `F`, `g`, `G`, `e`, and `E` (floating-point) conversions, it ensures the output will always contain a decimal point, even if the fractional part is zero.  
* Example: `"%#x" % 255` results in `'0xff'`.  
```python  
# Octal  
print("%#o" % 10)  # Output: '012'  
    
# Hexadecimal  
print("%#x" % 255)  # Output: '0xff'  
print("%#X" % 255)  # Output: '0XFF'  
    
# Floating-point  
print("%#f" % 123.0)  # Output: '123.000000'  
```

---  
### `0` (Zero Padding):  
---  
The `0` flag is used to pad the output with zeros instead of spaces.  
This is useful for numerical values where you want fixed-width formatting.  
* It's effective when used with a specified width: `"%05d" % 42` results in `'00042'`.  
* If the `-` flag is also present, it overrides the `0` flag, and the padding is done with spaces on the right.  
```python  
# Integer  
print("%05d" % 42)  # Output: '00042'  
    
# Floating-point  
print("%010.2f" % 3.14)  # Output: '0000003.14'  
```

---  
### `-` (Adjust Left):  
---  
The `-` flag is used for left adjustment of the converted value.  
By default, values are right-adjusted.  
This flag ensures the output is padded with spaces on the right to fill the specified width.  
* Example: `"%-10d" % 42` results in `'42        '` (42 followed by 8 spaces).  
```python  
# Integer  
print("%-10d" % 42)  # Output: '42        '  
    
# String  
print("%-10s" % "hello")  # Output: 'hello     '  
```

---  
### ` ` (space) Conversion Flag 
---  
To use the space flag in `printf`-style formatting, include it in a format  
specifier for a signed number, like `%d` for integers.  
```python  
number = 42
formatted = "% d" % number  # Note the space before the 'd'  
print(formatted)  # Output: ' 42'  
```
In this example, `% d` formats `number` as an integer **and** leaves  
a space before it if it's positive.  
The output is `' 42'` with a leading space.  

If number were negative, there would be no leading space.  
The minus sign would take its place:  
```python  
number = -42
formatted = "% d" % number  
print(formatted)  # Output: '-42'  
# Or, from the command line:  
>>> print("% d\n% d" % (55, -55 ))  
 55  
-55  
```

* Use Case:  
This flag is useful for aligning numbers in tabular data  
where positive and negative values are mixed. 

---  
### `+` (Sign):  
---  
The `+` flag forces the output to show the sign (`+` or `-`) of a number.  
By default, only the negative sign is shown.  
This is useful when you want to emphasize the positivity or negativity of a number.  
* Example: `"%+d" % 42` results in `'+42'`, and `"%+d" % -42` results in `'-42'`.  
* If both ` ` (space) and `+` flags are present, `+` takes precedence.  
```python  
# Integer  
print("%+d" % 42)   # Output: '+42'  
print("%+d" % -42)  # Output: '-42'  
    
# Floating-point  
print("%+6.2f" % 3.14)  # Output: ' +3.14'  
```

---  

## Resources  

* Python Documentation: [f-strings](https://docs.python.org/3/reference/lexical_analysis.html#f-strings)  

* Python Documentation: [Format Specification Mini-Language](https://docs.python.org/3/library/string.html#format-specification-mini-language)  

* Python Documentation: [Format String Syntax](https://docs.python.org/3/library/string.html#formatstrings)  

* Python Documentation: [Printf-Style String Formatting](https://docs.python.org/3/library/stdtypes.html#printf-style-string-formatting)  

