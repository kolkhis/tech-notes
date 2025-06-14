# tar

The `tar` tool is used to create or extract archives.  

An archive created with `tar` is usually called a "tarball."  

## Creating a Tarball

Create a tarball using the `tar` command with the `-czf` options.  
```bash
tar -czf my-project.tar.gz ./my-project/
```

- `-czf`
    - `-c`: Creates a new archive.  
    - `-z`: Specify that you want to use `gzip` to compress it.  
    - `-f`: Specify the output file
- `./my-project/`: The directory you want to create an archive from.  

## Extracting a Tarball

Extract a tarball using `tar` with the `-xzf` options.  
```bash
tar -xzf ./something.tar.gz
```
This will extract the tarball and dump the files into your current working directory.  

> Note that it's usually a good idea to make a new directory before doing this, as some
> people will create their archives in such a way that all the files are at the
> top-level of the archive (no subdirectory). These are referred to as "tarbombs."    

```bash
mkdir something
mv ./something.tar.gz ./something && cd ./something
tar -xzf ./something.tar.gz
```





