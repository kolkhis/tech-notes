# Exploring a Pre-existing Database with SQL

To get familiar with a pre-existing database using raw SQL queries, you need to
explore the database schema, tables, relationships, and the data.  

## Table of Contents
* [Connect to the Database](#connect-to-the-database) 
* [Explore the Schema](#explore-the-schema) 
    * [List all Tables](#list-all-tables) 
    * [Check table columns and data types](#check-table-columns-and-data-types) 
    * [Check Relationships and Foreign Keys](#check-relationships-and-foreign-keys) 
* [View Data Samples](#view-data-samples) 
* [Check how the Table is Indexed](#check-how-the-table-is-indexed) 
    * [Check how Tables are Linked by Joining Them](#check-how-tables-are-linked-by-joining-them) 
* [Analyze table sizes and usage](#analyze-table-sizes-and-usage) 
* [Document Findings](#document-findings) 
* [Misc Queries](#misc-queries) 


## Connect to the Database
Whatever database you're using has a CLI interface that can accept SQL queries.  
```bash
psql -U username -d database_name                   # PostgreSQL
mariadb -h 192.168.4.66 -u username database_name   # mariadb
```
etc.  

## Explore the Schema
### List all Tables
```sql
-- PostgreSQL
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public';

-- MySQL
SHOW TABLES;

-- SQLITE
.tables
```

### Check table columns and data types
```sql
-- PostgreSQL
SELECT column_name, data_type 
FROM information_schema.columns
WHERE table_name = 'the_table_name';

-- MySQL
DESCRIBE table_name;

-- SQLite
PRAGMA table_info(table_name);
```

### Check Relationships and Foreign Keys

```sql
-- PostgreSQL
SELECT 
    tc.table_name,
    kcu.column_name,
    ccu.table_name AS foreign_table_name,
    ccu.column_name AS foreign_column_name
FROM
    information_schema.table_contracts AS tc
    JOIN information_schema.key_column_usage AS kcu
    ON tc.constraint_name = kcu.constraint_name
    JOIN information_schema.constraint_column_usage AS ccu
    ON ccu.constraint_name = tc.constraint_name
WHERE constraint_type = 'FOREIGN KEY';
```
This retrieves all foreign key relationships in a PostgreSQL database.  
It queries the `information_schema` tables, which are a builtin set of tables that
describe the structure of a database.  
The query:
* Gets the name of the table (`tc.table_name`) that has a foreign key.  
* Gets the column in that table that serves as the foreign key(`kcu.column_name`)
* Gets the table that the foreign key points to (`ccu.table_name AS foreign_table_name`)
* Identifies the specific column in the referenced table (`ccu.column_name AS foreign_column_name`)

The `JOIN/AS/ON` statements here:
* `JOIN`: Combines rows from two tables based on a related column.  
    * `table_constraints` joins with `key_column_usage` based on `tc.constraint_name
      = kcu.constraint_name`
    * This makes sure that for each foreign key constraint, we get both the table and
      column it originates from (`kcu`) and the table/column it points to (`ccu`).  
* `AS`: Creates an alias for columns or tables to mmake them easier to reference in
  the query.  
    * `ccu.table_name AS foreign_table_name`: Lets you refere to `ccu.table_name` as `foreign_table_name`.  

If you're using MySQL, you might need to query the `INFORMATION_SCHEMA` database in
a similar way.  


## View Data Samples
View the first few rows of a table:
```sql
SELECT * FROM table_name LIMIT 10;
```

Get the row count:
```sql
SELECT COUNT(*) FROM table_name;
```

## Check how the Table is Indexed
Get a list of the indexes:
```sql
-- PostgreSQL
SELECT 
    tablename,
    indexname,
    indexdef
FROM 
    pg_indexes
WHERE
    schemaname = 'public';

-- MySQL
SHOW INDEX FROM table_name;

-- SQLite
PRAGMA index_list(table_name);
```

### Check how Tables are Linked by Joining Them
With the foreign keys, check how things are tied to each other.  
- Look for naming conventions.  
    - e.g., fields like `id`, `user_id`, `order_id`, etc. 
- Use `JOIN` queries to confirm relationships.  
```sql
SELECT *
FROM orders o
JOIN users u ON o.user_id = u.id
LIMIT 10;
```
* `JOIN`: Combines the rows from two tables based on the specified condition (`ON`).  
    * `orders` and `users` are combined where `o.user_id = u.id`.  
    * It matches the row in the `orders` table where the `user_id` column corresponds
      to the `id` column in the `users` table.  
* `orders o`: Creates an alias to be referenced inside the query.  
    * `users u` does the same.  

So if the `orders` table contains this data:
| `id` | `user_id`  | `amount`
|------|------------|---------
| `1`  | `101`      | `50.00`
| `2`  | `102`      | `75.00`

And the `users` table contains:
| `id`  | `name` 
|-------|--------
| `101` | `Bob`  
| `102` | `Alice`  

Then that query will combine those into this:
| `id` (`orders`) | `user_id`  | `amount` | `id` (`users`) | `name` 
|-----------------|------------|----------|----------------|-------
| `1`             | `101`      | `50.00`  | `101`          | `Bob`  
| `2`             | `102`      | `75.00`  | `102`          | `Alice`  



---


## Analyze table sizes and usage
```sql
-- PostgreSQL
SELECT 
    relname AS table_name,
    pg_size_pretty(pg_total_relation_size(relid)) AS total_size
FROM 
    pg_catalog.pg_statio_user_tables
ORDER BY
    pg_total_relation_size(relid) DESC;
```
* `relname`: Builtin for PostgreSQL.
    * It's a column in the `pg_statio_user_tables` and refers to the name of the table 
      (or relation, in PostgreSQL terminology).  
* `pg_size_pretty()`: Converts raw bute sizes into human-readable format.  
* `pg_total_relation_size()`: Calculates the total size of a table, including
  indexes, TOAST data, etc.  
    <!-- * TODO: What is TOAST data? -->
* `pg_statio_user_tables`: A PostgreSQL system view that provides stats for
  user-defined tables.  

---

The MySQL equivalent:
```sql
-- MySQL
SELECT 
    table_name AS Table
    round(((data_length + index_length) / 1024 / 1024), 2) AS Size_MB
FROM information_schema.TABLES
WHERE table_schema = "database_name"
ORDER BY Size_MB DESC;
```
* `ROUND()`: Builtin function to round a number to a specific number of decimal
  places.  
* `information_schema.TABLES`: Contains metadata about all tables in the database.  
* `DESC`: Order results in descending order (largest first).  


## Document Findings
Keep notes of the database to reference.  
Keep a list of tables, their purposes and relationships, and note improtant columns -
primary keys, foreign keys, and indexed columns.  

## Misc Queries
Use "exploratory queries" to learn how the data behaves.  
```sql
-- Aggregate data
SELECT column_name, COUNT(*)
FROM table_name
GROUP BY column_name;

-- Analyze date ranges, averages, patterns
SELECT AVG(column_name), MIN(column_name), MAX(column_name)
FROM table_name;
```

