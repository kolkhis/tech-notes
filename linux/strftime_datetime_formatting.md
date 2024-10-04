

# strftime - Datetime Formatting on Linux


## Table of Contents
* [Formatting Dates and Times](#formatting-dates-and-times) 
* [Format Specifiers](#format-specifiers) 
    * [Seconds](#seconds) 
    * [Minutes](#minutes) 
    * [Hours](#hours) 
    * [Days](#days) 
    * [Weeks](#weeks) 
    * [Months](#months) 
    * [Years](#years) 
    * [Others](#others) 


## Formatting Dates and Times
Formatting datetime on Linux uses mostly the same format as 
Python's `strftime` function.  

This uses format specifiers starting with a percent sign `%`.  
Each one represents a specific way to output a part of the date
or time.  


## Format Specifiers
Some of these specifiers are zero-padded.  
If they don't have non-zero-padded alts, try `%-X` where `X` is the original
specifier.  
E.g.:
```python
strftime(format='%-m')
# 03
strftime(format='%-m')
# 3
```


### Seconds
* `%S`: Second of the minute (00..60)
* `%L`: Millisecond of the second (000..999)
* `%s`: Number of seconds since 1970-01-01 00:00:00 UTC.

### Minutes
* `%M`: Minute of the hour (00..59 zero-padded)
* `%-M`: Minute as a decimal number. (0, 1..59 non zero-padded)

### Hours
* `%H`: Hour of the day, 24-hour clock (00..23)
* `%I`: Hour of the day, 12-hour clock (01..12)
* `%k`: Hour of the day, 24-hour clock, blank-padded ( 0..23)
* `%l`: Hour of the day, 12-hour clock, blank-padded ( 0..12)

### Days
* `%a`: Abbreviated weekday name (“Sun”)
* `%A`: Full weekday name (Sunday)
* `%w`: Day of the week (Sunday is 0, 0..6)
* `%u`: Day of the week (Monday is 1, 1..7)
* `%d`: Day of the month (01..31)
* `%e`: Day of the month (1..31)
* `%j`: Day of the year (001..366)

### Weeks
* `%w`: Day of the week (Sunday is 0, 0..6)
* `%U`: Week number of the current year, starting with the first Sunday as the first day of the first week (00..53)
* `%V`: Week number of year according to ISO 8601 (01..53)

### Months
* `%b`: Abbreviated month name (Jan)
* `%B`: Full month name (January)
* `%m`: Month of the year (01..12)

### Years
* `%y`: Year without a century (00..99)
* `%Y`: Year with century

### Others
* `%p`: Meridian indicator (AM or PM)
* `%P`: Meridian indicator (“am” or “pm”)
* `%c`: Preferred local date and time representation
* `%Z`: Time zone name
* `%%`: Literal % character
* `%C`: Century (20 in 2009)
* `%D`: U.S. Date (%m/%d/%y)
* `%n`: Newline (n)
* `%t`: Tab character (t)

