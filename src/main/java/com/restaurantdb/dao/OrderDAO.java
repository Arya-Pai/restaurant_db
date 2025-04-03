package com.restaurantdb.dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import com.restaurantdb.model.Order;
import com.restaurantdb.model.Table;
import com.restaurantdb.util.DBUtil;

public class OrderDAO {
    public void addOrder(Order order) throws SQLException, ClassNotFoundException {
        String query = "INSERT INTO ORDERS (bill_id, employee_id) VALUES (?, ?)";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {
            pst.setInt(1, order.getBillId());
            pst.setInt(2, order.getEmployeeId());
            pst.executeUpdate();

            ResultSet rs = pst.getGeneratedKeys();
            if (rs.next()) {
                order.setOrderId(rs.getInt(1));
            }
        }
    }

    public Order getOrder(int orderId) throws SQLException, ClassNotFoundException {
        String query = "SELECT * FROM ORDERS WHERE order_id = ?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(query)) {
            pst.setInt(1, orderId);
            ResultSet rs = pst.executeQuery();
            if (rs.next()) {
                Order order = new Order();
                order.setOrderId(rs.getInt("order_id"));
                order.setBillId(rs.getInt("bill_id"));
                order.setOrderTime(rs.getTimestamp("order_time"));
                order.setEmployeeId(rs.getInt("employee_id"));
                return order;
            }
        }
        return null;
    }

    public List<Order> getAllOrders() throws SQLException, ClassNotFoundException {
        List<Order> orders = new ArrayList<>();
        String query = "SELECT * FROM ORDERS";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(query);
             ResultSet rs = pst.executeQuery()) {
            while (rs.next()) {
                Order order = new Order();
                order.setOrderId(rs.getInt("order_id"));
                order.setBillId(rs.getInt("bill_id"));
                order.setOrderTime(rs.getTimestamp("order_time"));
                order.setEmployeeId(rs.getInt("employee_id"));
                orders.add(order);
            }
        }
        return orders;
    }

    public List<Order> getOngoingOrdersByTableId(int tableId) throws SQLException, ClassNotFoundException {
        List<Order> orders = new ArrayList<>();
        String query = "SELECT o.order_id, o.bill_id, o.order_time, o.employee_id " +
                       "FROM orders o " +
                       "JOIN bills b ON o.bill_id = b.bill_id " +
                       "JOIN orders_items oi ON o.order_id = oi.order_id " +
                       "WHERE b.table_id = ? AND oi.status = 'Pending'";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(query)) {
            pst.setInt(1, tableId);
            ResultSet rs = pst.executeQuery();
            while (rs.next()) {
                Order order = new Order();
                order.setOrderId(rs.getInt("order_id"));
                order.setBillId(rs.getInt("bill_id"));
                order.setOrderTime(rs.getTimestamp("order_time"));
                order.setEmployeeId(rs.getInt("employee_id"));
                orders.add(order);
            }
        }
        return orders;
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

    public void updateOrder(Order order) throws SQLException, ClassNotFoundException {
        String query = "UPDATE ORDERS SET bill_id = ?, employee_id = ? WHERE order_id = ?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(query)) {
            pst.setInt(1, order.getBillId());
            pst.setInt(2, order.getEmployeeId());
            pst.setInt(3, order.getOrderId());
            pst.executeUpdate();
        }
    }

    public void deleteOrder(int orderId) throws SQLException, ClassNotFoundException {
        String query = "DELETE FROM ORDERS WHERE order_id = ?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(query)) {
            pst.setInt(1, orderId);
            pst.executeUpdate();
        }
    }

    public int createOrder(int tableId, int employeeId) throws SQLException, ClassNotFoundException {
        int orderId = -1;
        int billId = -1;
        
        // Check if a bill already exists for the given tableId
        String checkBillQuery = "SELECT bill_id FROM bills WHERE table_id = ?";
        String billQuery = "INSERT INTO bills (table_id) VALUES (?)";
        String orderQuery = "INSERT INTO orders (bill_id, employee_id, order_time) VALUES (?,  ?, CURRENT_TIMESTAMP)";

        try (Connection con = DBUtil.getConnection();
             PreparedStatement pstCheckBill = con.prepareStatement(checkBillQuery);
             PreparedStatement pstBill = con.prepareStatement(billQuery, PreparedStatement.RETURN_GENERATED_KEYS);
             PreparedStatement pstOrder = con.prepareStatement(orderQuery, PreparedStatement.RETURN_GENERATED_KEYS)) {

            // Check for existing bill
            pstCheckBill.setInt(1, tableId);
            ResultSet rsCheckBill = pstCheckBill.executeQuery();
            if (rsCheckBill.next()) {
                billId = rsCheckBill.getInt("bill_id");
            } else {
                // Create bill entry
                pstBill.setInt(1, tableId);
                pstBill.executeUpdate();

                ResultSet rsBill = pstBill.getGeneratedKeys();
                if (rsBill.next()) {
                    billId = rsBill.getInt(1);
                }
            }

            // Create order entry
            pstOrder.setInt(1, billId);
      
            pstOrder.setInt(2, employeeId);
            pstOrder.executeUpdate();

            ResultSet rsOrder = pstOrder.getGeneratedKeys();
            if (rsOrder.next()) {
                orderId = rsOrder.getInt(1);
            }
        }
        return orderId;
    }

    public void confirmOrder(Order order) throws SQLException, ClassNotFoundException {
        Connection connection = DBUtil.getConnection();
        String query = "UPDATE orders SET employee_id = ? WHERE order_id = ?";
        PreparedStatement preparedStatement = connection.prepareStatement(query);
        preparedStatement.setInt(1, order.getEmployeeId());
        preparedStatement.setInt(2, order.getOrderId());
        preparedStatement.executeUpdate();
        connection.close();
    }
}