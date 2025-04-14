package com.restaurantdb.model;

import java.sql.Date;
import java.sql.Timestamp;



public class Sale {
    private int orderId;
    private int tableNumber;
    private String customerName;
    private String employeeName;
    private int paymentId;
    private int billId;
    private String paymentMode;
	private double amount;
	 private Timestamp orderTime;
	 private Date orderDate;

    // Getters and Setters

    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public int getTableNumber() {
        return tableNumber;
    }

    public void setTableNumber(int tableNumber) {
        this.tableNumber = tableNumber;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public String getEmployeeName() {
        return employeeName;
    }

    public void setEmployeeName(String employeeName) {
        this.employeeName = employeeName;
    }

    public int getPaymentId() {
        return paymentId;
    }

    public void setPaymentId(int paymentId) {
        this.paymentId = paymentId;
    }

    public int getBillId() {
        return billId;
    }

    public void setBillId(int billId) {
        this.billId = billId;
    }

    public String getPaymentMode() {
        return paymentMode;
    }

    public void setPaymentMode(String paymentMode) {
        this.paymentMode = paymentMode;
    }

	public void setAmount(double amount) {
		// TODO Auto-generated method stub
		this.amount=amount;
	}
	public double getAmount() {
		return amount;
	}
	
	 public Timestamp getPaymentTime() {
	        return orderTime;
	    }

	    public void setPaymentTime(Timestamp timestamp) {
	        this.orderTime = timestamp;
	    }

	    public Date getOrderDate() {
	        return orderDate;
	    }

	    public void setOrderDate(Date orderDate) {
	        this.orderDate = orderDate;
	    }
}
