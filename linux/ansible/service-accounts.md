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
This creates a new user called `ansible_svc` with a home directory (though it
doesn't usually need one).
The `-m` flag ensures that a home directory is created for the user.

Then, set a password for the user:
```bash
passwd ansible_svc
```
Set the password when prompted.

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
ansible localhost -m user -a "name=ansible_svc state=present generate_ssh_key=true"
```

- Optionally add `create_home=true` to ensure a home directory is created for
  the user.
- There's also an option to specify the password for the user using `password=<hashed_password>`.  
    - Note that the password must be hashed using a method like `openssl passwd -6`.
    - Instructions for how to do this can be found
      [here](https://docs.ansible.com/projects/ansible/latest/reference_appendices/faq.html#how-do-i-generate-encrypted-passwords-for-the-user-module)

#### With Password

If you want to create the user and set a password at the same time, use a
filter to hash the password before passing it to the `user` module.
```bash
ansible localhost -m user -a "name=ansible_svc state=present generate_ssh_key=true password={{ 'mypassword' | password_hash('sha512', 'mysecretsalt') }}"

