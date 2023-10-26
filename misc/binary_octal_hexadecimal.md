


# Calculating the Values of Numbers in Non-Base10 Number Systems

## Calculating in Any Number System
When we want to calculate a binary (base 2 `₂`), octal (base 8 `₈`),
or hexa-decimal (base 16 `₁₆`) number to a human-readable format,
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

