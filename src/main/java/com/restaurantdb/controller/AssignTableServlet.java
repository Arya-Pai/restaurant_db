package com.restaurantdb.controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class AssignTableServlet
 */
@WebServlet("/AssignTableServlet")
public class AssignTableServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		int table_id=Integer.parseInt(request.getParameter("table_id"));
		String phone=request.getParameter("phone_number");
		
	}

}
