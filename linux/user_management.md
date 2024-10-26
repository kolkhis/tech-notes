

# User Management


## Commands for User Management
Commands for user management:
| Command    | Description
| ---------- | ------------
| `sudo`     | Execute command as a different user
| `su`       | The `su` utility requests appropriate user credentials via PAM and switches to that user ID
| `useradd`  | Creates a new user or update default user information
| `userdel`  | Deletes a user account and related files
| `usermod`  | Modifies a user account
| `addgroup` | Adds a group to the system
| `delgroup` | Removes a group from the system
| `passwd`   | Changes user password
| `chage`    | Changes user password expiration date 


## Creating a New User

To create a new user using commands, use `useradd`:  
```bash
useradd user1
```

Then check that the entry was added to `/etc/passwd`:
```bash
tail -n 1 /etc/passwd
```
This will show you the new user with the format: 
```plaintext
username:password:UID:GID:GECOS:home_dir:login_shell
```
* The `password` field usually has an `x` (if a password exists).  
* The `UID` and `GID` (user/group ID) fields are assigned automatically.  
* The `GECOS` field stores information about the user.  
* `home_dir` is usually `/home/username`.  
* The `login_shell` is `/bin/bash` for users. 
    * Set to `/sbin/nologin` to not allow the user to login with bash.  


---

When a user is created, the default files are pulled from `/etc/skel` and put in the
new user's home directory.  




## User Files
Main user files:  
* `/etc/passwd`
    * Users are stored in this file as:  
      ```plaintext  
      username:password:user_id:group_id:user_info:home_dir:login_shell  
      ```
        * The `password` field usually has an `x` (if a password exists).  
* `/etc/group`
    * Groups are stored in this file as:  
      ```plaintext  
      group_name:password:group_id:group_members  
      ```
        * Just like `/etc/passwd`, the `password` field usually has an `x` (if a password exists).  

* `/etc/shadow`
* `/etc/gshadow`
* `/etc/login.defs`
* `/etc/skel`
* `/etc/sudoers`
* `/etc/sudoers.d/`  

Permissions:  
```bash  
-rw-r--r--. 1 root root 3435 Oct 17 16:59 /etc/passwd  
-rw-r--r--. 1 root root 1399 Oct 17 16:59 /etc/group  
----------. 1 root root  614 Jul  8 01:06 /etc/shadow  
----------. 1 root root  361 Jul  6 05:16 /etc/gshadow  
-rw-r--r--. 1 root root 7778 Oct 30  2023 /etc/login.defs  
```

Passwords are hashed into `/etc/shadow` based on the algo in `/etc/login.defs`.  
They're never stored in `/etc/passwd`.  
```bash  
grep -i 'encrypt_method' /etc/login.defs  
```


## The Shadow Password Suite
Four files compromise the shadow password suite.  
* `/etc/passwd`
* `/etc/group`
* `/etc/shadow`
* `/etc/gshadow`

One other file is used to store the hashing algorithm:
* `/etc/login.defs`

### `/etc/login.defs`
There are a few options in this file that can be changed.  



