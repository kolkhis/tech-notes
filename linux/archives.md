# Working with Archives

A lot of software packages will typically come in an archive file.  

Archives are either compressed files (single file compression), archive containers
(e.g., `.tar` files), or **both** (`.tar.gz`, `.tar.bz2`, etc.).  

More often than not, you'll see a compressed archive container (`.tar.gz`).  

## Creating Archives and Unarchiving 

There are a few different formats.  

- `.gz`: Gzip file.  
    - `gzip` is a compression utility, not an archiving utility.
    - Compression is often used in conjunction with archives to make the file smaller.  
- `.tar`: Tar archive file.  
- `.tar.gz`: Tar archive file compressed with `gzip`.  
    - Sometimes represented as `.tgz` 

```bash
# Modern GNU tar options. This works for files compressed
# with gzip and bzip too
tar --extract --file filename

# Same as above
tar -xf filename

# Same as above. The leading dash is optional
tar xf filename

# explicitly decompress gzip2-compressed file then
# pass uncompressed result directly into tar
gzip -cd filename.tgz | tar xf -

# same as above, but for bzip2-compressed files
bunzip2 -cd filename.tar.bz2 | tar xf -
```

## Compression Formats

### `.gz` (`gzip`)
Gzip is a fast compression utility, but it doesn't have a great compression ratio.  
It's usually good for most things and is widely used.  

#### Using `gzip`
- Compress a file with `gzip` by simply passing it as an argument.  
  ```bash
  gzip filename
  ```
  This creates a `filename.gz` file, a compressed version of `filename`.  

- Decompress a file with `gzip` either with `gzip -d` or `gunzip`
  ```bash
  gzip -d filename.gz
  gunzip filename.gz
  ```

- View `gzip` compressed files as a stream with `zcat` and `zless`.  
  ```bash
  zcat filename.gz
  zless filename.gz
  ```
  These act the same way as `cat` and `less`.  

### `.bz2` (`bzip2`)

Bzip2 is a compression utility. It's slower than `gzip` but has a better compression ratio.  


#### Using `bzip2`

- Compress a file with `bzip2` by passing it as an argument.  
  ```bash
  bzip2 filename
  ```
  This creates a `filename.bz2` file.  

- Decompress a `.bz2` file with either `bzip2 -d` or `bunzip2`.  
  ```bash
  bzip2 -d filename.bz2
  bunzip2 filename.bz2
  ```

### `.xz` (`xz`)

XZ is a compression utility that has a high compression ratio, but it's even slower 
than `bzip2`.  

#### Using `xz`

- Compress in the same way as the other tools.  
  ```bash
  xz filename
  ```
  Creates a `filename.xz` file.  

- Decompress with either `xz -d` or `unxz`.  
  ```bash
  xz -d filename.xz
  unxz filename.xz
  ```

### `.zst` (Zstandard/`zstd`)

Zstandard (`zstd`) is a compression utility that is both fast *and* has a good
compression ratio.  

Drawback: It's backed by Facebook.  

#### Using `zstd`

- Compress a file with `zstd`:  
  ```bash
  zstd filename
  ```
  This create a `filename.zst` file.  

- Decompress a file with `zstd -d` or `unzstd`.  
  ```bash
  zstd -d filename.zst
  unzstd filename.zst
  ```

### `.lzma` and `.lz`
These are legacy formats that were replaced by `.xz`. 

But, if you have to work with them:
```bash
lzma filename        # Compress
unlzma filename.lzma # Decompress
```

## Archive Container Formats

### `.tar` (Tape Archive)

The `tar` command creates archive files, which bundles multiple files into a single
file. There is no compression used by default.  

#### Using `tar`

- Create a `.tar` archive with `tar -c` and specify an output file with `-f`.  
  ```bash
  tar -cf archive.tar file1 file2 dir1/
  ```
  This bundles `file1`, `file2`, and `dir/` (and all its contents) into the
  `archive.tar` archive.  
    * By default, archives are not compressed.  
    * You can use the `-z` option to automatically use `gzip` to compress your archive.  
    * You can use the `-J` option to automatically use `xz` to compress your archive.  

- Extract an archive with `tar -x` and specify an input file with `-f`.  
  ```bash
  tar -xf archive.tar
  ```



```bash
tar -czf archive.tar.gz folder/
# -c: create archive
# -z: use gzip
# -f: filename to create (archive.tar.gz)

tar -xJf archive.tar.xz
# -x: extract
# -J: use xz
# -f: archive file name
```

### `.zip`
The `.zip` format is a cross-platform archive format.  
Supports compression and multi-file archiving.  

- Create an archive with `zip`:
  ```bash
  zip archive.zip file1 file2 dir/
  ```
  This bundles `file1`, `file2`, and `dir/` into `archive.zip`.  

- Extract an archive with `unzip`.  
  ```bash
  unzip archive.zip
  ```

### `.rar`

This is a **proprietary** archive format.  

- You **can not** create a `.rar` file without `rar`, which is **not free**.  

- Extracting a `.rar` requires the `unrar` package.  
  ```bash
  unrar x archive.rar
  ```


### `.7z` (7zip)

The `.7z` format has a high compression ratio and requires the `p7zip` or `7zip`
package to use.  

- Create a `.7z` archive with `7z a`.
  ```bash
  7z a archive.7z file1 dir/
  ```
  This creates `archive.7z` with the files given.  

- Extract a 7zip archive with `7z x`.  
  ```bash
  7z x archive.7z
  ```

---

## tl;dr

```bash
# Create
tar -czf foo.tar.gz dir/          # gzip
tar -cjf foo.tar.bz2 dir/         # bzip2
tar -cJf foo.tar.xz dir/          # xz
tar --zstd -cf foo.tar.zst dir/   # zstd
zip -r foo.zip dir/               # zip
7z a foo.7z dir/                  # 7zip

# Extract
tar -xzf foo.tar.gz
tar -xjf foo.tar.bz2
tar -xJf foo.tar.xz
tar --zstd -xf foo.tar.zst
unzip foo.zip
7z x foo.7z
```
