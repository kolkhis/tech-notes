# `run-parts`

`run-parts` is a command-line utility in Unix-like operating systems that 
executes all executables located in a specified directory.  

It's used by `cron` to run scheduled tasks (e.g., `/etc/cron.daily`, `/etc/cron.hourly`,
etc.) and can be used in other contexts where we want to execute a series of 
scripts or programs.

Although it's primarily a system utility, it can also be used manually or in scripts.  

## Usage

The basic syntax for `run-parts` is:

```bash
run-parts [options] <directory>
```
The `<directory>` specifies the directory where the executables are located.  

By default, `run-parts` executes the files in alphabetical order. This includes
numeric prefixes, so files named `01-backup`, `02-cleanup`, etc., will be 
executed in that order.

!!! info "Note on Filenames"

    `run-parts` will **only** execute files that are executable and **do not contain 
    a dot** (`.`) in their names.  
    So, for example, a file named `backup.sh` would **not** be executed by
    `run-parts`, but a file named `backup` would be executed, provided it has
    executable permissions.

### Options

There are many options/flags available for `run-parts` that control its
behavior.  

Some useful options:

- `--test`: Only print the names of the executables that would be run, without 
  actually executing them.
    - This is essentially a dry run mode.  

- `--list`: Print the names of all matching files, including those without execute permissions.  
    - Can be used with `--regex` to filter the list of files based on a regex pattern.

- `--debug`: Print which scripts are selected for execution and which are not.
    - Outputs to stderr.  
    - This does execute the scripts, but provides additional information about
      the selection process.

- `--exit-on-error`: Cause `run-parts` to exit immediately if any of the 
  executables return a non-zero exit status.
    - Useful for ensuring that if any script fails, the entire process 
      stops, making it an atomic operation.

- `--verbose`: Print the name of each executable as it is run.

- `--regex=RE`: Only run executables whose names match the regex pattern `RE`.
    - Allows us to filter which executables are run based on their names.   
    - This option accepts Extended Regular Expressions (EREs).  


### Examples

- To run all executables in the `/etc/cron.daily` directory, we would use:
  ```bash
  run-parts /etc/cron.daily
  ```
  This command will execute all the executables in the `/etc/cron.daily` 
  directory, except those containing a dot in the filename.

- To see which executables would be run without actually executing them, we can use:
  ```bash
  run-parts --test /etc/cron.daily
  ```

- To **only show** a list all files that will be executed and which will be skipped, we can use:
  ```bash
  run-parts --debug --list /etc/cron.daily
  ```
  This will print all the files that will be run and which will be skipped, along
  with the reason for skipping (e.g., not executable, contains a dot).
  The reason will be "classicalre fail" if the file is skipped because it 
  contains a dot or is not executable.




