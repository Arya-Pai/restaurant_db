package com.restaurantdb.controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import com.restaurantdb.dao.TableDAO;
import com.restaurantdb.model.Table;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Servlet implementation class TableServlet
 */
@WebServlet("/table")
public class TableServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
		HttpSession userSession = req.getSession(false);
		if (userSession == null || userSession.getAttribute("emp_id") == null) {
			res.sendRedirect("login.jsp");
			return;
		}

		TableDAO dao = new TableDAO();
		try {
			List<Table> availableTables = dao.getAvailableTables();
			
			userSession.setAttribute("tables", availableTables);
			
			res.sendRedirect("table.jsp");
		} catch (ClassNotFoundException | SQLException e) {
			e.printStackTrace();
			req.setAttribute("errorMessage", "Error fetching tables. Please try again later.");
			req.getRequestDispatcher("error.jsp").forward(req, res);
		}
	}
}
