# AD Groups

Active Directory (AD) groups are a way to manage permissions for users.  

You can manage AD groups in the GUI on your AD box by going to 
`Active Directory Users and Computers` or running `dsa.msc` from the Start menu.  

You can also manage AD groups directly through PowerShell.  
There are a variety of cmdlets for interacting with AD users and groups.  

## Checking Active AD Groups

### Checking AD Groups from Windows

To check the AD groups on Windows, you can either use the GUI or PowerShell.  

Using the UI:

- `Active Directory Users and Computers` (start, `dsa.msc`)
- Nav to `domain.local` -> `Users`
- Find user
- Go to the `Member Of` tab. This shows all AD groups the user is part of.  


Using PowerShell:

- Run on a domain-joined machine or the AD server.  
  ```sh
  Get-ADUser username -Properties MemberOf | Select-Object -ExpandProperty MemberOf
  ```
  This will output distinguished names, output looks like:
  ```txt
  CN=ssh_users,OU=Groups,DC=example,DC=com
  CN=Domain Users,CN=Users,DC=example,DC=com
  ```

- Or use a "cleaner" method using dot notation to extract the `MemberOf` property
  from the user and pipe it though a loop to extract just the first `CN` from each line:
  ```sh
  (Get-ADUser username -Properties MemberOf).MemberOf | ForEach-Object { ($_ -split ',' )[0]}
  ```
  This will parse the output down to:
  ```txt
  CN=ssh_users
  CN=Domain Users
  ```

### Checking AD Groups from a Linux Machine

On a system that's connected to AD (e.g., through SSSD), you can use the `getent`
tool to view the available AD groups.  
```bash
getent group
```

Look for AD groups, which will look something like:
```bash
domain_users:*:12345:alice,bob,charlie,dave
ssh_allowed:*:12346:alice,dave
```


## Creating a Group in Active Directory

You can either use PowerShell or the GUI to create a new AD group.  

GUI:
- Open `Active Directory Users and Computers` (or start -> `dsa.msc`)
- Go to where you want to create the group (usually under `Users` or a custom `Groups` OU).  
- Right click -> New -> Group
- Fill out the thing.  
    - Group name
    - Group scope
        - Global: Usually the right choice for users in the same domain
        - Universal: If spanning across multiple domains
        - Domain Local: Onlu used for resources in the same domain.  
    - Group Type: 
        - Security: Must be selected to control access to systems.  
- Click OK

PowerShell:

- Use the `New-ADGroup` cmdlet to specify the parameters of the new group.  
  ```sh
  New-ADGroup -Name "ssh_users" -GroupScope Global -GroupCategory Security -Path "CN=Users,DC=example,DC=com"
  ```
    - `-GroupScope Global`: Makes the group usable across the domain.  
    - `-GroupCategory Security`: Means the group can control access (not just email).  
    - `-Path`: Where to create it in the directory tree.  

## Adding Users to a Group

In the GUI:

- Go to the new group
- Right click -> Properties
- Go the the `Members` tab -> Click `Add` -> Add the usernames

In PowerShell:  

- Use the `Add-ADGroupMember` cmdlet to add a user to an AD group.  
  ```sh
  Add-ADGroupMember -Identity "ssh_users" -Members username1, username2
  ```
    - This adds `username1` and `username2` to the `ssh_users` AD group.  



### PowerShell Script to Check Group Membership

Specify a list of users in the array to check their memberships.  

```sh
# check_ad_groups.ps1
# Run in PowerShell on the AD box or a domain-joined machine 

$users = @("username1", "username2", "username3")  # List of AD usernames to check

foreach ($user in $users) {
    write-host "Groups for $user:"
    $groups = (Get-ADUser $user -Properties MemberOf).MemberOf | ForEach-Object { ($_ -split ',')[0] }
    foreach ($group in $groups) {
        write-host "  - $group"
    }
    write-host "---`n"
}
```


## Controlling Linux Access to AD Groups

If a Linux machine is properly joined to an AD domain (e.g., `realmd`/`sssd`) then
the Linux machines should be smart about recognizing the AD groups.  

You can control group access to SSH via `ssh_config` with `AllowGroups`.  
```bash
AllowGroups ssh_users
```
This will add `ssh_users` to the list of `AllowGroups`.  


Alternatively, if your systems are using PAM (Pluggable Authentication Modules),
which they should, then you can use an entry in `/etc/security/access.conf` to
control ingress based on groups. This has the added benefit of not being restricted
to SSH access control, but any type of logins.  

You'd add an entry with the following syntax:
```bash
+:@groupname:ALL
```
This will allow members of the group `groupname` to log in from any location (e.g.,
SSH, TTYs, IPs, etc.). The only requirement is that they are part of the group.  

So if our group is called `ssh_users`:
```bash
+:@ssh_users:ALL
```

- This requrires the PAM stack to include the line:
  ```bash
  account required pam_access.so
  ```
  This is usually the default (at least on Debian-based systems). Check:
  ```bash
  grep -rin 'pam_access' /etc/pam*
  ```
  If it's missing, you can add the line near the top of `/etc/pam.d/sshd`:
  ```bash
  account required pam_access.so
  ```


