package com.feastorder.model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import jakarta.persistence.Transient;

import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;

// Represents a row in the "menu_items" table
@Entity
@Table(name = "menu_items")
public class MenuItem {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "item_id")
    private int itemId;

    @Column(name = "category_id", nullable = false)
    private int categoryId;

    @Transient
    private String categoryName;

    @Column(name = "name", nullable = false)
    private String name;

    @Column(name = "description")
    private String description; // ingredients / description

    // Structured ingredient list for the detail-view "Ingredients" grid,
    // stored as "Name:Qty, Name:Qty, ..." (e.g. "Cabbage:0.15 kg, Carrot:0.1 kg").
    // Optional - if blank, the detail page simply skips that section.
    @Column(name = "ingredients")
    private String ingredients;

    // Selectable add-on choices for the detail-view "Add-ons" checkboxes,
    // stored as a comma-separated list (e.g. "Extra Cheese, Add Bacon").
    // Optional - if blank, the detail page shows no add-on choices.
    @Column(name = "addon_options")
    private String addonOptions;

    @Column(name = "nutritional_info")
    private String nutritionalInfo;

    @Column(name = "price", nullable = false, precision = 8, scale = 2)
    @JdbcTypeCode(SqlTypes.NUMERIC)
    private double price;

    @Column(name = "image_url")
    private String imageUrl;

    @Column(name = "rating", precision = 2, scale = 1)
    @JdbcTypeCode(SqlTypes.NUMERIC)
    private double rating;

    @Column(name = "is_available")
    private boolean available;

    // Built field-by-field via setters (from a DB row or HTML form fields).
    public MenuItem() {
    }

    // Getters and setters
    public int getItemId() {
        return itemId;
    }

    public void setItemId(int itemId) {
        this.itemId = itemId;
    }

    public int getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getIngredients() {
        return ingredients;
    }

    public void setIngredients(String ingredients) {
        this.ingredients = ingredients;
    }

    public String getAddonOptions() {
        return addonOptions;
    }

    public void setAddonOptions(String addonOptions) {
        this.addonOptions = addonOptions;
    }

    public String getNutritionalInfo() {
        return nutritionalInfo;
    }

    public void setNutritionalInfo(String nutritionalInfo) {
        this.nutritionalInfo = nutritionalInfo;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public double getRating() {
        return rating;
    }

    public void setRating(double rating) {
        this.rating = rating;
    }

    public boolean isAvailable() {
        return available;
    }

    public void setAvailable(boolean available) {
        this.available = available;
    }
}