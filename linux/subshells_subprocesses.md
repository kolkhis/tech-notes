

# Subshells and Subprocesses

## Subprocesses
### What are Subprocesses?
A subprocess is a child process spawned by a parent process. When you run an external command in the shell, it usually spawns a subprocess.
Builtins do not spawn subprocesses.

Intricacies:
* Isolation: Subprocesses are isolated from the parent process, meaning they don't share variables or states.
* Resource Overhead: Spawning a subprocess consumes more resources compared to running a builtin.

Use Cases:
1. Running External Programs: Anytime you run a program that's not a shell builtin, you're spawning a subprocess.
```bash
grep "pattern" file.txt
```

1. Pipelines: Each command in a pipeline runs in its own subprocess.
```bash
ls | grep txt
```


## Subshells
### What are Subshells?

A subshell is a child shell process spawned from a parent shell. Subshells inherit environment variables and settings from the parent shell but don't affect the parent when changed.

Intricacies:
* Environment Isolation: Changes to variables in a subshell don't affect the parent shell.
* Syntax: Subshells are often invoked using parentheses ().

Use Cases:
1. Grouping Commands: You can use a subshell to group commands and redirect their collective output.
```bash
(cd /some/dir && ls)
```

2. Isolated Environment: Running a script in a subshell to prevent it from affecting the current
   shell environment.
```bash
(source ~/.bashrc)
```


