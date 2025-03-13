package com.restaurantdb.controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import com.restaurantdb.dao.CategoryDAO;
import com.restaurantdb.dao.MenuItems;
import com.restaurantdb.model.Category;
import com.restaurantdb.model.Menu;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/getCategories")
public class CategoryServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        try {
            // Fetch all categories
            List<Category> categories = CategoryDAO.getAllCategories();
            req.setAttribute("categories", categories);

            // Check if category ID is provided
            String categoryIdParam = req.getParameter("categoryId");
            if (categoryIdParam != null && !categoryIdParam.isEmpty()) {
                try {
                    int categoryId = Integer.parseInt(categoryIdParam);
                    List<Menu> menuItems = MenuItems.getMenuItemsByCategory(categoryId);
                    req.setAttribute("menuItems", menuItems);
                } catch (NumberFormatException e) {
                    req.setAttribute("error", "Invalid category ID.");
                }
            }

            // Forward to menu.jsp
            req.getRequestDispatcher("menu.jsp").forward(req, res);

        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            req.setAttribute("error", "Error fetching categories.");
            req.getRequestDispatcher("menu.jsp").forward(req, res);
        }
    }
}

