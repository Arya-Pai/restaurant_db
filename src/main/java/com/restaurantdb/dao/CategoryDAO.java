package com.restaurantdb.dao;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;


import com.restaurantdb.util.DBUtil;
import com.restaurantdb.model.Category;




public class CategoryDAO {
	public static List<Category> getAllCategories() throws ClassNotFoundException {
		 List<Category> categories = new ArrayList<>();
	        String sql = "SELECT category_id, category_name, type FROM CATEGORIES";

	        try (Connection conn = DBUtil.getConnection();
	             Statement stmt = conn.createStatement();
	             ResultSet rs = stmt.executeQuery(sql)) {

	            while (rs.next()) {
	                Category category = new Category(
	                    rs.getInt("category_id"),
	                    rs.getString("category_name"),
	                    rs.getString("type")
	                );
	                categories.add(category);
	            }
	        } catch (SQLException e) {
	            e.printStackTrace();
	        }
	        return categories;
    }
}
