package com.restaurantdb.controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.restaurantdb.dao.SalesDAO;
import com.restaurantdb.model.Sale;

@WebServlet("/TodaySales")
public class SalesServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private SalesDAO salesDAO;

    public void init() {
        salesDAO = new SalesDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<Sale> sales = salesDAO.getTodaySales();
            request.setAttribute("sales", sales);
            request.getRequestDispatcher("todaysSales.jsp").forward(request, response);
        } catch (SQLException | ClassNotFoundException e) {
            throw new ServletException(e);
        }
    }
}
