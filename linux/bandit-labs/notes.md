# OverTheWire Bandit Lab Notes

Notes from doing the labs at <https://overthewire.org/wargames/bandit>.  


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


