package com.mit;
import java.sql.*;
public class FacultyDAO {
	static Connection conn;
	static PreparedStatement pst;
	
	public static int insertFaculty(FacultyBean f) {
		int status = 0;
		try {
			conn = ConnectionProvider.getCon();
			conn.setAutoCommit(false);
			pst=conn.prepareStatement("insert into faculty values(?,?)");
			pst.setString(1, f.getFaculty_name());
			pst.setString(2, f.getTitle());
			status=pst.executeUpdate();
			conn.setAutoCommit(false);
			conn.setAutoCommit(true);
			conn.close();
		}catch(Exception ex) {
			System.out.println(ex);
		}
		return status;
	}
	
	public static int deleteFaculty(FacultyBean f) {
		int status = 0;
		try {
			conn = ConnectionProvider.getCon();
			conn.setAutoCommit(false);
			pst = conn.prepareStatement(
					"DELETE FROM faculty WHERE faculty_name = ?");
			pst.setString(1, f.getFaculty_name());
			status=pst.executeUpdate();
			conn.setAutoCommit(false);
			conn.setAutoCommit(true);
			conn.close();
		}catch(Exception ex) {
			System.out.println(ex);
		}
		return status;
	}
}
