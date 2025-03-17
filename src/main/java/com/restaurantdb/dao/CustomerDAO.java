package com.restaurantdb.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.restaurantdb.model.Customer;
import com.restaurantdb.util.DBUtil;



public class CustomerDAO {
	public boolean checkCustomer(String phone) throws ClassNotFoundException, SQLException {
		String sql="SELECT customer_id FROM customers where phone=?";
		try(Connection con=DBUtil.getConnection();
			PreparedStatement st=con.prepareStatement(sql)){
			st.setString(1, phone);
			ResultSet rs=st.executeQuery();
			return rs.next();
		}catch(Exception e) {
			e.printStackTrace();
		}
		return false;
	}
	
	public Customer getCustomer(String phone) throws ClassNotFoundException, SQLException {
		Customer cust=new Customer();
		String sql="SELECT customer_id,name,preferences FROM customers where phone=?";
		boolean present=checkCustomer(phone);
		if(present) {
			try(Connection con=DBUtil.getConnection();
					PreparedStatement st=con.prepareStatement(sql)){
					st.setString(1, phone);
					ResultSet rs=st.executeQuery();
					if(rs.next()) {
						cust.setCustomerId(rs.getInt("customer_id"));
						cust.setCustomerPhone(phone);
						cust.setCustomerName(rs.getString("name"));
						cust.setCustomerPreferences(rs.getString("preferences"));
					}
				}
		}
		return cust;
	}
	
	public boolean createCustomer(String name,String phone) throws ClassNotFoundException, SQLException {
		String sql="INSERT INTO customers(customer_id,name,phone) VALUES (?,?,?)";
		int id=generateCustomerId();
		try(Connection con=DBUtil.getConnection();
				PreparedStatement st=con.prepareStatement(sql)){
			st.setInt(1,id);
			st.setString(2, name);
			st.setString(3,phone);
			int affectedRows=st.executeUpdate();
			return affectedRows>0;
		}
	}

	private int generateCustomerId() throws ClassNotFoundException {
		
		int newCustomerID = 1; 

        String query = "SELECT MAX(customer_id) FROM customers";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query);
             ResultSet rs = pstmt.executeQuery()) {

            if (rs.next()) {
                int lastCustomerID = rs.getInt(1); 
                if (lastCustomerID >= 1) {
                    newCustomerID = lastCustomerID + 1;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return newCustomerID;
	}
	
}
