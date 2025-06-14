# Building from Source

The term "build from source" means downloading the source code and compiling it yourself.

## Table of Contents
* [Quickref](#quickref) 
* [Tarballs](#tarballs) 
* [Download the Source Code](#download-the-source-code) 
    * [Extracting an Archive](#extracting-an-archive) 

## Quickref
Options for extracting tarballs:
```bash
tar -xzvf name.tar.gz
tar -xjvf name.tar.bz2
```

* `xvf` for both
* `z` for `.gz`
* `j` for `.bz2`


## Tarballs

Typically, open-source programs are shipped in a `.tar.gz` format.  

A `.tar.gz` file or `.tar.bz2` file is a *compressed* tarball.  

* E.g., `program.tar.gz` is a tarball that was compressed with `gzip`.  
* The uncompressed extension of a tarball would be `.tar`.  

The tarball contains the source code for an application.  

### Creating your Own Tarball

Create a tarball using the `tar` command with the `-czf` options.  
```bash
tar -czf my-project.tar.gz ./my-project/
```

- `-czf`
    - `-c`: Creates a new archive.  
    - `-z`: Specify that you want to use `gzip` to compress it.  
    - `-f`: Specify the output file
- `./my-project/`: The directory you want to create an archive from.  

## Download the Source Code

You found a program you want.  

Find the source code for it (possibly under github's releases) and find the tarball.  


### Extracting an Archive

* For `.tar.gz` files type:
```bash
tar -xzvf <filename>.tar.gz
```

* For `.tar.bz2` files type:
```bash
tar -xjvf <filename>.tar.bz2
```

