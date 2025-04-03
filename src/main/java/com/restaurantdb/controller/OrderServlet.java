package com.restaurantdb.controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.restaurantdb.model.OrderItem;
import com.restaurantdb.dao.OrderDAO;
import com.restaurantdb.model.Order;

@WebServlet("/OrderServlet")
public class OrderServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private OrderDAO orderDAO;

    public void init() {
        orderDAO = new OrderDAO();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        List<OrderItem> orderList = (List<OrderItem>) session.getAttribute("orderList");
        Integer employeeId = (Integer) session.getAttribute("emp_id");
        Integer orderId = (Integer) session.getAttribute("orderId");

        if (orderList != null && !orderList.isEmpty() && employeeId != null && orderId != null) {
            try {
                // Create a new order object
                Order order = new Order();
                order.setOrderId(orderId);
                order.setEmployeeId(employeeId);
                order.setOrderItems(orderList);

                // Save the order to the database
                orderDAO.confirmOrder(order);

                // Clear the session attributes
                session.removeAttribute("orderList");
                session.removeAttribute("orderId");

                session.setAttribute("sucess", "Your order "+orderId+" has been plaed successfully"); 
                response.sendRedirect("editOrder.jsp");
            } catch (SQLException | ClassNotFoundException e) {
                throw new ServletException(e);
            }
        } else {
            response.sendRedirect("menu.jsp");
        }
    }
}