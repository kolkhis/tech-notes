

# Run Processes in the Background  


## Use the Current Terminal Instance with `&`
You can background any process by appending `&` to the end:  
```bash  
ping 127.0.0.1 &  
```
This will still direct `stdout` to the current shell, but the process will  
run in the background. This is useful if you want to run a process in the current  
shell but also free it up to run other commands.  

If the program that is backgrounded has terminal output, it will still output to the 
current terminal instance, but you can still run commands.  

To stop it, you can use `fg` to bring it back to the foreground, then `^C` will stop it.  
Alternatively, use `ps` to find its PID (Process ID), then use `kill <PID>`


## Useing `nohup`

* `nohup` - run a command immune to hangups, with output to a non-tty  

This means that it will ignore the hangup signal, and will run in the background.  

If the program that you want background is a script, you can use  
the `nohup` command to run it in the background.  




