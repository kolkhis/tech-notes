
# Go Mod Tidy

## Usage
Output of `go help mod tidy`, formatted:

```bash
go mod tidy [-e] [-v] [-x] [-go=version] [-compat=version]
```

Tidy makes sure `go.mod` matches the source code in the module.

It adds any missing modules necessary to build the current module's
packages and dependencies, and it removes unused modules that
don't provide any relevant packages.

It also adds any missing entries to `go.sum` and removes any unnecessary ones.

* The `-v` flag causes `tidy` to print information about removed modules
  to standard error.

* The `-e` flag causes `tidy` to attempt to continue regardless of errors
  encountered while loading packages.

* The `-go` flag causes tidy to update the `'go'` directive in the `go.mod`
  file to the given version, which may change which module dependencies
  are retained as explicit requirements in the `go.mod` file.

(Go versions 1.17 and higher retain more requirements in order to
support lazy module loading.)

* The `-compat` flag preserves any additional checksums needed for the
  `'go'` command (from the indicated major Go release) to successfully load
  the module graph.
    * This also causes `tidy` to error out if that version of the
      `'go'` command would load any imported package from a different module
      version.

By default, `tidy` acts as if the `-compat` flag were set to the
version prior to the one indicated by the `'go'` directive in the `go.mod`
file.

* The `-x` flag causes tidy to print the commands download executes.


