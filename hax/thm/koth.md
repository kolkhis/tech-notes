


1. Scan for open ports
```bash
nmap -p- -T4 $target -v
```

2. Run `dirb` to scan `HTTP` server for directories using a dictionary file.  
```bash
dirb http://$t /usr/share/wordlists/dirb/common.txt  # -o dirb.txt
```


