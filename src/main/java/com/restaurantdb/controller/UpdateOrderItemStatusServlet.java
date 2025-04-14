package com.restaurantdb.controller;

import java.io.IOException;

import com.restaurantdb.dao.OrderItemsDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;


/**
 * Servlet implementation class UpdateOrderItemStatusServlet
 */
@WebServlet("/UpdateOrderItemStatusServlet")
public class UpdateOrderItemStatusServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		int itemId = Integer.parseInt(request.getParameter("itemId"));
		int orderId = Integer.parseInt(request.getParameter("orderId"));
		

        try {
            OrderItemsDAO orderItemsDAO = new OrderItemsDAO();
            orderItemsDAO.updateOrderItemStatusToDone(itemId,orderId);
            response.sendRedirect("index.jsp?successMessage=Order item marked as done.");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("index.jsp?errorMessage=" + e.getMessage());
        }
	}

}
