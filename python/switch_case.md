# Match/Case in Python

Python 3.10+ has the `match` keyword which can be used like `switch` in other 
languages.

- `case _`: This is the default case (`case *` in other languages)

A `break` statement isn't needed in any case.

```python
#!/usr/bin/env python3
import string

if __name__=='__main__':
    letters = string.ascii_lowercase
    print(f"Letters:\n{letters}")
    for l in letters:
        match l:
            case 'a':
                print('a')
            case 'b':
                print('b')
            case 'c':
                print('c')
            case _:
                print('other')
                break
                # Break out of the loop
```
