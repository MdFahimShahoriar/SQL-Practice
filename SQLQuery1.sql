create database book;
use book;
-- Create the Authors table first
CREATE TABLE Authors (
    AuthorID INT PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    BirthYear INT
);

-- Create the Books table after Authors table
CREATE TABLE Books (
    BookID INT PRIMARY KEY,
    Title VARCHAR(255) NOT NULL,
    AuthorID INT,
    Genre VARCHAR(100),
    PublishedYear INT,
    FOREIGN KEY (AuthorID) REFERENCES Authors(AuthorID)
);

-- Create the Borrowers table
CREATE TABLE Borrowers (
    BorrowerID INT PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Address VARCHAR(255),
    PhoneNumber VARCHAR(20)
);
-- Insert sample data into Authors table
INSERT INTO Authors (AuthorID, Name, BirthYear) VALUES
(1, 'J.K. Rowling', 1965),
(2, 'George Orwell', 1903),
(3, 'J.R.R. Tolkien', 1892),
(4, 'Agatha Christie', 1890),
(5, 'Stephen King', 1947),
(6, 'Mark Twain', 1835),
(7, 'Jane Austen', 1775),
(8, 'Charles Dickens', 1812),
(9, 'Ernest Hemingway', 1899),
(10, 'F. Scott Fitzgerald', 1896);

-- Insert sample data into Books table
INSERT INTO Books (BookID, Title, AuthorID, Genre, PublishedYear) VALUES
(1, 'Harry Potter and the Philosopher''s Stone', 1, 'Fantasy', 1997),
(2, '1984', 2, 'Dystopian', 1949),
(3, 'The Hobbit', 3, 'Fantasy', 1937),
(4, 'Murder on the Orient Express', 4, 'Mystery', 1934),
(5, 'The Shining', 5, 'Horror', 1977),
(6, 'Adventures of Huckleberry Finn', 6, 'Adventure', 1884),
(7, 'Pride and Prejudice', 7, 'Romance', 1813),
(8, 'A Tale of Two Cities', 8, 'Historical', 1859),
(9, 'The Old Man and the Sea', 9, 'Literary Fiction', 1952),
(10, 'The Great Gatsby', 10, 'Tragedy', 1925);

-- Insert sample data into Borrowers table
INSERT INTO Borrowers (BorrowerID, Name, Address, PhoneNumber) VALUES
(1, 'Alice Johnson', '123 Maple St', '555-1234'),
(2, 'Bob Smith', '456 Oak St', '555-5678'),
(3, 'Charlie Brown', '789 Pine St', '555-8765'),
(4, 'Daisy Miller', '101 Birch St', '555-4321'),
(5, 'Eve Davis', '202 Cedar St', '555-6789'),
(6, 'Frank Wilson', '303 Elm St', '555-9876'),
(7, 'Grace Lee', '404 Spruce St', '555-3456'),
(8, 'Hank Green', '505 Willow St', '555-6543'),
(9, 'Ivy White', '606 Fir St', '555-7890'),
(10, 'Jack Black', '707 Ash St', '555-0987');
--Select all data from each table
SELECT * FROM Books;
SELECT * FROM Authors;
SELECT * FROM Borrowers;
--Show all columns and their details for each table
SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns
WHERE table_name = 'Books';
--
SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns
WHERE table_name = 'Authors';
--
SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns
WHERE table_name = 'Borrowers';

--Basic Data Retrieval
--Select all columns from a table:
SELECT * FROM Books;
--Select specific columns from a table
SELECT Title, Genre FROM Books;
--Select distinct values:
SELECT DISTINCT Genre FROM Books;
--Filtering Data
--Filter rows using the WHERE clause
SELECT * FROM Books WHERE Genre = 'Fantasy';
--Filter rows using multiple conditions:
SELECT * FROM Books WHERE Genre = 'Fantasy' AND PublishedYear < 2000;
--Filter rows using the IN operator:
SELECT * FROM Books WHERE Genre IN ('Fantasy', 'Mystery');
--Sorting Data
--Order results by a column:
SELECT * FROM Books ORDER BY PublishedYear;
--Order results by multiple columns:
SELECT * FROM Books ORDER BY Genre, PublishedYear DESC;
SELECT * FROM Books ORDER BY Genre, PublishedYear ASC;
--Aggregating Data
--Count the number of rows:
SELECT COUNT(*) FROM Books;
--Calculate the average value:
SELECT AVG(PublishedYear) AS AverageYear FROM Books;
--Find the minimum and maximum values:
SELECT MIN(PublishedYear) AS OldestBook, MAX(PublishedYear) AS NewestBook FROM Books;
--Grouping Data
--Group by a column and count:
SELECT Genre, COUNT(*) AS NumberOfBooks FROM Books GROUP BY Genre;
--Group by multiple columns:
SELECT Genre, PublishedYear, COUNT(*) AS NumberOfBooks FROM Books GROUP BY Genre, PublishedYear;
--Joining Tables
--Inner join between Books and Authors:
SELECT Books.Title, Authors.Name
FROM Books
INNER JOIN Authors ON Books.AuthorID = Authors.AuthorID;
--Left join between Books and Authors:
SELECT Books.Title, Authors.Name
FROM Books
LEFT JOIN Authors ON Books.AuthorID = Authors.AuthorID;
--Subqueries
--Subquery in the WHERE clause:
SELECT * FROM Books
WHERE AuthorID IN (SELECT AuthorID FROM Authors WHERE BirthYear < 1900);
--Subquery in the SELECT clause
SELECT Title, (SELECT Name FROM Authors WHERE Authors.AuthorID = Books.AuthorID) AS AuthorName
FROM Books;
--Advanced Queries
--Using CASE statements:
SELECT Title,
       CASE
           WHEN PublishedYear < 2000 THEN 'Old'
           ELSE 'New'
       END AS BookAge
FROM Books;
--Using COALESCE to handle NULL values:
SELECT Title, COALESCE(Genre, 'Unknown') AS Genre
FROM Books;
--Using UNION to combine results from multiple queries:
SELECT Title FROM Books WHERE Genre = 'Fantasy'
UNION
SELECT Title FROM Books WHERE PublishedYear > 2000;
--Updating Data
--Update a single column:
UPDATE Books
SET Genre = 'Classic'
WHERE PublishedYear < 1950;
--Update multiple columns:
UPDATE Authors
SET Name = 'Samuel Clemens', BirthYear = 1835
WHERE AuthorID = 6;
--Deleting Data
--Delete specific rows:
DELETE FROM Borrowers
WHERE BorrowerID = 10;
--Delete all rows from a table:
--DELETE FROM Books;--
--Merging Data
--Merge (upsert) data
MERGE INTO Books AS target
USING (SELECT 1 AS BookID, 'New Book' AS Title, 1 AS AuthorID, 'Fiction' AS Genre, 2024 AS PublishedYear) AS source
ON (target.BookID = source.BookID)
WHEN MATCHED THEN
    UPDATE SET Title = source.Title, Genre = source.Genre, PublishedYear = source.PublishedYear
WHEN NOT MATCHED THEN
    INSERT (BookID, Title, AuthorID, Genre, PublishedYear)
    VALUES (source.BookID, source.Title, source.AuthorID, source.Genre, source.PublishedYear);
--Advanced Data Retrieval
--Using LIKE for pattern matching:
SELECT * FROM Books
WHERE Title LIKE '%Harry Potter%';
--Using BETWEEN for range filtering
SELECT * FROM Books
WHERE PublishedYear BETWEEN 1900 AND 2010;
--Using EXISTS to check for the existence of rows:
SELECT * FROM Authors
WHERE EXISTS (SELECT 1 FROM Books WHERE Books.AuthorID = Authors.AuthorID AND Genre = 'Fantasy');
--Window Functions
--Using ROW_NUMBER for ranking:
SELECT Title, PublishedYear,
       ROW_NUMBER() OVER (ORDER BY PublishedYear DESC) AS RowNum
FROM Books;
--Using SUM with PARTITION BY
SELECT AuthorID, SUM(PublishedYear) OVER (PARTITION BY AuthorID) AS TotalYears
FROM Books;
--Advanced Data Retrieval
--Using CTE (Common Table Expressions):
WITH BookCounts AS (
    SELECT AuthorID, COUNT(*) AS NumberOfBooks
    FROM Books
    GROUP BY AuthorID
)
SELECT Authors.Name, BookCounts.NumberOfBooks
FROM Authors
JOIN BookCounts ON Authors.AuthorID = BookCounts.AuthorID;
--Using Recursive CTE:
WITH Numbers AS (
    SELECT 1 AS Number
    UNION ALL
    SELECT Number + 1
    FROM Numbers
    WHERE Number < 10
)
SELECT Number FROM Numbers
OPTION (MAXRECURSION 10);
--Using PIVOT to transform data:
SELECT *
FROM (
    SELECT Genre, PublishedYear
    FROM Books
) AS SourceTable
PIVOT (
    COUNT(PublishedYear)
    FOR PublishedYear IN ([1997], [1949], [1937], [1934], [1977], [1884], [1813], [1859], [1952], [1925])
) AS PivotTable;
--Advanced Data Manipulation
--Using TRIGGERS to automate actions:
CREATE TRIGGER trgAfterInsert
ON Borrowers
AFTER INSERT
AS
BEGIN
    PRINT 'A new borrower has been added.'
END;
--Using STORED PROCEDURES for reusable code:
CREATE PROCEDURE GetBooksByAuthor
    @AuthorID INT
AS
BEGIN
    SELECT * FROM Books WHERE AuthorID = @AuthorID;
END;
--Using TRANSACTIONS to ensure data integrity
BEGIN TRANSACTION;
UPDATE Books SET Genre = 'Classic' WHERE PublishedYear < 1950;
DELETE FROM Borrowers WHERE BorrowerID = 10;
COMMIT TRANSACTION;
--Performance Optimization
--Creating INDEXES to speed up queries
CREATE INDEX idx_books_genre ON Books (Genre);
--Using EXPLAIN to analyze query performance:
SET SHOWPLAN_ALL ON;
GO

SELECT * FROM Books WHERE Genre = 'Fantasy';
GO

SET SHOWPLAN_ALL OFF;
GO
--
SET SHOWPLAN_XML ON;
GO

SELECT * FROM Books WHERE Genre = 'Fantasy';
GO

SET SHOWPLAN_XML OFF;
GO

--Security and Permissions
--Granting and revoking permissions:
--GRANT SELECT, INSERT ON Books TO [titu];--
--REVOKE INSERT ON Books FROM [titu];--
--Data Export and Import
--Exporting data to a CSV file
BCP "SELECT * FROM Books" queryout "C:\Books.csv" -c -t, -T -S [SQLQuery1];
--Importing data from a CSV file:
BULK INSERT Books
FROM 'C:\Books.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
);


