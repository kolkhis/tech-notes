# Building from Source

The term "build from source" means downloading the source code and compiling it yourself.

Software is usually packaged in an archived format. Commonly `.tar.gz` on Linux, 
or `.zip` on Windows.  

Public-source or open-source repositories can also be cloned directly with Git
without downloading an archived version.  

## Quickref
Options for extracting tarballs:
```bash
tar -xzvf name.tar.gz
tar -xjvf name.tar.bz2
```

* `xvf` for both
* `z` for `.gz`
* `j` for `.bz2`


## Tarballs/Archives

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

- For `.tar.gz` files type:
  ```bash
  tar -xzvf <filename>.tar.gz
  ```

- For `.tar.bz2` files type:
  ```bash
  tar -xjvf <filename>.tar.bz2
  ```

## Compiling the Source Code

First and foremost, use the documentation to determine how to build
from source.  
The compilation instructions are usually included somewhere within the project
repository. 

How you go about compiling the source code into an executable binary depends on
the programming language the tool was written in.  

For many C programs, which many of the GNU coreutils are written in, you'll 
either use `gcc` or `cmake`.  

For example, if we were to compile Bash from source, we'd use `make`.  

First we'd clone the repository (or download it in `.tar.gz` format).  
```bash
git clone git://git.git.savannah.gnu.org/bash.git
```
This gives us the entire git repo for Bash.  

According to the `README` file within the repository, we must run the
`./configure` program, then run `make` to compile bash.  

There is also an `INSTALL` file containing installation instructions for
further instructions, which says to run `make install` after compiling with 
`make` to install Bash and Bashbug.  

```bash
./configure
make
make install
```

Then we've successfully built and installed Bash from its source code.  



