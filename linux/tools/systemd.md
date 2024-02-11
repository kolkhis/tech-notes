
# systemd

TODO: Write actual notes on this topic.  

```bash
systemctl list-units --state=failed
```



* `systemctl cat ssh`
This will show you the configuration used for the ssh service.

* `cd /etc/systemd/system && ls`
This is the directory where systemd stores its service files.
You can find `target` files, `service` files, and `socket` files.

It will specify `target.wants/` and `service.wants/` directories, as well as 
`service.requires/` directories. These are the directories where systemd will look for
the configuration files for the services that it is managing.



```bash
systemd-analyze --help
```
This will output all of the different arguments and commands that
you can use with `systemd-analyze`.

## List of different systemd commands

```plaintext
systemd-analyze                 systemd-escape                  systemd-run
systemd-ask-password            systemd-hwdb                    systemd-socket-activate
systemd-cat                     systemd-id128                   systemd-stdio-bridge
systemd-cgls                    systemd-inhibit                 systemd-sysext
systemd-cgtop                   systemd-machine-id-setup        systemd-sysusers
systemd-cryptenroll             systemd-mount                   systemd-tmpfiles
systemd-delta                   systemd-notify                  systemd-tty-ask-password-agent
systemd-detect-virt             systemd-path                    systemd-umount
```

