package com.restaurantdb.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import com.restaurantdb.util.DBUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;


/**
 * Servlet implementation class UpdateBillStatusServlet
 */
@WebServlet("/UpdateBillStatusServlet")
public class UpdateBillStatusServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	 protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	        String billIdParam = request.getParameter("bill_id");
	        String newStatus = request.getParameter("bill_status");

	        if (billIdParam == null || newStatus == null || (!newStatus.equals("Pending") && !newStatus.equals("Paid"))) {
	            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid bill ID or status.");
	            return;
	        }

	        int billId;
	        try {
	            billId = Integer.parseInt(billIdParam);
	        } catch (NumberFormatException e) {
	            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid bill ID format.");
	            return;
	        }

	        try (Connection con = DBUtil.getConnection();
	             PreparedStatement pst = con.prepareStatement("UPDATE bills SET bill_status = ? WHERE bill_id = ?")) {

	            pst.setString(1, "Paid");
	            pst.setInt(2, billId);

	            int rowsUpdated = pst.executeUpdate();
	            if (rowsUpdated > 0) {
	                response.setStatus(HttpServletResponse.SC_OK);
	                response.sendRedirect("index.jsp");
	            } else {
	                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Bill ID not found.");
	            }

	        } catch (SQLException | ClassNotFoundException e) {
	            e.printStackTrace();
	            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "An error occurred while updating the bill status.");
	        }
	    }
	

}
