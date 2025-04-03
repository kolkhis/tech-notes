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
    * [List-like Arrays & String Manipulation/Slicing](#list-like-arrays--string-manipulationslicing) 
* [Using `mapfile`](#using-mapfile) 
    * [`mapfile` Examples](#mapfile-examples) 
        * [Using `mapfile` to read file contents into an array](#using-mapfile-to-read-file-contents-into-an-array) 
        * [Using `mapfile` with a custom delimiter](#using-mapfile-with-a-custom-delimiter) 
        * [Processing `MAPFILE` Lines with a Callback](#processing-mapfile-lines-with-a-callback) 
* [Associative Arrays (Dictionaries)](#associative-arrays-dictionaries) 
    * [Creating an Associative Array in Bash](#creating-an-associative-array-in-bash) 
    * [Using Associative Arrays](#using-associative-arrays) 
    * [Parameter Transformations on Dictionaries](#parameter-transformations-on-dictionaries) 
* [Check if an Element Exists in an Array](#check-if-an-element-exists-in-an-array) 
    * [Using an Associate Array to Check if Element Exists](#using-an-associate-array-to-check-if-element-exists) 
    * [Using a Loop to Check if Element Exists](#using-a-loop-to-check-if-element-exists) 
* [Getting a List of Files in an Array](#getting-a-list-of-files-in-an-array) 
    * [Filename Array Using `read`](#filename-array-using-read) 
    * [Filename Array Using `mapfile`](#filename-array-using-mapfile) 


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


## Using `mapfile` 
```bash
mapfile [-d delim] [-n count] [-O origin] [-s count] [-t] [-u fd] [-C callback] [-c quantum] [ARRAY_NAME]
```

Read lines from the standard input into the indexed array variable `array_name`, or from 
file descriptor `FD` if the `-u` option is given.

The variable `MAPFILE` is the default `array_name`.

Options:
* `-d delim`: Use `DELIM` to terminate lines, instead of a newline.  
* `-n count`: Copy at most `COUNT` lines.  If `COUNT` is `0`, all lines are copied
* `-O origin`: Begin assigning to `array_name` at index `ORIGIN`.  The default index is 0.  
* `-s count`: Discard (skip) the first `COUNT` lines read
* `-t`: Remove a trailing `DELIM` from each line read (default is newline).  
* `-u fd`: Read lines from the file descriptor `fd` instead of `stdin`.  
* `-C callback`: Evaluate `CALLBACK` each time `QUANTUM` lines are read
* `-c quantum`: Specify the number of lines read between each call to `CALLBACK`

Arguments:
* `array_name`: Array variable name to use for file data

If not supplied with an explicit origin, mapfile will 
clear `array_name` before assigning to it.

Exit Status:
Returns success unless an invalid option is given or ARRAY is readonly or
not an indexed array.

---
### `mapfile` Examples

#### Using `mapfile` to read file contents into an array:
* You have a file called `lines.txt`:
  ```plaintext
  line one
  line 2
  line 3.
  ```
* Pass this file (as `stdin`) to the `mapfile` command:
  ```bash
  mapfile -t my_array < lines.txt
  ```
    * `-t`: This will remove any trailing newlines from each line.  
* The `my_array` variable now contains the lines of the file.  
  ```bash
  echo "${my_array[0]}"  # line one
  echo "${my_array[1]}"  # line 2
  echo "${my_array[2]}"  # line 3.
  ```

---

#### Using `mapfile` with a custom delimiter:
* You can specify a delimiter with `-d`.
  ```bash
  echo "apples;oranges;bananas;" | mapfile -d ';' -t fruits
  ```
    * `-t` here removes the semicolons.  
* Access the elements in the array:
  ```bash
  echo "${fruits[0]}"  # apples
  echo "${fruits[1]}"  # oranges
  echo "${fruits[2]}"  # bananas
  ```

#### Processing `MAPFILE` Lines with a Callback
Using `-C`, you can specify a callback to process text.  
```bash
callback_function() {
    echo "Line index: $1"
    echo "Line content: $2"
}
echo -e "one;two;three;" | mapfile -d ';' -C callback_function -c 1 -t
```
* `-d ';'`: This sets the delimiter as a semicolon.  
* `-C callback_function`: Sets the callback function to use.  
    * This passes both the index and the contents of the current line for each call 
      (e.g., `$1 == 0` on the first call).  
    * `$1`: The index of the line (starting from zero).  
    * `$2`: The contents of the line itself.  
* `-c 1`: Says to execute the callback function on every single line.  
    * If you don't specify a count, it will default to `5000`.  
* Since no `array_name` was specified, the array is saved into the `MAPFILE` variable.  


## Associative Arrays (Dictionaries)
Bash supports the use of associative arrays, or dictionaries, with key/value pairs.  

### Creating an Associative Array in Bash
You need to declare a dictionary with `declare -A array_name`.  
```bash
declare -A PORTS
PORTS=(
    [SSH]="22"
    [HTTP]="80"
)
```
The brackets `[]` in the keys are mandatory.  
The keys inside the brackets don't have to be quoted, but they can be.  

### Using Associative Arrays
Access single values with their keys:
```bash
printf "SSH port: %s\n" "${PORTS['SSH']}"
# output:
# SSH port: 22
```

To access all the values of the dictionary:
```bash
printf "%s\n" "${PORTS[@]}"
# output:
# 22
# 80
```
Calling `[@]` as the index will pull only the values.  

To access the keys or indices of the dictionary:
```bash
printf "%s\n" "${!PORTS[@]}"
# output:
# SSH
# HTTP
```
Using `!` before the dictionary name tells it to use only the keys.  
When doing this on normal arrays, it will output the indices (`0, 1, 2`, etc).  

To loop over a dictionary and access both keys and values:
```bash
for idx in "${!PORTS[@]}"; do
    printf "Port for %s: %s\n" "$idx" "${PORTS[$idx]}"
done
# output:
# Port for SSH: 22
# Port for HTTP: 80
```

### Parameter Transformations on Dictionaries

You can only **directly** do parameter transformations on **values** of dictionaries, not keys.  
Transform values individually:  
```bash
printf "Ports quoted: %s\n" "${PORTS[@]@Q}"
# Ports quoted: '22'
# Ports quoted: '80'
```
Adding `@Q` to `[@]` will quote all the values individually.  
If you want to combine all values into one string, use `[*]` instead of `[@]`.  

If you tried to do the same for the keys:
```bash
printf "Port names quoted: %s\n" "${!PORTS[@]@Q}" # error
```
You'd get an error.  
However, you can get around this by using a `for` loop:
```bash
for idx in "${!PORTS[@]}"; do
    printf "Key quoted: %s\n" "${idx@Q}"
done
# output:
# Key quoted: 'SSH'
# Key quoted: 'HTTP'
```

## Check if an Element Exists in an Array
You'll have to use a loop or associative array if you want to check if an element
exists in an array.  

### Using an Associate Array to Check if Element Exists
This is the faster method.  
```bash
# Create the array
declare -A COMPLETED
something="Let's check for this"
# Add something to the array
COMPLETED[something]=true
if "${COMPLETED[something]}"; then
    printf "element exists\n"
else
    printf "Element doesn't exist\n"
fi
```

### Using a Loop to Check if Element Exists
Slower but still works.  
```bash
for item in "${ARRAY[@]}"; do
    if [[ $item == "the thing you're checking for" ]]; then
        printf "Element exists\n"
    else
        printf "Element doesn't exist\n"
    fi
done
```

###### See [parameter transformation](./parameter_transformation.md) for a full list of options.  


## Getting a List of Files in an Array
One way to get a list of files into an array is using the `read` command along with
process substitution.  

Declare the array variable.  
```bash
declare -a FILES
```

### Filename Array Using `read`
Then use `read` with a process substitution:
```bash
IFS=$'\n' read -r -d '' -a FILES < <(find . -name '*.md')
```
- `IFS=$'\n'`: Set `IFS` to newline. This is how it will split the elements.
    - If the elements are space-delimited, you can set `IFS` to a space, which is the
      default.  
- `read -r -d '' -a FILES`: 
    - `read -r`: Handle escape sequences properly.  
    - `-d ''`: The delimiter for the array - set to a blank string.  
        - This makes it read to EOF instead of the first newline. 
        - Without this you'd only get the first filename.  
    - `-a FILES`: Save in the the `FILES` array.  
- `< <(find . -name '*.md')`: Directing a process substitution to get the list of files.  

### Filename Array Using `mapfile`
This method uses `mapfile`, and it's friendlier to filenames that contain newlines or
spaces.  
```bash
declare -a FILES
mapfile -d '' -t FILES < <(find . -name '*.md' -print0)
for FILE in "${FILES[@]}"; do
    printf "File: %s\n" "$FILE"
done
```
- `mapfile`: Reads input and indexes it into an array.  
  - `-d ''`: Use a null character to delimit strings.
    - This is necessary since `-print0` separates the filenames with a NULL byte (`\0`).  
  - `-t`: Strips the trailing delimiters (NULL bytes) from files before storing them.  
  - `FILES`: The array name.  
  



