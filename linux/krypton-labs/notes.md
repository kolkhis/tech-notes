# Krypton Lab Notes

These are notes taken during the Krypton labs from OverTheWire, which can be
found [here](https://overthewire.org/wargames/krypton/).

These labs are designed to teach people about cryptography from the command line.  

SSH information:
- Host: krypton.labs.overthewire.org
- Port: 2231

Add SSH config entry for easily connecting:
```conf
Host krypton
    Hostname krypton.labs.overthewire.org
    Port 2231
```

## Level 0->1

> Welcome to Krypton! The first level is easy.
> The following string encodes the password using Base64:
> `S1JZUFRPTklTR1JFQVQ=`
> Use this password to log in to krypton.labs.overthewire.org with username krypton1 using SSH on port 2231. You can find the files for other levels in /krypton/

!!! warning "Solution"

    ```bash
    base64 -d <<< 'S1JZUFRPTklTR1JFQVQ='
    ```
    Output:

    - `KRYPTONISGREAT`

    ```bash
    ssh krypton1@krypton
    ```

## Level 1->2

> The password for level 2 is in the file ‘krypton2’.  
> It is ‘encrypted’ using a simple rotation.  
> It is also in non-standard ciphertext format.  
> When using alpha characters for cipher text it is normal to group the letters into 5 letter clusters, regardless of word boundaries.  
> This helps obfuscate any patterns.  
> This file has kept the plain text word boundaries and carried them to the cipher text.  
> Enjoy!

!!! warning "Solution"

    Look at the file:
    ```bash
    ls -alh /krypton/krypton1/krypton2
    cat /krypton/krypton1/krypton2
    # YRIRY GJB CNFFJBEQ EBGGRA
    ```
    This is a ROT13 encoded string.  
    It can be decoded in vi/vim by using `g?`.  

    - `LEVEL TWO PASSWORD ROTTEN`

    ```bash
    ssh krypton2@krypton
    ```

## Level 2->3

> ROT13 is a simple substitution cipher.
> 
> Substitution ciphers are a simple replacement algorithm. In this example of a 
> substitution cipher, we will explore a ‘monoalphebetic’ cipher. Monoalphebetic 
> means, literally, “one alphabet” and you will see why.
> 
> This level contains an old form of cipher called a ‘Caesar Cipher’. A Caesar cipher shifts the alphabet by a set number. For example:
> 
> plain:  a b c d e f g h i j k ...
> cipher: G H I J K L M N O P Q ...
> In this example, the letter ‘a’ in plaintext is replaced by a ‘G’ in the ciphertext so, for example, the plaintext ‘bad’ becomes ‘HGJ’ in ciphertext.
> 
> The password for level 3 is in the file krypton3.
> It is in 5 letter group ciphertext. It is encrypted with a Caesar Cipher.
> Without any further information, this cipher text may be difficult to break.
> You do not have direct access to the key, however you do have access to a program
> that will encrypt anything you wish to give it using the key.
> If you think logically, this is completely easy.
> 
> One shot can solve it!
> 
> Have fun.
> 
> Additional Information:
> 
> The encrypt binary will look for the keyfile in your current working directory.
> Therefore, it might be best to create a working direcory in /tmp and in there a link to the keyfile.
> As the encrypt binary runs setuid krypton3, you also need to give krypton3 access to your working directory.
> 
> Here is an example:
> 
> krypton2@melinda:~$ mktemp -d
> /tmp/tmp.Wf2OnCpCDQ
> krypton2@melinda:~$ cd /tmp/tmp.Wf2OnCpCDQ
> krypton2@melinda:/tmp/tmp.Wf2OnCpCDQ$ ln -s /krypton/krypton2/keyfile.dat
> krypton2@melinda:/tmp/tmp.Wf2OnCpCDQ$ ls
> keyfile.dat
> krypton2@melinda:/tmp/tmp.Wf2OnCpCDQ$ chmod 777 .
> krypton2@melinda:/tmp/tmp.Wf2OnCpCDQ$ /krypton/krypton2/encrypt /etc/issue
> krypton2@melinda:/tmp/tmp.Wf2OnCpCDQ$ ls
> ciphertext  keyfile.dat

!!! warning "Solution"

    - OMQEMDUEQMEK

    ```bash
    chmod 777 .
    ln -s /krypton/krypton2/keyfile.dat .
    chmod 777 .
    ln -s /krypton/krypton2/encrypt .
    ls
    echo 'test' > testfile
    ./encrypt testfile
    cat ciphertext 
    # FQEF
    ```
    'test' turns into 'FQEF'.  

    - T turns into to F.  
    - 20th letter to the 6th letter.  

    It's a -12 shift.  

    So this will give the same result either way:

    - `CAESARISEASY`



<!-- ## Level 3->4 -->
<!-- ## Level 4->5 -->
<!-- ## Level 5->6 -->
<!-- ## Level 6->7 -->
