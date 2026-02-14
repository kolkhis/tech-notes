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

## Level 0 -> 1

Find password for bandit1 in `~/readme`.  

??? warning "Solution"

    ```bash
    cat ~/readme
    ```

    - `ZjLjTmM6FvvyRnrb2rfNWOZOTa6ip5If`

    Log out of bandit0, log back in as bandit1 
    ```bash
    ssh bandit1@bandit
    ```

## Level 1 -> 2
Password in a file called `-` in home dir.  

??? warning "Solution"

    ```bash
    cat ~/-
    ```

    - `263JGJPfgU6LtdEvgfWU1XP5yac29mFx`

    The filename could not be specified as just `-` because that tells `cat` to
    read from stdin.  

    ```bash
    ssh bandit2@bandit
    ```



## Level 2 -> 3
Password in a file called `--spaces in this filename--` in home dir.  

??? warning "Solution"

    ```bash
    cat './--spaces in this filename--'
    ```
    Quote filename so spaces aren't treated as separate arguments.  

    - `MNk8KNH3Usiio41PRUEoDFPqfxLPlSmx`

    ```bash
    ssh bandit3@bandit
    ```


## Level 3 -> 4
Password in file `~/inhere/...Hiding-From-You`.  

??? warning "Solution"
    ```bash
    cat ~/inhere/...Hiding-From-You
    ```

    - `2WmrDFRmJIq3IPxneAaMGhap0pFhF3NJ`

    ```bash
    ssh bandit4@bandit
    ```

## Level 4 -> 5
Password in the only **human-readable** file in `~/inhere`.  

??? warning "Solution"

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

## Level 5 -> 6
The password for the next level is stored in a file somewhere under the inhere 
directory and has all of the following properties:

- human-readable
- 1033 bytes in size
- not executable

??? warning "Solution"

    ```bash
    find ./inhere/ -size 1033c
    # ./inhere/maybehere07/.file2
    find ./inhere/ -size 1033c | xargs cat
    ```

    - `HWasnPhtq9AVKe0dmk45nxy20cvUa6EG`

    ```bash
    ssh bandit6@bandit
    ```

## Level 6 -> 7

The password for the next level is stored somewhere on the server and has all 
of the following properties:

- owned by user bandit7
- owned by group bandit6
- 33 bytes in size

??? warning "Solution"

    ```bash
    find / -user bandit7 -group bandit6 -size 33c 2>/dev/null
    cat /var/lib/dpkg/info/bandit7.password
    ```

    - `morbNTDkSW6jIlUc0ymOdMaLnOlFVAaj`

    ```bash
    ssh bandit7@bandit
    ```

## Level 7 -> 8
The password for the next level is stored in the file `data.txt` next to the word 
"millionth". 

??? warning "Solution"

    ```bash
    cat data.txt | grep millionth
    ```

    - `dfwvzFQi4mU0wfNbFOe9RoWskMLg7eEc`

    ```bash
    ssh bandit8@bandit
    ```

## Level 8 -> 9
The password for the next level is stored in the file `data.txt` and is the only 
line of text that occurs only once.

??? warning "Solution"

    ```bash
    sort ./data.txt | uniq -u
    # Don't be me:
    sort ./data.txt | uniq -c | grep -P '^\s*1\s+'
    ```

    - `4CKMh1JI91bUIZZPXDqGanal4xvAg0JM`

    ```bash
    ssh bandit9@bandit
    ```

## Level 9 -> 10
The password for the next level is stored in the file `data.txt` in one of the 
few human-readable strings, preceded by several `=` characters.


??? warning "Solution"

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

## Level 10 -> 11

The password for the next level is stored in the file `data.txt`, which contains 
base64 encoded data.  

??? warning "Solution"

    ```bash
    cat data.txt | base64 -d
    # The password is dtR173fZKb0RRsDFSGsg2RWnpNVj3qRr
    ```

    - `dtR173fZKb0RRsDFSGsg2RWnpNVj3qRr`

    ```bash
    ssh bandit11@bandit
    ```

## Level 11 -> 12
The password for the next level is stored in the file `data.txt,` where all 
lowercase (a-z) and uppercase (A-Z) letters have been rotated by 13 positions.

??? warning "Solution" 

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

## Level 12 -> 13

The password for the next level is stored in the file `data.txt`, which is a 
hexdump of a file that has been repeatedly compressed. 

For this level it may be useful to create a directory under `/tmp` in which you 
can work. Use `mkdir` with a hard to guess directory name. Or better, use the 
command `mktemp -d`. Then copy the datafile using `cp`, and rename it using `mv` (
read the manpages!)

??? warning "Solution" 

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

## Level 13 -> 14

The password for the next level is stored in `/etc/bandit_pass/bandit14` and can 
only be read by user bandit14.

For this level, you don’t get the next password, but you get a private SSH key 
that can be used to log into the next level. Look at the commands that logged 
you into previous bandit levels, and find out how to use the key for this level.

??? warning "Solution"

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

## Level 14 -> 15

The password for the next level can be retrieved by submitting the password of 
the current level to port `30000` on localhost.

??? warning "Solution"

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

## Level 15 -> 16

The password for the next level can be retrieved by submitting the password of 
the current level to port `30001` on localhost using SSL/TLS encryption.  

Helpful note: Getting “DONE”, “RENEGOTIATING” or “KEYUPDATE”?  
Read the “CONNECTED COMMANDS” section in the manpage.  

---

??? warning "Solution"

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

## Level 16 -> 17

The credentials for the next level can be retrieved by submitting the password 
of the current level to a port on localhost in the range `31000` to `32000`.  

First find out which of these ports have a server listening on them. Then find 
out which of those speak SSL/TLS and which don't.  

There is only 1 server that will give the next credentials, the others will 
simply send back to you whatever you send to it.  

---

??? warning "Attempted Solutions"

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


??? warning "Solution"

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

    Save to localhost in `~/.ssh/bandit18_key.pem`, then SSH in.
    ```bash
    ssh -i ~/.ssh/bandit17_key.pem bandit17@bandit 
    ```

## Level 17 -> 18

There are 2 files in the homedirectory: `passwords.old` and `passwords.new`.

The password for the next level is in `passwords.new` and is the only line that has 
been changed between `passwords.old` and `passwords.new`.  

NOTE: if you have solved this level and see ‘Byebye!’ when trying to log into 
bandit18, this is related to the next level, bandit19

---

??? warning "Solution"

    Doing a diff one the file:
    ```bash
    diff passwords.new passwords.old
    ```

    Output:
    ```txt
    42c42
    < x2gLTTjFwMOhQ8oWNbMN362QKxfRqGlO
    ---
    > pGozC8kOHLkBMOaL0ICPvLV1IjQ5F1VA
    ```

    The diff on the left, in `passwords.new`, would be the password for the next
    level.  

    - `x2gLTTjFwMOhQ8oWNbMN362QKxfRqGlO`

    ```bash
    ssh bandit18@bandit
    ```

    Although correct, directly entering the password does not work.  
    We'll proceed to the next level.


## Level 18 -> 19

The password for the next level is stored in a file `readme` in the homedirectory.  
Unfortunately, someone has modified `.bashrc` to log you out when you log in with SSH.

---

??? warning "Solution"

    Command:
    ```bash
    ssh bandit18@bandit 'cat readme'
    ```

    Output:
    ```txt
    cGWpMaKXVwDUNgPAVJbWYuGHVn9zl3j8
    ```

Now we can ssh into bandit19.  
```bash
ssh bandit19@bandit
```

## Level 19 -> 20

To gain access to the next level, you should use the `setuid` binary in the 
home directory. Execute it without arguments to find out how to use it.  

The password for this level can be found in the usual place (`/etc/bandit_pass`), 
after you have used the `setuid` binary.

- Resources: <https://en.wikipedia.org/wiki/Setuid>

---

??? warning "Solution"

    ```bash
    ./bandit20-do cat /etc/bandit_pass/bandit20
    ```

    Output:
    ```txt
    0qXahG8ZjOVMN9Ghs7iOWsCfZyXOUbYO
    ```

    Notes:

    - In the first perm digit (octal), 4 is setuid, 2 is setgid  
        - E.g., `6711` has setuid and setgid  
        - If the file owner is bandit20, and setuid is on, the file can be run as
          that user

    ```bash
    ssh bandit20@bandit
    ```

## Level 20 -> 21

There is a setuid binary in the home directory that does the following:

- It makes a connection to localhost on the port you specify as a commandline argument.  

- It then reads a line of text from the connection and compares it to the password 
  in the previous level (bandit20). 

- If the password is correct, it will transmit the password for the next level (bandit21).  

NOTE: Try connecting to your own network daemon to see if it works as you think.  

---

??? warning "Solution"

    - Set up listener that will serve the password over a port
      ```bash
      echo "0qXahG8ZjOVMN9Ghs7iOWsCfZyXOUbYO" | nc -lp 1234 &
      # or
      echo "0qXahG8ZjOVMN9Ghs7iOWsCfZyXOUbYO" > >(nc -lp 1234) &
      # or
      nc -lp 1234 <<< "0qXahG8ZjOVMN9Ghs7iOWsCfZyXOUbYO" &
      ```

    - Then use the binary to connect to that port
      ```bash
      ./suconnect 1234
      ```

    Output:
    ```txt
    Read: 0qXahG8ZjOVMN9Ghs7iOWsCfZyXOUbYO
    Password matches, sending next password
    EeoULMCra2q0dSkYj561DX7s1CpBuOBt
    ```

## Level 21 -> 22

A program is running automatically at regular intervals from cron, the time-based job scheduler.  
Look in `/etc/cron.d/` for the configuration and see what command is being executed.

---

??? warning "Solution"

    ```bash
    ls -alh /etc/cron.d/
    vi /etc/cron.d/cronjob_bandit22
    ```

    File contains:
    ```bash
    #!/bin/bash
    chmod 644 /tmp/t7O6lds9S0RqQh9aMcz6ShpAoZKF7fgv
    cat /etc/bandit_pass/bandit22 > /tmp/t7O6lds9S0RqQh9aMcz6ShpAoZKF7fgv
    ```
    This prints the password to the /tmp file every minute.  

    Open file that it's putting password into every minute:
    ```bash
    vi /tmp/t7O6lds9S0RqQh9aMcz6ShpAoZKF7fgv
    ```

    - Contents: `tRae0UfB9v0UzbCdn9cY0gQnds9GF58Q`

!!! note "Notes"

    Perms for /tmp:
    ```bash
    drwxrwx-wt  37 root root 9.8M Jan 31 18:12 tmp
    ```
    The `x` perm has the value of `t`.  
    This prevented us from simply using `ls /tmp`.  

    The `t` is the sticky bit, so `/tmp` is world-writable but protected by sticky bit so users
    cannot delete each other’s tmp files.  
    When set on a directory, users can create files there (assuming write/execute), 
    but only the file's owner or root can delete or rename those files.  

```bash
ssh bandit22@bandit
```

## Level 22 -> 23
A program is running automatically at regular intervals from cron, the time- based job scheduler.  
Look in `/etc/cron.d/` for the configuration and see what command is being executed.

NOTE: Looking at shell scripts written by other people is a very useful skill. 
The script for this level is intentionally made easy to read. If you are having 
problems understanding what it does, try executing it to see the debug 
information it prints.

---

??? warning "Solution"

    ```bash
    ls -alh /etc/cron.d/cronjob_bandit23
    # -rw-r--r-- 1 root root 122 Oct 14 09:26 /etc/cron.d/cronjob_bandit23
    cat /etc/cron.d/cronjob_bandit23
    # @reboot bandit23 /usr/bin/cronjob_bandit23.sh  &> /dev/null
    # * * * * * bandit23 /usr/bin/cronjob_bandit23.sh  &> /dev/null
    ls -alh /usr/bin/cronjob_bandit23.sh
    # -rwxr-x--- 1 bandit23 bandit22 211 Oct 14 09:26 /usr/bin/cronjob_bandit23.sh
    ```

    We'll look at the script being run.  
    ```bash
    vi /usr/bin/cronjob_bandit23.sh
    ```
    Contents:
    ```bash
    #!/bin/bash

    myname=$(whoami)
    mytarget=$(echo I am user $myname | md5sum | cut -d ' ' -f 1)

    echo "Copying passwordfile /etc/bandit_pass/$myname to /tmp/$mytarget"

    cat /etc/bandit_pass/$myname > /tmp/$mytarget
    ```

    So this is being run as bandit23, so the /tmp filename is going to be the
    md5sum of this string:
    ```bash
    echo I am user $myname | md5sum | cut -d ' ' -f 1
    ```

    So we run the cmd as bandit23
    ```bash
    echo I am user bandit23 | md5sum | cut -d ' ' -f 1
    # 8ca319486bfbbc3663ea0fbe81326349
    cat /tmp/8ca319486bfbbc3663ea0fbe81326349
    # 0Zf11ioIjMVN551jX3CmStKLYqjk54Ga
    ```

    - `0Zf11ioIjMVN551jX3CmStKLYqjk54Ga`

    ```bash
    ssh bandit23@bandit
    ```

## Level 23 -> 24

A program is running automatically at regular intervals from cron, the time-based job scheduler.  
Look in `/etc/cron.d/` for the configuration and see what command is being executed.  

NOTE: This level requires you to create your own first shell-script. This is a 
very big step and you should be proud of yourself when you beat this level!

NOTE 2: Keep in mind that your shell script is removed once executed, so you 
may want to keep a copy around... 

---

??? warning "Solution"

    ```bash
    ls -alh /etc/cron.d/cronjob_bandit24
    # -rw-r--r-- 1 root root 120 Oct 14 09:26 /etc/cron.d/cronjob_bandit24
    cat /etc/cron.d/cronjob_bandit24
    # @reboot bandit24 /usr/bin/cronjob_bandit24.sh &> /dev/null
    # * * * * * bandit24 /usr/bin/cronjob_bandit24.sh &> /dev/null
    ```
    This cron job is running the `/usr/bin/cronjob_bandit24.sh` script **as the
    user bandit24** every minute (and on reboot). The one is important to us is the 
    job that runs every minute.  
    Since it runs the script as the `bandit24` user, it will have read
    permissions on the password file in `/etc/bandit_pass/bandit24`.  

    Let's look at the script the cron job is executing.
    ```bash
    ls -alh /usr/bin/cronjob_bandit24.sh
    # -rwxr-x--- 1 bandit24 bandit23 384 Oct 14 09:26 /usr/bin/cronjob_bandit24.sh
    ```
    We have read and execute permissions on this script. Let's look at its
    contents.  
    ```bash
    vi /usr/bin/cronjob_bandit24.sh
    ```

    Script contents (comments were added by me):
    ```bash
    #!/bin/bash

    myname=$(whoami) # bandit24

    cd /var/spool/$myname/foo # /var/spool/bandit24/foo
    echo "Executing and deleting all scripts in /var/spool/$myname/foo:"
    for i in * .*; # loop over all files in the directory
    do
        if [ "$i" != "." -a "$i" != ".." ];
        then
            echo "Handling $i"
            owner="$(stat --format "%U" ./$i)" # shows the owner of all files, saves to $owner
            if [ "${owner}" = "bandit23" ]; then
                timeout -s 9 60 ./$i
            fi
            rm -f ./$i
        fi
    done
    ```
    This is running all scripts in the `/var/spool/bandit24/foo` directory, then
    deletes the script file after it's run.  

    More exploring:
    ```bash
    ls -Alh /var/spool/bandit24/
    # total 1.9M
    # drwxrwx-wx 8 root     bandit24 1.9M Jan 31 18:38 foo
    ```
    We don't have read permissions, but we do have write permission for this
    directory. So, we can add a script in the `foo/` directory.  
    ```bash
    cd /var/spool/bandit24
    touch foo/kol.sh
    chmod 777 foo/kol.sh
    vi foo/kol.sh
    ```
    Now we have a script file in the same directory as all others.  

    ```bash
    #!/bin/bash
    target_dest="/tmp/b24pass.txt"
    touch "$target_dest"
    chmod 777 "$target_dest"
    cat /etc/bandit_pass/bandit24 > "$target_dest"
    ```

    This script should be run as the user bandit24 every minute then deleted, and 
    should have access to the password file.  

    We can then tail the file that we're outputting to.  
    ```bash
    tail -F /tmp/b24pass.txt
    ```

    This seems to not be working.  
    The script file is deleted, however it does not create the /tmp/b24pass.txt file for us to read.   


    It turns out it was the `/tmp` directory permissions that were the problem
    with that script (see the "Alternate Solution" section, we used that before we 
    figured this out).    

    Since it's being deleted, we can use this oneliner to quickly generate a
    new script.  

    ```bash
    printf '#!/bin/bash\ncat /etc/bandit_pass/bandit24 > /tmp/b24/pass.txt\n' > foo/kol.sh; chmod 755 foo/kol.sh
    ```

    We need to set up a **subdirectory** within `/tmp` to write to, **then**
    generate the script.  
    ```bash
    mkdir /tmp/b24
    chmod 777 /tmp/b24
    printf '#!/bin/bash\ncat /etc/bandit_pass/bandit24 > /tmp/b24/pass.txt\n' > foo/kol.sh; chmod 755 foo/kol.sh
    tail -F /tmp/b24/pass.txt
    ```
    This should give us the password to bandit24.  

    Alternatively, the `/tmp/b24` directory creation could be part of the
    script itself:  
    ```bash
    #!/bin/bash
    mkdir /tmp/b24
    chmod 777 /tmp/b24
    cat /etc/bandit_pass/bandit24 > /tmp/b24/pass.txt
    ```
    Then wait for the file to be created, then `cat` it out.
    ```bash
    cat /tmp/b24/pass.txt
    ```

    - `gb8KRRCsshuZXI0tUuR6ypOFjiZbf3G8`

    ```bash
    ssh bandit24@bandit
    ```




??? warning "Alternate Solution"

    This was the solution we used before we figured out the permissions issue on the
    `/tmp` directory.
    Serve using netcat.  
    ```bash
    #!/bin/bash
    trap : SIGKILL # Trap signal 9 because the cron script is using `timeout -s 9`
    nc -lp 1234 < /etc/bandit_pass/bandit24 &
    ```
    The `trap` is to prevent the `timeout -s 9` from killing our listener
    before we have a chance to connect.  

    Since we have a small window of time to connect after the script is run, we
    can use a `printf` oneliner to generate the script.  
    ```bash
    printf '#!/bin/bash\ntrap : 9\nnc -lp 1234 < /etc/bandit_pass/bandit24 &\n' > ./foo/kol.sh && chmod 755 ./foo/kol.sh
    ```

    Then try to connect to retrieve password using an `until` loop:
    ```bash
    until nc localhost 1234; do sleep 0.1; done
    # gb8KRRCsshuZXI0tUuR6ypOFjiZbf3G8
    ```

    - `gb8KRRCsshuZXI0tUuR6ypOFjiZbf3G8`

    ```bash
    ssh bandit24@bandit
    ```

## Level 24 -> 25

A daemon is listening on port `30002` and will give you the password for 
`bandit25` if given the password for `bandit24` and a secret numeric 4-digit 
pincode. 

There is no way to retrieve the pincode except by going through all of the 10000 
combinations, called brute-forcing.

You do not need to create new connections each time.  

---

??? warning "Solution"

    ```bash
    nc localhost 30002
    # I am the pincode checker for user bandit25. Please enter the password for user bandit24 and the secret pincode on a single line, separated by a space.
    ```

    So the format would be:
    ```txt
    password 1234
    ```

    `gb8KRRCsshuZXI0tUuR6ypOFjiZbf3G8`

    ```bash
    nc localhost 30002;
    for i in {1..9999}; do
        printf "gb8KRRCsshuZXI0tUuR6ypOFjiZbf3G8 %04d\n" "$i";
    done
    ```
    The `%04d` format specifier will zero-pad the digits, so that it will start at 
    `0001` instead of just `1`.  

    ---

    ```bash
    mkdir /tmp/b25
    touch /tmp/b25/pass.txt
    for i in {1..9999};
        do printf "gb8KRRCsshuZXI0tUuR6ypOFjiZbf3G8 %04d\n" "$i" >> /tmp/b25/pass.txt;
    done
    nc localhost 30002 < /tmp/b25/pass.txt;
    ```

    Output:
    ```txt
    ...
    Wrong! Please enter the correct current password and pincode. Try again.
    Wrong! Please enter the correct current password and pincode. Try again.
    Wrong! Please enter the correct current password and pincode. Try again.
    Wrong! Please enter the correct current password and pincode. Try again.
    Correct!
    The password of user bandit25 is iCi86ttT4KSNe1armKiwbQNmB3YJP3q4
    ```

    This writes all possible combinations to a file, then passes in each line as
    input to the daemon listening on 30002. It will stop once the correct
    combination is input.  

    - `iCi86ttT4KSNe1armKiwbQNmB3YJP3q4`

    ```bash
    ssh bandit25@bandit
    ```

## Level 25 -> 26

Logging in to bandit26 from bandit25 should be fairly easy... The shell for user 
bandit26 is not `/bin/bash`, but something else.  

Find out what it is, how it works and how to break out of it.  

NOTE: If you're a Windows user and typically use Powershell to ssh into bandit: 
Powershell is known to cause issues with the intended solution to this level. 
You should use command prompt instead.

---


??? warning "Solution"

    Looks like we have the bandit26 ssh key in the bandit25 home dir
    (`/home/bandit25/bandit26.sshkey`).  
    ```txt
    bandit25@bandit:~$ ls
    bandit26.sshkey
    bandit25@bandit:~$ cat ./bandit26.sshkey
    -----BEGIN RSA PRIVATE KEY-----
    MIIEpQIBAAKCAQEApis2AuoooEqeYWamtwX2k5z9uU1Afl2F8VyXQqbv/LTrIwdW
    pTfaeRHXzr0Y0a5Oe3GB/+W2+PReif+bPZlzTY1XFwpk+DiHk1kmL0moEW8HJuT9
    /5XbnpjSzn0eEAfFax2OcopjrzVqdBJQerkj0puv3UXY07AskgkyD5XepwGAlJOG
    xZsMq1oZqQ0W29aBtfykuGie2bxroRjuAPrYM4o3MMmtlNE5fC4G9Ihq0eq73MDi
    1ze6d2jIGce873qxn308BA2qhRPJNEbnPev5gI+5tU+UxebW8KLbk0EhoXB953Ix
    3lgOIrT9Y6skRjsMSFmC6WN/O7ovu8QzGqxdywIDAQABAoIBAAaXoETtVT9GtpHW
    qLaKHgYtLEO1tOFOhInWyolyZgL4inuRRva3CIvVEWK6TcnDyIlNL4MfcerehwGi
    il4fQFvLR7E6UFcopvhJiSJHIcvPQ9FfNFR3dYcNOQ/IFvE73bEqMwSISPwiel6w
    e1DjF3C7jHaS1s9PJfWFN982aublL/yLbJP+ou3ifdljS7QzjWZA8NRiMwmBGPIh
    Yq8weR3jIVQl3ndEYxO7Cr/wXXebZwlP6CPZb67rBy0jg+366mxQbDZIwZYEaUME
    zY5izFclr/kKj4s7NTRkC76Yx+rTNP5+BX+JT+rgz5aoQq8ghMw43NYwxjXym/MX
    c8X8g0ECgYEA1crBUAR1gSkM+5mGjjoFLJKrFP+IhUHFh25qGI4Dcxxh1f3M53le
    wF1rkp5SJnHRFm9IW3gM1JoF0PQxI5aXHRGHphwPeKnsQ/xQBRWCeYpqTme9amJV
    tD3aDHkpIhYxkNxqol5gDCAt6tdFSxqPaNfdfsfaAOXiKGrQESUjIBcCgYEAxvmI
    2ROJsBXaiM4Iyg9hUpjZIn8TW2UlH76pojFG6/KBd1NcnW3fu0ZUU790wAu7QbbU
    i7pieeqCqSYcZsmkhnOvbdx54A6NNCR2btc+si6pDOe1jdsGdXISDRHFb9QxjZCj
    6xzWMNvb5n1yUb9w9nfN1PZzATfUsOV+Fy8CbG0CgYEAifkTLwfhqZyLk2huTSWm
    pzB0ltWfDpj22MNqVzR3h3d+sHLeJVjPzIe9396rF8KGdNsWsGlWpnJMZKDjgZsz
    JQBmMc6UMYRARVP1dIKANN4eY0FSHfEebHcqXLho0mXOUTXe37DWfZza5V9Oify3
    JquBd8uUptW1Ue41H4t/ErsCgYEArc5FYtF1QXIlfcDz3oUGz16itUZpgzlb71nd
    1cbTm8EupCwWR5I1j+IEQU+JTUQyI1nwWcnKwZI+5kBbKNJUu/mLsRyY/UXYxEZh
    ibrNklm94373kV1US/0DlZUDcQba7jz9Yp/C3dT/RlwoIw5mP3UxQCizFspNKOSe
    euPeaxUCgYEAntklXwBbokgdDup/u/3ms5Lb/bm22zDOCg2HrlWQCqKEkWkAO6R5
    /Wwyqhp/wTl8VXjxWo+W+DmewGdPHGQQ5fFdqgpuQpGUq24YZS8m66v5ANBwd76t
    IZdtF5HXs2S5CADTwniUS5mX1HO9l5gUkk+h0cH5JnPtsMCnAUM+BRY=
    -----END RSA PRIVATE KEY-----
    ```

    Add that to your local machine:
    ```bash
    touch ~/.ssh/bandit26_key.pem
    vi ~/.ssh/bandit26_key.pem # Paste in the key here
    chmod 600 ~/.ssh/bandit26_key.pem
    ssh -i ~/.ssh/bandit26_key.pem bandit26@bandit
    ```
    Kicks immediately after connection due to shell setting.  

    Trying to exec bash:
    ```bash
    ssh -i ~/.ssh/bandit26_key.pem bandit26@bandit '/bin/bash'
    ```

    Let's have a look at the bandit26 shell:
    ```bash
    grep bandit26 /etc/passwd
    # bandit26:x:11026:11026:bandit level 26:/home/bandit26:/usr/bin/showtext
    ls -alh /usr/bin/showtext
    # -rwxr-xr-x 1 root root 58 Oct 14 09:26 /usr/bin/showtext
    /usr/bin/showtext
    # more: cannot open /home/bandit25/text.txt: No such file or directory
    ```

    Looking at the shell:
    ```bash
    cat /usr/bin/showtext
    ```

    Contains:
    ```bash
    #!/bin/sh

    export TERM=linux

    exec more ~/text.txt
    exit 0
    ```

    Make a really small term window with tmux to force the pager to hold.  
    SSH in, and hit ++v++ while in the pager. This opens vi.  
    From vi, we can use Ex commands (filters).

    We're in vim **as the bandit26 user**.  
    We can open the password file, `/etc/bandit_pass/bandit26` by using the `:e` Ex
    command.  

    ```vim
    :e! /etc/bandit\_pass/bandit26
    ```
    This opened the file and gave us the password.  

    - `s0773xxkk0MXfdqOfPRVr9L3jJBUOgCZ`



## Level 26 -> 27

Good job getting a shell! Now hurry and grab the password for bandit27!

---

??? warning "Solution"

    Bandit27 password came from 25-26.  
    Instead of using `:e` for the file, use `:set shell=/bin/bash` then `:sh` to 
    spawn a shell as the bandit26 user.  

    This way we can see that there is a `bandit27-do` setuid binary in bandit26 home
    dir.  

    We can use this to get the password for bandit27.  
    ```txt
    bandit26@bandit:~$ ./bandit27-do cat /etc/bandit_pass/bandit27
    upsNCc7vzaRDx6oZC6GiR6ERwe1MowGB
    ```

    - Bandit27 pass: `upsNCc7vzaRDx6oZC6GiR6ERwe1MowGB`

    ```bash
    ssh bandit27@bandit
    ```

## Level 27 -> 28

There is a git repository at 
`ssh://bandit27-git@bandit.labs.overthewire.org/home/bandit27-git/repo` via the port 2220.

The password for the user `bandit27-git` is the same as for the user bandit27.

From your local machine (not the OverTheWire machine!), clone the repository 
and find the password for the next level. This needs git installed locally on 
your machine.

---

??? warning "Solution"

    Clone locally (set port):
    ```bash
    git clone ssh://bandit27-git@bandit.labs.overthewire.org:2220/home/bandit27-git/repo
    cat repo/README
    # The password to the next level is: Yz9IpL0sBcCeuG7m9uQFt8ZNpS4HZRcN
    ```

    - `Yz9IpL0sBcCeuG7m9uQFt8ZNpS4HZRcN`


## Level 28 -> 29

There is a git repository at 
`ssh://bandit28-git@bandit.labs.overthewire.org/home/bandit28-git/repo` via the port 2220.
The password for the user bandit28-git is the same as for the user bandit28.

From your local machine (not the OverTheWire machine!), clone the repository 
and find the password for the next level. This needs git installed locally on 
your machine.

---

??? warning "Solution"

    ```bash
    git clone ssh://bandit28-git@bandit.labs.overthewire.org:2220/home/bandit28-git/repo
    cd repo
    cat ./README.md
    ```

    Output:
    ```md
    # Bandit Notes
    Some notes for level29 of bandit.

    ## credentials

    - username: bandit29
    - password: xxxxxxxxxx
    ```

    Password is not there, let's look at git history.  
    ```bash
    git log
    ```

    ```txt
    commit b5ed4b5a3499533c2611217c8780e8ead48609f6 (HEAD -> master, origin/master, origin/HEAD)
    Author: Morla Porla <morla@overthewire.org>
    Date:   Tue Oct 14 09:26:24 2025 +0000

        fix info leak

    commit 8b7c651b37ce7a94633b7b7b7c980ded19a16e4f
    Author: Morla Porla <morla@overthewire.org>
    Date:   Tue Oct 14 09:26:24 2025 +0000

        add missing data

    commit 6d8e5e607602b597ade7504a550a29ba03f2cca0
    Author: Ben Dover <noone@overthewire.org>
    Date:   Tue Oct 14 09:26:24 2025 +0000

        initial commit of README.md
    ```

    Roll back to before the 'fix info leak'.  

    ```bash
    git reset --hard HEAD~1
    cat README.md
    ```
    Contents:
    ```md
    # Bandit Notes
    Some notes for level29 of bandit.

    ## credentials

    - username: bandit29
    - password: 4pT1t5DENaYuqnqvadYs1oE4QLCdjmJ7
    ```
    Or, `git diff HEAD~1`.  

    - `4pT1t5DENaYuqnqvadYs1oE4QLCdjmJ7`
    
    ```bash
    ssh bandit29@bandit
    ```

## Level 29 -> 30

There is a git repository at 
`ssh://bandit29-git@bandit.labs.overthewire.org/home/bandit29-git/repo`
via the port 2220.

The password for the user bandit29-git is the same as for the user bandit29.

From your local machine (not the OverTheWire machine!), clone the repository 
and find the password for the next level. This needs git installed locally on 
your machine.

---

??? warning "Solution"

    ```bash
    git clone ssh://bandit29-git@bandit.labs.overthewire.org:2220/home/bandit29-git/repo
    cd repo
    cat README.md
    ```
    Output:
    ```txt
    # Bandit Notes
    Some notes for bandit30 of bandit.

    ## credentials

    - username: bandit30
    - password: <no passwords in production!>
    ```

    ```bash
    git branch -a
    ```
    Output:
    ```txt
    * master
      remotes/origin/HEAD -> origin/master
      remotes/origin/dev
      remotes/origin/master
      remotes/origin/sploits-dev
    ```

    Check out the dev branch:
    ```bash
    git checkout remotes/origin/dev
    ```
    Must use checkout for remote branches.  

    Look at readme:
    ```bash
    cat README.md
    ```

    Output:
    ```md
    # Bandit Notes
    Some notes for bandit30 of bandit.

    ## credentials

    - username: bandit30
    - password: qp30ex3VLz5MDG1n91YowTv4Q8l7CDZL
    ```

    - `qp30ex3VLz5MDG1n91YowTv4Q8l7CDZL`

## Level 30 -> 31

There is a git repository at 
`ssh://bandit30-git@bandit.labs.overthewire.org/home/bandit30-git/repo`
via the port 2220.  

The password for the user bandit30-git is the same as for the user bandit30.

From your local machine (not the OverTheWire machine!), clone the repository 
and find the password for the next level.

This needs git installed locally on your machine.

---

??? warning "Solution (Unfinished)"

    ```bash
    git clone ssh://bandit30-git@bandit.labs.overthewire.org:2220/home/bandit30-git/repo
    ```

    Exploring:
    ```bash
    git reflog show --all
    # d604df2 (HEAD, origin/master, origin/HEAD, master) HEAD@{0}: checkout: moving from master to remotes/origin/master
    # d604df2 (HEAD, origin/master, origin/HEAD, master) refs/heads/master@{0}: clone: from ssh://bandit.labs.overthewire.org:2220/home/bandit30-git/repo
    # d604df2 (HEAD, origin/master, origin/HEAD, master) refs/remotes/origin/HEAD@{0}: clone: from ssh://bandit.labs.overthewire.org:2220/home/bandit30-git/repo
    # d604df2 (HEAD, origin/master, origin/HEAD, master) HEAD@{1}: clone: from ssh://bandit.labs.overthewire.org:2220/home/bandit30-git/repo
    git cat-file -t refs/tags/secret
    # blob
    cat .git/packed-refs
    ## pack-refs with: peeled fully-peeled sorted
    # d604df2303c973b8e0565c60e4c29d3801445299 refs/remotes/origin/master
    # 84368f3a7ee06ac993ed579e34b8bd144afad351 refs/tags/secret
    git show 84368f3a7ee06ac993ed579e34b8bd144afad351
    # fb5S2xb7bRyFmAvQYQGEqsbhVyJqhnDy
    ```

    In the `.git/packed-refs` file, we saw some refs that were likely packed with
    `git pack-refs`.  

    So at some point someone ran `git tag -m 'PASSWORD'`, and then packed it so it
    was inaccessible.  

    By doing `git show <HASH>`, we can see the tag message and any referenced
    objects.  

    Alternatively, we could have just seen the tag with:
    ```bash
    git tag -l
    # secret
    git show secret
    # fb5S2xb7bRyFmAvQYQGEqsbhVyJqhnDy
    ```

## Level 31 -> 32

There is a git repository at 
`ssh://bandit31-git@bandit.labs.overthewire.org:2220/home/bandit31-git/repo`
via the port 2220.

The password for the user bandit31-git is the same as for the user bandit31.

From your local machine (not the OverTheWire machine!), clone the repository
and find the password for the next level. This needs git installed locally on
your machine.

---
??? warning "Solution"

    ```bash
    ls .git
    # .git/       .gitignore
    cat .gitignore
    # *.txt
    cat ./README.md
    # This time your task is to push a file to the remote repository.
    # 
    # Details:
    #     File name: key.txt
    #     Content: 'May I come in?'
    #     Branch: master
    # 
    sed -i '/\.txt/s/^/#/' ./.gitignore
    cat .gitignore
    #*.txt
    touch key.txt
    echo 'May I come in?' > key.txt
    git add key.txt
    git commit -m "Initial commit of key.txt"
    git push
    # remote: ### Attempting to validate files... ####
    # remote:
    # remote: .oOo.oOo.oOo.oOo.oOo.oOo.oOo.oOo.oOo.oOo.
    # remote:
    # remote: Well done! Here is the password for the next level:
    # remote: 3O9RfhqyAlVBEZpVb6LYStshZoqoSx5K
    # remote:
    # remote: .oOo.oOo.oOo.oOo.oOo.oOo.oOo.oOo.oOo.oOo.
    # remote:
    ```

    - The README contained instructions.
    - We had to remove the *.txt from .gitignore so we could push the file.  
    - There seems to be a git hook that responds. It gave us the password. 
        - They probably have a `pre-receive` or `post-receive` hook that reponds and 
          declines the file.  
        - TODO: Look into how git hooks work.  

    - `3O9RfhqyAlVBEZpVb6LYStshZoqoSx5K`


## Level 32 -> 33

After all this git stuff, it’s time for another escape. Good luck!

---

Upon login:
```txt
WELCOME TO THE UPPERCASE SHELL
>> whoami
sh: 1: WHOAMI: Permission denied
>> test
sh: 1: TEST: Permission denied
>> \test
sh: 1: TEST: Permission denied
>> ?
sh: 1: ?: Permission denied
>> \?
sh: 1: ?: Permission denied
>> test='echo'
>> ${test} hello
sh: 1: HELLO: Permission denied
>> $USER
sh: 1: bandit32: Permission denied
>> $SHELL
WELCOME TO THE UPPERCASE SHELL
>> $PATH
sh: 1: /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin: not found
```


<!-- ## Level 33 -> 34 -->

## Resources

- [Oh Shit, Git](https://ohshitgit.com/)

