# Using Globs in Python

Python provides a `glob` module in its standard library.  

There are two different ways to loop over files with `glob`:

- `glob.iglob('*')`: Returns an iterator  
- `glob.glob('*')`: Returns a list of matching filenames  

```python
#!/usr/bin/env python3
import glob

if __name__ == '__main__':
    

    for item in glob.iglob('*'):
        match item:
            case item if item.endswith('.py'):
                print(f"Python File found: {item}")
            case item if item.endswith('.txt'):
                print(f"Text File found: {item}")
            case item if item.endswith('.md'):
                print(f"Markdown File found: {item}")
            case _:
                print(f"Other file found: {item}")

##########################################################

    files = glob.glob('*')
    for item in files:
        match item:
            case item if item.endswith('.py'):
                print(f"Python File found: {item}")
            case item if item.endswith('.txt'):
                print(f"Text File found: {item}")
            case item if item.endswith('.md'):
                print(f"Markdown File found: {item}")
            case _:
                print(f"Other file found: {item}")
```

