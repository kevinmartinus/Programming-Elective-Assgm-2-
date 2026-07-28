// Represents one registered account (customer or admin), a row in the "users" table
package com.feastorder.model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

import java.sql.Timestamp;

@Entity
@Table(name = "users")
public class User {

	// Auto generated primary key to uniquely identifies this account
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "user_id")
    private int userId;

    // What the user logs in with, must be unique across all accounts.
    @Column(name = "username", nullable = false, unique = true)
    private String username;

    // The user real name, shown on receipts and the admin's order list
    @Column(name = "full_name", nullable = false)
    private String fullName;

    // Contact email that also used to enforce one account per email address
    @Column(name = "email", nullable = false, unique = true)
    private String email;

    @Column(name = "password_hash", nullable = false)
    private String passwordHash;

    // Contact number collected at registration.
    @Column(name = "phone_number", nullable = false)
    private String phoneNumber;

    // Distinguishes an ordinary customer from an admin, to decides whether a logged-in user can reach the Admin Dashboard
    @Column(name = "role", nullable = false)
    private String role;

    // When this account was created, and set automatically by the database
    @Column(name = "created_at", insertable = false, updatable = false)
    private Timestamp createdAt;

    // Used when registering a new user.
    public User() {
    }

    // Used when reading an existing user back out of the database.
    public User(int userId, String username, String fullName, String email, String passwordHash,
                String phoneNumber, String role, Timestamp createdAt) {
        this.userId = userId;
        this.username = username;
        this.fullName = fullName;
        this.email = email;
        this.passwordHash = passwordHash;
        this.phoneNumber = phoneNumber;
        this.role = role;
        this.createdAt = createdAt;
    }

    // Getters and setters
    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPasswordHash() {
        return passwordHash;
    }

    public void setPasswordHash(String passwordHash) {
        this.passwordHash = passwordHash;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    // Checks whether this user has the admin role.
    public boolean isAdmin() {
        return "admin".equals(role);
    }
}
