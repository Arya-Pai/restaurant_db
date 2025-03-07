package com.restaurantdb.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

import com.restaurantdb.dao.EmployeeDAO;
import com.restaurantdb.model.Employee;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
   protected void doPost(HttpServletRequest req,HttpServletResponse res) throws ServletException,IOException{
	   String id=req.getParameter("emp_id");
	   String password=req.getParameter("emp_password");
	   EmployeeDAO dao=new EmployeeDAO();
	   HttpSession session=req.getSession();
	   try {
		   boolean present=dao.validate(id, password);
		   if(present) {
			   Employee emp = dao.getEmployee(id);
			   if(emp.isActive()) {
				   session.setAttribute("emp_id", emp.getId());
				   session.setAttribute("emp_name", emp.getEmp_name());
				   session.setAttribute("role_id", emp.getRoleId());
				   session.setAttribute("role_name", emp.getRoleName());
				   res.sendRedirect("index.jsp");
			   }else {
				   session.setAttribute("errorMessage","This employee is currently inactive ,so cannot take orders");
				   res.sendRedirect("login.jsp");
			   }
			

			   	
		   }else {
			   session.setAttribute("errorMessage", "Please check your id or password");
			   res.sendRedirect("login.jsp");
		   }
	   }catch(Exception e) {
		   e.printStackTrace();
		   session.setAttribute("errorMessage",e.getMessage());
		   res.sendRedirect("login.jsp");
	   }
   }

}
