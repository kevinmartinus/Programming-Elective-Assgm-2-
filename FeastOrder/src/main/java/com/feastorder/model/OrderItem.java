package com.feastorder.model;

/**
 * MODEL: OrderItem
 * ------------------------------------------------------------
 * Represents ONE line item within an Order
 * (i.e. one row in an `order_items` join table: order_id, item_id, quantity, addons).
 *
 * TODO for your team:
 * 1. Add fields:
 *      - int orderItemId
 *      - int orderId
 *      - int menuItemId
 *      - String itemName        (denormalized copy, useful for display/receipts)
 *      - int quantity
 *      - String addOns          (e.g. "Extra cheese, Large size")
 *      - double subtotal         (price * quantity, plus add-on cost)
 *
 * 2. Generate getters/setters.
 *
 * This is what gets built up client-side in the Cart (session-based),
 * then persisted to DB when the order is submitted (rubric 2c).
 */
public class OrderItem {

    // TODO: declare fields here

    // TODO: generate getters and setters here

}
