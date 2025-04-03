package com.restaurantdb.controller;

import java.io.IOException;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.restaurantdb.dao.PaymentDAO;
import com.restaurantdb.dao.TableDAO;
import com.restaurantdb.dao.BillDAO;
import com.restaurantdb.model.Payment;

@WebServlet("/PaymentServlet")
public class PaymentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private PaymentDAO paymentDAO;
    private TableDAO tableDAO;
    private BillDAO billDAO;

    public void init() {
        paymentDAO = new PaymentDAO();
        tableDAO = new TableDAO();
        billDAO = new BillDAO();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int billId = Integer.parseInt(request.getParameter("billId"));
        double amount = Double.parseDouble(request.getParameter("amount"));
        String paymentMode = request.getParameter("paymentMode");
        String paymentStatus = request.getParameter("paymentStatus");

        Payment payment = new Payment();
        payment.setBillId(billId);
        payment.setAmount(amount);
        payment.setPaymentMode(paymentMode);
        payment.setPaymentStatus(paymentStatus);

        try {
            paymentDAO.savePayment(payment);

            // Update bill status based on payment status
            if ("Completed".equals(paymentStatus) || "Failed".equals(paymentStatus) || "Refunded".equals(paymentStatus)) {
                billDAO.updateBillStatus(billId, "Paid");
            }

            if ("Completed".equals(paymentStatus)) {
                int tableId = paymentDAO.getTableIdByBillId(billId);
                tableDAO.updateTableStatusAndCustomerId(tableId);
                tableDAO.changeTableIdButKeepTableNumber(tableId);
            }
        } catch (SQLException | ClassNotFoundException e) {
            throw new ServletException(e);
        }

        response.sendRedirect("payment.jsp");
    }
}
