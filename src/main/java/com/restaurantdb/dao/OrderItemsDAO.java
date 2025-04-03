package com.restaurantdb.dao;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import com.restaurantdb.model.OrderItem;
import com.restaurantdb.util.DBUtil;

public class OrderItemsDAO {
    public void addOrderItem(OrderItem orderItem) throws SQLException, ClassNotFoundException {
        String query = "INSERT INTO ORDERS_ITEMS (order_id, item_id, quantity, price, status) VALUES (?, ?, ?, ?, ?)";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(query)) {
            pst.setInt(1, orderItem.getOrderId());
            pst.setInt(2, orderItem.getItemId());
            pst.setInt(3, orderItem.getQuantity());
            pst.setDouble(4, orderItem.getPrice());
            pst.setString(5, orderItem.getStatus());
            pst.executeUpdate();
        }
    }

    public OrderItem getOrderItem(int orderId, int itemId) throws SQLException, ClassNotFoundException {
        String query = "SELECT * FROM ORDERS_ITEMS WHERE order_id = ? AND item_id = ?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(query)) {
            pst.setInt(1, orderId);
            pst.setInt(2, itemId);
            ResultSet rs = pst.executeQuery();
            if (rs.next()) {
                OrderItem orderItem = new OrderItem();
                orderItem.setOrderId(rs.getInt("order_id"));
                orderItem.setItemId(rs.getInt("item_id"));
                orderItem.setQuantity(rs.getInt("quantity"));
                orderItem.setPrice(rs.getDouble("price"));
                orderItem.setStatus(rs.getString("status"));
                return orderItem;
            }
        }
        return null;
    }

    public List<OrderItem> getAllOrderItems(int orderId) throws SQLException, ClassNotFoundException {
        List<OrderItem> orderItems = new ArrayList<>();
        String query = "SELECT oi.order_id, oi.item_id, oi.quantity, oi.price, oi.status, m.item_name " +
                       "FROM orders_items oi " +
                       "JOIN menu_items m ON oi.item_id = m.item_id " +
                       "WHERE oi.order_id = ?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(query)) {
            pst.setInt(1, orderId);
            ResultSet rs = pst.executeQuery();
            while (rs.next()) {
                OrderItem orderItem = new OrderItem();
                orderItem.setOrderId(rs.getInt("order_id"));
                orderItem.setItemId(rs.getInt("item_id"));
                orderItem.setQuantity(rs.getInt("quantity"));
                orderItem.setPrice(rs.getDouble("price"));
                orderItem.setStatus(rs.getString("status"));
                orderItem.setItemName(rs.getString("item_name"));
                orderItems.add(orderItem);
            }
        }
        return orderItems;
    }

    public void updateOrderItem(OrderItem orderItem) throws SQLException, ClassNotFoundException {
        String query = "UPDATE ORDERS_ITEMS SET quantity = ?, price = ?, status = ? WHERE order_id = ? AND item_id = ?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(query)) {
            pst.setInt(1, orderItem.getQuantity());
            pst.setDouble(2, orderItem.getPrice());
            pst.setString(3, orderItem.getStatus());
            pst.setInt(4, orderItem.getOrderId());
            pst.setInt(5, orderItem.getItemId());
            pst.executeUpdate();
        }
    }

    public void deleteOrderItem(int orderId, int itemId) throws SQLException, ClassNotFoundException {
        String query = "DELETE FROM ORDERS_ITEMS WHERE order_id = ? AND item_id = ?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(query)) {
            pst.setInt(1, orderId);
            pst.setInt(2, itemId);
            pst.executeUpdate();
        }
    }
    public boolean orderItemExists(int orderId, int itemId) throws SQLException, ClassNotFoundException {
        String query = "SELECT COUNT(*) FROM orders_items WHERE order_id = ? AND item_id = ?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(query)) {
            pst.setInt(1, orderId);
            pst.setInt(2, itemId);
            ResultSet rs = pst.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        }
        return false;
    }

    public void saveOrderItems(List<OrderItem> orderItems, int orderId) throws SQLException, ClassNotFoundException {
        Connection connection = DBUtil.getConnection();
        String insertQuery = "INSERT INTO orders_items (order_id, item_id, price, quantity) VALUES (?, ?, ?, ?)";
        String updateQuery = "UPDATE orders_items SET quantity = quantity + ? WHERE order_id = ? AND item_id = ?";
        
        for (OrderItem item : orderItems) {
            if (orderItemExists(orderId, item.getItemId())) {
                try (PreparedStatement pst = connection.prepareStatement(updateQuery)) {
                    pst.setInt(1, item.getQuantity());
                    pst.setInt(2, orderId);
                    pst.setInt(3, item.getItemId());
                    pst.executeUpdate();
                }
            } else {
                try (PreparedStatement pst = connection.prepareStatement(insertQuery)) {
                    pst.setInt(1, orderId);
                    pst.setInt(2, item.getItemId());
                    pst.setDouble(3, item.getPrice());
                    pst.setInt(4, item.getQuantity());
                    pst.executeUpdate();
                }
            }
        }
        connection.close();
    }
    
  
}

