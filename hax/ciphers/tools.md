## Tools

* hashcat
* xxd
* base64
* openssl enc
* hd
* gunzip
* xz
* tcpdump
* `xfreerdp` is for RDP
* ... What else?

### Hashcat searching
When trying to find a hash, search for it.  
The format is `hashcat -m <somenumber>` where `<somenumber>` is the type of hash  
```bash
hashcat --help | grep AS-REP gives 18200
```

### Stuff to look up
* Converting octal to decimal (or binary)



## gzip  
* Having `H4sI` at the beginning of a string suggests that it is Base64-encoded, 
gzip compressed data. 
    * This is recognized from the gzip magic number (`1F 8B` in hex) which 
      is translated to `H4sI` in Base64.
```bash
gzip file
gzip -d file
```
* When compressing, each file is replaced by one with the extension `.gz`.
    * By default, `gzip` keeps the original file name and timestamp in the compressed file.
    * By default, keeps the same ownership modes, access and modification times.
        * These are used when decompressing the file with the `-N` option.

* gzip uses the `.tgz` extension if necessary instead of truncating a file with a `.tar` 

### gunzip / gzip -d  
`gunzip` can currently decompress files created by:  
* `gzip`
* `zip`
* `compress`
* `compress -H` 
* `pack`.  

Files created by `zip` can be uncompressed by `gzip` only if they have a single 
`member` compressed with the 'deflation' method.  

`zcat` is identical to `gunzip -c`.

```bash
gunzip file1 file2
gzip -d file
```

* gunzip takes a list of files
    * It will only affect files with the suffixes: `.gz`, `-gz`, `.z`, `-z`, or `_z`
        * They should also begin with the correct "magic number" (file format/data type)
        * This means that it should be gzip compressed data.
    * gunzip also recognizes  `.tgz` and `.taz` as `.tar.gz` and `.tar.Z` respectively.
* It will decompress them and replace each file with its decompressed data.

To extract a zip file with a single member, use a command like  
```bash
gunzip gunzip -S .zip foo.zip 
# or
gunzip <foo.zip .zip foo.zip.
```






