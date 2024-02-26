
# Nix Basics

### Seasoned engineers respond to "Should I learn nix?"

> I've never seen it at the large Corp level.
> And most of the main features have either been implemented or there's
a close equivalent for more common and supported OS' like RHEL or AL2 (RHEL off shoot) 
> - *Sending_Grounds*


> I like the immutability, but you can technically do that with RHEL.
> It is painful, so much so that most businesses and processes cannot 
support it, even with RHEL enterprise support.
> - *het_tanis*

> I'd be amazed if anything besides maybe a small startup was using Nix at
> an enterprise level
> I would not learn it for professional use unless you get hired at a place
that specifically uses it and tells you you need to learn it
> - *fishermanguybro*

---

##### Examples from [Learn Nix in y Minutes](https://learnxinyminutes.com/docs/nix/)

## Nix Data Types

## Basic Syntax
```nix
with builtins; [
    # Comment
    /* Multi-line comment */

    "A string"
    ("A string with ${getEnv "ANTIQUOTATION_SUPPORT"}")
    "
      A multiline string
    "
    ''
      Multiline strings that strips leading whitespace
    ''

    1 0 217 (-3) (-68)  # some ints
    1.5 .27e13 (-68.22) # some floats
    # Operations use same the type for the output
    (7 / 2)   # 3
    (7 / 2.0) # 3.5

]
```

## Booleans and Conditionals
Use parentheses with the keywords `true` and `false`.
```nix
(true && false)  # false
(true || false)  # true
```

Conditional syntax is like lua, but inside parentheses.  
```nix
# Conditional
(if 5 < 6 then "yes" else "no")  # yes
```



## Integers and Floats

Integers and floats are the number types in Nix.  
```nix
1 0 217 (-3) (-68)  # ints
1.5 .27e13 (-68.22) # floats
```

Mathematical operations preserve the number type.
```nix
# Operations use same the type for the output
(4 + 4 - 6) # 2
(4 - 2.5)   # 1.5
 
(7 / 2)     # 3
(7 / 2.0)   # 3.5
```

## Strings
String literals are enclosed in double quotes.  
```nix
"String literals in double quotes"
```

Double quotes can be used for multiline strings.  
```nix
"
  String literals can span lines
"
```
Nix has "indented string literals" which strip leading whitespace.
```nix
''
  This is an "indented string" literal.
  It strips leading whitespace.
''

''
  a
     b
''
# "a\nb"
```
 
String concatenation is done with the `+` operator.  
```nix
("ab" + "cd")  # Concatenation - "abcd"
```

"Antiquotation" lets you embed values into strings.
* Allows you to insert or embed expressions within string literals.
* This works similarly to bash strings.  
```nix
("Home directory: ${getEnv "HOME"}")
```

## Paths
Nix has its own primitive data type for paths.
```nix
/tmp/learning/learn.nix
```
 
A relative `path` is always resolved into an absolute path when parsed,
relative to the nix file in which it occurs.
```nix
learning/learn.nix
#=> /the-base-path/learning/learn.nix
```

A `path` type must contain at least one slash.
A relative path for a file in the same directory needs a `./` prefix.
```nix
./learn.nix
```
 
The `/` operator needs to be surrounded by whitespace for division.
```nix
7/2        # This is a path literal
(7 / 2)    # This is integer division
```


## Imports
A nix file contains a single top-level expression with no free variables.
An import statement evaluates to the value of the file that it imports.

* You can import with a `path` type:
  ```nix
  (import /tmp/foo.nix)
  ```

* You can also do imports with a `string` type:
  ```nix
  (import "/tmp/foo.nix")
  ```

* Import paths *must* be absolute paths.
  `path` literals are automatically expanded, so this is fine.
  ```nix
  (import ./foo.nix)
  ```

* This does **not** happen with strings.
  ```nix
  (import "./foo.nix")
  # Error: string ‘foo.nix’ doesn't represent an absolute path
  ```
  
  
## `let` Blocks
Using `let` blocks lets you "bind values" to variables (define variables). 

```nix
# `let` blocks allow us to bind values to variables.
(let x = "a"; in
  x + x + x)

# Bindings can refer to each other, and their order does not matter.
(let y = x + "b";
  x = "a"; in
y + "c")
#=> "abc"

# Inner bindings shadow outer bindings.
(let a = 1; in
  let a = 2; in
    a)
#=> 2
```

## Functions
Functions are defined with a colon `:`.
```nix
(n: n + 1)      # Function that adds 1
 
((n: n + 1) 5)  # That same function, applied to 5
#=> 6
```
* `parameter: body`

There is no syntax for named functions, but they
can be bound by `let` blocks like any other value.
```nix
(let succ = (n: n + 1); in succ 5)
#=> 6
```

A function has exactly one argument.
Multiple arguments can be achieved with currying.
```nix
((x: y: x + "-" + y) "a" "b")
#=> "a-b"
```

We can have named function arguments too. See [sets](#sets).  

## Lists
Lists are enclosed in square brackets `[...]`.
Nix uses zero-based indexing.  

```nix
(length [1 2 3 "x"])
#=> 4
 
([1 2 3] ++ [4 5])  # List concatenation - combine lists
#=> [1 2 3 4 5]
 
(concatLists [[1 2] [3 4] [5]])
#=> [1 2 3 4 5]

(head [1 2 3])
#=> 1
(tail [1 2 3])
#=> [2 3]
 
(elemAt ["a" "b" "c" "d"] 2)
#=> "c"

(elem 2 [1 2 3])
#=> true
(elem 5 [1 2 3])
#=> false
 
(filter (n: n < 3) [1 2 3 4])
#=> [ 1 2 ]
```


## Sets
A `set` is an unordered map (dictionary) with `string` keys.  

```nix
# A "set" is an unordered mapping with string keys.
{ foo = [1 2]; bar = "x"; }
 
# The . operator pulls a value out of a set.
{ a = 1; b = 2; }.a
#=> 1
 
# The ? operator tests whether a key is present in a set.
({ a = 1; b = 2; } ? a)
#=> true
({ a = 1; b = 2; } ? c)
#=> false

# The // operator merges two sets.
({ a = 1; } // { b = 2; })
#=> { a = 1; b = 2; }
 
# Values on the right override values on the left.
({ a = 1; b = 2; } // { a = 3; c = 4; })
#=> { a = 3; b = 2; c = 4; }
 
# The rec keyword denotes a "recursive set",
# in which attributes can refer to each other.
(let a = 1; in     { a = 2; b = a; }.b)
#=> 1
(let a = 1; in rec { a = 2; b = a; }.b)
#=> 2

# Nested sets can be defined in a piecewise fashion.
{
a.b   = 1;
a.c.d = 2;
a.c.e = 3;
}.a.c
#=> { d = 2; e = 3; }

# Sets are immutable, so you can't redefine an attribute:
{
a = { b = 1; };
a.b = 2;
}
#=> attribute 'a.b' at (string):3:5 already defined at (string):2:11

# However, an attribute's set members can also be defined piecewise
# way even if the attribute itself has been directly assigned.
{
a = { b = 1; };
a.c = 2;
}
#=> { a = { b = 1; c = 2; }; }
```







* [Understanding Nix Inputs](https://gist.github.com/CMCDragonkai/45359ee894bc0c7f90d562c4841117b5)
* [Why Reproducable Builds](https://reproducible-builds.org) are important
