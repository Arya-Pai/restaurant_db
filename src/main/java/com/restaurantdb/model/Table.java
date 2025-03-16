package com.restaurantdb.model;

public class Table {
	private int tableId;
    private int tableNumber;
    private int capacity;
    private String status;
    private Integer customerId;

    public Table(int tableId, int tableNumber, int capacity, String status, Integer customerId) {
        this.tableId = tableId;
        this.tableNumber = tableNumber;
        this.capacity = capacity;
        this.status = status;
        this.customerId = customerId;
    }

    public Table() {
		
	}

	public int getTableId() { return tableId; }
    public int getTableNumber() { return tableNumber; }
    public int getCapacity() { return capacity; }
    public String getStatus() { return status; }
    public Integer getCustomerId() { return customerId; }

    public void setStatus(String status) { this.status = status; }
    public void setCustomerId(Integer customerId) { this.customerId = customerId; }

	public void setTableNumber(int table_no) {
		this.tableNumber=table_no;		
	}

	public void setCapacity(int capacity) {
		this.capacity=capacity;
		
	}

	public void setTableId(int table_id) {
		this.tableId=table_id;
		
	}
}

