
# NOP Slide ( or NOP Sledding )
Links:  
Course - https://taggartinstitute.org/courses/1840120  
Related Video -  https://www.youtube.com/watch?v=1S0aBV-Waeo  

## Basic Idea
You have a **rough** target memory address (not exact since things vary) on the stack.
On the stack you place a bunch of NOPs (No OPeration bits - x90) that then become 
executable shell code.
```
NOP NOP NOP NOP NOP NOP Script
x90 x90 x90 x90 x90 x90 <shellcode>
```
