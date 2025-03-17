package com.restaurantdb.controller;

import java.io.IOException;
import java.sql.SQLException;

import com.restaurantdb.dao.CustomerDAO;
import com.restaurantdb.model.Customer;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;


/**
 * Servlet implementation class CheckCustomerServlet
 */
@WebServlet("/CheckCustomerServlet")
public class CheckCustomerServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	protected void doPost(HttpServletRequest req,HttpServletResponse res) throws IOException,ServletException{

		String phone =req.getParameter("phone");
		String table_id=req.getParameter("table_id");
		System.out.println("CheckCustomerServlet called "+phone);
		if (phone == null || phone.trim().isEmpty()) {
            req.setAttribute("error", "Phone number is required.");
            req.getRequestDispatcher("table.jsp").forward(req, res);
            return;
        }
		HttpSession session=req.getSession();
		CustomerDAO dao=new CustomerDAO();
		boolean exists;
		try {
			exists = dao.checkCustomer(phone);
			if(exists) {
				session.setAttribute("table_id",table_id);
				Customer cust=dao.getCustomer(phone);
				session.setAttribute("customerInfo", cust);
				res.sendRedirect("menu.jsp");
				
			}else {
				System.out.println("Else customerservlet");
				session.setAttribute("table_id",table_id);
				session.setAttribute("phone", phone);
				session.setAttribute("customerNotFound", "true");
				res.sendRedirect("table.jsp");
			}
		} catch (ClassNotFoundException | SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		
	}

}
