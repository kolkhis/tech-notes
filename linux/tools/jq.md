# `jq`


`jq` is a tool for processing JSON data. It is an essential tool to learn.  
It's a command line tool that allows you to query and transform JSON data.  

It's described as a `sed`/`awk`/`grep` for JSON.  
This is the preferred tool for manipulating JSON in the terminal.  


## Quickref
```bash
jq '.' data.json        # Pretty-print 
jq '.key' data.json     # Extract values with the given .key
jq '.[] | select(.key > value)' # Filter based on conditions
```

* `.[]`: Used to iterate over each element of an array.




## `jq` Installation

* [Source](https://github.com/jqlang/jq?tab=readme-ov-file#installation)

Most Linux distributions have `jq` available via their package managers.  

Debian-based:  
```bash
apt-get install jq
```
RedHat-based:  
```bash
dnf install jq
```
For Windows:
```bash
choco install jq
scoop install jq
winget install jq
```


### Running `jq` as a Container
There's a container image available for `jq` stored on GitHub.  

Extracting the version from a `package.json` file with a mounted volume:
```bash
podman run --rm -i -v "${PWD}:${PWD}" -w "${PWD}" ghcr.io/jqlang/jq:latest '.version' package.json
```

## `jq` Basics

* `.` (dot): The identity operator. Stands for the current input when used by itself.  
* `--arg val 123`: Pass a value into `jq`.
    * This creates the `$val` variable, and assigns its value as `123`.  
* `--argjson val 123`: Pass a JSON value to `jq`.  
    * This creates a JSON object `{ "val": 123 }`


### Pipe json data to `jq` to pretty-print it
```bash
echo '{"name": "Alice", "age": 30}' | jq
```

### Extracting Specific Fields
Extract specific fields using the `.` operator.
```bash
echo '{"name": "Alice", "age": 30}' | jq '.name'
```
`.name` extracts the value whose key is called `"name"`.  

### Extracting Nested Fields
Get the values of nested fields by using more `.` operators. 
```bash
echo '{"person": {"name": "Alice", "age": 30}}' | jq '.person.name'
```
`.person.name` goes into the value with the `person` key, `.name` gets the value 
inside `"person"` whose key is called `"name"`.  

### Read JSON From a File
```bash
jq '.' data.json
```
This reads from `data.json` and applies the filter `'.'`, which just outputs the
entire json object.  

### Save `jq` Output to a File
Just use a redirection to save output to a file.  
```bash
echo '{"name": "Alice", "age": 30}' | jq '.' > output.json
```

## Filtering Arrays
Using this json:
```json
[
  {"name": "Alice", "age": 30},
  {"name": "Bob", "age": 25},
  {"name": "Charlie", "age": 35}
]
```
If we want to filter people over `30`:

```bash
jq '.[] | select(.age > 30)'
```
TODO: Get explanation of `'.[]'`



---

## Transforming JSON with `jq`
```bash
echo '{"name": "Alice", "age": 30}' | jq '{fullName: .name, years: .age}'
```
This results in the output:
```json
{
    "fullName": "Alice",
    "years": 30
}
```
So the key `name` is changed to `fullName`, and `age` turns to `years`.  

## Count the Elements in an Array
```bash
echo '[1, 2, 3, 4, 5]' | jq 'length'
# Output: 5
```

## Merge two JSON Objects
```bash
echo '{"name": "Alice"} {"age": 30}' | jq -s '.[0] + .[1]'
```
This results in the output:
```json
{
    "name": "Alice",
    "age": 30
}
```



## `jq` Flags/Options

* `--arg val 123`: Pass a value into `jq`.
    * This creates the `$val` variable, and assigns its value as `123`.  
* `--sort-keys`/`-S`: Outputs the object with sorted keys.  
* `-n`: Don't ready any input, use `null` as the input. 
* `-s`/`--slurp`: Instead of filtering each json object, read the entire input stream into an array and filter that.  
* `-R`/`--raw-input`: Don't parse the input as JSON, parse as a string.  
    * If `-R` and `-s` are combined, it passes the whole input as a single string.  
* `-c`/`--compact-output`: Don't pretty-print the output.  
* `--tab`: Use tabs for indentation instead of 2 spaces.  
* `--indent n`: Use the given number of spaces `n` for indentation.  
* `-C`/`--color-output`: Force color output, even when writing to a pipe or file.  
* `-M`/`--monochrome-output`: Disable color output.  
* `-a`/`--ascii-output`: Force output to be pure ASCII, instead of Unicode.  
    * Use this to expand escape sequences.  




## `jq` Learning Resources

* [Official Documentation](https://github.com/jqlang/jq)
* [jq Online Playground](https://jqplay.org/)
* [Learn `jq` in Y Minutes](https://learnxinyminutes.com/docs/jq/)
* [jq manual](https://jqlang.github.io/jq/manual/)
* [jq cheat sheet](https://gist.github.com/olih/f7437fb6962fb3ee9fe95bda8d2c8fa4)

