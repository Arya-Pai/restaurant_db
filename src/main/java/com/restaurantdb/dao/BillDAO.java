package com.restaurantdb.dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import com.restaurantdb.model.Bill;
import com.restaurantdb.util.DBUtil;

public class BillDAO {
    public void addBill(Bill bill) throws SQLException, ClassNotFoundException {
        String query = "INSERT INTO BILLS (table_id, total_amount, bill_status) VALUES (?, ?, ?)";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {
            pst.setInt(1, bill.getTableId());
            pst.setDouble(2, bill.getTotalAmount());
            pst.setString(3, bill.getBillStatus());
            pst.executeUpdate();

            ResultSet rs = pst.getGeneratedKeys();
            if (rs.next()) {
                bill.setBillId(rs.getInt(1));
            }
        }
    }

    public Bill getBill(int billId) throws SQLException, ClassNotFoundException {
        String query = "SELECT * FROM BILLS WHERE bill_id = ?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(query)) {
            pst.setInt(1, billId);
            ResultSet rs = pst.executeQuery();
            if (rs.next()) {
                Bill bill = new Bill();
                bill.setBillId(rs.getInt("bill_id"));
                bill.setTableId(rs.getInt("table_id"));
                bill.setTotalAmount(rs.getDouble("total_amount"));
                bill.setBillStatus(rs.getString("bill_status"));
                bill.setBillTime(rs.getTimestamp("bill_time"));
                return bill;
            }
        }
        return null;
    }

    public List<Bill> getAllBills() throws SQLException, ClassNotFoundException {
        List<Bill> bills = new ArrayList<>();
        String query = "SELECT * FROM BILLS";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(query);
             ResultSet rs = pst.executeQuery()) {
            while (rs.next()) {
                Bill bill = new Bill();
                bill.setBillId(rs.getInt("bill_id"));
                bill.setTableId(rs.getInt("table_id"));
                bill.setTotalAmount(rs.getDouble("total_amount"));
                bill.setBillStatus(rs.getString("bill_status"));
                bill.setBillTime(rs.getTimestamp("bill_time"));
                bills.add(bill);
            }
        }
        return bills;
    }

    public void updateBill(Bill bill) throws SQLException, ClassNotFoundException {
        String query = "UPDATE BILLS SET table_id = ?, total_amount = ?, bill_status = ? WHERE bill_id = ?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(query)) {
            pst.setInt(1, bill.getTableId());
            pst.setDouble(2, bill.getTotalAmount());
            pst.setString(3, bill.getBillStatus());
            pst.setInt(4, bill.getBillId());
            pst.executeUpdate();
        }
    }

    public void deleteBill(int billId) throws SQLException, ClassNotFoundException {
        String query = "DELETE FROM BILLS WHERE bill_id = ?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(query)) {
            pst.setInt(1, billId);
            pst.executeUpdate();
        }
    }
    public List<Bill> getPendingBills() throws SQLException, ClassNotFoundException {
        List<Bill> pendingBills = new ArrayList<>();
        String query = "SELECT * FROM bills WHERE bill_status = 'Pending'";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(query);
             ResultSet rs = pst.executeQuery()) {
            while (rs.next()) {
                Bill bill = new Bill();
                bill.setBillId(rs.getInt("bill_id"));
                bill.setTableId(rs.getInt("table_id"));
                bill.setTotalAmount(rs.getDouble("total_amount"));
                bill.setBillStatus(rs.getString("bill_status"));
                pendingBills.add(bill);
            }
        }
        return pendingBills;
    }
    public void updateBillStatus(int billId, String status) throws SQLException, ClassNotFoundException {
        String query = "UPDATE bills SET bill_status = ? WHERE bill_id = ?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(query)) {
            pst.setString(1, status);
            pst.setInt(2, billId);
            pst.executeUpdate();
        }
    }
}

