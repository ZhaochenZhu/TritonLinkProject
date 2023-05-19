package com.mit;
import java.sql.*;

public class ConnectionProvider implements Provider {

	static Connection con = null;
	
	public static Connection getCon() {
		try {
			Class.forName("org.postgresql.Driver");
			con = DriverManager.getConnection(connURL,username,"");
		}catch(Exception ex) {
			System.out.println(ex);
		}
		return con;
	}
}
