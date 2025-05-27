# Package Management


## Package Management Tools

The tools used to manage packages on your system heavily depends on your operating system or language.  


| Command    | Description  
| ---| ---
| `dpkg`     | The `dpkg` is a tool to install, build, remove and manage debian packages. The primary, user-friendly front-end for `dpkg` is `apt`  
| `apt`      | `apt` provides a high-level command line interface for the package management system  
| `yum`      | Yum is the older package management tools used on RedHat family systems.  
| `dnf`      | Dandified Yum, the newer package management tools used on RedHat family systems.  
| `rpm`      | RedHat Package Manager. Similar to Debian's `dpkg`, used to find and manage packages
| `aptitude` | `aptitude` is an alternative to `apt` and is a high-level package manager  
| `snap`     | Install, configure, refresh and remove `snap` packages. Snaps enable the secure distribution of the latest apps.  
| `gem`      | `gem` is the front-end to RubyGems, the standard package manager for ruby  
| `pip`      | Python package manager  
| `git`      | Git is a revision control system commonly used to store source code for application or tools for easier development  



## Package Management on Debian-based systems
Debian-based systems (Ubuntu, Mint, etc.) use `apt` with `dpkg` for package management.    
```bash  
apt update          # Update package lists  
apt upgrade         # Upgrade all packages to their newest versions
apt install package # Install a package  
apt remove package  # Remove a package  
dpkg -i package.deb # Install a .deb package manually  
dpkg -r package     # Remove a package  
dpkg -l             # List all installed packages  
dpkg -l | grep -i package_name  # Find out if a package is installed
```

### `dpkg` Output
When using `dpkg -l`, you'll see 5 main columns.  
Most are self-explanatory, but the first column (usually containing `ii`) holds
information about the state of the package.  

Understanding the letters in this column can help troubleshoot bad package
installs.  

1. The first character is the **desired action** performed on the package (what state it should be in, defined by the user):
    - `u`: Unknown.
    - `i`: Install.  
    - `r`: Remove (but keep config)
    - `p`: Purge (remove included config)
    - `h`: Hold

2. The second character is the **current status** of the package (what actually
   happened).  
    - `n`: Not installed.
    - `i`: Installed.  
    - `c`: Config files remain but package is gone.  
    - `u`: Unpacked but not configured.  
    - `F`: Half-configured (package failed halfway through its configuration)  
        - Usually happens when a post-installation script fails (like `postinst`) due to
          a bug or missing dependency.  
    - `H`: Half-installed  
        - Happens when `dpkg -i` (install) starts but is interrupted somehow
          (`^C`/`SIGINT`, system crash, power failure).  
    - `W`: Trigger await. The package is waiting for its trigger to be processed.  
    - `t`: Trigger pending. The trigger has been queued but hasn't been run yet.  
        - The **dpkg triggers** are deferred actions that are run after
          certain changes.  

3. The third character is the error code (if an error occurred).  
   This will be blank if there was no error.


The first column *should* be `ii` for all of your packages.  
However, if there are packages that did not succeed installation or removal, this
may be something other than `ii`.  

Some other example values that are possible:

- `hi`: Held from upgrade but currently installed
- `rc`: Removed but config still exists
- `pn`: Never installed (purge requested, package never found)
- `un`: Unknown package, not installed
- `iU`: Installed but waiting to be configured (e.g., mid-install)

---

###### tl;dr: first char is what you *wanted* to do, second char is what *actually happened*

## Package Management in RedHat-based systems 
RedHat family systems (Rocky, CentOS, Fedora, etc.) use `dnf` and `rpm` for package management.  
```bash  
# Package updates and installations
dnf update                      # Update all packages to the latest available versions  
dnf upgrade                     # Upgrade installed packages, replacing old versions  
dnf install package             # Install a package  
dnf remove package              # Remove a package  
dnf reinstall package           # Reinstall a package  
dnf downgrade package           # Downgrade a package to an earlier version  

# Searching and querying
dnf search package              # Search for a package in repositories  
dnf info package                # Get detailed information about a package  
dnf list installed              # List all installed packages  
dnf list available              # List available packages in the enabled repos  
dnf list package                # Show details about a specific package  

# Managing repositories
dnf repolist                    # List enabled repositories  
dnf repolist all                # Show all available repositories  
dnf config-manager --enable repo_id   # Enable a repository  
dnf config-manager --disable repo_id  # Disable a repository  

# Cleaning up package cache
dnf clean all                   # Clean all cached data  
dnf autoremove                  # Remove unneeded dependencies  

# Working with .rpm files
rpm -ivh package.rpm            # Install an .rpm package manually  
rpm -Uvh package.rpm            # Upgrade an installed .rpm package  
rpm -e package                  # Remove a package  
rpm -qa                         # List all installed packages  
rpm -q package                  # Check if a package is installed  
rpm -ql package                 # List files installed by a package  
rpm -qc package                 # List configuration files of a package  

# Dependency and package verification
dnf deplist package             # Show package dependencies  
rpm -V package                  # Verify installed package integrity  

# Transaction history and rollback
dnf history                     # Show transaction history with their transaction IDs
dnf history info transaction_id # Show details of a specific transaction  
dnf history undo transaction_id # Rollback a transaction  

# Group operations
dnf group list                  # List available package groups  
dnf group install "group-name"  # Install a package group  
dnf group remove "group-name"   # Remove a package group  

# Older systems with yum
yum update              # Update packages  
yum install package     # Install a package  
yum remove package      # Remove a package  
rpm -ivh package.rpm    # Install an .rpm package manually  
rpm -qa                 # List all installed packages  
```


## Find When a Package was Installed
You can find out when a package was installed on a system using the system's
package manager.  

* For Debian-based systems:  
  ```bash
  apt list --installed package_name
  ```

* For RedHat-based systems:  
  ```bash
  rpm -qi package_name | grep -i 'install'
  # or, with yum:
  yum history list package_name
  ```

