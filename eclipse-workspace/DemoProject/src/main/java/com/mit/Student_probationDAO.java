package com.mit;
import java.sql.*;

public class Student_probationDAO {


	static Connection conn;
	static PreparedStatement pst;
	
	public static int insertStudent_probation(Student_probationBean s) {
		int status = 0;
		try {
			conn = ConnectionProvider.getCon();
			pst=conn.prepareStatement("insert into student values(?,?,?,?)");
			pst.setInt(1,s.getStudent_id());
			pst.setInt(2, s.getProbation_year());
			pst.setString(3, s.getProbation_quarter());
			pst.setString(4, s.getProbation_reason());
			status=pst.executeUpdate();
			conn.close();
		}catch(Exception ex) {
			System.out.println(ex);
		}
		return status;
	}
}


