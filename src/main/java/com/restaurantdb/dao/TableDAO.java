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
             ResultSet rs = ps.executeQuery()) {

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

    public static void addTables(int totalTables, int capacity) throws SQLException, ClassNotFoundException {
        Connection con = DBUtil.getConnection();
        String query = "INSERT INTO TABLES (table_id, table_number, capacity, status) VALUES (?, ?, ?, 'Available')";

        PreparedStatement ps = con.prepareStatement(query);
        int startTableNumber = getHighestTableNumber();
        for (int i = 1; i <= totalTables; i++) {
            ps.setInt(1, generateTableID());
            ps.setInt(2, startTableNumber + i);
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
        int updated = ps.executeUpdate();

        ps.close();
        con.close();
        return updated > 0;
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
        int newTableID = 1;

        String query = "SELECT MAX(table_id) FROM tables";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query);
             ResultSet rs = pstmt.executeQuery()) {

            if (rs.next()) {
                int lastTableID = rs.getInt(1);
                if (lastTableID >= 1) {
                    newTableID = lastTableID + 1;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return newTableID;
    }

    public List<Table> getTablesByEmployeeId(int employeeId) throws SQLException, ClassNotFoundException {
        List<Table> tables = new ArrayList<>();
        String query = "SELECT DISTINCT t.table_id, t.table_number, t.capacity, t.status " +
                       "FROM TABLES t " +
                       "JOIN BILLS b ON t.table_id = b.table_id " +
                       "JOIN ORDERS o ON b.bill_id = o.bill_id " +
                       "WHERE o.employee_id = ?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(query)) {
            pst.setInt(1, employeeId);
            ResultSet rs = pst.executeQuery();
            while (rs.next()) {
                Table table = new Table();
                table.setTableId(rs.getInt("table_id"));
                table.setTableNumber(rs.getInt("table_number"));
                table.setCapacity(rs.getInt("capacity"));
                table.setStatus(rs.getString("status"));
                tables.add(table);
            }
        }
        return tables;
    }
    public static int getTableIdByNumber(int tableNumber) throws SQLException, ClassNotFoundException {
        String query = "SELECT table_id FROM tables WHERE table_number = ?";
        int tableId = -1; // Default value if not found

        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            ps.setInt(1, tableNumber);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                tableId = rs.getInt("table_id");
            }
        }
        return tableId; // Returns -1 if table not found
    }
    public void updateTableStatusAndCustomerId(int tableId) throws SQLException, ClassNotFoundException {
        String query = "UPDATE tables SET status = 'Available', customer_id = NULL WHERE table_id = ?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(query)) {
            pst.setInt(1, tableId);
            pst.executeUpdate();
        }
    }

    public void changeTableIdButKeepTableNumber(int tableId) throws SQLException, ClassNotFoundException {
        String selectQuery = "SELECT table_number,capacity FROM tables WHERE table_id = ?";
        String insertQuery = "INSERT INTO tables (table_number,capacity) VALUES (?,?)";

        try (Connection con = DBUtil.getConnection();
             PreparedStatement selectPst = con.prepareStatement(selectQuery);
             PreparedStatement insertPst = con.prepareStatement(insertQuery)) {
            selectPst.setInt(1, tableId);
            ResultSet rs = selectPst.executeQuery();
            if (rs.next()) {
                int tableNumber = rs.getInt("table_number");
                int capacity = rs.getInt("capacity");

                // Ensure uniqueness of table_number
                int newTableNumber = tableNumber;
                while (true) {
                    try {
                        insertPst.setInt(1, newTableNumber);
                        insertPst.setInt(2, capacity);
                        insertPst.executeUpdate();
                        break; // Break if the insert is successful
                    } catch (SQLException e) {
                        if (e.getErrorCode() == 1062) { // Duplicate entry error code
                            newTableNumber++; // Increment the table number to ensure uniqueness
                        } else {
                            throw e; // Re-throw the exception if it's not a duplicate entry error
                        }
                    }
                }
            }
        }
    }

    public int getTableIdByTableNumber(int tableNumber) throws SQLException, ClassNotFoundException {
        String query = "SELECT MAX(table_id) AS table_id FROM tables WHERE table_number = ?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(query)) {
            pst.setInt(1, tableNumber);
            ResultSet rs = pst.executeQuery();
            if (rs.next()) {
                return rs.getInt("table_id");
            }
        }
        return -1;
    }

    // Method to generate a new table ID
    

}
