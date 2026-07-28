<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>FeastOrder - Login</title>
    <link   rel="stylesheet" href="css/style.css">
    <link   rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
</head>
<body>
    <header>
        <nav class="navbar">
            <a href="index.html" class="logo">FeastOrder</a>
            <ul class="nav-links">
                <li><a href="index.html">Home</a></li>
                <li><a href="menu">Menu</a></li>
                <li><a href="about.html">About</a></li>
                <li><a href="contact.html">Contact</a></li>
            </ul>
        </nav>
    </header>

    <main class="auth-page">
        <div class="auth-card">
            <h1>Login</h1>

            <!-- Server-side error from LoginServlet (Invalid Credentials) -->
            <% if (request.getAttribute("error") != null) { %>
                <p class="error-message"><%= request.getAttribute("error") %></p>
            <% } %>

            <!-- Success message after registration redirect, e.g., login.jsp?registered=true -->
            <% if ("true".equals(request.getParameter("registered"))) { %>
                <p class="success-message">Account created successfully. Please log in.</p>
            <% } %>
            
            <!-- Username -->
            <form action="login" method="post" onsubmit="return validateLoginForm()" id="loginForm">
                <div class="form-group">
                    <label for="username">
                        <i class="bi bi-person"></i>Username
                    </label>
                    <input type="text" id="username" name="username" required
                        value="<%= request.getParameter("username") != null ? request.getParameter("username") : "" %>">
                    <span class="field-error" id="usernameError"></span>
                </div>

                <div class="form-group">
                    <label for="password">
                        <i class="bi bi-lock"></i>Password
                    </label>
                    <div style="display:flex; align-items:center; gap:6px;">
                        <input type="password" id="password" name="password" required>
                        <i class="bi bi-eye-slash" id="togglePassword" style="cursor:pointer;"></i>
                    </div>
                    <span class="field-error" id="passwordError"></span>
                </div>

                <button type="submit" class="btn-primary">Login</button>
            </form>

            <p class="auth-switch">Don't have an account? <a href="register.jsp">Register Here</a></p>
        </div>
    </main>

    <script src="js/main.js"></script>
</body>
</html>
