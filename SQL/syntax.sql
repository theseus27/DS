-- STARTING THE SERVER
  -- Win+R -> services.msc
  -- MySQL80 - start

/* STYLE
  * 
  * Align keywords along right, align values left

    SELECT thing
      FROM group1,
           group2
     WHERE exp1
       AND exp2;

  * Use single quotations for strings
  * Use semicolons to end statements
  * For groups/multiple variables, use commas to seperate
  * For multiple conditionals, use AND/OR
  * For single line comments, use two dashes  --
  * Use this_naming_convention
  * When computing things with functions like SUM/AVG, name the result using AS
  * All keywords should be UPPERCASE
*/

-- INJECTION (Not rlly code)
/*
    SQL injection occurs on websites when you ask for a field like username, and they input an SQL query

    Example: 1=1 
        txtUserId = getREquestString("UserID");
        sqlStr = "SELECT * FROM Users WHERE UserId = " + txtUserId;

        So if the user enters '105 OR 1=1' as their name, it will return all users (ALL of their data, not just name)

    Example: " or ""="
        sql = 'SELECT * FROM Users WHERE Name = "' + uName '"

        user enters " or ""=" as their name, so the OR is always true

    Batched SQL Statements: Group of statements separated by semicolons
    
    Example: Batched SQL
        If user enters '105; DROP TABLE suppliers', it will run the select statement, but also delete the whole table
*/


-- PROTECTING AGAINST INJECTION
/*
    Can use SQL parameters such as
        txtUserID = getRequestString("UserID");
        sql = "SELECT * FROM Users WHERE UserID = @0";
        db.Execute(textSQL, txtUserID);

    SQL parameters are represented by @[number]
    The SQL engine will check each parameter against the column type
*/


-- DATA TYPES
/*
    * CHAR(size)            size in [0, 255], default=1
    * VARCHAR(size)         size in [0, 65535], default=80
    * LONGTEXT              size = 4 billion chars
    * ENUM(val1,val2,etc.)  can hold up to 65535 values
    * SET(val1,val2,etc.)   can hold up to 64 values
    * BOOL/BOOLEAN
    * INT(size)             range = [-2mil, 2mil], size is display width, in [0, 255]
    * FLOAT(p)              p is decimals of precision
*/


-- KEYWORDS --
/*
    ADD                 Add column to existing table
    ALTER               Add/delete/modify columns or tables
    BETWEEN             Selects values in range
    CASE                Different outputs based on conditions
    CREATE PROCEDURE    Create stored procedure
    DELETE              Delete rows from table
    DROP                Delete column/constraint/db/table/view
    EXEC                Execute a stored procedure
    EXISTS              Check for existence of any record in a subquery
    FROM                Which table to use
    FULL OUTER JOIN     Return all rows w/ match in left OR right tables
    GROUP BY            Group result set (used w/ COUNT/MAX/MIN/SUM/AVG)
    HAVING              Used instead of WHERE w/ aggregate functions
    IN                  Specify multiple values in a WHERE clause
    INNER JOIN          Return all rows w/ match in left AND right tables
    INSERT INTO SELECT  Copy data from one table to another
    IS NULL             Test for empty values
    IS NOT NULL         Test for non-empty values
    JOIN                Joins tables
    LEFT JOIN           Return all from left, matching from right
    LIKE                Pattern in column
    LIMIT               Max. # records to return
    ORDER BY            Sort in ASC or DESC
    OUTER JOIN          Same as full outer join
    PROCEDURE           A stored procedure
    RIGHT JOIN          Return all from right, matching from left
    ROWNUM              Specify # records to return
    SELECT DISTINCT     Return only different values
    SELECT INTO         Copy data from one table into a new table
    SELECT TOP          Specify # records to return
    TRUNCATE TABLE      Clear table, but keeps table itself
    UNION               Combines result set of multiple SELECTS (distinct)
    UNION ALL           Union but allows duplicates
    UPDATE              Update existing rows in a table
    WHERE               Filter on condition(s)
*/


-- CONNECT
USE schema/db;


-- CREATE
CREATE DATABASE db_name;

CREATE TABLE table_name (
    PRIMARY KEY (var_one),
    FOREIGN KEY (var_two) REFERENCES db_name(fieldname),
    var_one     TYPE(length)    NOT NULL,
    var_two     VARCHAR(100)    NOT NULL,
    var_three   INT(2)          NOT NULL,
                CONSTRAINT var_three_range
                CHECK(var_three BETWEEN 1 and 99)
);

CREATE TABLE table_name AS
    SELECT field1, field2, field3
    FROM other_table
    WHERE ......;


-- ALTER
ALTER TABLE table_name
    
    -- delete, add, modify columns in table
    ADD col_name datatype;
    DROP COLUMN col_name_1, col_name_2;
    RENAME COLUMN old_name to new_name;
    MODIFY COLUMN col_name new_datatype;


-- DROP
DROP DATABASE db_name;

DROP TABLE table_name;


-- BACKUP
BACKUP DATABASE db_name
TO DISK = 'filepath.bak';

    -- To backup only things that have changed
    TO DISK = 'filepath.bak'
    WITH DIFFERENTIAL;


-- CONSTRAINTS
    -- Can be specified during CREATE TABLE or added later with ALTER TABLE
    -- Constraints check data being entered
    -- Can either 
        -- constrain a field itself
        -- create a new CONSTRAINT field with a new name

NOT NULL        -- Val can't be NULL
    col_name fieldtype NOT NULL;    -- with create table
    
    ALTER COLUMN col_name fieldtype NOT NULL; -- with alter table

UNIQUE          -- All values in a column must be different
    col_name fieldtype,     -- with create table
    UNIQUE (ID);

    col_one fieldtype,      -- with create table, constraint on mult. fields
    col_two fieldtype,
    CONSTRAINT constraint_name UNIQUE (col_one, col_two);

    ADD UNIQUE (existing_field); -- with alter table

    -- alter table, constraint on mult. fields
    ADD CONSTRAINT constraint_name UNIQUE (existing_one, existing_two);

    -- To drop a unique constraint
    ALTER TABLE table_name
    DROP INDEX constraint_name;

PRIMARY KEY     -- Uniquely identifies each row (NOT NULL && UNIQUE)
-- A table can have up to 1 primary key
    
    PRIMARY KEY(field_name); -- with create table

    -- create table, the primary key is made of two values
    CONSTRAINT constraint_name PRIMARY KEY(field1, field2); 

    ADD PRIMARY KEY(field_name); --alter table

    -- alter table, the primary key is made of two values
    ADD CONSTRAINT constraint_name PRIMARY KEY(field1, field2);

    -- to drop a primary key constraint
    ALTER TABLE table_name
    DROP PRIMARY KEY;

FOREIGN KEY     -- Prevents actions that would destroy links between tables
-- A field or collection of fields that refer to the PK of another table
-- Table w/ FK is child, table w/ PK is parent/referenced
    FOREIGN KEY (existing_var) REFERENCES T2(existing_var);   -- create

    CONSTRAINT const_name FOREIGN KEY (exist_var)  -- create
    REFERENCES T2(existing_var2);

    ALTER TABLE T1
    ADD FOREIGN KEY (exist_var) REFERENCES T2(exist_var2); -- alter

    ALTER TABLE T1
    ADD CONSTRAINT const_name
    FOREIGN KEY (exist_var) REFERENCES T2(exist_var2);

    -- to drop a foreign key constraint
    ALTER TABLE T1
    DROP FOREIGN KEY const_name;

CHECK           -- Make sure that values satisfy a specific condition
    field_name int,
    CHECK (field_name >= x);

    ADD CHECK(field_name=='word');

DEFAULT         -- Set a default value in none is specified
    field_name varchar(255) DEFAULT 'nothing';

    -- Can also use system functions
    field_name date DEFAULT GETDATE();

    ALTER TABLE table_name
    ALTER field_name SET DEFAULT 'value';

    -- To drop default constraint
    ALTER TABLE table_name
    ALTER COLUMN field_name DROP DEFAULT;

CREATE INDEX    -- Used to create/retrieve data very quickly

    CREATE INDEX idx_name           -- opt. CREATE UNIQUE INDEX
    ON table_name (col1, col2, ...);

    ALTER TABLE table_name
    DROP INDEX idx_name;


-- AUTO_INCREMENT    
-- generate new unique number when a new record is inserted (usually PK / ID)
    PersonID int NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (PersonID);

    -- to change the starting value (100)
    ALTER TABLE table_name AUTO_INCREMENT=100;

    -- to insert with a specified id
    INSERT INTO table_name (id, name) VALUES(100, 'name');
    INSERT INTO table_name (id, name) VALUES(NULL, 'name'); -- will be 101

    -- to insert into a table w/ an auto increment field, specify all the other fields
    INSERT INTO table_name (field1, field2)
    VALUES (val1, val2);


-- DATES

--Date Type gets chosen on create table
DATE        YYYY-MM-DD
DATETIME    YYYY-MM-DD HH:MI:SS -- used for specific valuese
TIMESTAMP   YYYY-MM-DD HH:MI:SS -- smaller range, considers timezone
YEAR        YYYY OR YY

-- For fields using Date
| 1  | Name | 2020-01-01
SELECT * FROM table_name WHERE OrderDate='2020-01-01'   -- returns above

| 1  | Name | 2020-01-01 13:12:11
SELECT * FROM table_name WHERE OrderDate='2020-01-01'   -- returns none


-- VIEWS
-- virtual table based on result of a query
-- view names usually named like [view name]

CREATE VIEW view_name AS
SELECT col1,col2,...
FROM table_name
WHERE condition;

-- Update view with create or replace
CREATE/REPLACE VIEW view_name AS ......

DROP VIEW view_name


-- JOIN
    -- Returns rows from multiple tables

    SELECT T1.field, T2.field
    FROM T1
    INNER/OUTER/LEFT/RIGHT JOIN T2 ON T1.field2 = T2.field2
    ORDER BY T.field ASC/DESC    -- Optional

    -- The 'from' table can also be the result of a join, so you can do a join on another join


-- 


-- CASE
    -- Iterates through conditions, returns a value once one is met

-- Example using select
SELECT fields,
CASE
    WHEN cond1 THEN val1
    WHEN cond2 THEN val2
    .....
    ELSE defaultval
END AS varname  -- Optional
FROM tablename;

-- Example using order by
SELECT ...
FROM ...
ORDER BY
 (CASE
    WHEN ___ THEN __
    ELSE __
);


-- SET
    -- update multiple rows at a time
    UPDATE table_name
    SET Field1='value'
    WHERE Field2'value';


-- LIKE
    -- Lets you searchc with regex-like expressions

--      %               represents 0/1/mult. chars
--      _               represents one char
--      []              represents a group of possible options
--      [^]             group is anything not in brackets
--      [start-stop]    reps. any single char in specified range

WHERE FieldName LIKE '%a'   -- Any values ending with a
WHERE FieldName LIKE 'a%'   -- Any values starting with a
WHERE FieldName LIKE '%a%'  -- Any value containing a
WHERE FieldName LIKE '_a'   -- Any value with a as the second letter
WHERE FieldName LIKE 'a__'  -- Any value starting w/ a AND at least 3 long
WHERE FieldName LIKE 'c[ao]t'   --Find cat or cot
WHERE FieldName LIKE 'c[^a]t'   -- Finds any word like c_t EXCEPT cat
WHERE FieldName LIKE 'c[a-c]t'  -- Finds cat, cbt, or cct


-- AGGREGATE FUNCTIONS

    -- COUNT    number of rows matching condition
    SELECT COUNT(col_name)
    FROM table_name
    WHERE condition;

    -- AVG      avg value of a numeric column
    SELECT AVG(col_name)
    FROM table_name
    WHERE condition;

    -- SUM      sum of numeric column
    SELECT SUM(col_name)
    FROM table_name
    WHERE condition;

    -- MAX      select max of column
    SELECT MAX(col_name) AS var_name
    FROM table_name;

    -- MIN      select min of column
    SELECT MIN(col_name) AS var_name
    FROM table_name;

    GROUP BY
    SELECT COUNT/AVG/SUM/MAX/MIN(field1), field2, field3...
    FROM table_name
    GROUP BY field2
    ORDER BY COUNT(field1) DESC


-- HAVING
    -- Exists bc WHERE can't be used with aggregate functions

SELECT cols
FROM tablename
WHERE condition
GROUP BY cols
HAVING condition
ORDER BY cols;

SELECT field1, COUNT(field2) AS var1
FROM table
GROUP BY field1
HAVING COUNT(field2) > 20;


-- UNION
SELECT field1 FROM table1
UNION
SELECT field1 FROM table2
ORDER BY field1


-- UPDATE
UPDATE table_name
SET col1 = val1, col2 = val2...
WHERE condition


-- STORED PROCEDURES
    -- Code that can be reused (basically functions)
    -- Can also take parameters, referenced with @

CREATE PROCEDURE proc_name [variables/types]
AS
sql_statement
GO;

EXEC proc_name;


CREATE PROCEDURE SelByField @Field varchar(30), @Field2 int
AS
SELECT * FROM table_name WHERE Field = @Field OR Field2=@Field2
GO;

EXEC SelByField @Field='London', @Field2=20;


-- BUILT IN FUUNCTIONS
/*
-- STRING --
    ASCII           Return ASCII val for char
    CHAR LENGTH     Return length of string (in chars)
    CONCAT          Add multiple expressions together
    CONCAT WS       Add expressions with separator
    FIELD           Return idx position of value in list of vals
    FIND IN SET     Return position of string in list of strs
    FORMAT          Format to something like "#,###.##"
    INSERT          Insert str within str at spec. position/length
    INSTR           Return position of first occurrence of str in other str
    LCASE/LOWER     Lowercase
    LEFT            Extract # of chars from str starting on left
    LENGTH          Return length of str in bytes
    LOCATE          Return position of first occ of str in other str, allows you to set a starting index
    LPAD            Left pad string w/ another string, to a spec. len
    LTRIM           Remove leading spaces
    MID             Extract substring (starting at any position)
    REPLACE         Replace all occurences of a substr with another substr
    REVERSE         Reverse string
    RIGHT           Extract chars from str starting on right
    RPAD            Right pad string w/ another string, to a spec. len
    RTRIM           Remove trailing spaces
    SPACE           Return string of spec. number of space chars
    STRCMP          Compare two strings
    SUBSTR          Extract substring starting at given position
    SUBSTRING INDEX Return substr of str before a spec. num of delimiters occur
    TRIM            Remove leading and trailing spaces
    UCASE/UPPER     Uppercase 

-- NUMERIC --
    ABS             Absolute value
    CEIL            Ceiling
    COS             Cosine
    COT             Cotangent
    DIV             Integer division
    EXP             e raised to power of x
    FLOOR           Floor
    LOG             Log of a number to a base, default natural
    LOG10           Log base 10
    LOG2            Log base 2
    MOD             Mod
    PI              Returns value of pi
    POW             x to power of y
    RAND            Random number
    ROUND           Round to spec. num of decimal places
    SIGN            Sign of number
    SIN             Sine
    SQRT            Square root of number
    TAN             Tangent
    TRUNCATE        Truncate num to spec num

-- DATE --
    ADDDATE
    ADDTIME
    CURDATE
    CURTIME
    CURRENT TIMESTAMP
    DATE
    DATEDIFF
    DATE ADD
    DATE FORMAT
    DATE SUB
    DAY
    DAYNAME
    DAYOFMONTH
    DAYOFWEEK
    DAYOFYEAR
    EXTRACT
    FROM DAYS
    HOUR
    LAST DAY
    LOCALTIME
    MAKEDATE
    MAKETIME
    MICROSECOND
    MINUTE
    MONTH
    MONTHNAME
    NOW
    SECOND
    SEC TO TIME
    STR TO DATE
    SUBDATE
    SUBTIME
    SYSDATE
    TIME
    TIME FORMAT
    TIME TO SEC
    TIMEDIFF
    TO DAYS
    WEEK
    WEEKDAY
    WEEKOFYEAR
    YEAR
    YEARWEEK

-- ADVANCED --
    BIN                 Returns binary rep. of number
    BINARY              Convert value to binary str
    CAST                Change datatype
    COALESCE            Return first non-null value in list
    IF                  Return values if TRUE/FALSE
    IFNULL              Return set value if NULL, otherwise return expr.
    ISNULL              Return 1 or 0 depending on if NULL
    LAST_INSERT_ID      Return last AUTO_INCREMENT id in table
    NULLIF              Takes two exprs, returns NULL if equal, else first exp.
*/



