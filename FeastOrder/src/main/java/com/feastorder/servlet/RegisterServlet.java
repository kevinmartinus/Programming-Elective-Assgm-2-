package com.feastorder.servlet;

import com.feastorder.dao.UserDAO;
import com.feastorder.model.User;

import java.io.IOException;
import java.sql.SQLException;
import java.util.regex.Pattern;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/** Handles new user signup: server-side validation, uniqueness checks, hashed storage. */
@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private static final Pattern EMAIL_PATTERN = Pattern.compile("^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$");
    private static final Pattern PHONE_PATTERN = Pattern.compile("^[0-9+()\\-\\s]{7,20}$");

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = trim(request.getParameter("username"));
        String email = trim(request.getParameter("email"));
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String phoneNumber = trim(request.getParameter("phoneNumber"));

        String error = validate(username, email, password, confirmPassword, phoneNumber);

        if (error == null) {
            try {
                if (userDAO.isUsernameTaken(username)) {
                    error = "That username is already taken.";
                } else if (userDAO.isEmailTaken(email)) {
                    error = "That email is already registered.";
                }
            } catch (SQLException e) {
                throw new ServletException("Database error during registration", e);
            }
        }

        if (error != null) {
            request.setAttribute("error", error);
            request.setAttribute("username", username);
            request.setAttribute("email", email);
            request.setAttribute("phoneNumber", phoneNumber);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        User user = new User();
        user.setUsername(username);
        user.setEmail(email);
        user.setPhoneNumber(phoneNumber);
        user.setRole("customer");

        try {
            userDAO.registerUser(user, password);
        } catch (SQLException e) {
            throw new ServletException("Database error during registration", e);
        }

        response.sendRedirect(request.getContextPath() + "/login.jsp?registered=true");
    }

    private String validate(String username, String email, String password,
                             String confirmPassword, String phoneNumber) {
        if (isBlank(username) || isBlank(email) || isBlank(password)
                || isBlank(confirmPassword) || isBlank(phoneNumber)) {
            return "All fields are required.";
        }
        if (!EMAIL_PATTERN.matcher(email).matches()) {
            return "Please enter a valid email address.";
        }
        if (!PHONE_PATTERN.matcher(phoneNumber).matches()) {
            return "Please enter a valid phone number.";
        }
        if (password.length() < 8) {
            return "Password must be at least 8 characters long.";
        }
        if (!password.equals(confirmPassword)) {
            return "Passwords do not match.";
        }
        return null;
    }

    private boolean isBlank(String value) {
        return value == null || value.isBlank();
    }

    private String trim(String value) {
        return value == null ? null : value.trim();
    }
}
