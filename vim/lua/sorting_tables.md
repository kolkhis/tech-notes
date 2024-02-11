
# Sorting Tables in Lua

The crux of the problem is that Lua tables are not implicitly ordered.

However, Lua does come with a `table.sort` function.


## Table of Contents
* [Using `table.sort`](#using-`table.sort`) 
* [Making your own sorting rules](#making-your-own-sorting-rules) 
* [Sorting tables in descending order](#sorting-tables-in-descending-order) 
* [Sorting tables in ascending order](#sorting-tables-in-ascending-order) 
* [Sorting Tables in Lua](#sorting-tables-in-lua) 
* [Example Table](#example-table) 
    * [Syntax](#syntax) 


## Using `table.sort`

This function works very well on dictionaries with numbered keys.  

Sorts table elements in a given order, `in-place`, from `table[1]` to
`table[n]`, where `n` is the length of the table (see |lua-length|).

### Syntax

You cannot call `sort` as a method (i.e., `my_table:sort()`).  
You must explicitly call `table.sort(my_table)`

```lua
table.sort({table} [, {rules}])
```

As an optional second argument, you can pass a function that determines your own sorting rules.  

## Making your own sorting rules

The second (optional) argument should take two table elements and returns a boolean value.

It must be a function that receives two table elements, and returns `true` when
the first is less than the second:
```lua
function(a, b) return a < b end
```

## Example Table
As an example table, we'll use a table of players and their levels:
```lua
local players = {
    {name = "Jeff", level = 10},
    {name = "Bob", level = 15},
    {name = "Jane", level = 12},
    {name = "Jill", level = 10},
}
```

## Sorting tables in ascending order
Sort a table in ascending order by using the less-than (`<`) operator.  

Now we can sort the table by comparing the `level` field in the 
second argument to `table.sort`:
```lua
table.sort(players, function(a, b) return a.level < b.level end)
```
This sorts it in **ascending** order, because we're using the less-than `<` operator.


## Sorting tables in descending order
Sort a table in descending order by using the greater-than operator (`>`), 
reversing the comparison.

To sort it in **descending** order, we can change the comparison to be greater-than (`>`):
```lua
table.sort(players, function(a, b) return a.level > b.level end)
```




