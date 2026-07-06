package com.feastorder.servlet;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * SERVLET: RegisterServlet
 * ------------------------------------------------------------
 * Handles new user signup.
 * URL mapping suggestion: /register  (also declare this in web.xml, or
 * keep the @WebServlet annotation below if your server supports it)
 *
 * TODO for your team:
 *
 * doGet():
 *   - Simply forward to register.jsp so the form displays
 *     (RequestDispatcher rd = request.getRequestDispatcher("/register.jsp");
 *      rd.forward(request, response);)
 *
 * doPost():
 *   1. Read form fields: username, email, password, confirmPassword, phone
 *      String username = request.getParameter("username");  ... etc
 *   2. SERVER-SIDE VALIDATION (don't trust client-side JS alone):
 *      - all fields non-empty
 *      - email format valid
 *      - password == confirmPassword
 *      - password meets minimum length/complexity
 *   3. Check with UserDAO.isUsernameTaken() / isEmailTaken()
 *      - if taken, set an error attribute and forward back to register.jsp
 *   4. If valid: hash the password, build a User object, call
 *      UserDAO.registerUser(user)
 *   5. On success: redirect to login.jsp with a success message
 *      (use redirect, not forward, to avoid duplicate form resubmission)
 *   6. On failure: forward back to register.jsp with an error message
 *
 * Maps to rubric "2a User Authentication System" (signup with validation).
 */
@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // TODO: forward to register.jsp
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // TODO: implement registration logic described above
    }
}
