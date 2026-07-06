<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>FeastOrder - Register</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>

    <!--
        REGISTRATION PAGE — TODO for your team:

        1. Form fields: username, email, password, confirm password, phone number
           <form action="register" method="post">
               ... inputs ...
               <button type="submit">Register</button>
           </form>

        2. Display server-side validation errors passed from RegisterServlet:
           <% if (request.getAttribute("error") != null) { %>
               <p class="error"><%= request.getAttribute("error") %></p>
           <% } %>
           (Consider using JSTL <c:if> instead of scriptlets for cleaner code
            — ask your lecturer if JSTL is expected/allowed.)

        3. Client-side JS validation (js/main.js or a dedicated register.js):
           - required fields
           - email format check
           - password === confirm password
           - phone number format
           (Remember: server-side validation in the Servlet is still required —
            JS validation alone is not secure.)

        4. Link to login.jsp for existing users ("Already have an account? Login")
    -->

    <h1>Register</h1>
    <!-- form goes here -->

</body>
</html>
