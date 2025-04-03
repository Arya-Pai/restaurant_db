package com.restaurantdb.controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.restaurantdb.model.OrderItem;
import com.restaurantdb.dao.OrderDAO;
import com.restaurantdb.dao.OrderItemsDAO;

@WebServlet("/EditOrderServlet")
public class editOrderServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private OrderDAO orderDAO;
    private OrderItemsDAO orderItemsDAO;

    public void init() {
        orderDAO = new OrderDAO();
        orderItemsDAO = new OrderItemsDAO();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer orderId = Integer.parseInt(request.getParameter("order_id"));
        Integer tableId = Integer.parseInt(request.getParameter("table_id"));
        String action = request.getParameter("action");

        try {
            if (action.startsWith("remove_")) {
                int itemId = Integer.parseInt(action.split("_")[1]);
                orderItemsDAO.deleteOrderItem(orderId, itemId);
            } else if ("update".equals(action)) {
                String[] itemIds = request.getParameterValues("item_ids");
                String[] quantities = request.getParameterValues("quantities");

                for (int i = 0; i < itemIds.length; i++) {
                    int itemId = Integer.parseInt(itemIds[i]);
                    int quantity = Integer.parseInt(quantities[i]);
                    orderItemsDAO.updateOrderItem(new OrderItem(orderId, itemId, quantity));
                }
            } else if ("add".equals(action)) {
                int itemId = Integer.parseInt(request.getParameter("item_id"));
                String itemName = request.getParameter("item_name");
                double price = Double.parseDouble(request.getParameter("price"));
                int quantity = Integer.parseInt(request.getParameter("quantity"));

                orderItemsDAO.addOrderItem(new OrderItem(orderId, itemId, itemName, price, quantity));
            }

            List<OrderItem> updatedOrderList = orderItemsDAO.getAllOrderItems(orderId);
            session.setAttribute("orderList", updatedOrderList);
        } catch (SQLException | ClassNotFoundException e) {
            throw new ServletException(e);
        }

        response.sendRedirect("editOrder.jsp");
    }
}
