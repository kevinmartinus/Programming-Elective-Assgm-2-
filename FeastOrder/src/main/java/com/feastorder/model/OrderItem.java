package com.feastorder.model;

/**
 * One line item within an Order (a row in the `order_items` join table).
 * Built up client-side in the session-based cart, then persisted to the DB
 * when the order is submitted.
 */
public class OrderItem {

    private int orderItemId;
    private int orderId;
    private int menuItemId;
    private String itemName;   // denormalized copy, useful for receipts
    private int quantity;
    private String addOns;     // e.g. "Extra cheese, Large size"
    private double unitPrice;
    private double subtotal;   // unitPrice * quantity

    public OrderItem() {
    }

    public OrderItem(int menuItemId, String itemName, int quantity, String addOns, double unitPrice) {
        this.menuItemId = menuItemId;
        this.itemName = itemName;
        this.quantity = quantity;
        this.addOns = addOns;
        this.unitPrice = unitPrice;
        recalculateSubtotal();
    }

    public void recalculateSubtotal() {
        this.subtotal = unitPrice * quantity;
    }

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
