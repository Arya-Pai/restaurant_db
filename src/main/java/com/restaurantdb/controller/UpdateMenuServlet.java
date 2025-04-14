package com.restaurantdb.controller;

import com.restaurantdb.dao.MenuItems;
import com.restaurantdb.model.Menu;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/UpdateMenuServlet")
public class UpdateMenuServlet extends HttpServlet {
    private static final long serialVersionUID = 4736792793338609118L;

	@Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int itemId = Integer.parseInt(request.getParameter("item_id"));
        String status = request.getParameter("status");

        boolean availableStatus = status.equals("available");

        try {
            MenuItems menuDAO = new MenuItems();
            menuDAO.updateMenuStatus(itemId, availableStatus);
            List<Menu> menuItems = menuDAO.getAllMenuItems();

            HttpSession session = request.getSession();
            session.setAttribute("menuItems", menuItems);
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        }

        response.sendRedirect("add_menu.jsp");
    }
}
