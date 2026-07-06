<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.feastorder.model.MenuItem" %>
<%@ page import="com.feastorder.model.Category" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>FeastOrder - Menu</title>
    <link rel="stylesheet" href="../../../css/style.css">
</head>
<body>

    <!--
        MENU PAGE — TODO for your team:
        (This file lives under WEB-INF so it can ONLY be reached via the
         MenuServlet forward — not directly by URL. That's intentional:
         it forces data to always be loaded first.)

        1. Category filter tabs/buttons
           - Loop through "categories" attribute (set by MenuServlet)
           - Each links to /menu?categoryId=X

        2. Menu item grid
           - Loop through "menuItems" attribute:
             <%
                 List<MenuItem> items = (List<MenuItem>) request.getAttribute("menuItems");
                 for (MenuItem item : items) {
             %>
                 <!-- render: image, name, description/ingredients, price,
                      rating, quantity selector, add-ons checkboxes,
                      "Add to Cart" button (posts to /cart with action=add) -->
             <%
                 }
             %>

        3. "View Details" link/modal per item -> could be its own
           itemDetail.jsp or an expandable section on this same page

        4. Cart icon/summary in navbar showing item count (from session)

        Maps to rubric "1a Page Development" (Menu Page — categorized items,
        ingredients, pricing, images, ratings, quantity/add-ons selection).
    -->

    <h1>Menu</h1>
    <!-- category filters + item grid go here -->

</body>
</html>
