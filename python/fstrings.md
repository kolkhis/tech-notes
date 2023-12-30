
# Format Strings (f-strings)  

f-strings were (formatted string literals) were introduced in Python 3.6.  
Along with standard format specifiers, f-strings support a set of modifiers  
that affect how the values are represented.  
Here's a breakdown of these modifiers:  

f-string modifiers (`!s`, `!r`, `!a`) control how values are converted to strings.  


## String Casting Modifier - `!s`
* `!s` (string): Applies `str()` to the variable.  
    * It's used to convert the value to a string.  

```python  
x = 10  
print(f"{x!s}")  # '10' as a string (no quotes)  
```

## `repr` Modifier - `!r`

* `!r` (representation): Applies `repr()` to the variable. 
    * This is used to get the string representation of the value in a way  
      that is usually valid Python syntax.  
    * It shows the quoted string or the precise representation of the object.  

```python  
x = "Hello"  
print(f"{x!r}")  # 'Hello' (with quotes)  
```

## ASCII Modifier (Escaping Non-ASCII characters) - `!a`

* `!a` (ASCII): Applies `ascii()` to the variable.  
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

---  

## Printf-Style String Formatting  
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

    | Flag | Meaning  
    |-|-  
    | `#`  | The value conversion will use the "alternate" form ([Conversion Types](#conversion-types)).  
    | `0`  | The conversion will be zero padded for numeric values.  
    | `-`  | The converted value is left adjusted (overrides the `0` flag if both are given).  
    | ` `  | (space) A blank should be left before a positive number (or empty string) produced by a signed conversion.  
    | `+`  | A sign character (`+` or `-`) will precede the conversion (overrides ` ` (space) flag).  
    * See [Conversion Flag Examples](#conversion-flag-examples)  

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

You can use this to format strings without using f-strings.  
The syntax is `%x` where `x` is a format specifier.  
The format specifier specifies the type of the value (e.g., `%s` for strings).  
```python  
# Dictionary  
print("%(name)s" % {"name": "Jeff"})  
# Single Value  
print("%s" % "Jeff")  
# Tuple  
print("%s" % ("Jeff"))  
```

You can name the variables you want to use in the string by 
using `%(varname)_`, where `_` is a format specifier. 
* `s` for strings, 
* `d` (or `i`) for integers,
* `f` for floats, etc. 
```python  
# Using a single value  
print("%s" % "I'm a string")  

# Using multiple named values:  
print('%(language)s has %(number)03d quote types.' %  
      {'language': "Python", "number": 2})  

print("%(name)s" % {"name": "Jeff"})  
print("%(number)d" % {"number": 3})  
print("%(decimal)f" % {"decimal": 3.14})  

print("%s %d" % ("I'm a string", 77))  
```

You pass in either a single value, a dictionary, or a tuple.  
* If you name a variable in the string, you **must** use a dictionary, 
  using the same name as a key in the dictionary.  

When using a tuple, the values are assigned to the variables in the order they appear.  


## Conversion Flag Examples  

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
### `-` (Left Adjust):  
---  
The `-` flag is used for left adjustment of the converted value. By default, values are right-adjusted.  
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
To use the space flag in printf-style formatting in Python, you would typically include it in a format specifier for a signed number, like %d for integers. Here's an example:  
```python  
number = 42
formatted = "% d" % number  # Note the space before the 'd'  
print(formatted)  # Output: ' 42'  
```
In this example, `% d` tells Python to format number as an integer **and** to  
leave a space before it if it's positive.  
The output is `' 42'` with a leading space.  

If number were negative, there would be no leading space since the  
minus sign would take its place:  
```python  
number = -42
formatted = "% d" % number  
print(formatted)  # Output: '-42'  
```

* Use Case:  
This behavior is particularly useful for aligning numbers in tabular data  
where positive and negative values are mixed and you want their 
signs (or lack thereof) to line up for better readability.  

---  
### `+` (Sign):  
---  
The `+` flag forces the output to show the sign (`+` or `-`) of a number.  
By default, only the negative sign is shown.  
This is particularly useful when you want to emphasize the positivity or negativity of a number.  
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

