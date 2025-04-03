package com.restaurantdb.dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import com.restaurantdb.model.Payment;
import com.restaurantdb.util.DBUtil;

public class PaymentDAO {
    public void addPayment(Payment payment) throws SQLException, ClassNotFoundException {
        String query = "INSERT INTO PAYMENTS (bill_id, amount, payment_mode, payment_status) VALUES (?, ?, ?, ?)";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {
            pst.setInt(1, payment.getBillId());
            pst.setDouble(2, payment.getAmount());
            pst.setString(3, payment.getPaymentMode());
            pst.setString(4, payment.getPaymentStatus());
            pst.executeUpdate();

            ResultSet rs = pst.getGeneratedKeys();
            if (rs.next()) {
                payment.setPaymentId(rs.getInt(1));
            }
        }
    }

    public Payment getPayment(int paymentId) throws SQLException, ClassNotFoundException {
        String query = "SELECT * FROM PAYMENTS WHERE payment_id = ?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(query)) {
            pst.setInt(1, paymentId);
            ResultSet rs = pst.executeQuery();
            if (rs.next()) {
                Payment payment = new Payment();
                payment.setPaymentId(rs.getInt("payment_id"));
                payment.setBillId(rs.getInt("bill_id"));
                payment.setAmount(rs.getDouble("amount"));
                payment.setPaymentMode(rs.getString("payment_mode"));
                payment.setPaymentStatus(rs.getString("payment_status"));
                payment.setPaymentTime(rs.getTimestamp("payment_time"));
                return payment;
            }
        }
        return null;
    }

    public List<Payment> getAllPayments() throws SQLException, ClassNotFoundException {
        List<Payment> payments = new ArrayList<>();
        String query = "SELECT * FROM PAYMENTS";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(query);
             ResultSet rs = pst.executeQuery()) {
            while (rs.next()) {
                Payment payment = new Payment();
                payment.setPaymentId(rs.getInt("payment_id"));
                payment.setBillId(rs.getInt("bill_id"));
                payment.setAmount(rs.getDouble("amount"));
                payment.setPaymentMode(rs.getString("payment_mode"));
                payment.setPaymentStatus(rs.getString("payment_status"));
                payment.setPaymentTime(rs.getTimestamp("payment_time"));
                payments.add(payment);
            }
        }
        return payments;
    }


    public void deletePayment(int paymentId) throws SQLException, ClassNotFoundException {
        String query = "DELETE FROM PAYMENTS WHERE payment_id = ?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(query)) {
            pst.setInt(1, paymentId);
            pst.executeUpdate();
        }
    }
   

    public void updatePayment(Payment payment) throws SQLException, ClassNotFoundException {
        String query = "UPDATE payments SET amount = ?, payment_mode = ?, payment_status = ? WHERE payment_id = ?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(query)) {
            pst.setDouble(1, payment.getAmount());
            pst.setString(2, payment.getPaymentMode());
            pst.setString(3, payment.getPaymentStatus());
            pst.setInt(4, payment.getPaymentId());
            pst.executeUpdate();
        }
    }

    public void savePayment(Payment payment) throws SQLException, ClassNotFoundException {
        String query = "INSERT INTO payments (bill_id, amount, payment_mode, payment_status) VALUES (?, ?, ?, ?)";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(query)) {
            pst.setInt(1, payment.getBillId());
            pst.setDouble(2, payment.getAmount());
            pst.setString(3, payment.getPaymentMode());
            pst.setString(4, payment.getPaymentStatus());
            pst.executeUpdate();
        }
    }

    public Payment getPaymentByBillIdAndStatus(int billId, String... statuses) throws SQLException, ClassNotFoundException {
        StringBuilder queryBuilder = new StringBuilder("SELECT * FROM payments WHERE bill_id = ? AND (");
        for (int i = 0; i < statuses.length; i++) {
            queryBuilder.append("payment_status = ?");
            if (i < statuses.length - 1) {
                queryBuilder.append(" OR ");
            }
        }
        queryBuilder.append(")");
        String query = queryBuilder.toString();

        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(query)) {
            pst.setInt(1, billId);
            for (int i = 0; i < statuses.length; i++) {
                pst.setString(i + 2, statuses[i]);
            }
            ResultSet rs = pst.executeQuery();
            if (rs.next()) {
                Payment payment = new Payment();
                payment.setPaymentId(rs.getInt("payment_id"));
                payment.setBillId(rs.getInt("bill_id"));
                payment.setAmount(rs.getDouble("amount"));
                payment.setPaymentMode(rs.getString("payment_mode"));
                payment.setPaymentStatus(rs.getString("payment_status"));
                return payment;
            }
        }
        return null;
    }

    public int getTableIdByBillId(int billId) throws SQLException, ClassNotFoundException {
        String query = "SELECT table_id FROM bills WHERE bill_id = ?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(query)) {
            pst.setInt(1, billId);
            ResultSet rs = pst.executeQuery();
            if (rs.next()) {
                return rs.getInt("table_id");
            }
        }
        return -1;
    }
}

