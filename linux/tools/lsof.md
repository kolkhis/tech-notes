# `lsof` - List Open Files

`lsof` is a versatile tool that can be used to show what files are being used.  



## Usage

List open files by process ID (PID):
```bash
lsof -p 32117
```
List files used by process with PID `32117`.  

---

List open files by port:
```bash
lsof -i :80
```
Lists files opened by port 80.  

---




