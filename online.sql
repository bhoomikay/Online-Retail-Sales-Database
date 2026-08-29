CREATE DATABASE online_retail_db;
USE online_retail_db;

CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15),
    city VARCHAR(50),
    state VARCHAR(50),
    registration_date DATE NOT NULL
);

CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    stock_quantity INT NOT NULL DEFAULT 0,
    supplier_name VARCHAR(100),
    
    CHECK (price >= 0),
    CHECK (stock_quantity >= 0)
);

CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,
    order_status VARCHAR(30) NOT NULL DEFAULT 'Pending',
    
    FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    
    FOREIGN KEY (order_id)
        REFERENCES orders(order_id)
        ON DELETE CASCADE,
        
    FOREIGN KEY (product_id)
        REFERENCES products(product_id),
        
    CHECK (quantity > 0),
    CHECK (unit_price >= 0)
);

CREATE TABLE payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    payment_date DATE NOT NULL,
    payment_method VARCHAR(30) NOT NULL,
    payment_amount DECIMAL(10,2) NOT NULL,
    payment_status VARCHAR(30) NOT NULL DEFAULT 'Pending',
    
    FOREIGN KEY (order_id)
        REFERENCES orders(order_id),
        
    CHECK (payment_amount >= 0)
);

INSERT INTO customers
(first_name, last_name, email, phone, city, state, registration_date)
VALUES
('Ananya', 'Sharma', 'ananya.sharma@gmail.com', '9876543210', 'Bengaluru', 'Karnataka', '2026-01-10'),
('Rahul', 'Kumar', 'rahul.kumar@gmail.com', '9876543211', 'Mysuru', 'Karnataka', '2026-01-15'),
('Sneha', 'Patil', 'sneha.patil@gmail.com', '9876543212', 'Mandya', 'Karnataka', '2026-02-05'),
('Arjun', 'Rao', 'arjun.rao@gmail.com', '9876543213', 'Bengaluru', 'Karnataka', '2026-02-10'),
('Priya', 'Das', 'priya.das@gmail.com', '9876543214', 'Mangaluru', 'Karnataka', '2026-02-20'),
('Vikram', 'Naik', 'vikram.naik@gmail.com', '9876543215', 'Hubballi', 'Karnataka', '2026-03-01'),
('Kavya', 'Shetty', 'kavya.shetty@gmail.com', '9876543216', 'Udupi', 'Karnataka', '2026-03-05'),
('Rohan', 'Mehta', 'rohan.mehta@gmail.com', '9876543217', 'Bengaluru', 'Karnataka', '2026-03-10');

INSERT INTO products
(product_name, category, price, stock_quantity, supplier_name)
VALUES
('Laptop', 'Electronics', 65000.00, 25, 'TechWorld Suppliers'),
('Wireless Mouse', 'Electronics', 1200.00, 100, 'TechWorld Suppliers'),
('Keyboard', 'Electronics', 1800.00, 75, 'TechWorld Suppliers'),
('Smartphone', 'Electronics', 28000.00, 40, 'MobileHub'),
('Headphones', 'Electronics', 2500.00, 60, 'AudioWorld'),
('T-Shirt', 'Clothing', 799.00, 150, 'FashionMart'),
('Jeans', 'Clothing', 1999.00, 80, 'FashionMart'),
('Running Shoes', 'Footwear', 3499.00, 50, 'SportsGear'),
('Backpack', 'Accessories', 1499.00, 70, 'BagWorld'),
('Watch', 'Accessories', 2999.00, 45, 'TimeZone');

INSERT INTO orders
(customer_id, order_date, order_status)
VALUES
(1, '2026-03-15', 'Delivered'),
(2, '2026-03-16', 'Delivered'),
(3, '2026-03-18', 'Shipped'),
(1, '2026-03-20', 'Processing'),
(4, '2026-03-22', 'Delivered'),
(5, '2026-03-25', 'Delivered'),
(6, '2026-03-27', 'Shipped'),
(7, '2026-04-01', 'Processing'),
(8, '2026-04-03', 'Pending');

INSERT INTO order_items
(order_id, product_id, quantity, unit_price)
VALUES
(1, 1, 1, 65000.00),
(1, 2, 2, 1200.00),

(2, 4, 1, 28000.00),
(2, 5, 1, 2500.00),

(3, 6, 3, 799.00),
(3, 7, 1, 1999.00),

(4, 3, 1, 1800.00),
(4, 5, 2, 2500.00),

(5, 8, 1, 3499.00),
(5, 9, 1, 1499.00),

(6, 10, 1, 2999.00),
(6, 6, 2, 799.00),

(7, 1, 1, 65000.00),

(8, 7, 2, 1999.00),
(8, 8, 1, 3499.00),

(9, 2, 1, 1200.00);


INSERT INTO payments
(order_id, payment_date, payment_method, payment_amount, payment_status)
VALUES
(1, '2026-03-15', 'UPI', 67400.00, 'Completed'),
(2, '2026-03-16', 'Credit Card', 30500.00, 'Completed'),
(3, '2026-03-18', 'UPI', 4396.00, 'Completed'),
(4, '2026-03-20', 'Debit Card', 6800.00, 'Completed'),
(5, '2026-03-22', 'UPI', 4998.00, 'Completed'),
(6, '2026-03-25', 'Credit Card', 4597.00, 'Completed'),
(7, '2026-03-27', 'Net Banking', 65000.00, 'Completed'),
(8, '2026-04-01', 'UPI', 7497.00, 'Completed'),
(9, '2026-04-03', 'Cash on Delivery', 1200.00, 'Pending');

CREATE TABLE inventory_transactions (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    transaction_type VARCHAR(20) NOT NULL,
    quantity INT NOT NULL,
    transaction_date DATE NOT NULL,

    FOREIGN KEY (product_id)
        REFERENCES products(product_id),

    CHECK (transaction_type IN ('PURCHASE', 'SALE', 'RETURN')),
    CHECK (quantity > 0)
);

INSERT INTO inventory_transactions
(product_id, transaction_type, quantity, transaction_date)
VALUES
(1, 'PURCHASE', 10, '2026-04-05'),
(2, 'PURCHASE', 20, '2026-04-05'),
(3, 'PURCHASE', 15, '2026-04-06'),
(4, 'PURCHASE', 10, '2026-04-06'),
(5, 'PURCHASE', 20, '2026-04-07'),
(6, 'PURCHASE', 30, '2026-04-07'),
(7, 'PURCHASE', 15, '2026-04-08'),
(8, 'PURCHASE', 10, '2026-04-08'),
(9, 'PURCHASE', 15, '2026-04-09'),
(10, 'PURCHASE', 10, '2026-04-09');

DELIMITER $$

CREATE TRIGGER update_product_stock
AFTER INSERT ON inventory_transactions
FOR EACH ROW
BEGIN

    IF NEW.transaction_type = 'PURCHASE' THEN

        UPDATE products
        SET stock_quantity = stock_quantity + NEW.quantity
        WHERE product_id = NEW.product_id;

    ELSEIF NEW.transaction_type = 'SALE' THEN

        UPDATE products
        SET stock_quantity = stock_quantity - NEW.quantity
        WHERE product_id = NEW.product_id;

    ELSEIF NEW.transaction_type = 'RETURN' THEN

        UPDATE products
        SET stock_quantity = stock_quantity + NEW.quantity
        WHERE product_id = NEW.product_id;

    END IF;

END$$

DELIMITER ;

CREATE OR REPLACE VIEW low_stock_products AS
SELECT
    product_id,
    product_name,
    category,
    stock_quantity,
    CASE
        WHEN stock_quantity <= 5 THEN 'REORDER NOW'
        WHEN stock_quantity <= 10 THEN 'LOW STOCK'
        ELSE 'IN STOCK'
    END AS stock_status
FROM products;

CREATE OR REPLACE VIEW customer_spending_report AS
SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.quantity * oi.unit_price), 2) AS total_spent
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name;
    
CREATE OR REPLACE VIEW category_sales_report AS
SELECT
    p.category,
    SUM(oi.quantity) AS units_sold,
    ROUND(SUM(oi.quantity * oi.unit_price), 2) AS total_sales
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
GROUP BY p.category;

CREATE OR REPLACE VIEW product_sales_report AS
SELECT
    p.product_id,
    p.product_name,
    p.category,
    SUM(oi.quantity) AS units_sold,
    ROUND(SUM(oi.quantity * oi.unit_price), 2) AS total_sales
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
GROUP BY
    p.product_id,
    p.product_name,
    p.category;
    
CREATE OR REPLACE VIEW order_sales_details AS
SELECT
    o.order_id,
    o.order_date,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    p.product_name,
    p.category,
    oi.quantity,
    oi.unit_price,
    ROUND(oi.quantity * oi.unit_price, 2) AS item_total,
    o.order_status
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id;




