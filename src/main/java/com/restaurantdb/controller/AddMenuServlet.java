package com.restaurantdb.controller;

import java.io.IOException;

import com.restaurantdb.dao.EmployeeDAO;
import com.restaurantdb.dao.MenuItems;
import com.restaurantdb.model.Employee;
import com.restaurantdb.model.Menu;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;


/**
 * Servlet implementation class AddMenuServlet
 */
@WebServlet("/AddMenuServlet")
public class AddMenuServlet extends HttpServlet {
	protected void doPost(HttpServletRequest req,HttpServletResponse res) throws ServletException ,IOException {
		 	String item_name = req.getParameter("item_name");
	        String category_name = req.getParameter("category_name");
	        String price = req.getParameter("price");
	        String type=req.getParameter("type");
	        String confirmCreateCategory = req.getParameter("confirmCreateCategory");
	        HttpSession session = req.getSession();

	        if (item_name == null || category_name == null || price == null) {
	            session.setAttribute("errorMessage", "All fields are required.");
	            res.sendRedirect("add_menu.jsp");
	            return;
	        }

	        MenuItems dao = new MenuItems();
	        try {
	            boolean Exists = dao.checkCategoryExists(category_name);

	            if (!Exists) {
	                if ("yes".equals(confirmCreateCategory)) {
	                    int roleId = dao.createCategory(category_name,type);
	                    if (roleId != -1) {
	                        boolean success = dao.addItem(new Menu(item_name,category_name,price,type ));
	                        session.setAttribute(success ? "successMessage" : "errorMessage", 
	                            success ? "Category created and item added successfully" : "Category created but item could not be added.");
	                    } else {
	                        session.setAttribute("errorMessage", "Failed to create category.");
	                    }
	                } else {
	                    session.setAttribute("newCategoryMessage", "Category '" + category_name + "' does not exist. Create it?");
	                    session.setAttribute("pendingItem", new Menu(item_name,category_name,price,type));
	                }
	                res.sendRedirect("add_menu.jsp");
	                return;
	            }

	            boolean success = dao.addItem(new Menu(item_name,category_name,price,type));
	            session.setAttribute(success ? "successMessage" : "errorMessage", 
	                success ? "item added successfully." : "Failed to add item.");
	            
	            res.sendRedirect("add_menu.jsp");

	        } catch (Exception e) {
	            e.printStackTrace();
	            session.setAttribute("errorMessage", "An error occurred.");
	            res.sendRedirect("add_menu.jsp");
	        }
	}
}
