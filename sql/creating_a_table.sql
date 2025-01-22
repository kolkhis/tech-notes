-- Create a table
CREATE TABLE students {
    id INTEGER PRIMARY KEY, -- Primary key, used as its ID
    name TEXT NOT NULL,      -- Required field
    gender TEXT NOT NULL    -- Required field
}; -- End SQL statements with semicolons

-- Insert some values
INSERT INTO students VALUES (1, 'Ryan', 'M');  -- positional parameters
INSERT INTO students VALUES (2, 'Joanna', 'F');

-- Fetch values
SELECT * FROM students WHERE gender = 'F'; -- use WHERE to specify conditionals


