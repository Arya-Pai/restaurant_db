package com.restaurantdb.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;

import com.echolink.util.DBUtil;
import com.restaurantdb.dao.EmployeeDAO;
import com.restaurantdb.model.Employee;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;


/**
 * Servlet implementation class AddEmployeeServlet
 */
@WebServlet("/AddEmployeeServlet")
public class AddEmployeeServlet extends HttpServlet  {
	protected void doPost(HttpServletRequest req,HttpServletResponse res) throws IOException, ServletException{
		String name=(String) req.getAttribute("name");
		String phone=(String)req.getAttribute("phone");
		String password=(String)req.getAttribute("password");
		String role_name=(String)req.getAttribute("role_name");
		HttpSession session=req.getSession();
		if(name==null||phone==null||password==null||role_name==null) {
			session.setAttribute("errorMessage","All fields are required");
			res.sendRedirect("add_employee.jsp");
			return;
		}
		Employee emp=new Employee(name,phone,password,role_name);
		EmployeeDAO dao=new EmployeeDAO();
//		boolean success=dao.addEmployee(name,phone,password,role_name);
		
		
	}
   
}
