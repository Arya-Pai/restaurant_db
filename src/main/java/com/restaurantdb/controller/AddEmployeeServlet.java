package com.restaurantdb.controller;

import java.io.IOException;


import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;


/**
 * Servlet implementation class AddEmployeeServlet
 */
@WebServlet("/AddEmployeeServlet")
public class AddEmployeeServlet extends HttpServlet {
	protected void doPost(HttpServletRequest req,HttpServletResponse res) {
		String name=(String) req.getAttribute("name");
		String phone=(String)req.getAttribute("phone");
		String password=(String)req.getAttribute("password");
		String role_name=(String)req.getAttribute("role_name");
		
	}
   
}
