# Encryption with Vim

## Table of Contents
* [Encryption with Vim](#encryption-with-vim) 
* [tl;dr](#tl;dr) 
* [Help Page](#help-page) 

## tl;dr:
Only available when compiled with the `+cryptv` feature.
```vim
:X
```
Prompts for an encryption key (typed text doesn't show).  
The typed key is stored in the 'key' option, which is used to encrypt
the file when it is written.  
The file will remain unchanged until you write it.  
The value of the 'key' options is used when text is written
To disable the encryption, reset the 'key' option to an empty value: >
```vim
:set key=
```

```vim
" Set cryptmethod before writing 
:setlocal cm=zip          " weak method, backwards compatible
:setlocal cm=blowfish     " method with flaws, do not use
:setlocal cm=blowfish2    " medium strong method (recommended)
:setlocal cm=xchacha20v2  " medium strong method using libsodium

" These functions become available for encrypted files
has('crypt-blowfish')
has('crypt-blowfish2')


" test for blowfish with:
if v:version >= 703

" And for blowfish2 with: 
if v:version > 704 || (v:version == 704 && has('patch401'))
```
* The text in memory is not encrypted.
    * A system administrator may be able to see your text while you are editing it.  
* When filtering text with ":!filter" or using ":w !command" the text 
  is also not encrypted, this may reveal it to others.

* The 'viminfo' file is not encrypted.
* The text in the swap file and the undo file is also encrypted.  
    * This is done block-by-block and may reduce the time needed to crack a password. 
    * You can disable the swap file, but then a crash will cause you to lose your work.  
    * The undo file can be disabled without too much disadvantage.
    ```vim
    :set noundofile
    :noswapfile edit secrets
    ```


> *:h :X*
Spot Instance




## Help Page

9. Encryption                       *encryption*

Vim is able to write files encrypted, and read them back.  The encrypted text
cannot be read without the right key.
{only available when compiled with the |+cryptv| feature}  *E833*

The text in the swap file and the undo file is also encrypted.  *E843*
However, this is done block-by-block and may reduce the time needed to crack a
password.  You can disable the swap file, but then a crash will cause you to
lose your work.  The undo file can be disabled without too much disadvantage. >
    :set noundofile
    :noswapfile edit secrets

Note: The text in memory is not encrypted.  A system administrator may be able
to see your text while you are editing it.  When filtering text with
":!filter" or using ":w !command" the text is also not encrypted, this may
reveal it to others.  The 'viminfo' file is not encrypted.

You could do this to edit very secret text: >
    :set noundofile viminfo=
    :noswapfile edit secrets.txt
Keep in mind that without a swap file you risk losing your work in the event
of a crash or a power failure.

WARNING: If you make a typo when entering the key and then write the file and
exit, the text will be lost!

The normal way to work with encryption, is to use the ":X" command, which will
ask you to enter a key.  A following write command will use that key to
encrypt the file.  If you later edit the same file, Vim will ask you to enter
a key.  If you type the same key as that was used for writing, the text will
be readable again.  If you use a wrong key, it will be a mess.

                            *:X*
:X  Prompt for an encryption key.  The typing is done without showing the
    actual text, so that someone looking at the display won't see it.
    The typed key is stored in the 'key' option, which is used to encrypt
    the file when it is written.
    The file will remain unchanged until you write it.  Note that commands
    such as `:xit` and `ZZ` will NOT write the file unless there are other
    changes.
    See also |-x|.

The value of the 'key' options is used when text is written.  When the option
is not empty, the written file will be encrypted, using the value as the
encryption key.  A magic number is prepended, so that Vim can recognize that
the file is encrypted.

To disable the encryption, reset the 'key' option to an empty value: >
    :set key=

You can use the 'cryptmethod' option to select the type of encryption, use one
of these: >
    :setlocal cm=zip          " weak method, backwards compatible
    :setlocal cm=blowfish     " method with flaws, do not use
    :setlocal cm=blowfish2    " medium strong method
    :setlocal cm=xchacha20v2  " medium strong method using libsodium

Do this before writing the file.  When reading an encrypted file it will be
set automatically to the method used when that file was written.  You can
change 'cryptmethod' before writing that file to change the method.

To set the default method, used for new files, use this in your |vimrc|
file: >
    set cm=blowfish2
Using "blowfish2" is highly recommended.  Only use another method if you
must use an older Vim version that does not support it.

The message given for reading and writing a file will show "[crypted]" when
using zip, "[blowfish]" when using blowfish, etc.

When writing an undo file, the same key and method will be used for the text
in the undo file. |persistent-undo|.

To test for blowfish support you can use these conditions: >
    has('crypt-blowfish')
    has('crypt-blowfish2')
This works since Vim 7.4.1099 while blowfish support was added earlier.
Thus the condition failing doesn't mean blowfish is not supported. You can
test for blowfish with: >
    v:version >= 703
And for blowfish2 with: >
    v:version > 704 || (v:version == 704 && has('patch401'))
If you are sure Vim includes patch 7.4.237 a simpler check is: >
    has('patch-7.4.401')
