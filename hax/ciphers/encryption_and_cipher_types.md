

## Base64 Encoding  

Base64 is a way of encoding binary data in ASCII text, to help it survive transportation over  
network layers that aren't "8-bit clean".  


There are generally 64 characters that will be present in a ton of character sets.  
So, 64. Base64.  

### Identifying Factors  
Base64 encoding often results in a string that uses a mix of alphanumeric characters  
along with + and /, and it's padded with = or == to make the length of  
the encoded data a multiple of four.  

* Strings ending with `==` are commonly seen in Base64-encoded data.  
    * If the length of the string is a multiple of four, it could be Base64-encoded.  
    * The `==` that sometimes appears is just padding for if it's not a 
      multiple of four when it's been encoded.  

* **Compressed Data:** Having `H4sIA` at the beginning of a string suggests that it 
  could be Base64-encoded, compressed data. 
    * This is recognized from the gzip magic number (`1F 8B` in hex) which 
      is translated to `H4sI` in Base64.
    * This specific sequence is commonly found at the start of strings  
      that are Base64 representations of data compressed using the gzip algorithm.  

* **Character Set:** The use of a broad character set (including both uppercase  
  and lowercase letters, numbers, and potentially `+` and `/`) could 
  indicate Base64-encoded data.  

```bash  
cat file | base64 -d  
base64 -d < file  
```


## Base32 Encoding  
* TOTP Codes are usually Base32-encoded.  
    * The shared secret for TOTP needs to be 128-160 bits according to the RFC.
    * (Microsoft uses 80, because ... Microsoft.) 
    * "<-- Hello, World -->" is 160 bits. Super secure shared secret.
* You can guess the base encoding often by looking at the string.  
* There are 32 different characters in Base32.  
* Base64 has both lower case and upper case.  
* Base32 does not mix cases. 
* Base32 usually only contains uppercase characters.  

### Identifying Factors for Base32-encoding  
* **Character Set**: Base32 typically uses `[A-Z]` (uppercase) 
   and the numbers `[2-7]` (2 through 7). Base32 does NOT mix case.  
    * This is different from Base64, which uses all the characters.  

* **Case Sensitivity**: Base32-encoded strings are case-insensitive  
  and usually represented in uppercase. 
    * This is different from Base64, which is case-sensitive.  

* **Padding**: Base32 also uses `=` as padding characters to make  
  final output a multiple of 8 characters.  
    * But, padding in Base32 is not always required like in Base64.  


### Common Uses of Base32

* **TOTP Authentication**: Base32 is widely used in Time-Based One-Time Password (TOTP) (like in 2FA apps).  
    * This is because Base32 strings are easier to read and manually input than Base64.  
    * Especially useful for devices like hardware tokens.  

* **DNS**: Base32 is used in various DNS-related implementations, particularly in encoding binary data that needs to be represented in DNS records.  

* **Email and Usenet**: In certain cases, Base32 is used in email
  and Usenet transmissions where the reader or transport layer is not 8-bit clean.  

* **Human-Readable Codes**: Its simplicity and readability make Base32
  suitable for encoding data that might need to be read and entered by 
  people (e.g., product keys).

```bash  
cat file | base32 -d  
base32 -d < file  
```



## gzip  
If a string starts with `H4sIA`, it might be a Base64-encoded version
of gzip-compressed data.  

### gunzip / gzip -d  
gunzip  can  currently  decompress files created by `gzip`, `zip`, `compress`, `compress -H` or `pack`.  
Files created by zip can be uncompressed by gzip only if they have a single member compressed with the 'deflation' method.  



## Identifying Factors of a NetPBM File (.pbm, .pgm, .ppm)
A NetPBM file will usually start the first two lines with something like:
```output
P4
96 8

# or

P1
36 11
```
Basically `P{num}`, linebreak, `{num} {num}`.  
Following lines will be a bunch of binary data.
It might look something like:  
```output
<|`|f```f```fff|`ffl`ff```f~~~<
```





## Stegonography  
Stegonography is hiding something in plain sight that can be recovered,
in the most generalized sense.  

## Atbash Cipher  
The Atbash Cipher takes the alphabet and reverses it.  

## Moontype  
Precursor to braile.  

## DTMF Tones  
The tones that play when you press the numbers on your phone.  

## Letter Cipher  
1-26 is A to Z.  

## pbkdf2
PBKDF2 stands for "Password-Based Key Derivation Function 2."  
### Password-Based  
* Takes a password as inpout and makes a cryptographic key from it. 
* The key can then be used for encryuption, authentication, or other security purposes.  
### Key Strengthening  
* Used to strengthen passwords.  
* Takes the user's password and applies a series of cryptographic operations, including multiple  
  iterations of a pseudo-random function, to generate a strong cryptographic key.  
### Salt  
* pbkdf2 requires the use of a salt, a randoim value that's combined with the password before  
  hashing.  
* The salt protects against precomputed tables (rainbow tables) to attack the hashed password.  
* Each user typically has a unique salt.  
### Cryptographic Hash Function  
* pbkdf2 uses a cryptographic has function, like SHA-1 or SHA-256, as the underlying  
  'psuedorandom' function.  
* The hash fn is applied repeatedly in each iteration to generate the final key  


