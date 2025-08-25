# `printf`

The `printf` builtin is a way to output text to the terminal.  

It's an alternative to `echo`.  

## Why `printf`?

This is one of those things that people debate over which one to use. I use `printf`
almost exclusively now, as it is much more feature-rich and portable than `echo`.

On different shells you will see different versions of `echo`, but `printf` is 
usually static in its functionality across all shells.  

Furthermore, it matches `printf` in other languages (e.g., C), so it's a much more 
portable knowledge set than using `echo`.  


## Date Formatting

The `printf` builtin supports a date format that **does not require and external call
to `date`**.  

It takes the same date formats as the `date` command would.  

- The format string for dates is: `%(DATE_FORMAT)T`
  ```bash
  printf "%(DATE_FORMAT)T"
  ```
    - The `DATE_FORMAT` inside the parentheses can be any valid format accepted by 
      the `date` command.  

Here's an example:
```bash
printf "%(%F %T)T\n"
# 2025-08-25 17:02:56
```

- Note that the date format did not require an argument like other formats do (e.g.,
  `%s` requires an argument).  


This is **extremely** useful.  

This can be great for cutting down on the amount of child processes you
spawn simply to get the current date.  

---

When using the date format with other formats **after** it, you need to pass it an argument.  







