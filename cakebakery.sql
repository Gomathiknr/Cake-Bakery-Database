-- Create cake_bakery database
CREATE DATABASE cake_bakery;
use cake_bakery;

-- Create Customers table
CREATE TABLE if not exists Customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(20)
);

-- Create Cakes table
CREATE TABLE if not exists Cakes (
    cake_id INT AUTO_INCREMENT PRIMARY KEY,
    cake_name VARCHAR(100),
    price DECIMAL(10, 2),
    description TEXT
);

-- Create Orders table (with DATETIME)
CREATE TABLE if not exists Orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    order_datetime DATETIME,  -- Stores both date and time
    total_amount DECIMAL(10, 2),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- Create Order_Items table
CREATE TABLE  if not exists Order_Items (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    cake_id INT,
    quantity INT,
    item_price DECIMAL(10, 2),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (cake_id) REFERENCES Cakes(cake_id)
);


-- insert values on Customers table

INSERT INTO Customers (name, email, phone)
VALUES 
('John Doe', 'john@example.com', '1234567890'),
('Jane Smith', 'jane@example.com', '2345678901'),
('Alice Brown', 'alice@example.com', '3456789012'),
('Bob White', 'bob@example.com', '4567890123'),
('Charlie Green', 'charlie@example.com', '5678901234'),
('Diana Black', 'diana@example.com', '6789012345'),
('Edward Blue', 'edward@example.com', '7890123456'),
('Fiona Gray', 'fiona@example.com', '8901234567'),
('George Red', 'george@example.com', '9012345678'),
('Helen Yellow', 'helen@example.com', '0123456789');

-- insert values on Cakes table

INSERT INTO Cakes (cake_name, price, description)
VALUES 
('Chocolate Cake', 20.50, 'Rich chocolate cake with layers of ganache.'),
('Vanilla Cake', 18.75, 'Classic vanilla sponge with buttercream.'),
('Red Velvet Cake', 22.00, 'Red velvet cake with cream cheese frosting.'),
('Black Forest Cake', 25.00, 'Layers of chocolate, cherries, and cream.'),
('Carrot Cake', 19.99, 'Moist carrot cake with walnuts and cream cheese.'),
('Lemon Drizzle Cake', 16.50, 'Zesty lemon drizzle cake with glaze.'),
('Strawberry Shortcake', 21.00, 'Light sponge with fresh strawberries and cream.'),
('Tiramisu Cake', 23.00, 'Coffee-flavored Italian dessert cake.'),
('Cheesecake', 24.50, 'Creamy cheesecake with a graham cracker crust.'),
('Opera Cake', 30.00, 'French layered cake with coffee and chocolate.');

-- insert values on Oders table

INSERT INTO Orders (customer_id, order_datetime, total_amount)
VALUES 
(1, '2024-08-23 10:30:00', 50.00),
(2, '2024-08-22 14:45:00', 40.75),
(3, '2024-08-21 09:15:00', 60.50),
(4, '2024-08-20 11:00:00', 70.00),
(5, '2024-08-19 13:30:00', 45.99),
(6, '2024-08-18 15:45:00', 55.25),
(7, '2024-08-17 16:00:00', 80.00),
(8, '2024-08-16 12:10:00', 35.99),
(9, '2024-08-15 17:30:00', 65.00),
(10, '2024-08-14 10:00:00', 90.00);

-- insert values on Oders_Items table

INSERT INTO Order_Items (order_id, cake_id, quantity, item_price)
VALUES 
(1, 1, 2, 20.50),  -- 2 Chocolate Cakes
(1, 2, 1, 18.75),  -- 1 Vanilla Cake
(2, 3, 1, 22.00),  -- 1 Red Velvet Cake
(2, 4, 1, 25.00),  -- 1 Black Forest Cake
(3, 5, 2, 19.99),  -- 2 Carrot Cakes
(4, 6, 3, 16.50),  -- 3 Lemon Drizzle Cakes
(5, 7, 1, 21.00),  -- 1 Strawberry Shortcake
(6, 8, 2, 23.00),  -- 2 Tiramisu Cakes
(7, 9, 1, 24.50),  -- 1 Cheesecake
(8, 10, 1, 30.00), -- 1 Opera Cake
(9, 1, 2, 20.50),  -- 2 Chocolate Cakes
(10, 3, 3, 22.00); -- 3 Red Velvet Cakes

-- Queries with Date and Time
-- View all orders with customer names, total amounts, and the exact date and time of the order

SELECT o.order_id, c.name, o.order_datetime, o.total_amount
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id;

-- Filter orders placed on a specific date (e.g., August 23, 2024)

SELECT o.order_id, c.name, o.order_datetime, o.total_amount
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
WHERE DATE(o.order_datetime) = '2024-08-23';


-- Get orders placed within a specific time range (e.g., between 9:00 AM and 5:00 PM)

SELECT o.order_id, c.name, o.order_datetime, o.total_amount
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
WHERE TIME(o.order_datetime) BETWEEN '09:00:00' AND '17:00:00';


 -- List the total number of orders per day
 
 SELECT DATE(o.order_datetime) AS order_date, COUNT(o.order_id) AS total_orders
FROM Orders o
GROUP BY order_date;

-- List Orders Grouped by Date and Time
-- Group orders by date and time (hour)

SELECT DATE(o.order_datetime) AS order_date, HOUR(o.order_datetime) AS order_hour, COUNT(o.order_id) AS total_orders
FROM Orders o
GROUP BY order_date, order_hour;

-- Select All Cake Names with Prices

SELECT cake_name, price
FROM Cakes;

-- Find Orders with Specific Cake (e.g., Chocolate Cake)

SELECT o.order_id, c.name, o.order_datetime, ca.cake_name, oi.quantity, oi.item_price
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
JOIN Order_Items oi ON o.order_id = oi.order_id
JOIN Cakes ca ON oi.cake_id = ca.cake_id
WHERE ca.cake_name = 'Chocolate Cake';


-- List All Cakes Ordered by a Specific Customer

SELECT c.name AS customer_name, ca.cake_name, oi.quantity, o.order_datetime
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
JOIN Order_Items oi ON o.order_id = oi.order_id
JOIN Cakes ca ON oi.cake_id = ca.cake_id
WHERE c.name = 'John Doe';


-- Find the Most Ordered Cake

SELECT ca.cake_name, SUM(oi.quantity) AS total_sold
FROM Cakes ca
JOIN Order_Items oi ON ca.cake_id = oi.cake_id
GROUP BY ca.cake_name
ORDER BY total_sold DESC
LIMIT 1;


-- List Cakes and Total Revenue Generated by Each Cake

SELECT ca.cake_name, SUM(oi.quantity * oi.item_price) AS total_revenue
FROM Cakes ca
JOIN Order_Items oi ON ca.cake_id = oi.cake_id
GROUP BY ca.cake_name
ORDER BY total_revenue DESC;

-- Find Orders Containing Multiple Cake Types

SELECT o.order_id, c.name AS customer_name, COUNT(DISTINCT ca.cake_id) AS cake_types
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
JOIN Order_Items oi ON o.order_id = oi.order_id
JOIN Cakes ca ON oi.cake_id = ca.cake_id
GROUP BY o.order_id
HAVING cake_types > 1;


-- Get Cake Name and Quantity Sold on a Specific Date

SELECT ca.cake_name, SUM(oi.quantity) AS total_sold
FROM Cakes ca
JOIN Order_Items oi ON ca.cake_id = oi.cake_id
JOIN Orders o ON oi.order_id = o.order_id
WHERE DATE(o.order_datetime) = '2024-08-23'
GROUP BY ca.cake_name;


-- List Customers Who Ordered a Specific Cake

SELECT c.name AS customer_name, o.order_datetime, oi.quantity
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
JOIN Order_Items oi ON o.order_id = oi.order_id
JOIN Cakes ca ON oi.cake_id = ca.cake_id
WHERE ca.cake_name = 'Red Velvet Cake';


-- Find Cakes That Have Never Been Ordered

SELECT ca.cake_name
FROM Cakes ca
LEFT JOIN Order_Items oi ON ca.cake_id = oi.cake_id
WHERE oi.order_item_id IS NULL;


-- List Cakes with Prices Above a Certain Threshold

SELECT cake_name, price
FROM Cakes
WHERE price > 20.00;



