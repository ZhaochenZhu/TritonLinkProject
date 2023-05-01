package com.mit;
import java.sql.*;
public class StudentDAO {

	static Connection conn;
	static PreparedStatement pst;
	
	public static int insertStudent(StudentBean s) {
		int status = 0;
		try {
			conn = ConnectionProvider.getCon();
			pst=conn.prepareStatement("insert into student values(?,?,?,?,?,?,?,?)");
			pst.setInt(1,s.getStudent_id());
			pst.setString(2, s.getFirst_name());
			pst.setString(3, s.getLast_name());
			pst.setString(4, s.getMiddle_name());
			pst.setInt(5, s.getSsn());
			pst.setString(6, s.getEnrolled());
			pst.setString(7, s.getResidential_status());
			pst.setString(8, s.getCurrent_degree());
			status=pst.executeUpdate();
			conn.close();
		}catch(Exception ex) {
			System.out.println(ex);
		}
		return status;
	}
}
