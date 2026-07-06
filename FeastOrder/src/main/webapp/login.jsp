<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>FeastOrder - Login</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>

    <!--
        LOGIN PAGE — TODO for your team:

        1. Form: username/email + password
           <form action="login" method="post">
               ... inputs ...
               <button type="submit">Login</button>
           </form>

        2. Show error message if login failed:
           <% if (request.getAttribute("error") != null) { %>
               <p class="error"><%= request.getAttribute("error") %></p>
           <% } %>

        3. Link to register.jsp ("Don't have an account? Register")

        4. After LoginServlet succeeds, user is redirected here based on role:
           admin -> admin dashboard, customer -> homepage/menu
    -->

    <h1>Login</h1>
    <!-- form goes here -->

</body>
</html>
