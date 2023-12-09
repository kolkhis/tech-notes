
# C Language Notes

For C programming:
`PRINTF(3)`

| Control Sequence | Produces              |
|------------------|-----------------------|
|       `\n`       |    newline            |
|       `\l`       |    line-feed          |
|       `\r`       |    return             |
|       `\t`       |    tab                |
|       `\b`       |    backspace          |
|       `\f`       |    form-feed          |
|       `\s`       |    space              |
|  `\E` and `\e`   | escape character      |
|      `^x`        |`control-x` (`x`=char) |


## Floats vs Doubles
Floats and Doubles both store floating point values.  
Floats allow for 4 bytes (or 32 bits), while doubles are 8 bytes (or 64 bits).

| Floats  |  Doubles  |
|---------|-----------------------|
| 4 bytes (32 bits) | 8 bytes (64 bits)
| 7 decimal digits precision  | 15 decimal digits precision |
| possible precision errors with big numbers | won't get precision errors with big numbers |
| Format specifier `%f` | Format specifier `%lf` |



