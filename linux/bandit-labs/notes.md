# OverTheWire Bandit Lab Notes

Notes from doing the labs at <https://overthewire.org/wargames/bandit>.  

!!! warning "SPOILER ALERT"

    This page contains the answers for the bandit labs.

## Level 0

The goal for this level is to SSH into the lab environment.  

Solution: Add entry in `~/.ssh/config`.  
```bash
Host bandit
    Hostname bandit.labs.overthewire.org
    Port 2220
```
Then SSH in:
```bash
ssh bandit0@bandit
```
Enter password. Level complete. 

## Level 1

Find password for bandit1 in `~/readme`.  
```bash
cat ~/readme
```

- `ZjLjTmM6FvvyRnrb2rfNWOZOTa6ip5If`

Log out of bandit0, log back in as bandit1 
```bash
ssh bandit1@bandit
```

## Level 2
Password in a file called `-` in home dir.  
```bash
cat ~/-
```

- `263JGJPfgU6LtdEvgfWU1XP5yac29mFx`

The filename could not be specified as just `-` because that tells `cat` to
read from stdin.  

```bash
ssh bandit2@bandit
```



## Level 3
Password in a file called `--spaces in this filename--` in home dir.  

```bash
cat './--spaces in this filename--'
```
Quote filename so spaces aren't treated as separate arguments.  

- `MNk8KNH3Usiio41PRUEoDFPqfxLPlSmx`

```bash
ssh bandit3@bandit
```


## Level 4
Password in file `~/inhere/...Hiding-From-You`.  

```bash
cat ~/inhere/...Hiding-From-You
```

- `2WmrDFRmJIq3IPxneAaMGhap0pFhF3NJ`

```bash
ssh bandit4@bandit
```

## Level 5
Password in the only **human-readable** file in `~/inhere`.  

Check the kind of files that are in there:
```bash
file ./inhere/*
```
Output:
```txt
./inhere/-file00: data
./inhere/-file01: OpenPGP Public Key
./inhere/-file02: OpenPGP Public Key
./inhere/-file03: data
./inhere/-file04: data
./inhere/-file05: data
./inhere/-file06: data
./inhere/-file07: ASCII text
./inhere/-file08: data
./inhere/-file09: data
```

Looks like `./inhere/-file07` is the password file, as it's a plain ASCII text
file.  

```bash
cat ./inhere/-file07
```

- `4oQYVPkxZOOEOO5pTW81FB8j8lxXGUQw`

```bash
ssh bandit5@bandit
```

## Level 6
The password for the next level is stored in a file somewhere under the inhere 
directory and has all of the following properties:

- human-readable
- 1033 bytes in size
- not executable

```bash
find ./inhere/ -size 1033c
# ./inhere/maybehere07/.file2
find ./inhere/ -size 1033c | xargs cat
```

- `HWasnPhtq9AVKe0dmk45nxy20cvUa6EG`

```bash
ssh bandit6@bandit
```

## Level 7

The password for the next level is stored somewhere on the server and has all 
of the following properties:

- owned by user bandit7
- owned by group bandit6
- 33 bytes in size

```bash
find / -user bandit7 -group bandit6 -size 33c 2>/dev/null
cat /var/lib/dpkg/info/bandit7.password
```

- `morbNTDkSW6jIlUc0ymOdMaLnOlFVAaj`

```bash
ssh bandit7@bandit
```

## Level 8
The password for the next level is stored in the file `data.txt` next to the word 
"millionth". 

```bash
cat data.txt | grep millionth
```

- `dfwvzFQi4mU0wfNbFOe9RoWskMLg7eEc`

```bash
ssh bandit8@bandit
```

## Level 9
The password for the next level is stored in the file `data.txt` and is the only 
line of text that occurs only once.

```bash
sort ./data.txt | uniq -u
# Don't be me:
sort ./data.txt | uniq -c | grep -P '^\s*1\s+'
```

- `4CKMh1JI91bUIZZPXDqGanal4xvAg0JM`

```bash
ssh bandit9@bandit
```

## Level 10
The password for the next level is stored in the file `data.txt` in one of the 
few human-readable strings, preceded by several `=` characters.



Open in `vi`.  
```bash
vi ./data.txt
```
Search for multiple equal signs with `/==`, hit `n` to go to next. Eventually
find password.  


- `grep` wasn't working properly when used normally, as it was a binary file with 
  ASCII strings hidden inside.  
  Use `--binary-files=text` to grep for the ASCII inside the binary file.  
  ```bash
  grep --binary-files=text '===' ./data.txt
  ```
  Output:
  ```txt
                          &/g>========== the
  q      r3>!A];Lu<Q /oa.*OYﾂ!ZWy4$ ========== password
  ##AMM/Dq]L":wySt+Ea|RE>wn;
                            ?@F,f\Z'========== is
  ǭ?*9f3ߚqw}ɺTc#y-ey =1а{}#Ax}K
  ( D! O?eR=[G6DVw ========== FGUW5ilLVJrxX9kMYMmlN4MgbpfMiqey
  ```

- `FGUW5ilLVJrxX9kMYMmlN4MgbpfMiqey`

```bash
ssh bandit10@bandit
```

## Level 11

The password for the next level is stored in the file `data.txt`, which contains 
base64 encoded data.  

```bash
cat data.txt | base64 -d
# The password is dtR173fZKb0RRsDFSGsg2RWnpNVj3qRr
```

- `dtR173fZKb0RRsDFSGsg2RWnpNVj3qRr`

```bash
ssh bandit11@bandit
```

## Level 12
The password for the next level is stored in the file `data.txt,` where all 
lowercase (a-z) and uppercase (A-Z) letters have been rotated by 13 positions.

Use `vi`'s builtin Rot13 encode/decode.  
```bash
vi data.txt
```
Use `g?` to rot13 decode the entire string.  

- The password is `7x16WNeHIi5YkIhWsfFIqoognUTyj9Q4`

Or, be like Zorgul and use `tr` like a smart man.  
```bash
cat data.txt | tr 'A-Za-z' 'N-ZA-Mn-za-m'
#The password is 7x16WNeHIi5YkIhWsfFIqoognUTyj9Q4
```

```bash
ssh bandit12@bandit
```

## Level 13

The password for the next level is stored in the file `data.txt`, which is a 
hexdump of a file that has been repeatedly compressed. 

For this level it may be useful to create a directory under `/tmp` in which you 
can work. Use `mkdir` with a hard to guess directory name. Or better, use the 
command `mktemp -d`. Then copy the datafile using `cp`, and rename it using `mv` (
read the manpages!)

```bash
mkdir /tmp/solve
cd /tmp/solve
cp ~/data.txt .
file data.txt
less data.txt 
xxd -r data.txt > unhexed.txt # reverse the hex dump
file unhexed.txt # gzip
mv unhexed.txt unhexed.gz
gunzip unhexed.gz
file unhexed # bzip
bzip2 -d ./unhexed
file unhexed.out # gzip
mv unhexed.out unhexed.gz
gunzip unhexed.gz
file unhexed # unhexed: POSIX tar archive (GNU)
tar -xvf unhexed # produced data5.bin
file data5.bin # data5.bin: POSIX tar archive (GNU)
tar -xvf ./data5.bin # produced data6.bin
file data6.bin # data6.bin: bzip2 compressed data, block size = 900k
bzip2 -d data6.bin # produced data6.bin.out
file data6.bin.out # data6.bin.out: POSIX tar archive (GNU)
tar -xvf data6.bin.out # produced data8.bin
file data8.bin # data8.bin: gzip compressed data, was "data9.bin"
mv data8.bin data8.gz
gunzip data8.gz
file data8 # data8: ASCII text
cat data8 # The password is FO5dwFsc0cbaIiH0h8J2eUks2vdTDwAn
```

- Password found in 27 commands
- `FO5dwFsc0cbaIiH0h8J2eUks2vdTDwAn`

SSH into next level with password:
```bash
ssh bandit13@bandit
```

## Level 14

The password for the next level is stored in `/etc/bandit_pass/bandit14` and can 
only be read by user bandit14.

For this level, you don’t get the next password, but you get a private SSH key 
that can be used to log into the next level. Look at the commands that logged 
you into previous bandit levels, and find out how to use the key for this level.

```bash
cat sshkey.private
```
Copy key to local machine in `~/.ssh/bandit14_key.pem`.
```bash
chmod 600 ~/.ssh/bandit14_key.pem
ssh bandit14@bandit -i ~/.ssh/bandit14_key.pem
cat /etc/bandit_pass/bandit14 # MU4VWeTyJk8ROof1qqmcBPaLh7lDCPvS
```

- `MU4VWeTyJk8ROof1qqmcBPaLh7lDCPvS`

```bash
ssh bandit14@bandit
```

## Level 15

The password for the next level can be retrieved by submitting the password of 
the current level to port `30000` on localhost.

```bash
nc localhost 30000
# Pasted in: MU4VWeTyJk8ROof1qqmcBPaLh7lDCPvS
# Correct!
# 8xCjnmgoKbGLhHFAZlGE5Tmu4M2tKJQo
```

- `8xCjnmgoKbGLhHFAZlGE5Tmu4M2tKJQo`

```bash
ssh bandit15@bandit
```

## Level 16

The password for the next level can be retrieved by submitting the password of 
the current level to port `30001` on localhost using SSL/TLS encryption.  

Helpful note: Getting “DONE”, “RENEGOTIATING” or “KEYUPDATE”?  
Read the “CONNECTED COMMANDS” section in the manpage.  

---

The port can be accessed using `openssl`, using the `s_client` subcommand.  

```bash
openssl s_client localhost:30001
# Pasted in: 8xCjnmgoKbGLhHFAZlGE5Tmu4M2tKJQo
# Correct!
# kSkvUpMQ7lBYyCM4GBPvCvT1BfWRy0Dx
```

- `kSkvUpMQ7lBYyCM4GBPvCvT1BfWRy0Dx`

```bash
ssh bandit16@bandit
```

## Level 17

The credentials for the next level can be retrieved by submitting the password 
of the current level to a port on localhost in the range `31000` to `32000`.  

First find out which of these ports have a server listening on them. Then find 
out which of those speak SSL/TLS and which don't.  

There is only 1 server that will give the next credentials, the others will 
simply send back to you whatever you send to it.  

---

First we'll check the ports that are open in the specified range.  
```bash
ss -ntulp | awk '{print $5}' | perl -pe 's/.*://' | sort -n
# 31046
# 31518
# 31691
# 31790
# 31960
```

- Five ports:
    - 31046
    - 31518: Uses SSL/TLS
        - Responds with KEYUPDATE
    - 31691
    - 31790: Uses SSL/TLS
        - Responds with KEYUPDATE
    - 31960

Attempted solutions:

- Wrote a probing script to check ports within the specified range using 
  `openssl s_client` and `nc`:
  ```bash
  #!/bin/bash
  
  declare -a PORTS=(
          31046
          31518
          31691
          31790
          31960
  )
  
  for port in "${PORTS[@]}"; do
          printf "\n\nConnecting to localhost on port: %d\n\n\n" "$port"
          printf "OpenSSL connection attempt:\n"
          echo "kSkvUpMQ7lBYyCM4GBPvCvT1BfWRy0Dx" | openssl s_client localhost:$port
          printf "nc connection attempt:\n"
          echo "kSkvUpMQ7lBYyCM4GBPvCvT1BfWRy0Dx" | nc localhost $port
  done
  ```

- Connecting manually:
  ```bash
  openssl s_client -connect localhost:31518
  ```
  Then pasting in the password.  

    - The main problem with this approach is that pasting the password interactively 
      was seen as a KEYUPDATE command (see the `CONNECTED COMMANDS` section 
      in `man openssl-s_client`).

Solution: Perform the input non-interactively with the `-quiet` flag and echo
in the password to the command instead.  
```bash
echo "kSkvUpMQ7lBYyCM4GBPvCvT1BfWRy0Dx" | openssl s_client -quiet -tls1_3 localhost:31790
```

Output:
```txt
Correct!
-----BEGIN RSA PRIVATE KEY-----
MIIEogIBAAKCAQEAvmOkuifmMg6HL2YPIOjon6iWfbp7c3jx34YkYWqUH57SUdyJ
imZzeyGC0gtZPGujUSxiJSWI/oTqexh+cAMTSMlOJf7+BrJObArnxd9Y7YT2bRPQ
Ja6Lzb558YW3FZl87ORiO+rW4LCDCNd2lUvLE/GL2GWyuKN0K5iCd5TbtJzEkQTu
DSt2mcNn4rhAL+JFr56o4T6z8WWAW18BR6yGrMq7Q/kALHYW3OekePQAzL0VUYbW
JGTi65CxbCnzc/w4+mqQyvmzpWtMAzJTzAzQxNbkR2MBGySxDLrjg0LWN6sK7wNX
x0YVztz/zbIkPjfkU1jHS+9EbVNj+D1XFOJuaQIDAQABAoIBABagpxpM1aoLWfvD
KHcj10nqcoBc4oE11aFYQwik7xfW+24pRNuDE6SFthOar69jp5RlLwD1NhPx3iBl
J9nOM8OJ0VToum43UOS8YxF8WwhXriYGnc1sskbwpXOUDc9uX4+UESzH22P29ovd
d8WErY0gPxun8pbJLmxkAtWNhpMvfe0050vk9TL5wqbu9AlbssgTcCXkMQnPw9nC
YNN6DDP2lbcBrvgT9YCNL6C+ZKufD52yOQ9qOkwFTEQpjtF4uNtJom+asvlpmS8A
vLY9r60wYSvmZhNqBUrj7lyCtXMIu1kkd4w7F77k+DjHoAXyxcUp1DGL51sOmama
+TOWWgECgYEA8JtPxP0GRJ+IQkX262jM3dEIkza8ky5moIwUqYdsx0NxHgRRhORT
8c8hAuRBb2G82so8vUHk/fur85OEfc9TncnCY2crpoqsghifKLxrLgtT+qDpfZnx
SatLdt8GfQ85yA7hnWWJ2MxF3NaeSDm75Lsm+tBbAiyc9P2jGRNtMSkCgYEAypHd
HCctNi/FwjulhttFx/rHYKhLidZDFYeiE/v45bN4yFm8x7R/b0iE7KaszX+Exdvt
SghaTdcG0Knyw1bpJVyusavPzpaJMjdJ6tcFhVAbAjm7enCIvGCSx+X3l5SiWg0A
R57hJglezIiVjv3aGwHwvlZvtszK6zV6oXFAu0ECgYAbjo46T4hyP5tJi93V5HDi
Ttiek7xRVxUl+iU7rWkGAXFpMLFteQEsRr7PJ/lemmEY5eTDAFMLy9FL2m9oQWCg
R8VdwSk8r9FGLS+9aKcV5PI/WEKlwgXinB3OhYimtiG2Cg5JCqIZFHxD6MjEGOiu
L8ktHMPvodBwNsSBULpG0QKBgBAplTfC1HOnWiMGOU3KPwYWt0O6CdTkmJOmL8Ni
blh9elyZ9FsGxsgtRBXRsqXuz7wtsQAgLHxbdLq/ZJQ7YfzOKU4ZxEnabvXnvWkU
YOdjHdSOoKvDQNWu6ucyLRAWFuISeXw9a/9p7ftpxm0TSgyvmfLF2MIAEwyzRqaM
77pBAoGAMmjmIJdjp+Ez8duyn3ieo36yrttF5NSsJLAbxFpdlc1gvtGCWW+9Cq0b
dxviW8+TFVEBl1O4f7HVm6EpTscdDxU+bCXWkfjuRb7Dy9GOtt9JPsX8MBTakzh3
vBgsyi/sN3RqRBcGU40fOoZyfAMT8s1m/uYv52O6IgeuZ/ujbjY=
-----END RSA PRIVATE KEY-----
```
Credentials for next level.  

