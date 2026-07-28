-- FeastOrder MySQL schema --
-- Defines the four tables backing the whole system: user accounts, menu
-- items/categories (Menu Page + Admin Dashboard), and orders/order_items
-- (Order Page/Cart + Admin order tracking).


CREATE DATABASE IF NOT EXISTS feastorder_db
    CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE feastorder_db;

-- Stores every registered account (customers and admins), backs to the Registration/Login pages and the User Authentication System requirement --
CREATE TABLE IF NOT EXISTS users (
    user_id       INT AUTO_INCREMENT PRIMARY KEY,
    username      VARCHAR(50)  NOT NULL UNIQUE,
    full_name     VARCHAR(100) NOT NULL,
    email         VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    phone_number  VARCHAR(20)  NOT NULL,
    role          VARCHAR(20)  NOT NULL DEFAULT 'customer',
    created_at    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- Groups menu items for the Menu Page's category filter (e.g. Appetizers, Main Courses) and the admin's "Manage Categories" panel --
CREATE TABLE IF NOT EXISTS categories (
    category_id   INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL UNIQUE,
    description   VARCHAR(255)
) ENGINE=InnoDB;

-- Every dish/drink shown on the Menu Page with ingredients, nutritional info, pricing, ratings, and images per item. Also what the admin adds/edits/deletes from
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

-- status: one of PENDING, PREPARING, OUT_FOR_DELIVERY, DELIVERED, CANCELLED
CREATE TABLE IF NOT EXISTS orders (
    order_id         INT AUTO_INCREMENT PRIMARY KEY,
    user_id          INT NOT NULL,
    total_price      DECIMAL(10,2) NOT NULL,
    status           VARCHAR(20) NOT NULL DEFAULT 'PENDING',
    order_type       VARCHAR(20) NOT NULL DEFAULT 'Pickup',
    delivery_address VARCHAR(255),
    notes            VARCHAR(500),
    order_time       TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_orders_user
        FOREIGN KEY (user_id) REFERENCES users(user_id)
        ON DELETE CASCADE
) ENGINE=InnoDB;

-- One dish within one order (the cart contents, frozen in place once an order is submitted).
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
