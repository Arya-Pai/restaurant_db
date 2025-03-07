package com.restaurantdb.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBUtil {
	private static final String JDBC_URl="jdbc:mysql://localhost:3306/restaurant_db";
	 private static final String JDBC_USERNAME = "root";
	 private static final String JDBC_PASSWORD = "bigchill@8459";
	 static {
		 try {
	            Class.forName("com.mysql.cj.jdbc.Driver"); 
	        } catch (ClassNotFoundException e) {
	        	e.printStackTrace();
	        	throw new ExceptionInInitializerError("Failed to load MySQL driver.");
	        }
	 }
	 public static Connection getConnection() throws ClassNotFoundException,SQLException{
		 
		 return DriverManager.getConnection(JDBC_URl,JDBC_USERNAME,JDBC_PASSWORD);
	 }
}
