
# yq - YAML Querying Tool

`yq` is a YAML processing tool for the command-line.  
See the [repository from mikefarah](https://github.com/mikefarah/yq)  


## Deep Compare of two YAML Files 
To do a deep compare of two yaml files, you need to get rid of the comments and sort the keys.

```bash
yq "sort_keys(..)" -P file1.yaml > formatted_file1.yaml
yq "sort_keys(..)" -P file2.yaml > formatted_file2.yaml
diff formatted_file1.yaml formatted_file2.yaml
```
or
```bash
diff <(yq "sort_keys(..)" -P file1.yaml) <(yq "sort_keys(..)" -P file2.yaml)
```

* `"sort_keys(..)"`: Recursively sorts the keys.   
    * `"sort_keys(.)"` sorts only the top-level keys in the file.  
* `-P`/`--prettyPrint`: Pretty-print the output. Removes comments.  
This also removes the `null` values.  



