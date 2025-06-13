-- Library-System-Management

-- Creating Branch Table
DROP TABLE IF EXISTS branch;
CREATE TABLE branch(
			branch_id VARCHAR(5) PRIMARY KEY,
			manager_id VARCHAR(5),
			branch_address	VARCHAR(15),
			contact_no VARCHAR(15)
);
select * from branch;
-- Creating Employees Table
DROP TABLE IF EXISTS employees;
CREATE TABLE employees(
			emp_id VARCHAR(5) PRIMARY KEY,
			emp_name VARCHAR(25),
			position VARCHAR(20),
			salary FLOAT,
			branch_id VARCHAR(7)
);
select * from employees;
-- Creating Books Table
DROP TABLE IF EXISTS books;
CREATE TABLE books(
			isbn VARCHAR(20) PRIMARY KEY,
			book_title VARCHAR(60),
			category VARCHAR(20),
			rental_price FLOAT,
			status VARCHAR(3),
			author VARCHAR(25),
			publisher VARCHAR(30)
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
			issued_member_id VARCHAR(5) FOREIGN KEY,
			issued_book_name VARCHAR(55),
			issued_date DATE,
			issued_book_isbn VARCHAR(20) FOREIGN KEY,
			issued_emp_id VARCHAR(5) FOREIGN KEY
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

