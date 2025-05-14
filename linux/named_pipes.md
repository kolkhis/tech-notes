
# Named Pipes (FIFO Files)  

## Table of Contents
* [Description of Named Pipes](#description-of-named-pipes) 
    * [What is a Named Pipe?](#what-is-a-named-pipe) 
    * [How it Works](#how-it-works) 
    * [Uses](#uses) 
    * [Benefits](#benefits) 
* [Named Pipe Usage](#named-pipe-usage) 
    * [Named Pipe Creation](#named-pipe-creation) 
    * [Relevant Conditional Statements](#relevant-conditional-statements) 
    * [Capturing the Output of a Background Process](#capturing-the-output-of-a-background-process) 
* [Examples of Using Named Pipes (FIFO Files)](#examples-of-using-named-pipes-fifo-files) 
    * [Streaming Log Files](#streaming-log-files) 
    * [Transcoding a Video Stream](#transcoding-a-video-stream) 
* [Breakdown of Named Pipes](#breakdown-of-named-pipes) 


## Description of Named Pipes  
### What is a Named Pipe?  
A named pipe is a special kind of file that exists as a name in the  
filesystem but behaves like a pipe.  

* It provides a FIFO communication channel between two or more processes.  

### How it Works  
Data written to a named pipe by one process can be read by another  
process in the order it was written, hence "first in, first out."  

* Unlike regular files, named pipes do not store data on the filesystem.  

### Uses  
Named pipes are useful for inter-process communication, especially when  
you want to transfer data between processes without writing to disk.  

* They can be used for logging, streaming data, message passing, and more.  

### Benefits  
Named pipes provide a simple and effective way to achieve real-time data  
processing and communication between processes. 

* This can minimize the need for temporary files and potentially reducing I/O overhead.  

## Named Pipe Usage  
### Named Pipe Creation  
A named pipe is created using `mkfifo`.  
```bash  
mkfifo my_pipe  
```
This acts as a temporary file that you can use to capture the output of a process.  


### Relevant Conditional Statements  
* `-p file` returns `true` if `file` exists and is a named pipe (FIFO).  


### Capturing the Output of a Background Process  
##### See [background processes](./background_processes.md).  
This script captures the output of a background process and waits until  
the program is ready to accept connections.  
```bash  
mkfifo my_pipe  
(./my_program > my_pipe 2>&1 &)  # & runs the program in the background  
printf "Waiting for program to be ready...\n"  
while IFS= read -r line; do  
    if printf "%s\n" "$line" | grep -i 'ready to accept connections'; then  
        printf "Program is ready to accept connections.\n"  
        break  
    fi  
done < my_pipe  
rm my_pipe  # Clean up the file  
```

## Examples of Using Named Pipes (FIFO Files)  

Named pipes, or FIFO (First In, First Out) files, are a type  
of file that acts as a pipe between two or more processes.  
 
Data written to a named pipe by one process can be read by 
another, facilitating inter-process communication.  


### Streaming Log Files  
You can stream log output from one process to another for real-time processing or monitoring.  
 
```bash  
mkfifo /tmp/logpipe  
tail -f /var/log/myapp.log > /tmp/logpipe &  
grep "ERROR" < /tmp/logpipe > /tmp/error_logs  
```
This setup allows you to filter for error messages in real-time  
from an application's log file and save them to a separate file.  


### Transcoding a Video Stream  

Use `ffmpeg` to transcode video and stream the output directly  
to a player like `vlc` without intermediate files.  

```bash  
mkfifo /tmp/videostream  
ffmpeg -i input.mp4 -f mpegts /tmp/videostream &  
vlc /tmp/videostream  
```

## Breakdown of Named Pipes  


