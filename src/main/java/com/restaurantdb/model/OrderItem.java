package com.restaurantdb.model;

public class OrderItem {
    private int itemId;
    private String itemName;
    private double price;
    private int quantity;
    private String status;
    private int orderId;

    // Constructor
    public OrderItem() {
    	
    }
    public OrderItem(int itemId, String itemName, double price, int quantity) {
        this.itemId = itemId;
        this.itemName = itemName;
        this.price = price;
        this.quantity = quantity;
    }
    public OrderItem(int orderId, int itemId, int quantity, double price, String status) {
        this.orderId = orderId;
        this.itemId = itemId;
        this.quantity = quantity;
        this.price = price;
        this.status = status;
    }

    // Constructor with itemName (Used for fetching order details)
    public OrderItem(int orderId, int itemId, int quantity, double price, String status, String itemName) {
        this.orderId = orderId;
        this.itemId = itemId;
        this.quantity = quantity;
        this.price = price;
        this.status = status;
        this.itemName = itemName;
    }

    public OrderItem(Integer orderId, int itemId, int quantity) {
		this.orderId=orderId;
		this.itemId=itemId;
		this.quantity=quantity;
	}
	public OrderItem(Integer orderId, int itemId, String itemName, double price, int quantity) {
		this.orderId=orderId;
		this.itemId=itemId;
		this.quantity=quantity;
		this.itemName = itemName;
	    this.price = price;
	}
	// Getters and setters
    public int getItemId() {
        return itemId;
    }

    public void setItemId(int itemId) {
        this.itemId = itemId;
    }

    public String getItemName() {
        return itemName;
    }

    public void setItemName(String itemName) {
        this.itemName = itemName;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }
	public String getStatus() {
		// TODO Auto-generated method stub
		return status;
	}
	public int getOrderId() {
		// TODO Auto-generated method stub
		return orderId;
	}
	public void setOrderId(int orderid) {
		this.orderId=orderid;
		
	}
	public void setStatus(String status) {
		this.status=status;
		
	}
	
	public OrderItem(int itemId, String itemName, int quantity, double price) {
        this.itemId = itemId;
        this.itemName = itemName;
        this.quantity = quantity;
        this.price = price;
    }
}

