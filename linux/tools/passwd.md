# `passwd`

## Using `passwd`
Using passwd is the easiest way to change a user's password or 
perform other actions around user passwords.

### Change a user's password:
```bash
passwd username
```
This will prompt you to enter a new password for `username`.

### Lock a user's password:
Locking a user's password will prevent them from logging in.
This does not disable a user's account, it just prevents them from logging in.
```bash
passwd -l username
```
This will lock the password for `username`, preventing them from logging in.  

### Unlock a user's password:
Unlocking a user's password will allow them to log in, undoing
the effect of `passwd -l username`.
```bash
passwd -u username
```
The password will revert to what it was before it was locked.  


### Set passwords to expire:
Making passwords expire is a good security practice, as it
forces users to change their passwords every `N` days.
```bash
passwd -x 60 username
```
This sets `--max-days=60` for `username`.
That means that the maximum number of days that the user's password
will remain valid is 60 days, after that they will need to change it. 

---

### Set how often a user can change their password

To set a minimum number of days between password changes,
to prevent a user from changing passwords too often, 
use the `-n` (`--mindays`) flag.
```bash
passwd -n 30 username
```
This will set `--min-days=30` for `username`.
Which means that the user will only be able to change their
password every 30 days.  


### Display a warning that a password is going to expire


## Options

| Option           | Description
|-|-
| `-a, --all`      | Used with `-S` to show status for all users.
| `-d, --delete`   | Deletes a user's password, making the account passwordless.
| `-e, --expire`   | Expires an account's password to force password change at next login.
| `-h, --help`     | Displays help message and exits.
| `-i, --inactive` | Disables an account after password expiration for `specified days`.
| `-k, --keep-tokens`| Changes password only for expired tokens, keeps non-expired ones unchanged.
| `-l, --lock`     | Locks password of the account, disabling it without disabling account itself.
| `-n, --mindays`  | Sets minimum days between password changes to `MIN_DAYS`. Zero allows changing at any time.
| `-q, --quiet`    | Quiet mode.
| `-r, --repository` | Changes password in specified `REPOSITORY`.
| `-R, --root`     | Applies changes in specified `CHROOT_DIR` directory, using its config files.
| `-S, --status`   | Displays account information: login name, password status, last change, and password policies.
| `-u, --unlock`   | Unlocks the password of the account. Reverts to what it was before `-l`.
| `-w, --warndays` | Sets days of warning before password expiration.
| `-x, --maxdays`  | Sets the max number of days a password stays valid before requiring a change.


### `-k, --keep-tokens`

When you change a password in Linux using the `passwd` command, all authentication tokens associated with the user, such as passwords or possibly other forms of authentication, are typically reset. The `-k` option, however, modifies this behavior by ensuring that only expired authentication tokens are updated. Non-expired tokens, such as valid passwords or other credentials that haven't yet reached their expiration date, remain unchanged.

Practical Use: This option is particularly useful in environments where multiple forms of authentication are used, and you want to enforce password changes for security reasons without affecting currently valid tokens. It helps in scenarios where, for example, forcing a password update due to a policy change without disrupting users who have recently updated their passwords.

### `-r, --repository`

* A `REPOSITORY`, in this context, refers to a place where user authentication data is stored.

This specifies that the password change should be made in a specific 
password `REPOSITORY` rather than the default system password file (typically
`/etc/shadow` on most Linux systems).

* Linux systems can be configured to use alternative authentication methods, such
  as LDAP, NIS, or others, which might store their data in different repositories.

---

### `-R, --root CHROOT_DIR`

The `-R` option specifies that the `passwd` command should operate in a `chroot` environment.  

* `chroot` is a Unix operation that changes the root directory for the current running
  process and its children, effectively isolating it from the rest of the system.

This tells `passwd` to apply changes as if it were running inside
the specified `CHROOT_DIR` directory, using configuration files from that
directory instead of the system's root.

<!-- ## Using `chage` -->
