package com.restaurantdb.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.restaurantdb.model.Employee;
import com.restaurantdb.util.DBUtil;

public class EmployeeDAO {
	
	public Employee validate(String id, String password) throws ClassNotFoundException, SQLException {
		String sql = "SELECT e.employee_id, e.name, e.is_active, r.role_id, r.role_name " +
                     "FROM EMPLOYEES e " +
                     "JOIN ROLES r ON e.role_id = r.role_id " +
                     "WHERE e.employee_id = ? AND e.password = ?";

		try (Connection con = DBUtil.getConnection();
		     PreparedStatement st = con.prepareStatement(sql)) {

			int emp_id = Integer.parseInt(id);
			st.setInt(1, emp_id);
			st.setString(2, password);

			ResultSet rs = st.executeQuery();
			if (rs.next()) {
				Employee emp = new Employee();
				emp.setEmpID(rs.getInt("employee_id"));
				emp.setEmp_name(rs.getString("name"));
				emp.setActive(rs.getBoolean("is_active"));
				emp.setRole_ID(rs.getInt("role_id"));
				emp.setRole(rs.getString("role_name"));
				return emp;  
			}
		}
		return null;  
	}
}

