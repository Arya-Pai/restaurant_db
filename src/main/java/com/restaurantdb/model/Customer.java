package com.restaurantdb.model;

public class Customer {
	private int customer_id;
	private String name;
	private String phone;
	private String preferences;
	
	public void setCustomerId(int customerId) {
		this.customer_id=customerId;
	}
	public void setCustomerName(String name) {
		this.name=name;
	}
	public void setCustomerPhone(String phone) {
		this.phone=phone;
	}
	public void setCustomerPreferences(String preferences) {
		this.preferences=preferences;
	}

	public String getName() {
		return name;
	}
	public String getPhone() {
		return phone;
	}
	public String getPreferences() {
		return preferences;
	}
	public int getId() {
		return customer_id;
	}
	
}
