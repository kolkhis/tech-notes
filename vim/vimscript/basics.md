
# Vim Script Basics  

## Type Conversion  

| Conversion         | VimScript  
|-|-  
| Number to Float    | `floor(n)`
| Float to Number    | `float2nr(f)`
| Number to String   | `string(n)`
| String to Number   | `str2nr(str)`
| Float to String    | `string(f)`
| String to Float    | `str2float(str)`
| List to String     | `string(l)`
| String to List     | `eval(str)`
| Dict to String     | `string(d)`
| String to Dict     | `eval(str)`




## Types  
| Type    | VimScript  
|-|-  
| Number        | `let num = 10`
| Float         | `let f = 3.4`
| Booelan       | `let done = v:true`
| String        | `let str = "green"`
| List          | `let l = [1, 2, 3]`
| Dictionary    | `let d = #{a : 5, b : 6}`

## Type Checking  

| Type         | VimScript  
|-|-  
| Number       | `type(x) is v:t_number`
| String       | `type(x) is v:t_string`
| List         | `type(x) is v:t_list`
| Dictionary   | `type(x) is v:t_dict`
| Float        | `type(x) is v:t_float`
| Boolean      | `type(x) is v:t_bool`

## Variable Namespaces  

All the variables in VimScript have a scope.  
The default namespace is global (`g:`), unless defined inside a function.  
Inside a function, the default namespace is local (`l:`)  

|Scope Prefix| Description  
|-|-  
| `g:`      | global  
| `l:`      | function-local  
| `s:`      | script-local  
| `a:`      | function argument  
| `v:`      | internal  
| `b:`      | buffer local  
| `w:`      | window local  
| `t:`      | tab local  

## Strings  
Single quoted strings are string literals.  
Double quoted strings are expanded (`\n` adds a newline).  

### String Length  
To find the actual length of a string in chars, use either:  
* `len("string")` (This counts bytes)  
* `strwidth("string")`
* `strcharlen("string")`

All the functions available:  
```vim  
" number of bytes in a string  
let n = len("Hello World")  
" number of bytes in a string  
let n = strlen("Hello World")  
" number of characters in a string  
let n = strcharlen("Hello World")  
" number of characters in a string  
let n = strwidth("Hello World")  
```

### String Concatenation  
Strings can be concatenated with two dots: `..`
```vim  
let hello = "Hello "  
let world = "World"  
let s = hello .. world  

" Deprecated:  
let s = str1 . str2
```

### String Comparison  
```vim  
" compare strings matching case  
let str1 = "blue"  
let str2 = "blue"  
let str3 = "sky"  
if str1 ==# str2
  echo "str1 and str2 are same"  
endif  
if str1 is# str2
  echo "str1 and str2 are same"  
endif  
if str1 !=# str3
  echo "str1 and str3 are not same"  
endif  
if str1 isnot# str3
  echo "str1 and str3 are not same"  
endif  

" compare strings ignoring case  
let str1 = "Blue"  
let str2 = "BLUE"  
let str3 = "sky"  
if str1 ==? str2
  echo "str1 and str2 are same"  
endif  
if str1 is? str2
  echo "str1 and str2 are same"  
endif  
if str1 !=? str3
  echo "str1 and str3 are not same"  
endif  
if str1 isnot? str3
  echo "str1 and str3 are not same"  
endif  
```


### String Slicing  
```vim  
let str = "HelloWorld"  
" use byte index range  
echo str[2:4]  
" use a negative byte range  
echo str[-3:]  
echo str[2:-3]  
" use byte index and length  
echo strpart(str, 2, 3)  
" use character index and length  
echo strcharpart(str, 2, 3)  
" use the start and end character indexes  
echo slice(str, 2, 3)  
" exclude the last character  
echo slice(str, 6, -1)  
```

### Counting Occurrences of a Substring  
To count the occurrences of a substring, you can use the `count()` method  
of the `string` type.  
Methods are invoked with the method (`->`) operator.  
* `:h count()`
```vim  
let helloworld = "Hello World"  
let c = helloworld->count("l")  
```

### Find Position of a Substring  
There are two `string` methods for finding positions of substrings.  
* `string->strindex("substr")`
    * Find substring starting from the left.  
* `string->strrindex("substr")`
    * Find substring starting from the right.  
```vim  
let str = "running"  
let idx = str->stridx("nn")    " leftmost  
let idx = str->strridx("ing")  " rightmost  
" idx == -1 if the substring is not present  
```

### Check if a String Starts With or Ends With a Substring  
Check if a string starts with or ends with a substring with 
the `=~#` comparison operator, or with a slice and the `is#` operator.  
```vim  
let str = "running"  
if str =~# '^run'  
  echo "starts with run"  
endif  
if str[:len('run') - 1] is# 'run'  
  echo "starts with run"  
endif  

if str =~# 'ing$'  
  echo "ends with ing"  
endif  
```

### Join Strings in a List with a Separator  
Use the `join()` function on a list, with the separator as the second argument.  
```vim  
let s = join(['ab', 'cd', 'ef'], ':')  
```

### Replace a Substring  
Use the `string` method `string->substitute(old, new, flags)`.  
```vim  
let s = "Hello World"  
let s2 = s->substitute("Hello", "New", 'g')  
```

### Split a String
Use the `string` method `string->split(separator)` to split a string.
```vim
let s = "a:b:c"
let s2 = s->split(":")
```

### Trimming/Stripping Strings of Whitespace
Use the `string` method `string->trim(char, direction)`
Direction is:
* `0`: Remove from beginning and end (default)
* `1`: Remove from beginning
* `2`: Remove from end
```vim
let s = "  vim  "
" strip leading and trailing whitespace
let s2 = s->trim()
echo $"<{s2}>"
" strip leading space characters
let s2 = s->trim(' ', 1)
echo $"<{s2}>"
" strip trailing space characters
let s2 = s->trim(' ', 2)
echo $"<{s2}>"
```


## Heredoc  
Assigning multi-line values to a variable.  
```vim  
let i =<< trim END  
    one  
    two three  
      four  
    five  
END  
" i == ['one', 'two three', '  four', 'five']  
```





## Resources  
* [Vim Script for Python Developers](https://gist.github.com/yegappan/16d964a37ead0979b05e655aa036cad0)  
* `:h usr_41.txt`
