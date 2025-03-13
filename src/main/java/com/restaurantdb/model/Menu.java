package com.restaurantdb.model;

public class Menu {
	private int item_id;
	private String item_name;
	private String price;
	private String status;
	private String category_name;
	private String type;
	private int category_id;
	
	
	public Menu(String item_name, String category_name, String price,String type) {
		this.item_name=item_name;
		this.category_name=category_name;
		this.price=price;
		this.type=type;
	}
	public Menu(int item_id, String item_name, int categoryId, double price, String status) {
		this.item_id=item_id;
		this.item_name=item_name;
		this.category_id=categoryId;
		this.price=String.valueOf(price);
		this.status=status;
		
	}

	public Menu(String name, double price, String type) {
		this.item_name=name;
		this.price=String.valueOf(price);
		this.type=type;
		
	}
	public int getItem_Id() {
		return item_id;
	}
	public String getItem_name() {
		return item_name;
	}
	public String getPrice() {
		return price;
	}
	public String getStatus() {
		return status;
	}
	public void setItem_name(String item_name) {
		this.item_name=item_name;
	}
	public void setPrice(String price) {
		 this.price=price;
	}
	public void setStatus(String status) {
		this.status=status;
	}
	public void setItem_ID(int item_id) {
		
		this.item_id=item_id;
	}
	public void setType(String type) {
		this.type=type;
		
	}
	public void setCategory_ID(int category_id) {
		this.category_id=category_id;
		
	}
	public void setCategory_Name(String category_name) {
		this.category_name=category_name;
		
	}


	public int getCategoryId() {
		
		return category_id;
	}
	public String getCategoryName() {
		
		return category_name;
	}
	public String getType() {
		return type;
	}
}
