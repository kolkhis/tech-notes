

# UTF-8
Unicode Transformation Format - 8-bit


## UTF-8 Bytes
UTF-8 bytes contain `header bytes` that tell the decoder how many bytes to read to 
get the character.
It will be the first byte of the character.


F0 is 11110000, which is a header byte that says "this character needs 4 
bytes" (because of the 4 1's)


## Unicode Emojis

Unicode characters are typically used in hexadecimal format.  
The most common emojis start with `1F6`. i.e., `0x1F643` is the upside-down face 🙃 emoji.  


