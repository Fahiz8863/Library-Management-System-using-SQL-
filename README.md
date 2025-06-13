# Library Management System using SQL

## Project Overview

This project demonstrates the implementation of a Library Management System using SQL. It includes creating and managing tables, performing CRUD operations, and executing advanced SQL queries. The goal is to showcase skills in database design, manipulation, and querying.

![Library_project](https://github.com/Fahiz8863/Library-Management-System-using-SQL-/blob/main/Library%20Management%20System.png)
![Library](https://github.com/Fahiz8863/Library-Management-System-using-SQL-/blob/main/library.jpeg)

## Objectives

1. **Set up the Library Management System Database**: Create and populate the database with tables for branches, employees, members, books, issued status, and return status.
2. **CRUD Operations**: Perform Create, Read, Update, and Delete operations on the data.
3. **CTAS (Create Table As Select)**: Utilize CTAS to create new tables based on query results.
4. **Advanced SQL Queries**: Develop complex queries to analyze and retrieve specific data.

## Project Structure

### 1. Database Setup
![ERD](https://github.com/Fahiz8863/Library-Management-System-using-SQL-/blob/main/ERD.png)

- **Database Creation**: Created a database named ` Library System Management`.
- **Table Creation**: Created tables for branches, employees, members, books, issued status, and return status. Each table includes relevant columns and relationships.

```sql
CREATE DATABASE Library System Management;

DROP TABLE IF EXISTS branch;
CREATE TABLE branch
(
            branch_id VARCHAR(5) PRIMARY KEY,
            manager_id VARCHAR(5),
            branch_address VARCHAR(15),
            contact_no VARCHAR(15)
);


-- Creating Employees Table
DROP TABLE IF EXISTS employees;
CREATE TABLE employees(
            emp_id VARCHAR(5) PRIMARY KEY,
            emp_name VARCHAR(25),
            position VARCHAR(20),
            salary FLOAT,
            branch_id VARCHAR(7)
);


-- Creating Employees Table
DROP TABLE IF EXISTS employees;
CREATE TABLE employees(
            emp_id VARCHAR(5) PRIMARY KEY,
            emp_name VARCHAR(25),
            position VARCHAR(20),
            salary FLOAT,
            branch_id VARCHAR(7)
);

-- Creating Members Table
DROP TABLE IF EXISTS members;
CREATE TABLE members(
            member_id VARCHAR(5) PRIMARY KEY,
            member_name VARCHAR(15),
            member_address VARCHAR(15),
            reg_date DATE
);


-- Creating Issued Status Table
DROP TABLE IF EXISTS issued_status;
CREATE TABLE issued_status(
            issued_id VARCHAR(5) PRIMARY KEY,
            issued_member_id VARCHAR(5),
            issued_book_name VARCHAR(55),
            issued_date DATE,
            issued_book_isbn VARCHAR(20),
            issued_emp_id VARCHAR(5) 
);




-- Creating Return Status Table
DROP TABLE IF EXISTS return_status;
CREATE TABLE return_status(
            return_id VARCHAR(5) PRIMARY KEY,
            issued_id VARCHAR(5) ,
            return_book_name VARCHAR(55),
            return_date DATE,
            return_book_isbn VARCHAR(20) 
);

--Adding foreign Keys

ALTER TABLE branch
ADD CONSTRAINT fk_manager 
FOREIGN KEY(manager_id)
REFERENCES employees(emp_id);

ALTER TABLE employees
ADD CONSTRAINT fk_branch	 
FOREIGN KEY(branch_id)
REFERENCES branch(branch_id);

ALTER TABLE issued_status
ADD CONSTRAINT fk_member	 
FOREIGN KEY(issued_member_id)
REFERENCES members(member_id);

ALTER TABLE issued_status
ADD CONSTRAINT fk_isbn	 
FOREIGN KEY(issued_book_isbn)
REFERENCES books(isbn);

ALTER TABLE issued_status
ADD CONSTRAINT fk_employee	 
FOREIGN KEY(issued_emp_id)
REFERENCES employees(emp_id);

ALTER TABLE return_status
ADD CONSTRAINT fk_issued_id	 
FOREIGN KEY(issued_id)
REFERENCES issued_status(issued_id);
```

### 2. CRUD Operations

- **Create**: Inserted sample records into the `books` table.
- **Read**: Retrieved and displayed data from various tables.
- **Update**: Updated records in the `employees` table.
- **Delete**: Removed records from the `members` table as needed.

**Task 1. Create a New Book Record**
-- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"

```sql
INSERT INTO books
VALUES('978-1-60129-456-2','To Kill a Mockingbird','Classic',6.00,'yes','Harper Lee','J.B. Lippincott & Co.');
SELECT * FROM books;

```
**Task 2: Update an Existing Member's Address**

```sql
UPDATE members
SET member_address = '125 Oak St'
WHERE member_id = 'C103';
```

**Task 3: Delete a Record from the Issued Status Table**
-- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.

```sql
DELETE FROM issued_status
WHERE issued_id = 'IS121';
```

**Task 4: Retrieve All Books Issued by a Specific Employee**
-- Objective: Select all books issued by the employee with emp_id = 'E101'.
```sql
SELECT * FROM issued_status 
WHERE issued_emp_id= 'E101';
```


**Task 5: List Members Who Have Issued More Than One Book**
-- Objective: Use GROUP BY to find members who have issued more than one book.

```sql
SELECT * FROM
(
SELECT 
            issued_member_id,
	COUNT(issued_id) as count 
FROM issued_status
GROUP BY 1
) AS t1 
WHERE t1.count>1;
```

### 3. CTAS (Create Table As Select)

- **Task 6: Create Summary Tables**: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt**

```sql
CREATE TABLE book_issued_count
AS SELECT
            b.isbn,
            b.book_title,
            COUNT(ist.issued_id) AS no_issued
FROM books as b
JOIN issued_status as ist on 
b.isbn= ist.issued_book_isbn
GROUP BY 1,2;

SELECT*FROM book_issued_count;
```


### 4. Data Analysis & Findings

The following SQL queries were used to address specific questions:

Task 7. **Retrieve All Books in a Specific Category**:

```sql
SELECT * FROM books
WHERE category ='History';
```

8. **Task 8: Find Total Rental Income by Category**:

```sql
SELECT
            b.category,
	SUM(b.rental_price) as total_rental_income
FROM books as b
JOIN issued_status as ist
	ON b.isbn= ist.issued_book_isbn
GROUP BY 1;
```

9. **List Members Who Registered in the Last 180 Days**:
```sql
SELECT * FROM members
WHERE reg_date >= CURRENT_DATE - INTERVAL '180 days';
```

10. **List Employees with Their Branch Manager's Name and their branch details**:

```sql
SELECT 
    e1.emp_id,
    e1.emp_name,
    e1.position,
    e1.salary,
    b.*,
    e2.emp_name as manager
FROM employees as e1
JOIN 
branch as b
ON e1.branch_id = b.branch_id    
JOIN
employees as e2
ON e2.emp_id = b.manager_id;
```

Task 11. **Create a Table of Books with Rental Price Above a Certain Threshold**:
```sql
DROP TABLE IF EXISTS books_above_7; 
CREATE TABLE books_above_7 AS 
SELECT * FROM books 
WHERE rental_price>7;
SELECT * FROM books_above_7;
```

Task 12: **Retrieve the List of Books Not Yet Returned**
```sql
SELECT * FROM issued_status as ist
LEFT JOIN
return_status as rs
ON rs.issued_id = ist.issued_id
WHERE rs.return_id IS NULL;
```

## Advanced SQL Operations

**Task 13: Identify Members with Overdue Books**  
Write a query to identify members who have overdue books (assume a 30-day return period). Display the member's_id, member's name, book title, issue date, and days overdue.

```sql
SELECT 
            m.member_id,
	m.member_name,
	bk.book_title,
	ist.issued_date,
	CURRENT_DATE - issued_date as days_overdue
FROM issued_status as ist
JOIN members as m 
	ON m.member_id= ist.issued_member_id
JOIN books as bk
	ON bk.isbn= ist.issued_book_isbn
LEFT JOIN return_status as rs
	ON rs.issued_id= ist.issued_id
WHERE return_id is NULL 
AND 
(CURRENT_DATE - issued_date) > 30
ORDER BY 2;

```


**Task 14: Update Book Status on Return**  
Write a query to update the status of books in the books table to "Yes" when they are returned (based on entries in the return_status table).


```sql

CREATE OR REPLACE PROCEDURE add_return_records(p_return_id VARCHAR(10),p_issued_id VARCHAR(10),p_book_quality VARCHAR(10))
LANGUAGE plpgsql
AS $$

DECLARE
	v_isbn VARCHAR(50);
	v_book_name VARCHAR(80);

BEGIN 
            INSERT INTO return_status(return_id,issued_id,return_date,book_quality)
	VALUES
	(p_return_id,p_issued_id,CURRENT_DATE,p_book_quality);

	SELECT
		issued_book_isbn,
		issued_book_name
		INTO 
		v_isbn,
		v_book_name
	FROM issued_status
	WHERE issued_id = p_issued_id;

	UPDATE books
	SET status = 'yes'
	WHERE isbn= v_isbn;

	RAISE NOTICE 'Thank you for returning the book %', v_book_name;
	
END;
$$

-- Checking the book if returned or not
SELECT * FROM books
WHERE isbn= '978-0-307-58837-1';

SELECT * FROM issued_status
WHERE issued_book_isbn= '978-0-307-58837-1'

SELECT * FROM return_status
WHERE issued_id= 'IS135'

SELECT * FROM issued_status
WHERE issued_id= 'IS135'

--Calling the function so that it will add and update the tables
CALL add_return_records('RS138','IS135','good');
```

**Task 15: Branch Performance Report**  
Create a query that generates a performance report for each branch, showing the number of books issued, the number of books returned, and the total revenue generated from book rentals.

```sql
DROP TABLE IF EXISTS branch_performance;
CREATE TABLE branch_performance
AS
SELECT 
	b.branch_id,
	COUNT(ist.issued_id) as no_of_books_issued,
	COUNT(rs.return_id) as no_of_books_returned,
	SUM(bk.rental_price) as total_revenue
FROM
	branch as b 
JOIN employees as e ON
	b.branch_id= e.branch_id
JOIN issued_status as ist ON
	ist.issued_emp_id= e.emp_id
LEFT JOIN return_status as rs ON 
	ist.issued_id = rs.issued_id
JOIN books as bk ON 
	bk.isbn= ist.issued_book_isbn
GROUP BY 1;

SELECT * FROM branch_performance;

```

**Task 16: CTAS: Create a Table of Active Members**  
Use the CREATE TABLE AS (CTAS) statement to create a new table active_members containing members who have issued at least one book in the last 2 months.

```sql

DROP TABLE IF EXISTS active_members;
CREATE TABLE active_members
AS
SELECT
	m.member_id,
	m.member_name,
	ist.issued_date
FROM members as m
RIGHT JOIN issued_status as ist ON
	ist. issued_member_id = m.member_id
WHERE ist.issued_date > CURRENT_DATE - INTERVAL '6 months'
GROUP BY 1,3;

SELECT * FROM active_members;

```


**Task 17: Find Employees with the Most Book Issues Processed**  
Write a query to find the top 3 employees who have processed the most book issues. Display the employee name, number of books processed, and their branch.

```sql
SELECT 
            e.emp_name,
	ist.issued_emp_id,
	COUNT(ist.issued_id) as no_of_books_issued,
	b.branch_id
FROM employees as e
JOIN issued_status as ist ON
	ist.issued_emp_id= e.emp_id
LEFT JOIN branch as b ON
	b.branch_id= e.branch_id
GROUP BY 1,2,4
ORDER BY 3 DESC
LIMIT 3;

```

**Task 18: Identify Members Issuing High-Risk Books**  
Write a query to identify members who have issued books more than twice with the status "damaged" in the books table. Display the member name, book title, and the number of times they've issued damaged books.   

```sql
SELECT 
	m.member_name,
	bk.book_title,
	COUNT(rs.issued_id) as count
FROM members as m
RIGHT JOIN issued_status as ist ON
	m.member_id = ist.issued_member_id
LEFT JOIN books as bk ON
	bk.isbn= issued_book_isbn
RIGHT JOIN return_status as rs ON
	rs.issued_id= ist.issued_id
WHERE rs.book_quality = 'Damaged'
GROUP BY 1,2;

```

**Task 19: Stored Procedure**
Objective:
Create a stored procedure to manage the status of books in a library system.
Description:
Write a stored procedure that updates the status of a book in the library based on its issuance. The procedure should function as follows:
The stored procedure should take the book_id as an input parameter.
The procedure should first check if the book is available (status = 'yes').
If the book is available, it should be issued, and the status in the books table should be updated to 'no'.
If the book is not available (status = 'no'), the procedure should return an error message indicating that the book is currently not available.

```sql

CREATE OR REPLACE PROCEDURE book_issuance(p_issued_id VARCHAR(5),p_issued_member_id VARCHAR(5), p_issued_book_isbn VARCHAR(20),p_issued_emp_id VARCHAR(5))
LANGUAGE plpgsql
AS $$

DECLARE 
	v_status VARCHAR(3);
	v_book_title VARCHAR(70);
BEGIN
	-- checking if the book is available
	SELECT 
		status,
		book_title
		INTO
		v_status,
		v_book_title
	FROM books
	WHERE isbn= p_issued_book_isbn;

	IF v_status='yes' THEN
		RAISE NOTICE 'The book % is available',v_book_title;

                        INSERT INTO issued_status(issued_id,issued_member_id,issued_book_name,issued_date,issued_book_isbn,issued_emp_id)
		VALUES (p_issued_id,p_issued_member_id,v_book_title,CURRENT_DATE, p_issued_book_isbn,p_issued_emp_id);

		UPDATE books
		SET status= 'no'
		WHERE isbn= p_issued_book_isbn;

	ELSE
		RAISE NOTICE 'The book is % not available',v_book_title;
	END IF;

END;
$$

CALL book_issuance('IS786','C107','978-0-679-76489-8','E107');

CALL book_issuance('IS789','C107','978-0-09-957807-9','E107');

SELECT * FROM issued_status;
SELECT * FROM books;
```



**Task 20: Create Table As Select (CTAS)**
Objective: Create a CTAS (Create Table As Select) query to identify overdue books and calculate fines.

Description: Write a CTAS query to create a new table that lists each member and the books they have issued but not returned within 30 days. The table should include:
    The number of overdue books.
    The total fines, with each day's fine calculated at $0.50.
    The number of books issued by each member.
    The resulting table should show:
    Member ID
    Number of overdue books
    Total fines

```sql

CREATE TABLE overdue_books
AS
SELECT 
	m.member_id,
	m.member_name,
	bk.isbn,
	bk.book_title,
	ist.issued_id,
	ist.issued_date,
	rs.return_id,
	rs.return_date,

	-- Overdue days after 30-day limit
	CASE
		WHEN rs.return_id IS NULL AND CURRENT_DATE - ist.issued_date > 30 THEN
			(CURRENT_DATE - ist.issued_date - 30)
		WHEN rs.return_id IS NOT NULL AND rs.return_date - ist.issued_date > 30 THEN 
			(rs.return_date - ist.issued_date - 30)
		ELSE 0
	END AS days_overdue,

	-- Fine to pay = overdue days * $0.5
	CASE
		WHEN rs.return_id IS NULL AND CURRENT_DATE - ist.issued_date > 30 THEN
			(CURRENT_DATE - ist.issued_date - 30) * 0.5
		WHEN rs.return_id IS NOT NULL AND rs.return_date - ist.issued_date > 30 THEN 
			(rs.return_date - ist.issued_date - 30) * 0.5
		ELSE 0
	END AS fine_to_pay

FROM 
	members AS m
JOIN issued_status AS ist ON
	ist.issued_member_id = m.member_id
JOIN books AS bk ON
	bk.isbn = ist.issued_book_isbn
LEFT JOIN return_status AS rs ON
	rs.issued_id = ist.issued_id;

SELECT * FROM overdue_books;

CREATE TABLE fine_summary
AS
SELECT 
	member_name,
	COUNT(isbn) AS count_of_due_books,
	SUM(fine_to_pay) as total_fine
FROM overdue_books
WHERE fine_to_pay != 0
GROUP BY 1;

SELECT * FROM fine_summary;

CREATE TABLE total_fine
AS 
SELECT
	SUM(count_of_due_books) as num_of_books_due,
	SUM(total_fine)
FROM fine_summary;

SELECT * FROM total_fine;
```


## Reports

- **Database Schema**: Detailed table structures and relationships.
- **Data Analysis**: Insights into book categories, employee salaries, member registration trends, and issued books.
- **Summary Reports**: Aggregated data on high-demand books and employee performance.

## Conclusion

This project demonstrates the application of SQL skills in creating and managing a library management system. It includes database setup, data manipulation, and advanced querying, providing a solid foundation for data management and analysis.


## Author - Fahiz Mohammed 
