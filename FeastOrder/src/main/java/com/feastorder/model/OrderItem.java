// Represents one food item within an order (e.g. "2x Spring Rolls, extra sauce")
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

// One line item within an Order (a row in the "order_items" table). Built up client-side in the session-based cart, then persisted to the DB when the order is submitted
@Entity
@Table(name = "order_items")
public class OrderItem {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "order_item_id")
    private int orderItemId;

    @Column(name = "order_id", nullable = false)
    private int orderId;

    @Column(name = "item_id", nullable = false)
    private int menuItemId;

    @Column(name = "item_name", nullable = false)
    private String itemName; // denormalized copy, useful for receipts

    @Column(name = "quantity", nullable = false)
    private int quantity;

    @Column(name = "add_ons")
    private String addOns; // e.g. "Extra cheese, Large size"

    @Transient
    private double unitPrice;

    @Column(name = "subtotal", nullable = false, precision = 8, scale = 2)
    @JdbcTypeCode(SqlTypes.NUMERIC)
    private double subtotal; // unitPrice * quantity

    public OrderItem() {
    }

    // Used when adding a MenuItem to the cart.
    public OrderItem(int menuItemId, String itemName, int quantity, String addOns, double unitPrice) {
        this.menuItemId = menuItemId;
        this.itemName = itemName;
        this.quantity = quantity;
        this.addOns = addOns;
        this.unitPrice = unitPrice;
        recalculateSubtotal();
    }

    // Recomputes subtotal from quantity and unitPrice.
    public void recalculateSubtotal() {
        this.subtotal = unitPrice * quantity;
    }

    // Getters and setters
    public int getOrderItemId() {
        return orderItemId;
    }

    public void setOrderItemId(int orderItemId) {
        this.orderItemId = orderItemId;
    }

    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public int getMenuItemId() {
        return menuItemId;
    }

    public void setMenuItemId(int menuItemId) {
        this.menuItemId = menuItemId;
    }

    public String getItemName() {
        return itemName;
    }

    public void setItemName(String itemName) {
        this.itemName = itemName;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
        recalculateSubtotal();
    }

    public String getAddOns() {
        return addOns;
    }

    public void setAddOns(String addOns) {
        this.addOns = addOns;
    }

    public double getUnitPrice() {
        return unitPrice;
    }

    public void setUnitPrice(double unitPrice) {
        this.unitPrice = unitPrice;
        recalculateSubtotal();
    }

    public double getSubtotal() {
        return subtotal;
    }

    public void setSubtotal(double subtotal) {
        this.subtotal = subtotal;
    }
}