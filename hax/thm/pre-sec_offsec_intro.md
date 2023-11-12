

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
# GoBuster command to brute-force hidden website pages
gobuster -u http://fakebank.com/ -w ./wordlist.txt dir
```
* `-u` is used to state the website we're scanning
    * `-u`: Target URL / Domain  
* `-w` takes a list of words to iterate through to find hidden pages.
    * `-w`: Path to the "wordlist"  
  
GoBuster will have told you the pages it found in the list of page/directory names 
(indicated by Status: 200).

* It found `/images` but it's not a Status 200, so it results in a 404.
* It also found `/bank-transfer`, which had Status 200.



## Intro to Web Application Security

A web application will be served through a browser.  
It will usually have one or more databases that it queries for results, and 
gives the client a webpage to render.  


