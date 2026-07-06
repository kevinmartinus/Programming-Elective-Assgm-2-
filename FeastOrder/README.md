# FeastOrder — Project Skeleton

A Food Ordering and Restaurant Management Website (SWE306 coursework).

## What this skeleton gives you
Every file needed for the project structure, with comments explaining
exactly what logic goes where — but **no business logic filled in**.
Your team writes the actual code; this just removes the "where do I even
start / how do I structure this" problem.

## Suggested task split (3 members)

**Member A — Front-end / Pages**
- `webapp/index.html`, `about.html`, `contact.html`, `faq.html`
- `webapp/register.jsp`, `login.jsp`, `confirmation.jsp`
- `webapp/WEB-INF/jsp/user/menu.jsp`, `cart.jsp`
- `webapp/css/style.css`, `webapp/js/main.js`

**Member B — Auth + Admin + Database**
- `model/User.java`
- `dao/UserDAO.java`, `util/DBConnection.java`
- `servlet/RegisterServlet.java`, `LoginServlet.java`, `LogoutServlet.java`
- `servlet/AdminMenuServlet.java`, `AdminOrderServlet.java`
- `webapp/WEB-INF/jsp/admin/*.jsp`
- MySQL schema design (see below)

**Member C — Menu + Cart + Order logic**
- `model/MenuItem.java`, `Category.java`, `Order.java`, `OrderItem.java`
- `dao/MenuDAO.java`, `OrderDAO.java`
- `servlet/MenuServlet.java`, `CartServlet.java`, `OrderServlet.java`

## Database schema (design this together, Member B builds it)
Suggested tables — flesh these out into a proper ERD for your report:
- `users` (user_id, username, email, password_hash, phone, role, created_at)
- `categories` (category_id, name, description)
- `menu_items` (item_id, name, description, price, category_id FK, image_url, rating)
- `orders` (order_id, user_id FK, total_price, status, order_time)
- `order_items` (order_item_id, order_id FK, item_id FK, item_name, quantity, add_ons, subtotal)

## Java EE technologies used (for the "at least 3" requirement)
This skeleton already sets you up to use:
1. **JSP** — all `.jsp` pages
2. **Servlets** — all classes in `servlet/`
3. **JavaBeans** — all classes in `model/`
4. (Optional 4th) **RequestDispatcher** — used for forwarding requests
   between servlets and JSPs

## Getting started
1. Import this folder as a Dynamic Web Project / Maven project in Eclipse
   (or your IDE of choice).
2. Add the MySQL Connector/J `.jar` to `webapp/WEB-INF/lib/`.
3. Create your MySQL database and run your schema SQL.
4. Fill in `util/DBConnection.java` first — everything else depends on it.
5. Work outward: DAO layer → Servlets → JSPs, testing each piece as you go.

## Reminder
Per your assignment brief, all code must be your own team's work —
no AI-generated content. Use this skeleton as a map, not a shortcut.
