package com.restaurantdb.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

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
	private int generateEmployeeID() throws ClassNotFoundException {
        int newEmpID = 1000; // Default starting ID

        String query = "SELECT MAX(employee_id) FROM employees"; // Get the last employee ID
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query);
             ResultSet rs = pstmt.executeQuery()) {

            if (rs.next()) {
                int lastEmpID = rs.getInt(1); // Get the highest emp_id
                if (lastEmpID >= 1000) {
                    newEmpID = lastEmpID + 1; // Increment
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return newEmpID;
    }
	
	private int getRoleID(String rolename) throws ClassNotFoundException, SQLException {
		String sql="SELECT role_id FROM roles WHERE role_name =?";
		try(Connection con=DBUtil.getConnection();
				PreparedStatement st=con.prepareStatement(sql)){
				st.setString(1, rolename);
				ResultSet rs=st.executeQuery();
				if(rs.next()) {
					return rs.getInt("role_id");
				}
		}catch(Exception e) {
			e.printStackTrace();
		
		}
		return -1;
	}
	
	
	public boolean addEmployee(Employee employee) throws ClassNotFoundException, SQLException {
		int roleId=getRoleID(employee.getRoleName());
		if(roleId==-1) {
			System.out.println("role does not exist ,employee not added");
			return false;
			
		}
		int empId=generateEmployeeID();
		String sql="INSERT INTO employees(employee_id,name,phone,role_id,password) VALUES(?,?,?,?,?)";
		try(Connection con=DBUtil.getConnection();
				PreparedStatement st=con.prepareStatement(sql)){
			st.setInt(1, empId);
			st.setString(2, employee.getEmp_name());
			st.setString(3, employee.getPhone());
			st.setInt(4, roleId);
			st.setString(5,employee.getPassword() );
			int rows=st.executeUpdate();
			return rows>0;
		}catch(Exception e) {
			e.printStackTrace();
			return false;
		}
		
	}
	public int createRole(String roleName) throws ClassNotFoundException {
        String insertRoleSql = "INSERT INTO roles (role_name) VALUES (?)";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement insertStmt = conn.prepareStatement(insertRoleSql, PreparedStatement.RETURN_GENERATED_KEYS)) {

            insertStmt.setString(1, roleName);
            int rowsInserted = insertStmt.executeUpdate();

            if (rowsInserted > 0) {
                ResultSet generatedKeys = insertStmt.getGeneratedKeys();
                if (generatedKeys.next()) {
                    return generatedKeys.getInt(1); // Return new role ID
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1; // Error case
    }
	public boolean checkRoleExists(String roleName) throws ClassNotFoundException {
        String query = "SELECT role_id FROM roles WHERE role_name = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setString(1, roleName);
            ResultSet rs = stmt.executeQuery();
            return rs.next(); // If role exists, return true

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
	public static List<Employee> getAllEmployees() throws ClassNotFoundException, SQLException {
        List<Employee> employees = new ArrayList<>();
        String sql = "SELECT e.employee_id, e.name, e.phone, e.is_active, r.role_name " +
                     "FROM EMPLOYEES e " +
                     "JOIN ROLES r ON e.role_id = r.role_id";

        try (Connection con = DBUtil.getConnection();
             PreparedStatement st = con.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {

            while (rs.next()) {
                Employee emp = new Employee();
                emp.setEmpID(rs.getInt("employee_id"));
                emp.setEmp_name(rs.getString("name"));
                emp.setPhone(rs.getString("phone"));
                emp.setActive(rs.getBoolean("is_active"));
                emp.setRole(rs.getString("role_name"));
                employees.add(emp);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return employees;
    }
	public static boolean updateEmployeeStatus(int employeeId, boolean activeStatus) throws ClassNotFoundException, SQLException {
        String sql = "UPDATE employees SET is_active = ? WHERE employee_id = ?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement st = con.prepareStatement(sql)) {
            st.setBoolean(1, activeStatus);
            st.setInt(2, employeeId);
            int rows = st.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}

