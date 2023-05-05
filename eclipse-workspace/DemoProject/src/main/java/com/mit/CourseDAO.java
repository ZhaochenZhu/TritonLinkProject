package com.mit;
import java.sql.*;
public class CourseDAO {
    
    static Connection conn;
	static PreparedStatement pst;
	
    public static int insertCourset(CourseBean c) {
		int status = 0;
		try {
			conn = ConnectionProvider.getCon();
			pst=conn.prepareStatement("insert into course info(?,?,?,?)");
			pst.setString(1,c.getCourse_number());
			pst.setString(2, c.getCourse_number());
			pst.setString(3, c.getDepartment());
			pst.setString(4, c.getLab_requirment());
			status=pst.executeUpdate();
			conn.close();
		}catch(Exception ex) {
			System.out.println(ex);
		}
		return status;
	}
}