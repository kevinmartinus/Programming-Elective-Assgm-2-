package com.feastorder.dao;

import com.feastorder.model.Category;
import com.feastorder.model.MenuItem;
import com.feastorder.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

/** All SQL related to the `menu_items` and `categories` tables. */
public class MenuDAO {

    private static final String SELECT_MENU_ITEM =
            "SELECT mi.*, c.category_name FROM menu_items mi " +
            "JOIN categories c ON mi.category_id = c.category_id";

    public List<MenuItem> getAllMenuItems() throws SQLException {
        String sql = SELECT_MENU_ITEM + " ORDER BY c.category_name, mi.name";
        List<MenuItem> items = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                items.add(mapRow(rs));
            }
        }
        return items;
    }

    public List<MenuItem> getMenuItemsByCategory(int categoryId) throws SQLException {
        String sql = SELECT_MENU_ITEM + " WHERE mi.category_id = ? ORDER BY mi.name";
        List<MenuItem> items = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, categoryId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    items.add(mapRow(rs));
                }
            }
        }
        return items;
    }

    public MenuItem getMenuItemById(int itemId) throws SQLException {
        String sql = SELECT_MENU_ITEM + " WHERE mi.item_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, itemId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? mapRow(rs) : null;
            }
        }
    }

    public List<Category> getAllCategories() throws SQLException {
        String sql = "SELECT * FROM categories ORDER BY category_name";
        List<Category> categories = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Category category = new Category();
                category.setCategoryId(rs.getInt("category_id"));
                category.setCategoryName(rs.getString("category_name"));
                category.setDescription(rs.getString("description"));
                categories.add(category);
            }
        }
        return categories;
    }

    public boolean addMenuItem(MenuItem item) throws SQLException {
        String sql = "INSERT INTO menu_items " +
                "(category_id, name, description, nutritional_info, price, image_url, rating, is_available) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            bindItem(ps, item);
            int rows = ps.executeUpdate();
            if (rows == 0) {
                return false;
            }
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) {
                    item.setItemId(keys.getInt(1));
                }
            }
            return true;
        }
    }

    public boolean updateMenuItem(MenuItem item) throws SQLException {
        String sql = "UPDATE menu_items SET category_id = ?, name = ?, description = ?, " +
                "nutritional_info = ?, price = ?, image_url = ?, rating = ?, is_available = ? " +
                "WHERE item_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            bindItem(ps, item);
            ps.setInt(9, item.getItemId());
            return ps.executeUpdate() > 0;
        }
    }

    public boolean deleteMenuItem(int itemId) throws SQLException {
        String sql = "DELETE FROM menu_items WHERE item_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, itemId);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean addCategory(Category category) throws SQLException {
        String sql = "INSERT INTO categories (category_name, description) VALUES (?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, category.getCategoryName());
            ps.setString(2, category.getDescription());
            int rows = ps.executeUpdate();
            if (rows == 0) {
                return false;
            }
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) {
                    category.setCategoryId(keys.getInt(1));
                }
            }
            return true;
        }
    }

    public boolean deleteCategory(int categoryId) throws SQLException {
        String sql = "DELETE FROM categories WHERE category_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, categoryId);
            return ps.executeUpdate() > 0;
        }
    }

    private void bindItem(PreparedStatement ps, MenuItem item) throws SQLException {
        ps.setInt(1, item.getCategoryId());
        ps.setString(2, item.getName());
        ps.setString(3, item.getDescription());
        ps.setString(4, item.getNutritionalInfo());
        ps.setDouble(5, item.getPrice());
        ps.setString(6, item.getImageUrl());
        ps.setDouble(7, item.getRating());
        ps.setBoolean(8, item.isAvailable());
    }

    private MenuItem mapRow(ResultSet rs) throws SQLException {
        MenuItem item = new MenuItem();
        item.setItemId(rs.getInt("item_id"));
        item.setCategoryId(rs.getInt("category_id"));
        item.setCategoryName(rs.getString("category_name"));
        item.setName(rs.getString("name"));
        item.setDescription(rs.getString("description"));
        item.setNutritionalInfo(rs.getString("nutritional_info"));
        item.setPrice(rs.getDouble("price"));
        item.setImageUrl(rs.getString("image_url"));
        item.setRating(rs.getDouble("rating"));
        item.setAvailable(rs.getBoolean("is_available"));
        return item;
    }
}
