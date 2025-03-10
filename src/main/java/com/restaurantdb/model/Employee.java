package com.restaurantdb.model;

public class Employee {
	private int id;
	private String username;
	private String password;
	private String phone;
	private boolean isActive;
	private String role_name;
	private int role_id;
	
	
	public Employee(String name, String phone, String password, String role_name) {
		this.username=name;
		this.password=password;
		this.phone=phone;
		this.role_name=role_name;
	}
	public Employee() {
		
	}

	public int getId() {
		return id;
	}
	public String getEmp_name() {
		return username;
	}
	public String getPassword() {
		return password;
	}
	public String getPhone() {
		return phone;
	}
	public void setEmp_name(String username) {
		this.username=username;
	}
	public void setPhone(String phone) {
		 this.phone=phone;
	}
	public void setPassword(String password) {
		this.password=password;
	}
	public void setEmpID(int id) {
		
		this.id=id;
	}
	public void setActive(boolean isActive) {
		this.isActive=isActive;
		
	}
	public void setRole_ID(int role_id) {
		this.role_id=role_id;
		
	}
	public void setRole(String role_name) {
		this.role_name=role_name;
		
	}

	public int getRoleId() {
		
		return role_id;
	}
	public String getRoleName() {
		
		return role_name;
	}
	public boolean isActive() {
		return isActive;
	}
}
