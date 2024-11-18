

# User Management


## Table of Contents
* [Commands for User and Group Management](#commands-for-user-and-group-management) 
* [Show Default User Settings](#show-default-user-settings) 
    * [Changing the Default User Settings](#changing-the-default-user-settings) 
* [Creating a New User](#creating-a-new-user) 
* [Setting up Password Change Policies](#setting-up-password-change-policies) 
* [User Files](#user-files) 
* [The Shadow Password Suite](#the-shadow-password-suite) 
* [Manually Adding Users Through `/etc/passwd`](#manually-adding-users-through-etcpasswd) 
    * [Add a new line for the user](#add-a-new-line-for-the-user) 
    * [Create the user's home directory](#create-the-users-home-directory) 
    * [Set permissions for the home directory](#set-permissions-for-the-home-directory) 
    * [Set the user's password](#set-the-users-password) 
    * [Test the new user account](#test-the-new-user-account) 
* [Determining the UID and GID for a New User](#determining-the-uid-and-gid-for-a-new-user) 
    * [Finding an Available UID](#finding-an-available-uid) 
    * [Determining the **GID (Group ID)**](#determining-the-gid-group-id) 
* [The GECOS Field (General Electric Comprehensive Operating System)](#the-gecos-field-general-electric-comprehensive-operating-system) 
* [Useful User and Group Management Commands](#useful-user-and-group-management-commands) 
    * [Lock or Unlock a User Account](#lock-or-unlock-a-user-account) 
    * [Change a user's login shell](#change-a-users-login-shell) 
    * [Add a User to a Group](#add-a-user-to-a-group) 
    * [Change a User's Home Directory](#change-a-users-home-directory) 
* [Best Practices for User and Group Management](#best-practices-for-user-and-group-management) 
* [Backing up User Configuration Files](#backing-up-user-configuration-files) 
* [Resources](#resources) 


## Commands for User and Group Management
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
| `users`    | Lists the users currently logged into the system
| `groups`   | Lists all the groups on the system  
| `id`       | Get GID, UID, and groups for a user
| `who`      | Show who is logged in and what they are doing
| `w`        | More detailed version of `who`  
| `last`     | Show login records for all users
| `lslogins` | Information about users and processes
| `getent`   | Display entries from the Name Service Switch libraries


```bash
# Creating and managing users
useradd -m username        # Create a new user with a home directory
passwd username            # Set a password for the user
usermod -aG sudo username  # Add a user to a specific group 
userdel -r username        # Delete a user and their home directory

# Managing groups
addgroup groupname             # Create a new group
usermod -aG groupname username # Add an existing user to a group
delgroup groupname             # Delete a group
groups username                     # List all groups a user belongs to

# Getting user and group information
id username      # Show UID, GID, and groups for the user
who              # Show who is logged in
w                # Show who is logged in, and what they're doing
last             # Show login records, newest to oldest
last | tac       # Show login records, oldest to newest 
getent passwd username  # Show the /etc/passwd entry for a user


# Password management
passwd                  # Change the password for the current user
passwd username         # Change the password for another user (root only)
passwd -l username      # Lock a user's account
passwd -u username      # Unlock a user's account
chage -M 30 username    # Set password expiration for a user (expire in 30 days)
chage -l username       # View password expiration details

# User modifications
usermod -l newusername username  # Rename a user account
usermod -d /new/home/dir -m username # Change a user's home directory and create it
gpasswd -d username groupname  # Remove a user from a group

```

## Show Default User Settings 

Show the defaults for users made with the `useradd` command:
```bash
useradd -D
```

Output:
```plaintext
GROUP=100
HOME=/home
INACTIVE=-1
EXPIRE=
SHELL=/bin/sh
SKEL=/etc/skel
CREATE_MAIL_SPOOL=no
```
This shows:
* `GROUP`: The group that they will be added to when created,
* `HOME`: Where their home directory will be.  
* `INACTIVE`: The number of days after a password expires before the account is locked.  
    * `-1` means the account will never be locked when a password expires.  
* `EXPIRE`: The date when the account will expire and be disabled.  
* `SHELL`: The login shell they will have
* `SKEL`: The skeleton directory, where their default home files will be copied from.
* `CREATE_MAIL_SPOOL`: Whether or not to create a mail spool (mailbox) for the user.  

The skeleton directory is the location where it will pull default files from (`SKEL`).  
Every file in `/etc/skel` will be copied into the new user's home directory.  


### Changing the Default User Settings
The defaults can be changed by adding more arguments to the `useradd -D` command:
```bash
useradd -D -b /home/user1   # Change the default home directory
useradd -D -s /bin/sh       # Change the default shell
useradd -D -e 01/01/2024    # Change the default expiration date of new accounts
useradd -D -f 40            # Change the default inactivity period for new accounts
useradd -D -g 100           # Change the default group ID for new accounts
```



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


When a user is created, the default files are pulled from `/etc/skel` and put in the
new user's home directory.  

Every file from `/etc/skel/` is copied to the new user's home directory.  

This is a good way to make sure new users have certain files or settings that you
want them to have.  


## Setting up Password Change Policies
Having users regularly change their passwords is a good security practice.  
You can use the `chage` command to set password change policies.  

`chage` changes the number of days between password changes and the date of the 
last password change.
```bash
chage -m 30 user1  # Sets the minimum number of days between password changes to 30 days

chage -M 45 user1  # Sets the max number of days between password changes to 45 days
chage -M -1        # Remove checking a password's validity.  

chage -I 3 user1  # Set the number of days until the user must change their password to 3 days.
chage -I -1 user1 # Stop the account from being locked after a password expires.  

chage -M 90 user1  # Set the number of days after a password has expired until the account is disabled.  
chage -W 5 user1   # Set the number of days the user will be warned before the password expires. 
chage -d 0 user1   # Disable password aging. Resets the age of the password to 0 days.   
```



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
    * There are a few options in this file that can be changed.  




## Manually Adding Users Through `/etc/passwd`  
Each line in the `/etc/passwd` file represents a user account.  
You can manually add a user account by adding a line to this file.  

### Add a new line for the user  
You'll need to open `/etc/passwd` to add a user manually:
```bash
sudo vi /etc/passwd
```
The format of each line is as follows:  
```bash  
username:password:UID:GID:GECOS:home_directory:shell  
```
* `username`: The username for the new user.  
* `password`: The encrypted password for the user.  
    * You can leave this field empty to disable password login.  
    * You can also leave this empty and set the password manually 
      with the `passwd` command.
* `UID`: The user ID for the new user. Normally auto-generated when adding users with `useradd`.  
* `GID`: The primary group ID for the new user. Also auto-generated when using `useradd`.    
* `GECOS`: Additional information about the user (such as full name or description).  
* `home_directory`: The home directory for the new user.  
* `shell`: The login shell for the new user.  
    * Set to `/bin/bash` to allow them to use bash on the system.  

Save and close the file after adding the user information.  

### Create the user's home directory  
If you specified a home directory for the new 
user, you may need to manually create it using the `mkdir` command.  
```bash  
sudo mkdir /home/newuser  
```

### Set permissions for the home directory  

After creating the home directory, make the new user the owner to allow the new user 
to access it.  
* ```bash  
  sudo chown newuser:newuser /home/newuser  
  ```

### Set the user's password 
If you left the password field empty in the `/etc/passwd` file, set a password for 
the new user using the `passwd` command.  
* ```bash  
  sudo passwd newuser  
  ```

### Test the new user account  
After completing those steps, you can test the new 
user account by logging in with the username and password (if applicable) and 
verifying that the user has access to the home directory.  


## Determining the UID and GID for a New User 

### Finding an Available UID  
* To find the next available UID, you can typically look at the highest UID used for 
  existing users in the `/etc/passwd` file and increment it by 1.  
    * Alternatively, you can use the `id` command to list existing user IDs and choose one 
      that is not already in use.  
* For example, you can use the following command to list existing user IDs:  
```bash  
awk -F: '{print $3}' /etc/passwd  
```
You could also sort them in numerical order:  
```bash  
awk -F: '{ print($3) }' /etc/passwd | sort -n  
```

### Determining the **GID (Group ID)**  
All the groups on the system live in the `/etc/group` file.  

* You should choose a unique GID for the new user's primary group.  
    * The GID is a numeric value that identifies the primary group to which the user 
      belongs.  
* You can choose an existing group's GID or create a new group with a unique GID.  
    * To find the next available GID, you can follow a similar approach as for finding 
      the UID.  
* For example, you can use the following command to list existing group IDs:  
```bash  
awk -F: '{print $3}' /etc/group  
```

## The GECOS Field (General Electric Comprehensive Operating System)  

* The GECOS field typically includes additional information about the user, such as 
  the user's full name or description.  
* You can enter any descriptive information you like in the GECOS field, such as the 
  user's full name or job title.  
    * This field is optional, so you can leave it empty if you prefer.  
* For example, you can enter "John Smith,,," to indicate that the user's full name is 
  "John Smith" and leave the other fields empty.  



## Useful User and Group Management Commands


### Lock or Unlock a User Account
You can lock a user account with `passwd -l`:
```bash
sudo passwd -l user1  # Lock user1 from being able to login
```

Unlock with `passwd -u`:
```bash
sudo passwd -u user1  # Unlock user1's account
```

### Change a user's login shell
To change a user's login shell, use `usermod`:
```bash
usermod -s /bin/sh user1
```
This changes `user1`'s login shell to `/bin/sh`.  


### Add a User to a Group
Add a user to a group with `usermod -aG`:
```bash
usermod -aG group1 user1
```
* `-aG`: Adds the user to a secondary group without removing them from existing groups.  


### Change a User's Home Directory
User home directories can be changed with `usermod -d`:
```bash
usermod -d /new_home/dir -m user1
```
* `-d`: Sepcifies the new home diretcory.  
* `-m`: Moves the contents of the old home directory to the new one.  


## Best Practices for User and Group Management
* Always create individual user accounts for each person who needs access.
  Avoid using shared accounts.  
* Use strong password policies. Enforce regular password changes with tools like `chage`.  
    * `chage` changes the number of days between password changes and the date of the 
      last password change.
    * `chage -d 0` disables password aging. It resets the age of the password to `0` days.   
    * `chage -I -1` sets the number of days until the user must change their password to `1` day.
    * `chage -M 90` sets the number of days after a password has expired until the account is disabled.  

## Backing up User Configuration Files
It's a good idea to back up user configuration files:
```bash
sudo cp /etc/passwd /etc/passwd.bak
sudo cp /etc/shadow /etc/shadow.bak
sudo cp /etc/group /etc/group.bak
```



## Resources
* [User mangement on Linux (GeeksForGeeks)](https://www.geeksforgeeks.org/user-management-in-linux/)
* [Finding User Info (hostingmate)](https://hostingmate.net/web-hosting/12-ways-to-find-user-account-info-and-login-details-in-linux/)



