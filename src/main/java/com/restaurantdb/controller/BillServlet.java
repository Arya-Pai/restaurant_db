package com.restaurantdb.controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import com.restaurantdb.dao.BillDAO;
import com.restaurantdb.model.Bill;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/BillServlet")
public class BillServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private BillDAO billDAO;

    public void init() {
        billDAO = new BillDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<Bill> billList = billDAO.getAllBills();
            request.setAttribute("billList", billList);
            request.getRequestDispatcher("billList.jsp").forward(request, response);
        } catch (SQLException | ClassNotFoundException e) {
            throw new ServletException(e);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        try {
            switch (action) {
                case "add":
                    addBill(request, response);
                    break;
                case "update":
                    updateBill(request, response);
                    break;
                case "delete":
                    deleteBill(request, response);
                    break;
                default:
                    doGet(request, response);
                    break;
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        } catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    }

    private void addBill(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ClassNotFoundException {
        int tableId = Integer.parseInt(request.getParameter("tableId"));
        double totalAmount = Double.parseDouble(request.getParameter("totalAmount"));
        String billStatus = request.getParameter("billStatus");

        Bill bill = new Bill();
        bill.setTableId(tableId);
        bill.setTotalAmount(totalAmount);
        bill.setBillStatus(billStatus);

        billDAO.addBill(bill);
        response.sendRedirect("BillServlet");
    }

    private void updateBill(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ClassNotFoundException {
        int billId = Integer.parseInt(request.getParameter("billId"));
        int tableId = Integer.parseInt(request.getParameter("tableId"));
        double totalAmount = Double.parseDouble(request.getParameter("totalAmount"));
        String billStatus = request.getParameter("billStatus");

        Bill bill = new Bill();
        bill.setBillId(billId);
        bill.setTableId(tableId);
        bill.setTotalAmount(totalAmount);
        bill.setBillStatus(billStatus);

        billDAO.updateBill(bill);
        response.sendRedirect("BillServlet");
    }

    private void deleteBill(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ClassNotFoundException {
        int billId = Integer.parseInt(request.getParameter("billId"));
        billDAO.deleteBill(billId);
        response.sendRedirect("BillServlet");
    }
}
