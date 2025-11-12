# `curl` and `wget`

The tools `curl` and `wget` are used to sent HTTP requests to remote endpoints.
 
They can both be used to download files from the internet, and in most cases
that's their primary use.  

- `curl` is a versatile command-line tool for sending HTTP requests. It can be
  used to download files and interact with web APIs.  

- `wget` is exclusively a tool for downloading files from the internet.
    - It's mostly useful for downloading large numbers of files, for when `curl` is too
      cumbersome.  


## Basic `wget` Usage
```bash
# Download file.txt, save it locally as file.txt
wget https://example.com/file.txt  

# Download and save the file to remote_file.txt
wget -O remote_file.txt https://example.com/file.txt 

# Fetch a script, print to stdout, and pipe it to sh (doesn't save the file)
wget -O- https://example.com/script.sh | sh - 
```

## Basic `curl` Usage
```bash
# Fetch the contents of file.txt, print to stdout
curl https://example.com/file.txt     

# Same as above, but follow any redirects
curl -L https://example.com/file.txt  

# Download file.txt, save it to a file with the same name (file.txt)
curl -O https://example.com/file.txt  

# Same as above, follow redirects
curl -LO https://example.com/file.txt 

# Download file.txt and save it to output.txt
curl -o output.txt https://example.com/file.txt 

# Quietly fetch and run a script by piping it to sh
curl -fsSL https://example.com/script.sh | sh - 
```

When we need **only** the *exact* output of the endpoint file (e.g.,
`script.sh`), we need to use the `-fsSL` options.  

This effectively silences any extraneous stdout and stderr if the command is
successful and passes only the output of the endpoint.  

This is important when using `curl` in pipelines. 

### Common `curl` Options

- `-f`: Fail silently on HTTP errors  
- `-s`: Silent mode (no progress meter or error messages)  
- `-S`: Show errors even when `-s` is used  
- `-L`: Follow redirects  
- `-O`: Write output to a file using the remote filename  
- `-o <file>`: Write output to a specific file  
- `-C -`: Resume a partially downloaded file  
- `-I`: Fetch HTTP headers only (like `HEAD` request)  
- `-X`: Specify HTTP method (e.g. `-X POST`)  
- `-d`: Send POST data  
- `-H`: Add custom headers  
- `-u`: HTTP authentication (e.g. `-u user:pass`)  

## `wget` Examples

As stated above, `wget` shines when you need to download a large number of
files from the internet.  

`curl` can accomplish the same thing, but it's much more cumbersome for this
purpose, and maybe a little less user-friendly.  

### Example: Fully Caching a Website

This will fully cache a website locally in the given directory.  
It will recursively download all files available at the website's location,
excluding parent directories.
```bash
wget \
     --mirror \
     --convert-links \
     --page-requisites \
     --no-parent \
     --adjust-extension \
     -P "$CACHE_DIR" \
     "$URL"
```

- `--mirror`: Recursive. 
    - Shortcut for `-r`, `-N`, `-l inf` `--no-remove-listing`.
- `--convert-links`: Adjusts the HTML so links point to local files
- `--page-requisites`: Downloads images, CSS, JS, etc.
- `--no-parent`: Doesn’t follow links to parent directories.
- `--adjust-extension`: This will add file extensions to correctly match their file
  types. 
    - E.g., if an HTML file doesn't have a `.html` file extension, it will be
      added.
    - This is useful when serving locally, to avoid ambiguous MIME types.
- `-P`:  Destination directory (`$CACHE_DIR`)
- `$URL`: The URL to download from.

## `curl` Examples

### Query an Endpoint with `curl`

One very common and useful use of `curl` is to test queries to web API
endpoints.  

Learning `curl` will allow us to ditch any external applications that were
built for querying/testing web APIs (e.g., Postman).  

We can use `-X` to specify a specific HTTP method to use (defaults to `GET`),
in conjunction with `-H` to specify HTTP headers.    

```bash
curl -X GET -H "Accept: application/json" https://api.github.com/users/octocat
```

This will fetch the Octocat user's GitHub profile from the GitHub API and
output in JSON format.  

!!! note

    The `-X GET` here is unnecessary, since that is the default behavior, but
    it's just there as an example.  

We can also use the POST HTTP method.  

Say we need to use POST to send data into an API.  
```bash
curl -X POST -H "Content-Type: application/json" \
    -d '{"name": "Connor", "job": "sysadmin"}' \
    https://api.example.com/post
```
This will send a POST request to `https://api.example.com/post`, with the JSON
data specified in the argument to `-d`.  







