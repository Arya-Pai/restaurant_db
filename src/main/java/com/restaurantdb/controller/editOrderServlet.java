package com.restaurantdb.controller;

import com.restaurantdb.dao.OrderItemsDAO;
import com.restaurantdb.model.OrderItem;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/editOrderServlet")
public class editOrderServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        int orderId = Integer.parseInt(request.getParameter("order_id"));
        int tableId = Integer.parseInt(request.getParameter("table_id"));

        try {
            OrderItemsDAO orderItemsDAO = new OrderItemsDAO();

            if ("update".equals(action)) {
                String[] itemIds = request.getParameterValues("item_ids");
                String[] quantities = request.getParameterValues("quantities");
                String[] prices = request.getParameterValues("prices");

                for (int i = 0; i < itemIds.length; i++) {
                    int itemId = Integer.parseInt(itemIds[i]);
                    int quantity = Integer.parseInt(quantities[i]);
                    double price = Double.parseDouble(prices[i]);

                    orderItemsDAO.updateOrderItem(orderId, itemId, quantity, price);
                }
            } else if (action.startsWith("remove_")) {
                int itemId = Integer.parseInt(action.split("_")[1]);
                orderItemsDAO.removeOrderItem(orderId, itemId);
            } else if ("add".equals(action)) {
                int itemId = Integer.parseInt(request.getParameter("item_id"));
                int quantity = Integer.parseInt(request.getParameter("quantity"));

                OrderItem existingItem = orderItemsDAO.getOrderItem(orderId, itemId);
                if (existingItem != null) {
                    int newQuantity = existingItem.getQuantity() + quantity;
                    orderItemsDAO.updateOrderItem(orderId, itemId, newQuantity, existingItem.getPrice());
                } else {
                    double price = orderItemsDAO.getItemPrice(itemId);
                    orderItemsDAO.addOrderItem(orderId, itemId, quantity, price);
                }
            }

            response.sendRedirect("editOrder.jsp?tableId=" + tableId + "&orderId=" + orderId);
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            response.sendRedirect("editOrder.jsp?tableId=" + tableId + "&orderId=" + orderId + "&errorMessage=" + e.getMessage());
        }
    }
}
