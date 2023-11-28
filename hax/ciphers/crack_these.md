
# Puzzle Codes to Crack

base64 usually ends with 0, 1, or 2 = signs

I strongly suggest piping to either "file" or "hexdump". Dumping random binary
data in your terminal isn't cool.



## Tools

* hashcat
* xxd
* base64
* openssl enc
* hd
* gunzip
* xz
* ... What else?

### Hashcat searching
When trying to find a hash, search for it.  
The format is `hashcat -m <somenumber>` where `<somenumber>` is the type of hash  
```bash
hashcat --help | grep AS-REP gives 18200
```


## Codes


### Artsy...
H4sIAAAAAAACA32O2wkAMAgD/50icPvv2FZbpfSBxAieQYSgS3JFG4bPhLn3wVCxLG56Vd6bZ/Ph0c6/8rnka/KUjv9zH/83vfXFVPAAAAA=


### Hope you know the password...
Wk5lNGFvRUtxenBWSTNZdjRMRUJXMHYyZmNyais5eGtwem55TjM2Zi91b0RkTWJXZ1FHZnE4MVhrVkdkc0YyVQpXeVFzYVpMUnlaNFJnNFRVSmlJUjVNUUdUMWs4ODNIeXRwdXNtQnRNUGdycEdRaHNpM2RHTWw4K28wQnQ3M1JxCm43V0JSN0tZZmJnSkhPVEFDb3p4YWNQbEpVbUtQZCtQcWJLVVVyK1RuUTR3VW5TVFdWRnVLbnlVekZsMUNZOS8KS2VWZlBhVUR3cTRlSXVmaUJoQ3dGYjFxNnhjYWdTMlpjcTZra0dxdWNGdVFTZGxkeXJRd016OUt6cWNSaU9WMApTTGlUQzdja05TMG8zdkpYTElOdnlIdlU4VEJxeExEV3JrdEwxQjJTR3JuTlJKUno1TGNlbGJtOVZLS1FWTWt2Cj1BaXl1Zmh2WXErdksyYms2TFlJVTF6WjI4bC9CeGN4aWFNSzFzTUxuM1NhCg==


### Ok, 1 it is... 
/Td6WFoAAATm1rRGAgAhARwAAAAQz1jM4AB7AFVdADqcyM7fkEzWksRKW8LDOw8L2nvn9Ow+NSvqbwuiXN5HyG7PptUUighU1D9jH4TF2kBSGUCckOUB9voiy6djepTLiqlMimtCAfk8Fs6R8JwpHAbVTQAAAAAAE1meTRlNH6gAAXF8i8ARTx+2830BAAAAAARZWg==


### Should this be a string?
"/Td6WFoAAATm1rRGAgAhARwAAAAQz1jM4B//ARRdACmURZ1gyBn4JmSIjib+MZX9x4eABpe77H+oCX4ENOqTjJ28OhWqqGO+kRFLn0FwxGy0KTG4Pnl9AIP/7hgkkcw/ZBtFFQI19zDVYOd9n5ZpgwXpI01+JmakruDp/EAc1ID7+9hx1+jgoxUqgyBvM6XHTxIgKcp8UsYY5OTYLifWSQnOcm90I5WJMHVxMGkBMcIIIYyZGBWWeUeORps1uCR02WvXFxq1e8cowdHZRt7U93/7DL3PODf64WYyAyjsq28l56FoeLnBKVpLMWesIDI+Z/fIXZgWXmiQtOSwhgkirIxxwsJZ09VEgbjz4d2zU2D7wJsB+wYrCuTL4smK0Vxap2fwG/ifb5pwotRyrCXE3JaAAADNh5uOIRcaOgABsAKAQAAAM6+cPrHEZ/sCAAAAAARZWg=="
