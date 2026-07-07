---
description: Work on the FeastOrder Java EE food ordering & restaurant management assignment
---

You are working on the **FeastOrder** assignment: a Food Ordering and Restaurant Management
Website built with Java EE. The project lives under `FeastOrder/` (servlets in
`src/main/java/com/feastorder/{servlet,dao,model,util}`, JSPs under
`src/main/webapp/WEB-INF/jsp/`, static HTML/CSS/JS under `src/main/webapp/`).

Focus for this session (optional, may be blank): $ARGUMENTS

## Assignment brief

Build a system that lets users browse food menus, view item details (ingredients, price,
ratings), register/log in, and place orders. Must be implemented in Java EE.

### 1. Front-end
**a) Pages** [20 marks]
- Homepage — featured restaurants, popular dishes
- Menu page — categorized items (appetizers/mains/desserts), ingredients, nutritional info,
  pricing, quantity/add-on selection (extra cheese, drinks), ratings/reviews, images,
  descriptions, prices
- Registration page — username, email, password, phone number
- Login page
- Order page (cart/checkout)
- Admin dashboard — add/edit/delete menu items, view customer orders
- Other pages — About Us, Contact, FAQ

**b) Styling & responsiveness** [10 marks] — professional look, responsive across devices
(CSS or Bootstrap).

### 2. Back-end
MySQL database storing user accounts, menu items, categories, orders/transactions.

**a) User authentication** [10 marks] — signup with validation, login with session
management, access restriction on ordering for guests, logout.

**b) Admin system & DB connectivity** [10 marks] — add/edit/delete food items, manage
categories, view customer orders (user info, items, total price, timestamp).

**c) Dynamic order processing** [10 marks] — select items loaded from DB, add to cart,
submit order, persist order details, show confirmation, validate inputs with JavaScript.

**Constraint**: at least three Java EE technologies must be used (e.g. JavaBeans, JSP,
Servlets, RequestDispatcher, Hibernate, Spring). This project currently uses Servlets, JSP,
and JavaBeans (the `model` classes) — keep that trio intact, or deliberately swap one for
Hibernate/Spring if asked.

## How to work this session

1. **Check current state before writing anything.** Read the relevant existing files (don't
   assume the brief above is unimplemented — much of the skeleton already exists: DAOs,
   servlets, JSPs, and static HTML pages are present). Diff what's there against the rubric
   item you're focused on and report gaps before coding.
2. There is currently **no build file** (no `pom.xml`/`build.xml`) and no SQL schema file in
   the repo — flag this if the task requires running or packaging the app, and confirm with
   the user which servlet container / build tool (Maven + Tomcat is the natural default)
   before introducing one.
3. Keep changes scoped to the rubric item in focus; don't refactor unrelated pages/servlets.
4. When touching DB-backed logic (DAO/servlet pairs), keep SQL parameterized (no string-built
   queries) and validate/sanitize all form input server-side, even where JS validation also
   exists client-side.
5. After changes to a page or flow, describe how to manually verify it (there's no test
   suite), since this is a UI-heavy Java EE app that isn't easily unit-tested.
