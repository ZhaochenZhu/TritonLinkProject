package com.mit;
import java.sql.*;
public class Courses_takenDAO {
    static Connection conn;
	static PreparedStatement pst;

    public static int insertCourses_taken(Courses_takenBean c) {
        int status = 0;
        try{
            conn = ConnectionProvider.getCon();
			pst=conn.prepareStatement("insert into student values(?,?,?,?,?,?,?,?)");
			pst.setInt(1,c.getStudent_id());
			pst.setString(2, c.getCourse_number());
			pst.setString(3, c.getSection_id());
			pst.setInt(4, c.getYear());
			pst.setInt(5, c.getUnit());
			pst.setString(6, c.getGrade());
			pst.setString(7, c.getProfessor());
			status=pst.executeUpdate();
			conn.close();
		}catch(Exception ex) {
			System.out.println(ex);
		}
		return status;
    }
}
