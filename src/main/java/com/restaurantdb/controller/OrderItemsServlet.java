package com.restaurantdb.controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.ArrayList;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.restaurantdb.model.OrderItem;
import com.restaurantdb.dao.OrderDAO;
import com.restaurantdb.dao.OrderItemsDAO;

@WebServlet("/OrderItemsServlet")
public class OrderItemsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private OrderDAO orderDAO;
    private OrderItemsDAO orderItemDAO;

    public void init() {
        orderDAO = new OrderDAO();
        orderItemDAO = new OrderItemsDAO();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        List<OrderItem> orderList = (List<OrderItem>) session.getAttribute("orderList");
        if (orderList == null) {
            orderList = new ArrayList<>();
        }

        String action = request.getParameter("action");
        String itemIdParam = request.getParameter("item_id");
        String itemName = request.getParameter("item_name");
        String priceParam = request.getParameter("price");
        String quantityParam = request.getParameter("quantity");

        if (itemIdParam != null && priceParam != null && quantityParam != null) {
            int itemId = Integer.parseInt(itemIdParam); // Parse the item ID
            double price = Double.parseDouble(priceParam); // Parse the price
            int quantity = Integer.parseInt(quantityParam); // Parse the quantity

            switch (action) {
                case "add":
                    boolean found = false;
                    for (OrderItem item : orderList) {
                        if (item.getItemId() == itemId) {
                            item.setQuantity(item.getQuantity() + quantity);
                            found = true;
                            break;
                        }
                    }
                    if (!found) {
                        orderList.add(new OrderItem(itemId, itemName, price, quantity));
                    }
                    break;
                case "update":
                    for (OrderItem item : orderList) {
                        if (item.getItemId() == itemId) {
                            item.setQuantity(quantity);
                            break;
                        }
                    }
                    break;
                case "remove":
                    orderList.removeIf(item -> item.getItemId() == itemId);
                    break;
            }

            // Save or update the order in the database
            try {
            	Integer orderId;
                String orderIdStr=(String)session.getAttribute("orderId");
                if(orderIdStr!=null) {
                	orderId=Integer.parseInt(orderIdStr);
                }
                int tableId =  (int) (session.getAttribute("table_id"));
                Integer employeeId = (Integer) session.getAttribute("emp_id");
                if(employeeId==null) {
                	response.sendRedirect("login.jsp");
                }

                if (orderIdStr == null) {
                    // Create a new order and get the generated order ID
                    orderId = orderDAO.createOrder(tableId, employeeId);
                    session.setAttribute("orderId", orderId.toString());
                }
                // Save the order items with the order ID
                orderItemDAO.saveOrderItems(orderList, Integer.parseInt(orderIdStr));
            } catch (SQLException | ClassNotFoundException e) {
                throw new ServletException(e);
            }

            session.setAttribute("orderList", orderList);
        }

        response.sendRedirect("editOrder.jsp?tableId=" + request.getParameter("table_id") + "&orderId=" + request.getParameter("order_id"));
    }
}

