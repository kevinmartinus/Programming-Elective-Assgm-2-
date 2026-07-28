package com.feastorder.dao;

import com.feastorder.model.Category;
import com.feastorder.model.MenuItem;

import java.sql.SQLException;
import java.util.List;

// Contract for anything that can read/write menu items and categories
public interface MenuRepository {

    public List<MenuItem> getAllMenuItems() throws SQLException;

    public List<MenuItem> getMenuItemsByCategory(int categoryId) throws SQLException;

    public MenuItem getMenuItemById(int itemId) throws SQLException;

    public List<Category> getAllCategories() throws SQLException;

    public boolean addMenuItem(MenuItem item) throws SQLException;

    public boolean updateMenuItem(MenuItem item) throws SQLException;

    public boolean deleteMenuItem(int itemId) throws SQLException;

    public boolean addCategory(Category category) throws SQLException;

    public boolean deleteCategory(int categoryId) throws SQLException;
}
