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

