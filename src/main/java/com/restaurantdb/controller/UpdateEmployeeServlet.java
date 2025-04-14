package com.restaurantdb.controller;

import com.restaurantdb.dao.EmployeeDAO;
import com.restaurantdb.model.Employee;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/UpdateEmployeeServlet")
public class UpdateEmployeeServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

	@Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int employeeId = Integer.parseInt(request.getParameter("employeeId"));
        String status = request.getParameter("status");

        boolean activeStatus = status.equals("active");

        try {
            EmployeeDAO.updateEmployeeStatus(employeeId, activeStatus);
            List<Employee> employees = EmployeeDAO.getAllEmployees();

            HttpSession session = request.getSession();
            session.setAttribute("employees", employees);
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        }

        response.sendRedirect("add_employee.jsp");
    }
}
