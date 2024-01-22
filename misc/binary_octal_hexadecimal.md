


# Calculating the Values of Numbers in Non-Base10 Number Systems  

Here's a table representing how the different number systems  
increment:  

|  Binary₂  | Octal₈ | Decimal₁₀ | Hexadecimal₁₆ |
|-----------|--------|-----------|---------------|
|  `0000`   |   `0`  |   `0`     |      `0`      |
|  `0001`   |   `1`  |   `1`     |      `1`      |
|  `0010`   |   `2`  |   `2`     |      `2`      |
|  `0011`   |   `3`  |   `3`     |      `3`      |
|  `0100`   |   `4`  |   `4`     |      `4`      |
|  `0101`   |   `5`  |   `5`     |      `5`      |
|  `0110`   |   `6`  |   `6`     |      `6`      |
|  `0111`   |   `7`  |   `7`     |      `7`      |
|  `1000`   |  `10`  |   `8`     |      `8`      |
|  `1001`   |  `11`  |   `9`     |      `9`      |
|  `1010`   |  `12`  |  `10`     |      `A`      |
|  `1011`   |  `13`  |  `11`     |      `B`      |
|  `1100`   |  `14`  |  `12`     |      `C`      |
|  `1101`   |  `15`  |  `13`     |      `D`      |
|  `1110`   |  `16`  |  `14`     |      `E`      |
|  `1111`   |  `17`  |  `15`     |      `F`      |




## Calculating in Any Number System  
When we want to calculate a binary (base 2 `₂`), octal (base 8 `₈`),
or hexadecimal (base 16 `₁₆`) number to a human-readable format,
we calculate it into a decimal number (base 10 `₁₀`).  

This is the number system we know, understand, and use in our everyday lives. 

### Formula  
The numbers' positions are indexed starting at 0 from right to left.  
For example, in the number 1234, 4 would have position 0, and 1 would have position 3

**Any non-zero number raised to the power of 0 is equal to 1.**  

The formula is as follows:  
```python  
# Binary  
base = 2
value = 10101  
( (value * base^4) + (value * base^3) + (value * base^2) + (value * base^1) + (value * base^0) )  
# 10101₂ = 21₁₀  
```

### Binary  (Base 2)  
Binary is base 2.  
This is because it only has 2 numbers, 0 and 1.  

To calculate the value of the binary number `10101₂` (`₂` means "base 2"):  
```math  
# Number: 10101₂  
( (1 * 2^4) +  (0 * 2^3) + (1 * 2^2) + (0 * 2^1) + (1 * 2^0))₁₀  
(   (16)    +     (0)    +    (4)    +    (0)    +    (1)   )₁₀  
10101₂ = 21₁₀  
```


### Hexadecimal  
Hexadecimal is base 16 (it has 16 "states of nature").  
It has 16 numbers, 0 through 9 and A through F.  

| Hexadecimal |  Binary   | 
|-------------|-----------|
|    `0`      |  `0000`   | 
|    `1`      |  `0001`   | 
|    `2`      |  `0010`   | 
|    `3`      |  `0011`   | 
|    `4`      |  `0100`   | 
|    `5`      |  `0101`   | 
|    `6`      |  `0110`   | 
|    `7`      |  `0111`   | 
|    `8`      |  `1000`   | 
|    `9`      |  `1001`   | 
|    `A`      |  `1010`   | 
|    `B`      |  `1011`   | 
|    `C`      |  `1100`   | 
|    `D`      |  `1101`   | 
|    `E`      |  `1110`   | 
|    `F`      |  `1111`   | 


Converting values to hexadecimal is the same as converting them to binary,
except you'll be using base16 instead of base2.  


---  

Search Terms:  
converting to binary convert to binary converting from binary convert from binary  
converting to hexadecimal convert to hexadecimal converting from hexadecimal convert from hexadecimal  
converting to octal convert to octal converting from octal convert from octal  
converting to decimal convert to decimal converting from decimal convert from decimal  

