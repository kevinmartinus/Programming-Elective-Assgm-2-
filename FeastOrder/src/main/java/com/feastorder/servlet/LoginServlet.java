package com.feastorder.servlet;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * SERVLET: LoginServlet
 * ------------------------------------------------------------
 * Handles authentication + session creation.
 * URL mapping suggestion: /login
 *
 * TODO for your team:
 *
 * doGet():
 *   - forward to login.jsp
 *
 * doPost():
 *   1. Read username + password from request
 *   2. Call UserDAO.login(username, password)
 *   3. If a User is returned (valid credentials):
 *        - HttpSession session = request.getSession();
 *        - session.setAttribute("user", user);
 *        - session.setMaxInactiveInterval(...)   // optional timeout
 *        - if user.getRole().equals("admin") -> redirect to admin dashboard
 *        - else -> redirect to homepage or menu page
 *   4. If invalid: forward back to login.jsp with an error message
 *
 * Maps to rubric "2a User Authentication System" (login + session mgmt).
 */
@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // TODO: forward to login.jsp
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // TODO: implement login logic described above
    }
}
