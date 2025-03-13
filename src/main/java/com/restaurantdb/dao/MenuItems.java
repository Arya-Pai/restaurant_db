package com.restaurantdb.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.*;
import com.restaurantdb.model.Menu;
import com.restaurantdb.util.DBUtil;

public class MenuItems {

    public boolean checkCategoryExists(String categoryName) throws ClassNotFoundException {
        String query = "SELECT category_id FROM categories WHERE category_name = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, categoryName);
            ResultSet rs = stmt.executeQuery();
            return rs.next(); // If category exists, return true
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public int createCategory(String categoryName,String type) throws ClassNotFoundException {
        String insertCategorySql = "INSERT INTO categories (category_id ,category_name,type) VALUES (?,?,?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement st = conn.prepareStatement(insertCategorySql, PreparedStatement.RETURN_GENERATED_KEYS)) {
        	int category_id=generateCategoryID();
        	st.setInt(1, category_id);
        	st.setString(2, categoryName);
        	st.setString(3, type);
            int rowsInserted =st.executeUpdate();
            if (rowsInserted > 0) {
                ResultSet generatedKeys = st.getGeneratedKeys();
                if (generatedKeys.next()) {
                    return generatedKeys.getInt(1); // Return new category ID
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1; // Error case
    }

    private int getCategoryID(String categoryName) throws ClassNotFoundException, SQLException {
        String sql = "SELECT category_id FROM categories WHERE category_name = ?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement st = con.prepareStatement(sql)) {
            st.setString(1, categoryName);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return rs.getInt("category_id");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }

    public boolean addItem(Menu menu) throws ClassNotFoundException, SQLException {
        int categoryId = getCategoryID(menu.getCategoryName());
        if (categoryId == -1) {
            System.out.println("Category does not exist, item not added");
            return false;
        }
        int item_id=generateItemID();
        String sql = "INSERT INTO menu_items (item_id,item_name, category_id, price) VALUES (?,?, ?, ?)";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement st = con.prepareStatement(sql)) {
        	st.setInt(1, item_id);
            st.setString(2, menu.getItem_name());
            st.setInt(3, categoryId);
            st.setDouble(4, Double.parseDouble(menu.getPrice()));
            int rows = st.executeUpdate();
            return rows > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    private int generateCategoryID() throws ClassNotFoundException {
        int newCategoryID = 01; 

        String query = "SELECT MAX(category_id) FROM categories";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query);
             ResultSet rs = pstmt.executeQuery()) {

            if (rs.next()) {
                int lastCategoryID = rs.getInt(1); 
                if (lastCategoryID >= 01) {
                    newCategoryID = lastCategoryID + 1;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return newCategoryID;
    }
    private int generateItemID() throws ClassNotFoundException {
        int newItemID = 001; 

        String query = "SELECT MAX(item_id) FROM menu_items"; 
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query);
             ResultSet rs = pstmt.executeQuery()) {

            if (rs.next()) {
                int lastItemID = rs.getInt(1);
                if (lastItemID >= 001) {
                    newItemID = lastItemID + 1; 
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return newItemID;
    }
    public static List<Menu> getMenuItemsByCategory(int categoryId) throws SQLException, ClassNotFoundException {
    	List<Menu> menuItems = new ArrayList<>();
        String sql = "SELECT item_id, item_name, price, status FROM MENU_ITEMS WHERE category_id = ? AND status = 'Available'";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, categoryId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Menu item = new Menu(
                    rs.getInt("item_id"),
                    rs.getString("item_name"),
                    categoryId,
                    rs.getDouble("price"),
                    rs.getString("status")
                );
                menuItems.add(item);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return menuItems;
    }
}

