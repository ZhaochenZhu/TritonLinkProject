package com.mit;
import java.sql.*;
public class DegreesDAO {
    static Connection conn;
	static PreparedStatement pst;

    public static int insertDegrees(DegreesBean d) {
        int status = 0;
		try {
			conn = ConnectionProvider.getCon();
			pst=conn.prepareStatement("insert into student values(?,?,?,?,?)");
			pst.setString(1, d.getMajor());
            pst.setString(2, d.getType());
			pst.setString(3, d.getCategory());
			pst.setInt(4,d.getMinimum_unit());
            pst.setString(5, d.getMinimum_grade());
			status=pst.executeUpdate();
			conn.close();
		}catch(Exception ex) {
			System.out.println(ex);
		}
		return status;
    }
}
