package com.feastorder.dao;

import com.feastorder.model.User;

import java.sql.SQLException;
import java.util.List;

// Contract for anything that can store/authenticate users data (password, username, email)
public interface UserRepository {

    public boolean registerUser(User user, String plainPassword) throws SQLException;

    public User login(String username, String plainPassword) throws SQLException;

    public boolean isUsernameTaken(String username) throws SQLException;

    public boolean isEmailTaken(String email) throws SQLException;

    public int countUsers() throws SQLException;

    public List<User> getAllUsers() throws SQLException;
}