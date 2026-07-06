package com.feastorder.dao;

import com.feastorder.model.User;

/**
 * DAO: UserDAO
 * ------------------------------------------------------------
 * All SQL related to the `users` table lives here. Servlets should
 * NEVER write raw SQL directly — they call these methods instead.
 *
 * TODO for your team, implement:
 *
 * 1. boolean registerUser(User user)
 *    - INSERT INTO users (...) VALUES (...)
 *    - Use PreparedStatement (never string-concatenate SQL — SQL injection risk)
 *    - Remember to HASH the password before storing (e.g. with BCrypt or
 *      at minimum SHA-256 — ask your lecturer which is expected)
 *
 * 2. User login(String username, String password)
 *    - SELECT * FROM users WHERE username = ?
 *    - Compare hashed password
 *    - Return the User object if match, else null
 *
 * 3. boolean isUsernameTaken(String username)
 *    - Used during signup validation
 *
 * 4. boolean isEmailTaken(String email)
 *    - Used during signup validation
 *
 * Maps to rubric "2a User Authentication System".
 */
public class UserDAO {

    // TODO: implement methods described above, using DBConnection.getConnection()

}
