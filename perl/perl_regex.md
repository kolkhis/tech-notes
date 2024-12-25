# Perl

## Perl Regex
Perl is noted to have the most powerful regular expression engine.  
It's usually called PCRE (Perl Compatible Regular Expression).  

### Lowercase input:
```bash
ls -alh | perl -pe '$_ = lc $_'
```
This turns all input to lowercase.  
