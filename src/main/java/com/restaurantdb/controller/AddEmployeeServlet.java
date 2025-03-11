package com.restaurantdb.controller;

import java.io.IOException;
import com.restaurantdb.dao.EmployeeDAO;
import com.restaurantdb.model.Employee;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/AddEmployeeServlet")
public class AddEmployeeServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
        String name = req.getParameter("name");
        String phone = req.getParameter("phone");
        String password = req.getParameter("password");
        String roleName = req.getParameter("role_name");
        String confirmCreateRole = req.getParameter("confirmCreateRole");
        HttpSession session = req.getSession();

        if (name == null || phone == null || password == null || roleName == null) {
            session.setAttribute("errorMessage", "All fields are required.");
            res.sendRedirect("add_employee.jsp");
            return;
        }

        EmployeeDAO dao = new EmployeeDAO();
        try {
            boolean roleExists = dao.checkRoleExists(roleName);

            if (!roleExists) {
                if ("yes".equals(confirmCreateRole)) {
                    int roleId = dao.createRole(roleName);
                    if (roleId != -1) {
                        boolean success = dao.addEmployee(new Employee(name, phone, password, roleName));
                        session.setAttribute(success ? "successMessage" : "errorMessage", 
                            success ? "Role created and employee added successfully" : "Role created but employee could not be added.");
                    } else {
                        session.setAttribute("errorMessage", "Failed to create role.");
                    }
                } else {
                    session.setAttribute("newRoleMessage", "Role '" + roleName + "' does not exist. Create it?");
                    session.setAttribute("pendingEmployee", new Employee(name, phone, password, roleName));
                }
                res.sendRedirect("add_employee.jsp");
                return;
            }

            boolean success = dao.addEmployee(new Employee(name, phone, password, roleName));
            session.setAttribute(success ? "successMessage" : "errorMessage", 
                success ? "Employee added successfully." : "Failed to add employee.");
            
            res.sendRedirect("add_employee.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "An error occurred.");
            res.sendRedirect("add_employee.jsp");
        }
    }
}
