CREATE DATABASE "Online_Bookstore";
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS books;

CREATE TABLE books (
    Book_ID INT PRIMARY KEY,
    Title VARCHAR(100),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    Published_Year INT,
    Price NUMERIC(10, 2),
    Stock INT
);

CREATE TABLE customers (
    Customer_ID INT PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50),
    Country VARCHAR(150)
);

CREATE TABLE orders (
    Order_ID INT PRIMARY KEY,
    Customer_ID INT REFERENCES customers(Customer_ID),
    Book_ID INT REFERENCES books(Book_ID),
    Order_Date DATE,
    Quantity INT,
    Total_Amount NUMERIC(10, 2)
);


SELECT * FROM books;
SELECT * FROM customers;
SELECT * FROM orders;

-- 1) Retrieve all books in the "Fiction" genre:
SELECT * FROM books
WHERE Genre = 'Fiction';

-- 2) Find books published after the year 1950:
SELECT * FROM books
WHERE Published_Year > 1950;

-- 3) List all customers from the Canada:
SELECT * FROM customers
WHERE Country = 'Canada';

-- 4) Show orders placed in November 2023:
SELECT * FROM orders
WHERE Order_Date BETWEEN '2023-11-01' AND '2023-11-30';

-- 5) Retrieve the total stock of books available:
SELECT SUM(Stock) AS total_stock FROM books;

-- 6) Find the details of the most expensive book:
SELECT * FROM books
ORDER BY Price DESC
LIMIT 1;

-- 7) Show all customers who ordered more than 1 quantity of a book:
SELECT DISTINCT c.*
FROM customers c
JOIN orders o ON c.Customer_ID = o.Customer_ID
WHERE o.Quantity > 1;

-- 8) Retrieve all orders where the total amount exceeds $20:
SELECT * FROM orders
WHERE Total_Amount > 20;

-- 9) List all genres available in the Books table:
SELECT DISTINCT Genre FROM books;

-- 10) Find the book with the lowest stock:
SELECT * FROM books
ORDER BY Stock ASC
LIMIT 1;

-- 11) Calculate the total revenue generated from all orders:
SELECT SUM(Total_Amount) AS total_revenue FROM orders;

-- Advance Questions :

-- 1) Retrieve the total number of books sold for each genre:
SELECT b.Genre, SUM(o.Quantity) AS total_books_sold
FROM books b
JOIN orders o ON b.Book_ID = o.Book_ID
GROUP BY b.Genre;

-- 2) Find the average price of books in the "Fantasy" genre:
SELECT AVG(Price) AS avg_price_fantasy
FROM books
WHERE Genre = 'Fantasy';

-- 3) List customers who have placed at least 2 orders:
SELECT c.Customer_ID, c.Name, COUNT(o.Order_ID) AS order_count
FROM customers c
JOIN orders o ON c.Customer_ID = o.Customer_ID
GROUP BY c.Customer_ID, c.Name
HAVING COUNT(o.Order_ID) >= 2;

-- 4) Find the most frequently ordered book:
SELECT b.Book_ID, b.Title, COUNT(o.Order_ID) AS order_count
FROM orders o
JOIN books b ON o.Book_ID = b.Book_ID
GROUP BY b.Book_ID, b.Title
ORDER BY order_count DESC
LIMIT 1;

-- 5) Show the top 3 most expensive books of 'Fantasy' Genre :
SELECT * FROM books
WHERE Genre = 'Fantasy'
ORDER BY Price DESC
LIMIT 3;

-- 6) Retrieve the total quantity of books sold by each author:
SELECT b.Author, SUM(o.Quantity) AS total_quantity_sold
FROM books b
JOIN orders o ON b.Book_ID = o.Book_ID
GROUP BY b.Author
ORDER BY total_quantity_sold DESC;

-- 7) List the cities where customers who spent over $30 are located:
SELECT c.City, c.Name, SUM(o.Total_Amount) AS total_spent
FROM customers c
JOIN orders o ON c.Customer_ID = o.Customer_ID
GROUP BY c.Customer_ID, c.City, c.Name
HAVING SUM(o.Total_Amount) > 30;

-- 8) Find the customer who spent the most on orders:
SELECT c.Customer_ID, c.Name, SUM(o.Total_Amount) AS Total_Spent
FROM orders o
JOIN customers c ON o.Customer_ID = c.Customer_ID
GROUP BY c.Customer_ID, c.Name
ORDER BY Total_Spent DESC
LIMIT 1;

-- 9) Calculate the stock remaining after fulfilling all orders:
SELECT b.Book_ID, b.Title, b.Stock, 
       COALESCE(SUM(o.Quantity),0) AS ordered_quantity,
       b.Stock - COALESCE(SUM(o.Quantity),0) AS Remaining_quantity
FROM books b
LEFT JOIN orders o ON b.Book_ID = o.Book_ID
GROUP BY b.Book_ID, b.Title, b.Stock
ORDER BY b.Book_ID;