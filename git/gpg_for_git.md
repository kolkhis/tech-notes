# GPG for Git

##### Plain GPG Protected Credential Helper:
1. Set git to use gpg
`$ git config --global credential.credentialStore gpg`

1. Generate gpg key
    1. Run `$ gpg --full-generate-key`
    1. Specify the type. RSA/whatever (default) is good. (is ed25519 available?)
    1. Specify key size (4096)
    1. Enter when key will expire
    1. Verify
    1. Enter User info (Email should be the same as GH account)
    1. Set a password
1. Get the secret key
`$ gpg --list-secret-keys --keyid-format=long`
It will look something like `rsa4096/<secret_key>` under the `sec` section. Only take the key.

1. Init the password with the secret key
`$ pass init <secret_key>`

1. Add the public key to GH account.
    * Get the public key with `$ gpg --armor --export <secret_key>`.
        * ` > gpg_key` for easy copypasta
    * Profile > Settings > SSH and GPG keys. Paste key.
 
