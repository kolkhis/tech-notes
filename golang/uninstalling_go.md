# Uninstalling Go
##### Taken from [official docs](https://go.dev/doc/manage-install#uninstalling)

You can remove Go from your system using the steps described in this topic.

## Linux / macOS / FreeBSD

Delete the go directory.

This is usually `/usr/local/go`.
Remove the Go `bin` directory from your `PATH` environment variable.

Under Linux and FreeBSD, edit `/etc/profile` or `$HOME/.profile`.
If you installed Go with the macOS package, remove the `/etc/paths.d/go` file.

## Windows

The simplest way to remove Go is via Add/Remove Programs in the Windows control panel:

1. In Control Panel, double-click Add/Remove Programs.
2. In Add/Remove Programs, select Go Programming Language, click Uninstall, then 
   follow the prompts.

---

For removing Go with tools, you can also use the command line:

1. Uninstall using the command line by running the following command:
```cmd
msiexec /x go{{version}}.windows-{{cpu-arch}}.msi /q
```

Note: Using this uninstall process for Windows will automatically remove Windows 
environment variables created by the original installation.

