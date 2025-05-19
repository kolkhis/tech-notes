# AIDE

AIDE stands for Advanced Instrusion Detection Environment.  

AIDE is a tool used for detecting changes inside a system.  

It does this by calculating the hashes of specified system files, storing them in a
database, then periodically checking those hashes against newly calculated hashes
of the same files to see if anything has changed in those files.  

It's a great tool for detecting configuration drift.  

## `aide` Usage

Install AIDE with your package manager:
```bash
sudo apt install -y aide
```

Create a new AIDE database:
```bash
aide -i -c /etc/aide/aide.conf
```

This will output a new database, `/var/lib/aide/aide.db.new`.  

- The `.new` is added so it does not overwrite any pre-existing AIDE database.  

Set up the database properly:
```bash
cp /var/lib/aide/aide.db.new /var/lib/aide/aide.db
```

Then you can test AIDE by making changes in a tracked directory, then running:
```bash
aide -c /etc/aide/aide.conf --check
```


## AIDE Configuration Files

When installing AIDE, you'll see a bunch of files put into `/etc/aide/aide.conf.d`.  
These files contain instructions for AIDE.  
The instructions have some conditional statements inside, and they also contain
patterns for files that should be hashed, stored, and checked every time an aide
check is run.  

An example configuration file:
`/etc/aide/aide.conf.d/31_aide_apache2`
```c
# you can define your own APACHE2_LOGS regex in an earlier file,
# overriding the defaults given here
@@if not defined APACHE2_LOGS
@@if defined APACHE2_SUEXEC
@@define APACHE2_LOGS (access|error|suexec)
@@else
@@define APACHE2_LOGS (access|error)
@@endif
@@endif
/var/log/apache2/@@{APACHE2_LOGS}\\.log$ f Log
/var/log/apache2/@@{APACHE2_LOGS}\\.log\\.1$ f LowLog
/var/log/apache2/@@{APACHE2_LOGS}\\.log\\.2\\.@@{LOGEXT}$ f LoSerMemberLog
/var/log/apache2/@@{APACHE2_LOGS}\\.log\\.([3-9]|[1-4][0-9]|5[0-1])\\.@@{LOGEXT}$ f SerMemberLog
/var/log/apache2/@@{APACHE2_LOGS}\\.log\\.52\\.@@{LOGEXT}$ f HiSerMemberLog

/@@{RUN}/apache2/apache2\\.pid$ f VarFile
/@@{RUN}/apache2/ssl_scache$ f VarFile
/var/log/apache2$ d VarDir
/@@{RUN}/apache2$ d VarDirInode
```

Conditional statements start the line with two `@` symbols (`@@`).  

