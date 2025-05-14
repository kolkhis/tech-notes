# `pass` - CLI Password Manager

## Using GPG with Pass (Password Manager)

Before you can use `pass`, you need to initialize it with a GPG key.

* See `./gpg.md` on how to generate a GPG key and get its ID.


Initialize `pass` with a GPG Key ID.
```bash  
pass init <Your-Key-ID>  
```

### How to Use `pass`

* To add a new password to `pass`:
    ```bash
    pass insert <path/to/password>
    ```
* To retrieve a password: 
    ```bash
    pass show <path/to/password>
    ```

Passwords are stored in a GPG-encrypted file structure, which can
be backed up or synchronized like any other files.

The security of your passwords in `pass` depends on the security
of your GPG key and the strength of your passphrase.
