package com.restaurantdb.controller;

import com.restaurantdb.dao.BillDAO;
import com.restaurantdb.dao.OrderDAO;
import com.restaurantdb.dao.OrderItemsDAO;
import com.restaurantdb.model.OrderItem;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/OrderServlet")
public class OrderServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        List<OrderItem> orderList = (List<OrderItem>) session.getAttribute("orderList");
        Integer employeeId = (Integer) session.getAttribute("emp_id");
        Integer tableId=(Integer) session.getAttribute("table_id");
        // Check if employeeId is null
        if (employeeId == null) {
            response.sendRedirect("menu.jsp?errorMessage=Employee ID is missing.");
            return;
        }

        try {
            if ("confirm".equals(action)) {
                if (orderList == null || orderList.isEmpty()) {
                    response.sendRedirect("menu.jsp?errorMessage=Order list is empty.");
                    return;
                }

                OrderDAO orderDAO = new OrderDAO();
                OrderItemsDAO orderItemsDAO = new OrderItemsDAO();
//                BillDAO.addBill(tableId);
                int orderId = orderDAO.createOrder(tableId,employeeId);

                for (OrderItem item : orderList) {
                    orderItemsDAO.addOrderItem(orderId, item.getItemId(), item.getQuantity(), item.getPrice());
                }

                session.removeAttribute("orderList");
                response.sendRedirect("menu.jsp?successMessage=Order confirmed successfully.");
            } else {
                response.sendRedirect("menu.jsp?errorMessage=Invalid action.");
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            response.sendRedirect("menu.jsp?errorMessage=" + e.getMessage());
        }
    }
}