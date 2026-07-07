-- FeastOrder MySQL schema
-- Run this once against a MySQL 8+ server:
--   mysql -u root -p < schema.sql

CREATE DATABASE IF NOT EXISTS feastorder_db
    CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE feastorder_db;

CREATE TABLE IF NOT EXISTS users (
    user_id       INT AUTO_INCREMENT PRIMARY KEY,
    username      VARCHAR(50)  NOT NULL UNIQUE,
    email         VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    phone_number  VARCHAR(20)  NOT NULL,
    role          ENUM('customer', 'admin') NOT NULL DEFAULT 'customer',
    created_at    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS categories (
    category_id   INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL UNIQUE,
    description   VARCHAR(255)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS menu_items (
    item_id           INT AUTO_INCREMENT PRIMARY KEY,
    category_id       INT NOT NULL,
    name              VARCHAR(100) NOT NULL,
    description       TEXT,                 -- ingredients / description
    nutritional_info  VARCHAR(255),
    price             DECIMAL(8,2) NOT NULL,
    image_url         VARCHAR(255),
    rating            DECIMAL(2,1) NOT NULL DEFAULT 0.0,
    is_available      BOOLEAN NOT NULL DEFAULT TRUE,
    CONSTRAINT fk_menu_items_category
        FOREIGN KEY (category_id) REFERENCES categories(category_id)
        ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS orders (
    order_id     INT AUTO_INCREMENT PRIMARY KEY,
    user_id      INT NOT NULL,
    total_price  DECIMAL(10,2) NOT NULL,
    status       VARCHAR(20) NOT NULL DEFAULT 'Pending',
    order_time   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_orders_user
        FOREIGN KEY (user_id) REFERENCES users(user_id)
        ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS order_items (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id      INT NOT NULL,
    item_id       INT NOT NULL,
    item_name     VARCHAR(100) NOT NULL,   -- denormalized snapshot for receipts
    quantity      INT NOT NULL,
    add_ons       VARCHAR(255),
    subtotal      DECIMAL(8,2) NOT NULL,
    CONSTRAINT fk_order_items_order
        FOREIGN KEY (order_id) REFERENCES orders(order_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_order_items_menu_item
        FOREIGN KEY (item_id) REFERENCES menu_items(item_id)
        ON DELETE RESTRICT
) ENGINE=InnoDB;

-- Seed categories + menu items so the menu page has something to show.
INSERT INTO categories (category_name, description) VALUES
    ('Appetizers', 'Small plates to start your meal'),
    ('Main Course', 'Hearty main dishes'),
    ('Desserts', 'Sweet treats to finish'),
    ('Drinks', 'Beverages, hot and cold')
ON DUPLICATE KEY UPDATE category_name = category_name;

INSERT INTO menu_items (category_id, name, description, nutritional_info, price, image_url, rating, is_available)
VALUES
    (1, 'Spring Rolls', 'Crispy rolls with cabbage, carrot, glass noodles', '220 kcal, 6g fat', 5.90, 'images/spring-rolls.jpg', 4.5, TRUE),
    (1, 'Garlic Bread', 'Toasted baguette with garlic butter and herbs', '310 kcal, 14g fat', 4.50, 'images/garlic-bread.jpg', 4.2, TRUE),
    (2, 'Grilled Chicken Rice', 'Grilled chicken thigh, jasmine rice, side salad', '650 kcal, 22g fat', 12.90, 'images/grilled-chicken-rice.jpg', 4.7, TRUE),
    (2, 'Beef Burger', 'Beef patty, cheddar, lettuce, tomato, brioche bun', '780 kcal, 38g fat', 11.50, 'images/beef-burger.jpg', 4.6, TRUE),
    (3, 'Chocolate Lava Cake', 'Warm chocolate cake with molten center', '420 kcal, 20g fat', 6.90, 'images/lava-cake.jpg', 4.8, TRUE),
    (4, 'Iced Lemon Tea', 'Freshly brewed tea with lemon', '90 kcal, 0g fat', 3.20, 'images/iced-lemon-tea.jpg', 4.3, TRUE)
ON DUPLICATE KEY UPDATE name = name;

-- No seed admin user: passwords are hashed in the Java app (see PasswordUtil),
-- so create the first admin by registering normally through /register, then:
--   UPDATE users SET role = 'admin' WHERE username = 'yourusername';
