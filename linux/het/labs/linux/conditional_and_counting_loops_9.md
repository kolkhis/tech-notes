# Conditional Loops and Counting Loops



## Conditional Loops
### Scenario
You are a new system administrator at a company.
You've decided that you need to start using loops to increase
your productivity and monitoring of the system.
### Goals
* Create a conditional loop to watch cpu resources every 5 seconds.
* Create a conditional loop to count to 10, with various different starting and ending numbers.

---

### Commands
1. Create a while loop to conditionally check CPU resources every 5 seconds until you break it.
```bash
while true; do uptime; sleep 5; done
```
You can stop this execution with a `CTRL-C` and that will stop it.

---

1. Let's make a conditional loop where we control the condition by 
   incrementing a number (a version of a counting loop).
* Set count to 0
```bash
count=0
```

* Set conditon = 10
```bash
condition=10
```

1. Create a loop that increments over count while the expression evaluates true.
```bash
while [[ $count -lt $condition ]]; do echo "I am counting on $count"; (( count++ )); done
```

### Questions

What happened with this count?
Did it count the way you expected?
How can you modify it to count the way you expected?

What are some things you notice about using a conditional loop?
I want you to think about them as we move over into counting loops
so you can contrast how they work.



## Counting Loops


## Scenario
Create counting loops that count over a list of numbers,
a generated list of numbers, and a file read.

* Create a counting loop over a list of numbers or items.
* Generate numbers programmatically and loop over them.
* Read the contents of a file and loop over the variables.
Test each of these counting loops and see their behavior.

### Commands
## Looping over a list of numbers
Create a couting loop over a list of numbers:
```bash
for i in 1 2 3 4 5; do echo "I am couting over $i"; done
```
## Looping over a list of strings
Loop over a list of space-delimited strings:
```bash
for dessert in cookie cake pie; do echo "I am couting over $dessert"; done
```

#### Questions
What do you notice about this type of counting?
Does anything stand out as different than conditonal looping? 
How?

### Commands
## Using the seq command to generate numbers
* Create a set of numbers programmatically and loop over them.
    * You can hit `CTRL-C` to stop these once you've observed them long enough.
```bash
for i in $(seq 1000); do echo "I am counting over $i"; sleep 1; done
```

* Can you make it count by 5's?
```bash
for i in $(seq 5 5 1000); do echo "I am counting over $i"; sleep 1; done
```

Remember to stop this if you don't want to watch it complete.

## Looping over the contents of a file
Loop over the lines in a file.
* Create a file and populate it with fruit
```bash
echo "apple
banana
pear
grapes" >> fruit.txt
```

* Read the list from a file.
```bash
for item in $(cat fruit.txt); do echo "I am reading $item"; done
```

* Write the two servers in this lab to a file, and then loop
  over the commands to execute to both servers.
```bash
echo "controlplane
node01" >> /root/servers.txt

for server in $(cat /root/servers.txt); do ssh $server 'hostname; uptime'; done
```

#### Questions
Do you see how this may be useful as a systems administrator to hit multiple nodes?
Why or why not?



## Scripting a Loop

Now that we've used some loops, we've decided we are going to create a script that uses both of the loop types to create 100 files on both of our servers.

Create a script that loops over a list of servers, logs into them, and then creates 100 files called /tmp/file{{1..100}}.

Solution
Solution

Create a script that connects over ssh to both servers and creates the necessary files. use vi or the text editor of your choice to create this script /root/file_create.sh

#!/bin/bash

for server in $(cat /root/servers.txt)
  do ssh $server 'for i in $(seq 100); do touch /tmp/file$i; done'
done

Set the file to executable for root user and root group.

chmod 750 /root/file_create.sh

Execute the script

/root/file_create.sh

If this works, you can see the files in both locations with this loop.
```bash
for server in controlplane node01; do ssh $server 'hostname;ls /tmp/file* | wc -l'; done
# controlplane
# 100
# node01
# 100
```


Do you see the output you expected? Why or why not?




