
# Arrays in Bash  

## Table of Contents
* [Declaring an Array in Bash](#declaring-an-array-in-bash) 
* [Defining an Array in Bash](#defining-an-array-in-bash) 
* [Adding Elements to an Array](#adding-elements-to-an-array) 
* [Reassigning a Value in an Array](#reassigning-a-value-in-an-array) 
* [Retrieving Elements from an Array](#retrieving-elements-from-an-array) 
    * [Retrieving a Single Element in an Array](#retrieving-a-single-element-in-an-array) 
    * [Retrieving a Range of Elements from an Array](#retrieving-a-range-of-elements-from-an-array) 
    * [Retrieving all Elements in an Array](#retrieving-all-elements-in-an-array) 
* [Get the Index of an Element in an Array](#get-the-index-of-an-element-in-an-array) 
* [Looping over an Array in Bash](#looping-over-an-array-in-bash) 
* [Quickref](#quickref) 
    * [List-like Arrays & String Manipulation/Slicing](#list-like-arrays-&-string-manipulation/slicing) 

## Declaring an Array in Bash  

Arrays in Bash can be declared with the `declare` keyword:  
```bash  
declare -a ARRAY_NAME  
```
* The `-a` flag indicates that the variable is an array.  


## Defining an Array in Bash
Define an array by passing in elements inside parentheses, separated by spaces:
```bash
MY_ARRAY=("Item 1" "Item 2" "Item 3")
```

## Adding Elements to an Array  
The `+=` operator is a "compound assignment operator."  
This means that it compounds the `+` and `=` operators.  

Elements can be added to an array with the `+=` operator:  
```bash  
MY_ARRAY+=("element")  
# or
MY_ARRAY=("${MY_ARRAY[@]}" "element")
```
* Note the parentheses `( )` around the element.  
* This is necessary when appending elements to an array.  


## Reassigning a Value in an Array
Arrays in bash are mutable.  
Reassign a value in an array like you would in any other language:
```bash
MY_ARRAY[0]="New Value"
```


## Retrieving Elements from an Array
### Retrieving a Single Element in an Array  
Bash arrays are zero-indexed.

Use the syntax `[n]` to retrieve a single element from 
an array (where `n` is the index of the element):
```bash
printf "First element: %s\n" "${MY_ARRAY[0]}"
```

### Retrieving a Range of Elements from an Array
Bash supports slicing syntax to retrieve a range of elements from an array.
Slicing syntax is similar to Python's slicing syntax.  
```bash
printf "First three elements:\n"
printf "%s\n" "${MY_ARRAY[0:3]}"
# or: 
printf "%s\n" "${MY_ARRAY[@]:0:3}"
```
* This will call `printf`'s `%s` three times, once for each element passed in.  
* The third `printf` uses the syntax `"${ARR[@]:start:length}"`.
    * The `@` operator indicates that we're passing in the whole array.  
    * The `start` and `length` parameters indicate the range of elements to retrieve.
        * `start`: Starting index
        * `length`: Number of elements to retrieve (moving forward from `start`)


### Retrieving all Elements in an Array
See `man://tmux 1200`

Use the `@` operator to retrieve all of the elements in an array: 
```bash
printf "This will print all the elements of the array:\n"
printf "%s " "${MY_ARRAY[@]}"   # Output as a space-separated list
```

This command expands to `printf '%s, ' 1 2 3 4 5 Six Seven`
In this case, since the whole array is being passed in, the format 
specifier `%s` will be called once for each element in the array.  

This is useful for formatting data, since you can format it 
as CSV, TSV, or any other format.  
```bash
printf "%s," "${MY_ARRAY[@]}"   # Output as a comma-separated list
printf "%s\n" "${MY_ARRAY[@]}"  # Output as a newline-separated list
```

---

Something similar can also be done with the `*` operator:
```bash
printf "%s " "${MY_ARRAY[*]}"
```
This command expands to `printf '%s, ' '1 2 3 4 5 Six Seven'`.  
In this case, `%s` will only be called once, using
the string `'1 2 3 4 5 Six Seven'`.  
* Note the quotes around the elements.
* The `*` operator combines all elements into a single string.
* This means that formatting as CSV, TSV, etc., is not possible.


## Get the Index of an Element in an Array 
See `man://tmux 1220`
To get the index of an element in an array, use the `!` operator:
```bash
declare -a IDX
IDX="${!MY_ARRAY[@]}"
```




## Looping over an Array in Bash
Loop over an array in bash with a `for` loop, using the syntax `"${ARRAY_NAME[@]}"`:
```bash
for item in "${MY_ARRAY[@]}"; do
    printf "Item: %s\n" "$item"
done
```
* The `@` is a special variable that tells the array to return all of 
  it's elements, separated by spaces.

You can also loop over the keys (indexes) of an array:
```bash
for idx in "${!MY_ARRAY[@]}"; do
    printf "Index: %d - Item: %s\n" "$idx" "${MY_ARRAY[$idx]}"
done
```






## Quickref
### List-like Arrays & String Manipulation/Slicing  
```bash  
Fruits=('Apple' 'Banana' 'Orange')  
Fruits[0]="Apple"  
Fruits[1]="Banana"  
Fruits[2]="Orange"  
echo "${Fruits[0]}"           # Element #0  
echo "${Fruits[-1]}"          # Last element  
echo "${Fruits[@]}"           # All elements, space-separated  
echo "${Fruits[*]}"           # All elements in one string, space-separated  
echo "${#Fruits[@]}"          # Number of elements  
echo "${#Fruits}"             # String length of the 1st element  
echo "${#Fruits[3]}"          # String length of the Nth element  
echo "${Fruits[@]:3:2}"       # Range (from position 3, length 2)  
echo "${!Fruits[@]}"          # Keys of all elements, space-separated  

Fruits=("${Fruits[@]}" "Watermelon")    # Push      (Append)
Fruits+=('Watermelon')                  # Also Push (Append) 
Fruits=( "${Fruits[@]/Ap*/}" )          # Remove by regex (pattern?) match  
unset Fruits[2]                         # Remove one item  
Fruits=("${Fruits[@]}")                 # Duplicate  
Fruits=("${Fruits[@]}" "${Veggies[@]}") # Concatenate  
lines=(`cat "logfile"`)                 # Read from file  
lines=("$(cat "logfile")")              # Read from file  
read -r -d '' -a lines < "logfile"      # Read from file

for val in "${arrayName[@]}"; do        # Iterating over an array (values)
  echo "$val"  
done  

for idx in "${!arrayName[@]}"; do       # Iterating over an array (indexes/keys)
  echo "$idx" "${arrayName[$idx]}" 
done  
```

