

# Intro to Offensive Security
## Using GoBuster to Find Hidden Links / Webpages


### Hidden Links
Most companies will have an admin portal page,
giving their staff access to basic admin controls for day-to-day operations.
For a bank, an employee might need to transfer money to and from client accounts.
Often these pages are not made private,
allowing attackers to find hidden pages that show, or give
access to, admin controls or sensitive data.


### GoBuster
The exercise is to find hidden pages on a fake bank's web app.
We'll use GoBuster:
```bash
gobuster -u http://fakebank.com/ -w ./wordlist.txt dir
```


`-u`: Target URL / Domain  
`-w`: Path to the "wordlist"  


