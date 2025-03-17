package com.restaurantdb.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.restaurantdb.util.DBUtil;
import com.restaurantdb.model.Table;

public class TableDAO {
	public static List<Table> getAvailableTables() throws SQLException, ClassNotFoundException {
        List<Table> tables = new ArrayList<>();

        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement("SELECT * FROM tables WHERE status = 'Available'");
             ResultSet rs = ps.executeQuery()){

            while (rs.next()) {
                Table table = new Table();
                table.setTableId(rs.getInt("table_id"));
                table.setTableNumber(rs.getInt("table_number"));
                table.setCapacity(rs.getInt("capacity"));
                table.setStatus(rs.getString("status"));
                tables.add(table);

        
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return tables;
	}


    public static boolean assignTableToEmployee(int tableId, int employeeId) throws SQLException, ClassNotFoundException {
        Connection con = DBUtil.getConnection();
        String checkQuery = "SELECT * FROM ORDERS WHERE bill_id IN (SELECT bill_id FROM BILLS WHERE table_id = ?) AND employee_id IS NOT NULL";
        PreparedStatement checkPs = con.prepareStatement(checkQuery);
        checkPs.setInt(1, tableId);
        ResultSet rs = checkPs.executeQuery();
        if (rs.next()) return false;

        String updateQuery = "UPDATE BILLS SET employee_id = ? WHERE table_id = ?";
        PreparedStatement updatePs = con.prepareStatement(updateQuery);
        updatePs.setInt(1, employeeId);
        updatePs.setInt(2, tableId);
        int updated = updatePs.executeUpdate();

        return updated > 0;
    }
    public static void addTables(int totalTables,int capacity) throws SQLException, ClassNotFoundException {
        Connection con = DBUtil.getConnection();
        String query = "INSERT INTO TABLES (table_id,table_number,capacity, status) VALUES (?,?,?, 'Available')";

        PreparedStatement ps = con.prepareStatement(query);
        int startTableNumber = getHighestTableNumber();
        for (int i = 1; i <= totalTables; i++) {
        	ps.setInt(1, generateTableID());
        	ps.setInt(2, startTableNumber+i); 
        	ps.setInt(3, capacity);
            ps.executeUpdate();
        }

        ps.close();
        con.close();
    }
    public static boolean assignTable(int tableId, int customerId) throws SQLException, ClassNotFoundException {
        Connection con = DBUtil.getConnection();
        String query = "UPDATE TABLES SET status = 'Occupied', customer_id = ? WHERE table_id = ?";

        PreparedStatement ps = con.prepareStatement(query);
        ps.setInt(1, customerId);
        ps.setInt(2, tableId);
       boolean status= ps.execute();

        ps.close();
        con.close();
        return status;
    }
    public static int getHighestTableNumber() throws SQLException, ClassNotFoundException {
        Connection con = DBUtil.getConnection();
        String query = "SELECT MAX(table_number) FROM TABLES";

        PreparedStatement ps = con.prepareStatement(query);
        ResultSet rs = ps.executeQuery();

        int maxTableNumber = 0;
        if (rs.next()) {
            maxTableNumber = rs.getInt(1); 
        }

        rs.close();
        ps.close();
        con.close();
        return maxTableNumber;
    }
    private static int generateTableID() throws ClassNotFoundException {
        int newCategoryID = 01; 

        String query = "SELECT MAX(table_id) FROM tables";
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
}
