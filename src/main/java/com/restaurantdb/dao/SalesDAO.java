package com.restaurantdb.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.restaurantdb.util.DBUtil;
import com.restaurantdb.model.Sale;

public class SalesDAO {
    public List<Sale> getTodaySales() throws SQLException, ClassNotFoundException {
        String query = "SELECT order_id, table_number, customer_name, employee_name, payment_id, bill_id, payment_mode FROM todays_sales";
        
        List<Sale> sales = new ArrayList<>();
        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(query);
             ResultSet rs = pst.executeQuery()) {
            while (rs.next()) {
                Sale sale = new Sale();
                sale.setOrderId(rs.getInt("order_id"));
                sale.setTableNumber(rs.getInt("table_number"));
                sale.setCustomerName(rs.getString("customer_name"));
                sale.setEmployeeName(rs.getString("employee_name"));
                sale.setPaymentId(rs.getInt("payment_id"));
                sale.setBillId(rs.getInt("bill_id"));
                sale.setPaymentMode(rs.getString("payment_mode"));
                sales.add(sale);
            }
        }
        return sales;
    }
}
