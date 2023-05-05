package com.mit;
import java.sql.*;
public class Thesis_committeeDAO {
    static Connection conn;
	static PreparedStatement pst;

    public static int insertThesis_committee(Thesis_committeeBean t) {
        int status = 0;
        try{
            conn = ConnectionProvider.getCon();
			pst=conn.prepareStatement("insert into student values(?,?,?,?,?,?,?,?)");
			pst.setInt(1,t.getStudent_id());
			pst.setString(2, t.getFaculty_name());
			status=pst.executeUpdate();
			conn.close();
		}catch(Exception ex) {
			System.out.println(ex);
		}
		return status;
    }
}
