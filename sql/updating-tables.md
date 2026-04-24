# Updating SQL Tables

There are a couple ways to update an existing SQL table.

1. Use `UPDATE` to change rows that already exist.  
2. Use `INSERT` with an `ON CONFLICT` handler to perform an **upsert**.  

## `UPDATE`

`UPDATE` is the standard way to modify data in-place.  

This method typically uses a `WHERE` conditional clause so that it only changes 
the rows that meet certain conditions, which is usually what needs to happen 
when modifying single rows.  


For example, if a specific row in a table called `users` needed its `email`
value changed:
```sql
UPDATE users
SET email = 'new@example.com'
WHERE user_id = 42;
```
The `WHERE` clause is saying to only set the email to `new@example.com` when the
value of `user_id` is equal to `42`.  

!!! warning

    If an `UPDATE` is used without a `WHERE` clause, it will update **every row
    in the table**.  
    This has its use cases, but it can be a very destructive operation without
    the `WHERE` clause.  
    Only omit the `WHERE` when the same field in all rows needs to be
    homogenized.

## `INSERT`/`ON CONFLICT` (**Upsert**)

This method is great for combining the functionality of both the creation of, 
and updating of, rows.  

- Creates new rows  
- Updates existing rows if the row exists already  

For example, doing the same operation as above (updating the `email` field in
the `users` table, where the `user_id` field has the value of `42`):
```sql
INSERT INTO users (user_id, email)
VALUES (42, 'new@example.com')
ON CONFLICT (user_id)
DO UPDATE SET email = EXCLUDED.email;
```

- `INSERT INTO users (user_id, email)`: This says to create a row in the
  `users` table with two fields: `user_id` and `email`.

- `VALUES (42, 'new@example.com')`: The values for the two fields (in order).  

- `ON CONFLICT (user_id) DO`: Says "If a row matching `user_id = 42` already exists, do the following."  

- `UPDATE SET email = EXCLUDED.email;`: Do an `UPDATE` (as above), setting the
  email to the new value passed in `VALUES`.  

    - `EXCLUDED.email` is the value that the query **attempted** to use before
      the conflict resolution runs.  

    - If only `email` was used here without `EXCLUDED`, `email` would refer to
      the **existing row in the table being updated, not the incoming row**.  

    - In PostgreSQL, `ON CONFLICT DO UPDATE`, `EXCLUDED` is a special alias for
      the would-be inserted row, so `EXCLUDED.email` means "Use the new email
      from the attempted insert."

So, if `user_id = 42` already exists, update the stored row's `email` to the
newly provided one. If only `email` was used, the nnew incoming value would not
be clearly referenced, and in most cases would refer to the current row's
`email` value instead.  









