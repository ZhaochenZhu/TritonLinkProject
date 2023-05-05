package com.mit;
import java.sql.*;
public class ClassDAO {
    static Connection conn;
	static PreparedStatement pst;

    public static int insertClass(ClassBean c) {
        int status = 0;
        try{
            conn = ConnectionProvider.getCon();
			pst=conn.prepareStatement("insert into student values(?,?,?,?,?,?,?,?)");
			pst.setInt(1,c.getYear());
			pst.setString(2, c.getSection_id());
			pst.setString(3, c.getCourse_number());
			pst.setString(4, c.getQuarter());
			pst.setInt(5, c.getUnits());
			pst.setString(6, c.getStart_date());
			pst.setString(7, c.getEnd_date());
			pst.setString(8, c.getProfessor());
			status=pst.executeUpdate();
			conn.close();
		}catch(Exception ex) {
			System.out.println(ex);
		}
		return status;

    }
    
}
