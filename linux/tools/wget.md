# wget
wget is a tool for downloading files from the internet.

It's mostly useful for downloading large numbers of files, for when `curl` is too
cumbersome.  


## Basic Usage
```bash
wget https://example.com/file.txt  # Download file.txt
wget -O remote_file.txt https://example.com/file.txt # save the file to remote_file.txt
```



## Example: Fully Caching a Website
This will fully cache 
```bash
wget \
     --mirror \
     --convert-links \
     --page-requisites \
     --no-parent \
     -P "$CACHE_DIR" \
     "$URL"
```
* `--mirror`: Recursive. 
    - Shortcut for `-r`, `-N`, `-l inf` `--no-remove-listing`.
* `--convert-links`: Adjusts the HTML so links point to local files
* `--page-requisites`: Downloads images, CSS, JS, etc.
* `--no-parent`: Doesn’t follow links to parent directories
* `-P`:  Destination folder (`$CACHE_DIR`)
* `$URL`: The URL to download from.


