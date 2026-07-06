package com.feastorder.servlet;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * SERVLET: LogoutServlet
 * ------------------------------------------------------------
 * URL mapping suggestion: /logout
 *
 * TODO for your team:
 *   1. HttpSession session = request.getSession(false);
 *   2. if (session != null) session.invalidate();
 *   3. redirect to homepage (index.html) or login.jsp
 *
 * Maps to rubric "2a User Authentication System" (logout mechanism).
 */
@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // TODO: invalidate session and redirect
    }
}
