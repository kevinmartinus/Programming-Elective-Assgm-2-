// Data layer for user accounts registration, login, and validation checks, using Hibernates
package com.feastorder.dao;

import com.feastorder.model.User;
import com.feastorder.util.HibernateUtil;
import com.feastorder.util.PasswordUtil;

import org.hibernate.Session;
import org.hibernate.Transaction;

import java.sql.SQLException;
import java.util.List;

public class UserDAO implements UserRepository {

    // Inserts a new user row, hashing the plain password before it's stored.
    public boolean registerUser(User user, String plainPassword) throws SQLException {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            user.setPasswordHash(PasswordUtil.hash(plainPassword));
            if (user.getRole() == null) {
                user.setRole("customer");
            }
            session.persist(user);
            tx.commit();
            return true;
        } catch (RuntimeException e) {
            if (tx != null) {
                tx.rollback();
            }
            throw e;
        }
    }

    // Verifies credentials and returns the matching user, or null if invalid.
    public User login(String username, String plainPassword) throws SQLException {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            List<User> results = session
                    .createQuery("from User where username = :username", User.class)
                    .setParameter("username", username)
                    .list();
            if (results.isEmpty()) {
                return null;
            }
            User user = results.get(0);
            if (!PasswordUtil.matches(plainPassword, user.getPasswordHash())) {
                return null;
            }
            return user;
        }
    }

    // Checks whether a username is already registered.
    public boolean isUsernameTaken(String username) throws SQLException {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Long count = session
                    .createQuery("select count(u) from User u where u.username = :username", Long.class)
                    .setParameter("username", username)
                    .uniqueResult();
            return count != null && count > 0;
        }
    }

    // Checks whether an email is already registered.
    public boolean isEmailTaken(String email) throws SQLException {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Long count = session
                    .createQuery("select count(u) from User u where u.email = :email", Long.class)
                    .setParameter("email", email)
                    .uniqueResult();
            return count != null && count > 0;
        }
    }

    // Returns the total number of registered users, for the admin dashboard.
    public int countUsers() throws SQLException {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Long count = session.createQuery("select count(u) from User u", Long.class).uniqueResult();
            return count == null ? 0 : count.intValue();
        }
    }

    // Returns every registered user, newest first, for the admin "Manage Users" page.
    public List<User> getAllUsers() throws SQLException {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session
                    .createQuery("from User order by createdAt desc", User.class)
                    .list();
        }
    }
}