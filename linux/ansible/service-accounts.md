# Ansible Service Accounts

Ansible often uses service accounts to manage and automate tasks on remote systems.  
Service accounts are special user accounts that are created specifically for running services or applications, rather than for regular users.  

They typically have limited permissions and are used to enhance security by isolating the service's operations from regular user accounts.

## Creating Service Accounts

Create an Ansible service account the same way you'd create any other user to
begin with.

This can either be done using Ansible itself or with Bash from the CLI.

### Using Bash
Create the user via `useradd`:
```bash
# using bash
sudo useradd -m ansible_svc
```
This creates a new user called `ansible_svc` with a home directory.
The `-m` flag ensures that a home directory is created for the user.

Then, set a password for the user:
```bash
passwd ansible_svc
```
Set the password when prompted.

Ensure that the user is in the `sudo` group (or `wheel` group on Red Hat-based 
systems) if it needs privilege escalation:
```bash
usermod -aG sudo ansible_svc   # For Debian-based systems
usermod -aG wheel ansible_svc  # For Red Hat-based systems
```

Finally, generate an SSH key for the user:
```bash
# switch to the new user
su ansible_svc
ssh-keygen -t ed25519 -C "ansible_svc@localhost"
```
Then press enter to accept default file locations. 


### Using Ansible

#### Without Password
The Ansible `user` module can be used to create a service account and generate 
an SSH key for it.
This can be done with a single ad-hoc command:
```bash
ansible localhost -m user -a "name=ansible_svc state=present generate_ssh_key=true create_home=true group=sudo"
```

- `group=sudo`: Sets the primary group of the user to `sudo`. 
    - Alternatively, `groups=sudo append=true` ensures that the user is added to 
      the `sudo` group without removing it from any other groups it may already 
      belong to.
    - Change `sudo` to `wheel` if you're on a Red Hat-based system.

- There's also an option to specify the password for the user using `password=<hashed_password>`.  

    - Note that the password must be hashed, e.g., using a method like 
      `openssl passwd -6 -noverify`.

    - Instructions for how to do this can be found
      [here](https://docs.ansible.com/projects/ansible/latest/reference_appendices/faq.html#how-do-i-generate-encrypted-passwords-for-the-user-module)

#### With Password

If you want to create the user and set a password at the same time, use a
filter to hash the password before passing it to the `user` module.

```bash
ansible localhost -m user -a "name=ansible_svc state=present generate_ssh_key=true group=sudo password={{ 'mypassword' | password_hash('sha512', 'mysecretsalt') }}"
```
The key part here is:
```bash
"{{ 'mypassword' | password_hash('sha512', 'mysecretsalt') }}"
```

!!! warning "Note"
    
    The `passlib` module must be installed on the Ansible control node for
    this to work.
    ```bash
    pip install passlib
    ```

This can be tested with an ad-hoc command as well:
```bash
ansible all -i localhost, -m debug -a "msg={{ 'mypassword' | password_hash('sha512', 'mysecretsalt') }}"
```

## Copying the SSH Key to Remote Hosts

Every time a new user tries to SSH to a remote host, the remote host needs to 
have the public key of that user in its `~/.ssh/authorized_keys` file.

It will additionally check if the remote host's signature is in the 
`~/.ssh/known_hosts` file of the user trying to connect.
This is what prompts the user to type "yes" when connecting to a new host for
the first time.


To copy the SSH key to the remote host, use the `ssh-copy-id` command:
```bash
ssh-copy-id -i /home/ansible_svc/.ssh/id_ed25519.pub ansible_svc@remote_host
```

- This assumes the `ansible_svc` user already exists on the remote host and 
  that you have the password for it.

## Adding to the Sudoers Group

If the service account needs to run commands with elevated privileges (it 
usually does), it must be added to the sudoers group.

- On Debian-based systems, the sudoers group is typically called `sudo`.
- On Red Hat-based systems, the sudoers group is typically called `wheel`.

If this was not done when creating the user, it can be done afterwards, either
with Bash or Ansible.

Both of the methods below append the `ansible_svc` user to the `sudo` group 
without removing it from any other groups it may already belong to.

- Using Bash:
  ```bash
  # For Debian-based systems
  sudo usermod -aG sudo ansible_svc
  # For Red Hat-based systems
  sudo usermod -aG wheel ansible_svc
  ```

- Using Ansible
  ```bash
  # Debian
  ansible localhost -m user -a "name=ansible_svc groups=sudo append=true"
  # RedHat
  ansible localhost -m user -a "name=ansible_svc groups=wheel append=true"
  ```
  

## Using the Service Account in Ansible Playbooks

When running Ansible playbooks, you should be on the control node as the 
service account user before running playbooks or ad-hoc commands.
```bash
su ansible_svc
```

This will ensure that the playbooks/commands are connecting to the remote hosts 
as that user.

The `become_user` will still be `root`.  
This is necessary for many operations.

For example, on Ubuntu Server, the `apt` lockfile is owned by `root` and has
VERY restrictive permissions:
```bash
-rw-r----- 1 root root 0 Aug  9  2023 /var/lib/apt/lists/lock
```
So this file, which needs to be accessible to the `become_user` when installing
new packages via `apt`, will not be accessible to any other user account.  









