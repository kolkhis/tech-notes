

## Base64
Base64 is a way of encoding binary data in ASCII text, to help it survive transportation over
network layers that aren't "8-bit clean".  
There are generally 64 characters that will be present in a ton of character sets.  
So, 64. Base64.
```bash
base64 -d
```
> "Base64 is a group of tetrasexagesimal binary-to-text encoding schemes that  
> represent binary data in sequences of 24 bits that can be represented by  
> four 6-bit Base64 digits"  
>  - Wikipedia

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


