package com.mit;
import java.sql.*;
public class FacultyDAO {
	static Connection conn;
	static PreparedStatement pst;
	
	public static int insertFaculty(FacultyBean f) {
		int status = 0;
		try {
			conn = ConnectionProvider.getCon();
			pst=conn.prepareStatement("insert into faculty values(?,?)");
			pst.setString(1, f.getFaculty_name());
			pst.setString(2, f.getTitle());
			status=pst.executeUpdate();
			conn.close();
		}catch(Exception ex) {
			System.out.println(ex);
		}
		return status;
	}
}
