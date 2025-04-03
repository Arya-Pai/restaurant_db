package com.restaurantdb.model;

import java.sql.Timestamp;
import java.util.List;

public class Bill {
    private int billId;
    private int tableId;
    private double totalAmount;
    private String billStatus;
    private Timestamp billTime;
    private List<Order> orders;

    // Getters and Setters
    public int getBillId() {
        return billId;
    }

    public void setBillId(int billId) {
        this.billId = billId;
    }

    public int getTableId() {
        return tableId;
    }

    public void setTableId(int tableId) {
        this.tableId = tableId;
    }

    public double getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }

    public String getBillStatus() {
        return billStatus;
    }

    public void setBillStatus(String billStatus) {
        this.billStatus = billStatus;
    }

    public Timestamp getBillTime() {
        return billTime;
    }

    public void setBillTime(Timestamp billTime) {
        this.billTime = billTime;
    }

    public List<Order> getOrders() {
        return orders;
    }

    public void setOrders(List<Order> orders) {
        this.orders = orders;
    }
}
