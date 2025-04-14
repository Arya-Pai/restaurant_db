package com.restaurantdb.controller;

import java.io.IOException;
import java.sql.SQLException;

import com.restaurantdb.dao.CustomerDAO;
import com.restaurantdb.dao.TableDAO;
import com.restaurantdb.model.Customer;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Servlet implementation class AssignTableServlet
 */
@WebServlet("/AssignTableServlet")
public class AssignTableServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		System.out.println("Assign Servlet called");
		int table_id=Integer.parseInt(request.getParameter("table_id"));
		String phone=request.getParameter("phone");
		CustomerDAO dao=new CustomerDAO();
		String name=request.getParameter("name");
		HttpSession session=request.getSession(false);
		if (phone == null || phone.trim().isEmpty() || table_id == -1 ) {
            session.setAttribute("errorMessage", "Phone number and Table ID are required.");
            response.sendRedirect("table.jsp");
            return;
        }
		if (name == null || name.trim().isEmpty()) {
            session.setAttribute("errorMessage", "Name is required for new customers.");
            response.sendRedirect("table.jsp");
            return;
        }
		try {
			System.out.println("Assign Customer" + name);
			boolean created=dao.createCustomer(name, phone);
			System.out.println(created);
			if(created) {
				
				Customer cust=dao.getCustomer(phone);
				boolean status= TableDAO.assignTable(cust.getId(), table_id);
				if(status) {
					System.out.println(status);
					session.setAttribute("table_id", table_id);
					session.setAttribute("customerInfor", cust);
					response.sendRedirect("menu.jsp");
				}else {
					session.setAttribute("errorMessage","Assigning failed");
					response.sendRedirect("table.jsp");
					return;
				}
				
				
			}
		} catch (ClassNotFoundException | SQLException e) {
			e.printStackTrace();
		}
		
	}

}
