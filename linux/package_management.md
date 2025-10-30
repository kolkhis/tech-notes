# Package Management


## Package Management Tools

The tools used to manage packages on your system heavily depends on your operating system or language.  


| Command    | Description  
| ---| ---
| `dpkg`     | `dpkg` is a tool to install, build, remove and manage debian packages. The primary front-end for `dpkg` is `apt`  
| `apt`      | `apt` provides a high-level command line interface for the package management system  
| `yum`      | Yum is the older package management tools used on RedHat family systems.  
| `dnf`      | Dandified Yum, the newer package management tools used on RedHat family systems.  
| `rpm`      | RedHat Package Manager. Similar to Debian's `dpkg`, used to find and manage packages, with `dnf` or `yum` as a front-end
| `snap`     | Install, configure, refresh and remove `snap` packages. Snaps enable the secure distribution of the latest apps.  
| `aptitude` | `aptitude` is an alternative to `apt` and is a high-level package manager  
| `gem`      | `gem` is the front-end to RubyGems, the standard package manager for ruby  
| `pip`      | Python package manager  
| `git`      | Git is a revision control system commonly used to store source code for application or tools for easier development  
| `zypper`   | A package manager for SUSE



## Package Management on Debian-based systems
Debian-based systems (Ubuntu, Mint, etc.) use `apt` with `dpkg` for package management.    

The `apt` command is sort of a wrapper for all the `apt-*` family commands.  
For instance:

- `apt install` is `apt-get install`  
- `apt show` is `apt-cache show`  
- etc.

This provides a centralized tool to perform the same functionality without
memorizing all the different `apt-*` commands. However, there are some commands
that are not available through `apt` itself.  

```bash  
apt update          # Update package lists  (apt-get update)
apt upgrade         # Upgrade all packages to their newest versions (apt-get upgrade)
apt install package # Install a package (apt-get install)  
apt install package=4.5.0 # Install a specific version of a package (apt-get install)  
apt remove package  # Remove a package (apt-get remove) 
apt search package  # Search for a package in the repositories (apt-cache search)
apt show package    # Show a specific package in the repositories (apt-cache show)
apt-cache showpkg package   # Show a package and its dependencies in the repositories
apt-cache depends package   # Show a package's dependencies
apt-cache rdepends package  # Show reverse dependencies 
apt-mark showmanual     # Show packages that were installed manually

dpkg -i package.deb # Install a .deb package manually  
dpkg -r package     # Remove a package  
dpkg -l             # List all installed packages  
dpkg -l | grep -i package_name  # Find out if a package is installed
dpkg -S command     # Search for the package that installed the command
dpkg-query -l pattern # List all packages matching the pattern
dpkg-query -s package # See the status of a package (or multiples)
```

Sometimes package installations can be borked and dependencies aren't properly
installed. 

Fix package installations:
```bash
sudo apt-get update --fix-missing           # Rebuild the package list 
sudo apt-get install --fix-missing package  # Fix broken dependencies automatically
```

Or, simply reinstall the package (this works in most cases).  
```bash
sudo apt-get install --reinstall package
```

If a package installation was interrupted, it may be unpacked but unconfigured.
Use `dpkg` to solve this problem.  
```bash
# Reconfigure partially installed packages (install was interrupted)
sudo dpkg --configure -a
```

We can free up space by clearing the package cache and removing unnecessary
package files and dependencies.  
```bash
sudo apt clean      # Clean pkg cache
sudo apt autoremove # Remove unnecessary files/deps
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

RedHat family systems (Rocky, CentOS, Fedora, etc.) use `rpm` for package management.  
The frontend provided for RPM is usually either `dnf` (newer), or `yum`
(older).  

On SUSE systems, which also use RPM, its frontend may be `zypper`.  

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
dnf whatprovides command        # Show the package that provides the given command
dnf repoquery --requires package  # Show package dependencies
yum deplist package             # Show package dependencies

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

## Find Package Files

### `dpkg --search`
On Debian-based systems, you'd use `dpkg -S` to search for a filename from
installed packages.  

This searches package files for a specific filename. It can be used to 
determine which package a specific file or command came from.  
```bash
dpkg --search filename/toolname
dpkg -S filename/toolname
```
This will match the tool name and show you files that came from the installed
package or tool.  

For instance, finding what package `pgrep` came from:
```bash
dpkg -S pgrep
```

The output would look something like this:
```plaintext
unzip: /usr/share/man/man1/zipgrep.1.gz
procps: /usr/share/man/de/man1/pgrep.1.gz
procps: /usr/share/man/man1/pgrep.1.gz
procps: /usr/share/man/fr/man1/pgrep.1.gz
procps: /usr/share/man/uk/man1/pgrep.1.gz
bash-completion: /usr/share/bash-completion/completions/pgrep
procps: /usr/bin/pgrep
procps: /usr/share/man/sv/man1/pgrep.1.gz
unzip: /usr/bin/zipgrep
```

Then just look for the binary.  

```bash
procps: /usr/bin/pgrep
```
So that tells us that the `procps` package is responsible for installing
`/usr/bin/pgrep`.  

### `dnf whatprovides`

On a Rocky system (or other RedHat-based distros that use `dnf`), you can use the
`dnf whatprovides` command to see where a tool came from. This has the added bonus of
not needing the tool to already be installed. You can use this on any command whether
it's available or not.  
```bash
dnf whatprovides pgrep
```

The output contains what packages provide the tool *and* which repositories they're
coming from.  

```bash
procps-ng-3.3.17-14.el9.i686 : System and process monitoring utilities
Repo        : baseos
Matched from:
Filename    : /usr/bin/pgrep

procps-ng-3.3.17-14.el9.x86_64 : System and process monitoring utilities
Repo        : @System
Matched from:
Filename    : /usr/bin/pgrep

procps-ng-3.3.17-14.el9.x86_64 : System and process monitoring utilities
Repo        : baseos
Matched from:
Filename    : /usr/bin/pgrep
```

So you can see that the package that provides `pgrep` on Rocky is `procps-ng`, and is 
available from the `baseos` repository.  

## Package Management on SUSE

SUSE Linux distributions use the RPM package format, just like RHEL, Rocky, and
other RedHat-based distros.  

The primary front-ends for RPM in SUSE distros are `zypper` and YaST.  

- YaST: This is SUSE's graphical (and text-based) sysadmin suite for managing
  software, system settings, and repositories.  
    - This is for admins that prefer using a GUI.  

- `zypper`: The CLI package manager for SUSE systems.  
    - Used to install, update, and remove packages, and "refresh" package
      sources (repos).  

- `rpm`: The same tool used on RedHat-based systems.    
    - Mainly used to query package databases or interact with RPM files
      directly.  

### Zypper

Zypper has some pretty robust help text/documentation.  
```bash
####### Getting help #######
zypper help         # show all main options/subcmds
zypper help install # help text for a subcmd

####### Search for packages #######
zypper search PKG_NAME/KEYWORD  # Find pkg matching a name or keyword
zypper se PKG_NAME/KEYWORD      # Short form for 'search'

####### Installing packages #######
zypper install PKG_NAME # basic install (auto-resolves deps)
zypper in PKG_NAME      # Short form for 'install'

zypper --non-interactive install PKG_NAME # Skip prompts (like -y)
zypper -n in PKG_NAME   # Short form/Skip prompts (like -y)

zypper install --from REPONAME PKG_NAME # Install from specific repository
# '--repo' is an alias for '--from'

####### Removing packages #######
zypper remove PKG_NAME # Uninstall package
zypper rm PKG_NAME     # Short form
zypper remove --dry-run PKG_NAME  # Do a dry run to simulate

####### Update Packages/System #######
zypper update   # Update package 
zypper up       # Short form
zypper patch    # apply all patches

####### Managing repos #######
zypper repos    # List repos
zypper lr       # Short form

# Add a new repo
zypper addrepo URL_OR_PATH REPO_ALIAS  # Add a new repository
zypper refresh  # Refresh repos
```


## Resources

- `man`
    - `apt`
    - `apt-get`
    - `apt-cache`
    - `apt-mark`
    - `dpkg`
    - `dnf`
    - `yum`
    - `rpm`

- <https://en.opensuse.org/Package_management>

