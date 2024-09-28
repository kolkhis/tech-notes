
# Manually Adding User Accounts on a Linux System  


## Table of Contents  
* [Manually Adding User Accounts on a Linux System](#manually-adding-user-accounts-on-a-linux-system) 
* [Adding Users Through /etc/passwd](#adding-users-through-/etc/passwd) 
    * [Add a new line for the user](#add-a-new-line-for-the-user:) 
    * [Create the user's home directory](#create-the-user's-home-directory) 
    * [Set permissions for the home directory](#set-permissions-for-the-home-directory) 
    * [Set the user's password](#set-the-user's-password) 
    * [Test the new user account](#test-the-new-user-account) 
* [Determining the UID and GID for a New User](#determining-the-uid-and-gid-for-a-new-user) 
    * [Finding an Available UID](#finding-an-available-uid) 
    * [Determining the **GID (Group ID)**](#determining-the-**gid-(group-id)**) 


## Adding Users Through /etc/passwd  
Each line in the `/etc/passwd` file represents a user account.  

### Add a new line for the user:  
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
* `UID`: The user ID for the new user.  
* `GID`: The primary group ID for the new user.  
* `GECOS`: Additional information about the user (such as full name or description).  
* `home_directory`: The home directory for the new user.  
* `shell`: The login shell for the new user.  
    * Set to `/bin/bash` to allow them to use bash on the system.  

Save and close the file after adding the user information.  

### Create the user's home directory  
If you specified a home directory for the new 
user, you may need to manually create it using the `mkdir` command.  
* ```bash  
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




