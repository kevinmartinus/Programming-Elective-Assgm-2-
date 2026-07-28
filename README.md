
# 🍽️ FeastOrder

A full-stack food ordering and kitchen management app. The customers browse the menu, customize, and check out; admins run the kitchen from a separate dashboard. Built for a programming elective as a two-sided system, not just a static menu page.

## ✨ Technologies

- Java 17
- Jakarta EE 10 (Servlets & JSP)
- Hibernate ORM
- MySQL 8
- Maven
- Bootstrap 5

## 🚀 Features

- Browse 18 menu items across 4 categories (Appetizers, Main Courses, Desserts, Beverages)
- Each dish shows ingredients and add-on options, not just a description
- Add to cart, customize, and check out
- Accounts enable register, log in, log out
- Admin dashboard can manage menu items, orders, and users
- Seed data included, so the app is fully populated on first run

## 📌 The Process

This started as a class assignment, but I wanted it to feel like a real ordering system rather than a form that saves to a table. The trickiest part was keeping the customer-facing flow and the admin dashboard in sync against the same database, getting Hibernate's schema validation to actually match the seed data took a few passes. Once the accounts, menu, and cart were talking to MySQL properly, the rest was building out the two sides: one for people ordering food, one for the kitchen running it.

## 🔋 Running the Project

**Prerequisites**
- Eclipse IDE for Enterprise Java and Web Developers
- Apache Tomcat 10.1.x
- MySQL Server 8.0.x
- JDK 21 (Eclipse's bundled JRE works)

**Setup**
1. Clone the repo and import it into Eclipse as an **Existing Maven Project**
2. Create the database and restore the full backup (schema + seed data + demo accounts in one file):
   ```sql
   CREATE DATABASE feastorder_db;
   USE feastorder_db;
   source /path/to/FeastOrder/sql/feastorder_full_backup.sql;
   ```
3. In `src/main/resources/hibernate.cfg.xml`, confirm the DB URL/username/password match your local MySQL setup
4. Add Tomcat 10.1 as a server in Eclipse, add the FeastOrder project to it, and start the server
5. Open [http://localhost:8080/FeastOrder/](http://localhost:8080/FeastOrder/)

## 🔑 Demo Accounts

Included automatically when you restore the full backup:

| Role     | Username | Password       |
|----------|----------|----------------|
| Admin    | ADMIN    | HiMrSufyan123  |
| Customer | CUSTOMER | Kevin123       |

*(Local demo credentials only — for testing the app, not real accounts.)*

## 🎬 Preview
https://github.com/user-attachments/assets/9dd204c4-6a42-47b5-b21d-c24f1465e0e5
