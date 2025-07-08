# AD Groups



---

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



## Check Group Membership

Specify a list of users to check memberships of.  

```sh
# check_ad_groups.ps1
# Usage: Run in PowerShell on a domain-joined machine

$users = @("username1", "username2", "username3")  # List of AD usernames to check

foreach ($user in $users) {
    Write-Host "Groups for $user:"
    $groups = (Get-ADUser $user -Properties MemberOf).MemberOf | ForEach-Object { ($_ -split ',')[0] }
    foreach ($group in $groups) {
        Write-Host "  - $group"
    }
    Write-Host "`n"
}
```

