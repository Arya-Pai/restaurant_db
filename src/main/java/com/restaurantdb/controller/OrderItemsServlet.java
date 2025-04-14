package com.restaurantdb.controller;

import com.restaurantdb.model.OrderItem;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/OrderItemsServlet")
public class OrderItemsServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        List<OrderItem> orderList = (List<OrderItem>) session.getAttribute("orderList");

        // Initialize orderList if it's null
        if (orderList == null) {
            orderList = new ArrayList<>();
            session.setAttribute("orderList", orderList);
        }

        if ("add".equals(action)) {
            int itemId = Integer.parseInt(request.getParameter("item_id"));
            String itemName = request.getParameter("item_name");
            double price = Double.parseDouble(request.getParameter("price"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));

            boolean itemExists = false;
            for (OrderItem item : orderList) {
                if (item.getItemId() == itemId) {
                    item.setQuantity(item.getQuantity() + quantity);
                    itemExists = true;
                    break;
                }
            }

            if (!itemExists) {
                OrderItem newItem = new OrderItem();
                newItem.setItemId(itemId);
                newItem.setItemName(itemName);
                newItem.setPrice(price);
                newItem.setQuantity(quantity);
                orderList.add(newItem);
            }

        } else if ("update".equals(action)) {
            int itemId = Integer.parseInt(request.getParameter("item_id"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));

            for (OrderItem item : orderList) {
                if (item.getItemId() == itemId) {
                    item.setQuantity(quantity);
                    break;
                }
            }

        } else if ("remove".equals(action)) {
            int itemId = Integer.parseInt(request.getParameter("item_id"));

            orderList.removeIf(item -> item.getItemId() == itemId);
        }

        session.setAttribute("orderList", orderList);
        response.sendRedirect("menu.jsp");
    }
}

