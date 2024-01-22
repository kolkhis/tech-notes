

# UTF-8
Unicode Transformation Format - 8-bit


## UTF-8 Bytes
UTF-8 bytes contain `header bytes` that tell the decoder how many bytes to read to get the character.
It will be the first byte of the character.


F0 is 11110000, which is a header byte that says "this character needs 4 
bytes" (because of the 4 1's)



