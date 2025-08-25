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

## Formatting Strings to Variables

In Bash 3.1+, `printf` has the `-v VAR` option.  

> **Note**: This option is not POSIX-compliant. POSIX printf has no options at all, 
> only the standard `format [args...]`.  

This allows you to save the output of a format string into a variable rather than
printing it to stdout.  

```bash
printf -v VAR_NAME ...
```

This is useful for formatting variables and even cutting down on subshells.  

```bash
printf -v GREETING "Hello, %s\n" "$USER"
```

This saves the output of the string to the `GREETING` variable, which can then be
used later.  

This option can be very powerful when combined with formats like the [date format](#date-formatting):  
```bash
printf -v current_date "%(%F %T)T"
printf "Current date: %s\n" "$current_date"
```



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


Combine this powerful tool with `printf`'s `-v VAR` option to save it to a variable:  
```bash
printf -v current_date "%(%F %T)T"
# As opposed to:
current_date="$(date '+%F %T')"  # Old way, requires a subshell
```

---

### Date Format with Other Formats

When using the date format with other formats **after** it, you need to pass it an argument.  

For example, this will break:
```bash
# BAD:
printf "%(%F %T)T [INFO]: Timeout limit reached: %s\n" "$idle_time"
```

- The date format does not *require* an argument. However, if there is one present,
  it will ingest it.  

- So the date format is ingesting the `"$idle_time"` argument, and leaves nothing for
  the `%s` format.  

The way around this is to pass the date format an argument.  

You can simply pass it `-1`:
```bash
printf "%(%F %T)T [INFO]: Timeout limit reached: %s\n" -1 "$idle_time"
```

---

If the date format comes **after** all other formats, it does not require an
argument.  
```bash
printf "[INFO]: Timeout limit reached: %s -- %(%F %T)T\n" "$idle_time"
```
This will work just fine. The `%s` format gets its argument, and the date format does
not try to ingest it.  








