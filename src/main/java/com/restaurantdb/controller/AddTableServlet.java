package com.restaurantdb.controller;

import java.io.IOException;

import com.restaurantdb.dao.TableDAO;
import com.restaurantdb.model.Table;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;


/**
 * Servlet implementation class AddTableServlet
 */
@WebServlet("/AddTableServlet")
public class AddTableServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	protected void doPost(HttpServletRequest req,HttpServletResponse res) throws IOException {
		  HttpSession session = req.getSession();
		  Integer employeeId = (Integer) session.getAttribute("emp_id");
		  String empname = (String) session.getAttribute("emp_name");
		 
		  System.out.println(empname+" add table servlet"+employeeId);
		 if (employeeId == null) {
		        res.sendRedirect("login.jsp");
		        return;
		    }
		int tables=Integer.parseInt(req.getParameter("totalTables"));
		 int capacity=Integer.parseInt(req.getParameter("table_capacity"));
		try {
			TableDAO.addTables(tables,capacity);
			req.setAttribute("successMessage","Tables Added successfully");
			res.sendRedirect("index.jsp");
		}catch (Exception e) {
			e.printStackTrace();
			req.setAttribute("errorMessage", e.getMessage());
			res.sendRedirect("index.jsp");
		}
	}

}
