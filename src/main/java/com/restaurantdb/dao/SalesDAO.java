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
        String query = "SELECT DISTINCT payment_id, table_number, employee_name, order_id, bill_id, payment_mode,total_amount FROM todays_sales";
        
        List<Sale> sales = new ArrayList<>();
        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(query);
             ResultSet rs = pst.executeQuery()) {
            while (rs.next()) {
                Sale sale = new Sale();
                sale.setOrderId(rs.getInt("order_id"));
                sale.setTableNumber(rs.getInt("table_number"));
    
                sale.setEmployeeName(rs.getString("employee_name"));
                sale.setPaymentId(rs.getInt("payment_id"));
                sale.setBillId(rs.getInt("bill_id"));
                sale.setPaymentMode(rs.getString("payment_mode"));
                sale.setAmount(rs.getDouble("total_amount"));
                sales.add(sale);
            }
        }
        return sales;
    }
    
    public List<Sale> getAllCompletedSales() throws SQLException, ClassNotFoundException {
        List<Sale> totalSales = new ArrayList<>();
        String query =""" 	
        	WITH RankedPayments AS (
            SELECT 
                p.payment_id,
                o.order_id,
                e.name AS employee_name,
                o.bill_id,
                p.amount,
                p.payment_time,
                p.payment_mode,
        ROW_NUMBER() OVER (PARTITION BY p.payment_id ORDER BY p.payment_time DESC) AS rn_payment,
        ROW_NUMBER() OVER (PARTITION BY o.bill_id ORDER BY p.payment_time DESC) AS rn_bill
            FROM 
                orders o
            JOIN 
                bills b ON o.bill_id = b.bill_id
            JOIN 
                payments p ON p.bill_id = b.bill_id
            JOIN 
                employees e ON o.employee_id = e.employee_id
            WHERE 
                p.payment_status = 'completed'
                AND p.amount>0
        )
        SELECT 
            payment_id, order_id, employee_name, bill_id, amount, payment_time, payment_mode
        FROM 
            RankedPayments
        WHERE 
    rn_payment = 1 AND rn_bill = 1
   
        ORDER BY 
            payment_time DESC;
            
        		""";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(query)) {
            ResultSet rs = pst.executeQuery();
            while (rs.next()) {
                Sale sale = new Sale();
                sale.setOrderId(rs.getInt("order_id"));
                sale.setPaymentId(rs.getInt("payment_id"));
                sale.setPaymentMode(rs.getString("payment_mode"));
                sale.setEmployeeName(rs.getString("employee_name"));
                sale.setBillId(rs.getInt("bill_id"));
                sale.setAmount(rs.getDouble("amount"));
                sale.setPaymentTime(rs.getTimestamp("payment_time"));
                totalSales.add(sale);
            }
        }
        return totalSales;
    }
}
