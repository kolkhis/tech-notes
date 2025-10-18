## Tools

* `hashcat`
* `xxd`
* `base64`
* `openssl enc`
* `hd`
* `gzip -d` / `gunzip`
* `xz`
* `tcpdump`
* `xfreerdp` is for RDP
* `iconv`
* `rev` - reverse a string
* `file` 
* `type`


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



## xxd

`xxd` is used to deicpher hexadecimal text. 

If we had a file that contained a series of hex chars:
```plaintext
4f 6b 2c 20 73 6f 20 79  6f 75 20 6b 6e 6f 77 20
62 61 73 65 31 36 20 41  4b 41 20 68 65 78 2e 2e
2e 0a 0a 42 75 74 20 64  6f 20 79 6f 75 20 6b 6e
6f 77 20 62 61 73 65 34  20 77 68 65 72 65 20 74
68 65 20 34 20 73 79 6d  62 6f 6c 73 20 61 72 65
20 27 2f 27 2c 20 27 2d  27 2c 20 27 5c 27 2c 20
61 6e 64 20 27 7c 27 20  3f 0a 0a 2d 2f 20 5c 2f
20 20 2d 5c 20 2d 2d 20  20 2d 5c 20 7c 2f 20 20
2d 5c 20 7c 2f 0a 2d 5c  20 7c 7c 20 20 2f 5c 20
7c 2f 20 20 2f 5c 20 2f  2f 20 20 2d 2d 20 2d 7c
0a 2d 5c 20 7c 7c 20 20  2d 7c 20 2f 5c 20 20 2d
5c 20 7c 2f 20 20 2d 5c  20 2d 2f 0a 2f 5c 20 2f
2d 20 20 2f 2f 20 5c 5c  20 20 20 20 20 20 20 0a
```

"Revert" it from hexadecimal format by using:
```bash
xdd -r -p ./file.txt
```

- `-r`: Revert from hexadecimal
- `-p`: Convert to a plaintext hex dump


