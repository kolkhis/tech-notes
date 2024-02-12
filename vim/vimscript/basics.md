
# Vim Script Basics  

## Table of Contents
* [Type Conversion](#type-conversion) 
* [Types](#types) 
* [Type Checking](#type-checking) 
* [Variable Namespaces](#variable-namespaces) 
* [Strings](#strings) 
    * [String Length](#string-length) 
    * [String Concatenation](#string-concatenation) 
    * [String Comparison](#string-comparison) 
    * [String Slicing](#string-slicing) 
    * [Counting Occurrences of a Substring](#counting-occurrences-of-a-substring) 
    * [Find Position of a Substring](#find-position-of-a-substring) 
    * [Check if a String Starts With or Ends With a Substring](#check-if-a-string-starts-with-or-ends-with-a-substring) 
    * [Join Strings in a List with a Separator](#join-strings-in-a-list-with-a-separator) 
    * [Replace a Substring](#replace-a-substring) 
    * [Split a String](#split-a-string) 
    * [Trimming/Stripping Strings of Whitespace](#trimming/stripping-strings-of-whitespace) 
    * [Fuzzy Matching Strings](#fuzzy-matching-strings) 
    * [String Methods](#string-methods) 
* [Appending to a List](#appending-to-a-list) 
* [Join Two Lists / Extend a List](#join-two-lists-/-extend-a-list) 
* [Insert an Item Into a List](#insert-an-item-into-a-list) 
* [Remove an Item from a List](#remove-an-item-from-a-list) 
* [Remove the Last Item from a List](#remove-the-last-item-from-a-list) 
* [Find the Index of an Item in a List](#find-the-index-of-an-item-in-a-list) 
* [Find the index of an item in a List of Dictionaries by the item value](#find-the-index-of-an-item-in-a-list-of-dictionaries-by-the-item-value) 
* [List Slicing](#list-slicing) 
* [Adding multiple items to a list using repetition](#adding-multiple-items-to-a-list-using-repetition) 
* [Count number of occurrences of an item in a list](#count-number-of-occurrences-of-an-item-in-a-list) 
* [Get the length of a list](#get-the-length-of-a-list) 
* [Dictionaries](#dictionaries) 
* [The -> syntax](#the-->-syntax) 
* [Heredoc](#heredoc) 
* [Resources](#resources) 


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

### Fuzzy Matching Strings  
Use the `matchfuzzy()` function to fuzzily-search for a substring.  
```vim  
let str_list = ['crow', 'clay', 'cobb']  
let m = matchfuzzy(str_list, 'cay')  
echo m  
```

### String Methods  
|Method |  VimScript  
|-|-  
| `capitalize()` | `'one two'->substitute('.', '\u&', '')`
| `count()` | `"abbc"->count('b')`
| `endswith()` | `'running' =~# 'ing$'`
| `expandtabs()` | `"a\tb"->substitute("\t", repeat(' ', 8), 'g')`
| `find()` | `"running"->stridx('nn')`
| `index()` | `'hello'->stridx('e')`
| `isalnum()` | `str =~ '^[[:alnum:]]\+'`
| `isalpha()` | `str =~ '^\a\+$'`
| `isdigit()` | `str =~ '^\d\+$'`
| `islower()` | `str =~ '^\l\+$'`
| `isspace()` | `str =~ '^\s\+$'`
| `istitle()` | `str =~ '\(\<\u\l\+\>\)\s\?'`
| `isupper()` | `str =~ '^\u\+$'`
| `join()` | `join(['a', 'b', 'c'], ':')`
| `lower()` | `'Hello'->tolower()`
| `lstrip()` | `'  vim  '->trim(' ', 1)`
| `partition()` | ``'ab-cd-ef'->matchlist('\(.\{-}\)\(-\)\(.*\)')[1:3]``
| `replace()` | `'abc'->substitute('abc', 'xyz', 'g')`
| `rfind()` | `'running'->strridx('ing')`
| `rindex()` | `'running'->strridx('ing')`
| `rpartition()` | `` 'ab-cd-ef'->matchlist('\(.*\)\(-\)\(.*\)')[1:3]``
| `rstrip()` | `'  vim  '->trim(' ', 2)`
| `split()` | `'a-b-c'->split('-')`
| `splitlines()` | `"one\ntwo"->split("\n")`
| `startswith()` | `'running' =~# '^run'`
| `strip()` | `'  vim  '->trim()`
| `title()` | `'onE twO'->substitute('\<\(.\)\(\S\+\)\>', '\u\1\L\2', 'g')`
| `upper()` | `'Hello'->toupper()`
| `translate()` | `'abcd'->tr('bd', '12')`




## Appending to a List  
Call the `list->add()` method to append to a list.  
```vim  
let l = [1, 2, 3]  
call add(l, 4)  
let l = l->add(5)  
let l = add(l, 6)  
echo(l)  
" [1, 2, 3, 4, 5, 6]  
```

## Join Two Lists / Extend a List  
Join or extend a list with another list with the `list->extend()` method.  
Or, to concatenate a list, use the `+` operator.  
```vim  
let l = []  
call extend(l, [1, 2])  
let l = l->extend([3, 4])  
let l = extend(l, [5, 6])  
let l += [7, 8]  
echo(l)  
" [1, 2, 3, 4, 5, 6, 7, 8]  
let l = [1, 2] + [3, 4]  
echo(l)  
" [1, 2, 3, 4]  
```


## Insert an Item Into a List  
Insert an item into a list with the `list->insert(obj, idx)` method.  
```vim  
let l = [2, 4]  
" Insert before index 1  
eval l->insert(3, 1)  
" Insert just before last item  
eval l->insert(5, -1) 
" Insert at the beginning  
eval l->insert(1)  
echo(l)  
" [1, 2, 3, 4, 5]  
```

## Remove an Item from a List  
Use the `list->remove(idx)` method, or `unlet` to remove an item from a list.  
```vim  
let l = [4, 5, 6]  
let idx = index(l, 5)  
if idx != -1  
  call remove(l, idx)  
endif  
unlet l[0]  
" [6]  
```

## Remove the Last Item from a List  
Use the `list->remove(-1)` method to remove (and return) the last item from a list.  
```vim  
let l = [1, 2, 3, 4, 5]  
let last_item = l->remove(-1)  
eval l->remove(-1)  
echo(last_item)  
" 5  
echo(l)  
" [1, 2, 3] 
```

## Find the Index of an Item in a List  
Use the `list->index()` method to get the index of an item in a list.  
```vim  
let l = [1, 2, 3]  
let idx = l->index(2)  
echo(idx)  
" 1  
```

## Find the index of an item in a List of Dictionaries by the item value  
Use the `list->indexof()` method to get the index of a dictionary value.  
This should be passed 
```vim  
let colors = [{'color': 'red'}, {'color': 'green'}, {'color': 'blue'}]  
let idx = indexof(colors, {i, v -> v.color == 'blue'})  
echo(idx)  
" 2
let idxx = colors->indexof({i, v -> v.color == 'blue'})  
echo(idxx)  
" 2
```

## List Slicing  
To slice a list, you can use the square bracket slice notation (`l[:-1]`) or  
the `list->slice()` method.  
* `slice()` does not include the `end` index.  
    * This can also be used on strings.  
```vim  
let l = [1, 2, 3, 4]  
let x = l->slice(0, 2)  
echo(x)  
" [1, 2]  
let y = l[0:2]  
echo(y)  
" [1, 2, 3]  
echo(l[-2:])  
" [3, 4]  
```


## Adding multiple items to a list using repetition
Use the `list->repeat()` method to add multiples of an item to a list.  
```vim
let l = ['vim']->repeat(4)
```

## Count number of occurrences of an item in a list
Use the `list->count()` method to find all occurrences of an item in a list.  
```vim
let l = [2, 4, 4, 5]
let x = l->count(2)
echo(x)
" 1
```

## Get the length of a list
Use the `list->len()` method to get the length of a list.  
```vim
let l = [1, 2, 3, 4]
let x = l->len()
echo(x)
" 4
```



## Dictionaries  
Dictionaries can be defined just like in Python.  
```vim  
let colors = { 'name': 'Kolkhis', 'age': 'Nunya' }
```
To avoid having to put quotes around every key, the `#{}` syntax can be used.  
```vim  
let colors = { name: 'Kolkhis', age: 'Nunya' }
```



## The -> syntax  
The `->` syntax can be used variables to call methods availale for the type 
of variable that calls it.  
Essentially it passes in `self` as the first argument.  

This also allows for chaining, passing the value that one method returns to the  
next method: 
```vim  
mylist->filter(filterexpr)->map(mapexpr)->sort()->join()  
```

Example of using a lambda:  
```vim  
GetPercentage()->{x -> x * 100}()->printf('%d%%')  
```

When using `->` the `expr7` operators will be applied first, so:  
```vim  
-1.234->string()  
"  Is equivalent to: >  
(-1.234)->string()  
```
`->name(` can not contain white space.  
There can be white space before the `->` and after the `(`,
so you can split the lines like this: 
```vim  
mylist  
\ ->filter(filterexpr)  
\ ->map(mapexpr)  
\ ->sort()  
\ ->join()  
```
When using the lambda form there can't be white space between the `}` and the `(`.  


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
