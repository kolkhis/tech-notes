# SQL Basics
Basics of SQL.  
SQL stands for "Structured Query Language".  

There's an IDE called DBeaver that's made for working with SQL databases.  

## Table of Contents
* [Types of SQL Commands](#types-of-sql-commands) 
* [Creating a Table](#creating-a-table) 
    * [Example: Creating a Table](#example-creating-a-table) 
* [SQL Data Types](#sql-data-types) 
    * [Numeric Data Types](#numeric-data-types) 
    * [Character and String Data Types](#character-and-string-data-types) 
    * [Date and Time Data Types](#date-and-time-data-types) 
    * [Binary Data Types](#binary-data-types) 
    * [Boolean Data Types](#boolean-data-types) 
    * [Other Common Data Types](#other-common-data-types) 
* [Adding Constraints to a Table](#adding-constraints-to-a-table) 
    * [Example: Using Constraints on Columns](#example-using-constraints-on-columns) 
* [Common SQL Queries](#common-sql-queries) 
    * [Inserting Data into a Table](#inserting-data-into-a-table) 
    * [Updating DAta](#updating-data) 
    * [Deleting Data](#deleting-data) 
    * [Selecting Data](#selecting-data) 
* [Automatically Generate IDs, Using Indexes](#automatically-generate-ids-using-indexes) 
* [Indexes](#indexes) 
    * [Creating an Index](#creating-an-index) 
* [Composite Primary Key](#composite-primary-key) 

## Types of SQL Commands
* DDL: Data Definition Language
    * CREATE, ALTER, DROP
* DML: Data Manipulation Language
    * INSERT, UPDATE, DELETE
* DCL: Data Control Language
    * GRANT, REVOKE
* DQL: Data Query Language
    * SELECT


## Creating a Table
Use the `CREATE TABLE` statement to create a new table in a database.  
Syntax:
```sql
CREATE TABLE table_name (
    column1 DATA_TYPE,
    column2 DATA_TYPE,
    column3 DATA_TYPE,
    ...
);
```
* `CREATE TABLE table_name`: Creates a table with the name `table_name`
* `column1 DATA_TYPE`: Creates a new column inside the table named `column1`.
    * This column will only be able to store data of the type `DATA_TYPE` (See [SQL data types](#sql-data-types)).  

This creates a table with the name `table_name` with the columns specified.  
Here, the `DATA_TYPE` is just specifying what kind of data the column will store.  

Table `table_name` will look like this:
| column1 | column2 | column3 |
|---------|---------|---------|
|DATA     |DATA     |DATA     |


### Example: Creating a Table
```SQL
-- Create a table called students
CREATE TABLE students {
    id INTEGER PRIMARY KEY, -- Primary key, used as its ID
    name TEXT NOT NULL,     -- Specifying `NOT NULL` marks it as a required field
    gender TEXT NOT NULL    -- Required field
}; 
-- End SQL statements with semicolons

-- Insert some values
INSERT INTO students VALUES (1, 'Ryan', 'M');  -- positional parameters
INSERT INTO students VALUES (2, 'Joanna', 'F');
INSERT INTO students VALUES (3, 'Joan', 'F');

-- Fetch values
SELECT * FROM students; -- Get all rows from a table
SELECT * FROM students WHERE gender = 'F'; -- use WHERE to specify conditionals
```



## SQL Data Types
SQL data types define the type of data that a column in a table can store.  
Most can be broken down into categories:
* Numeric
* Char/String
* Binary
* Date/Datetime
* Boolean

Other common data types that don't necessarily fit into those categories:
* `ENUM`
* `JSON`
* `UUID`

### Numeric Data Types

* `INT`/`INTEGER`: Whole numbers. Range varies by database.  
    * Most common default `INT` range is the default unsigned int range in C.  
* `SMALLINT`: Smaller range of integers than `INT`.  
* `BIGINT`: Larger range of integers than `INT`.  
* `DECIMAL(p, s)`: Exact numeric values with `p` precision and `s` scale
    * `p`: The total number of digits the number can have.  
    * `s`: The total number of digits to the right of the decimal point.  
* `NUMERIC(p, s)`: Alias for `DECIMAL`.  
* `FLOAT`: Approximate floating-point numbers.  
    * Less precise than `DECIMAL` but suitable for most decimal data.  
    * Precision can vary between databases, but typically stores ~`7` digits of
      precision (single-precision floating point).  
* `REAL`: Alias for `FLOAT` in some databases.  
* `DOUBLE`: Double-precision floating point number.  
    * Typically can store ~`15`-`16` digits of precision.  


`DECIMAL` vs `FLOAT`/`DOUBLE`:  
* Use `DECIMAL` for exact financial/monetary calculation (anywhere precision is critical).  
* `FLOAT` and `DOUBLE` are approximate and can introduce rounding errors.  

### Character and String Data Types

* `CHAR(n)`/`CHARACTER(n)`: Fixed-length string.
    * Pads with spaces if input is shorter than `n`.  
* `VARCHAR(n)`/`CHARACTERVARYING(n)`: A variable-length string.  
    * More space-efficient than `CHAR`.  
* `TEXT`: Stores large amounts of text.
    * This has no length limit in most databases.  
    * Can store massive amounts of data (gigabyes in PostgreSQL).  

### Date and Time Data Types

* `DATE`: Stores calendar dates. Uses the format: `YYYY-MM-DD`.  
* `TIME`: Stores the time of day. Uses the format: `HH:MM:SS`.  
* `TIMESTAMP`: Stores both date and time. Uses the format: `YYYY-MM-DD HH:MM:SS`
* `DATETIME`: Alias for `TIMESTAMP` in some databases.  
* `YEAR`: Stores a year value. Uses the format: `YYYY`

### Binary Data Types
Binary data types are usually used for storing files, images, or encoded data.  

* `BINARY(n)`: Fixed-length binary data.  
* `VARBINARY(n)`: Variable-length binary data.  
* `BLOB` (Binary Large Object): Stores large binary objects. (E.g., images or files).  

### Boolean Data Types
* `BOOLEAN`: Stores `TRUE` or `FALSE`.  

Some databases (MySQL) don't natively support `BOOLEAN`.  
This is usually implemented as an alias for `TINYINT(1)` with values `1` (true) or `0` (false).  

### Other Common Data Types
* `ENUM`: Stores a predefined set of string values.  
    * E.g., `'small', 'medium', 'large'`
    * `ENUM`s can improve performance because it stores the values as integers internally.  
* `JSON`: Stores JSON data.  
    * This is supported in newer databases; e.g., MySQL 5.7+, PostgreSQL.  
* `UUID`: Stores universally unique identifiers. Useful for distributed systems.  
  ```sql
  CREATE TABLE users (
      id UUID PRIMARY KEY,
      username VARCHAR(50)
  );
  INSERT INTO users (id, username)
  VALUES ('550e8500-e29b-4141-a718-006655440000', 'kolkhis');
  ```


## Adding Constraints to a Table
Constraints enforce rules for the data in a table.  
Use a constraint on a column definition to apply it to that column.  


Common constraints:
* `PRIMARY KEY`: Ensures unique identification on each row.  
    * Only one of these is allowed per table.  
* `FOREIGN KEY`: Enforces referential integrity between two tables.  
    * This is used to make relationships between rows across different tables in a database.  
    * Use with `REFERENCES` to specify a relationship.  
    * When defining a `FOREIGN KEY`, you must make sure the referenced column exists in the other table.  
* `UNIQUE`: Ensures all values in a column are unique.  
* `NOT NULL`: Prevents null values (empty values).  
* `CHECK`: Ensures all values in a column meet a specific condition.  
* `DEFAULT`: Sets a default value for a column when no value is specified.  

The constraint will typically come after the `DATA_TYPE`.  

### Example: Using Constraints on Columns
```sql
CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    hire_date DATE NOT NULL,
    salary DECIMAL(10, 2) DEFAULT 0.00,
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES departments(department_id)

);
```


## Common SQL Queries
### Inserting Data into a Table
```sql
INSERT INTO table_name (name, hire_date) 
VALUES ('John Doe', '2025-01-14');
```

### Updating DAta
```sql
UPDATE table_name SET column1='value1', column2='value2' WHERE condition;
-- e.g.,
UPDATE employees 
SET salary = salary + 1000 
WHERE department_id = 2;
```

### Deleting Data
```sql
DELETE FROM table_name WHERE condition; 
-- e.g., Delete the row where the employee id is 10
DELETE FROM employees WHERE employee_id = 10;
```

### Selecting Data
```sql
SELECT column1, column2 FROM table_name WHERE condition;
-- e.g., select all employees with a salary greater than 50k
SELECT * FROM employees WHERE salary > 50000;
```


## Automatically Generate IDs, Using Indexes
* MySQL: use `AUTO_INCREMENT` to generate unique values for a column.  
  ```sql
  CREATE TABLE users (
      id INT AUTO_INCREMENT PRIMARY KEY,
      username VARCHAR(30) NOT NULL,
  );
  ```

* PostgreSQL: Use `SERIAL` to automatically generate unique IDs.  
  ```sql
  CREATE TABLE users (
      id INT SERIAL PRIMARY KEY,
      username VARCHAR(30) NOT NULL
  );
  ```

`SERIAL` is PostgreSQL's version of `AUTO_INCREMENT`.
It makes sure that the `id` column gets automatically incremented with each new inserted row.  




## Indexes
Indexes are special data structures that improve the speed of data retrieval
operations in a database table.  

Indexes allow the database to find specific rows without scanning the entire table.  

Queries that use `WHERE`, `ORDER BY`, `GROUP BY` or use multiple conditions benefit
greatly from indexes, making filtering and sorting easier.  


Unique indexes (e.g., created implicitly by `PRIMARY KEY` or `UNIQUE`) ensure that no
two rows have the same values in the indexed columns.  

Indexes also help when foreign keys exist to help enforce referential integrity.  


### Creating an Index
When you define a column as `PRIMARY KEY` or `UNIQUE`, most relational 
databases (e.g., MySQL, PostgreSQL) automatically create an index on that 
column.  


e.g.,
When creating an ID in PostgreSQL that is unique, that effectively makes an index 
```sql
CREATE TABLE users (
    id INT SERIAL UNIQUE PRIMARY KEY,
    username VARCHAR(20)
);
```
This effectively makes the `id` column the `index`.  



To explicitly create an index on a specific column:
```sql
CREATE INDEX index_name ON table_name(column1, column2);
-- e.g., create an index called `idx_username` on the `users(name)` column
CREATE INDEX idx_username ON users(username);  
```
Then that index will be used to improve performance.  

For example, this query:
```sql
SELECT * FROM users WHERE username == 'kolkhis';
```
Instead of scanning each row in the database for the condition `username == 'kolkhis'`,
the database will check if the `username` column has an index, and will use the 
index for the condition before going and scanning the whole table.  


---

## Composite Primary Key
A composite primary key is a primary key that consists of two or more columns.  
These columns then uniquely identify a row in a table.  

E.g.,
```sql
CREATE TABLE orders (
    order_id INT,
    customer_id INT,
    PRIMARY KEY (order_id, customer_id)
);
```
This enforces uniqueness.  
Each combination of `order_id` and `customer_id` must be unique.  


Good for `many-to-many` relationships.  
Ex: A single customer can have multiple orders, and a single order can have multiple customers.  

