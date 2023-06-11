<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.sql.*, com.mit.*"%>
<!DOCTYPE html>
<html>
<head>
<style>
table { 
	border-collapse: separate; border-spacing: 5px; 
}
</style>
<meta charset="UTF-8">
<title>Register Attendance</title>
</head>
<body>
<TABLE>
      <TR>
      <td><a href="student.jsp">Go Back</a></td>
    </TR>
</TABLE>

<H1>Register Attendance</H1>
<form name = "f1" method="get">
<input type="hidden" value="insert" name="action">
Student ID: <input type="text" name="student_id" size="5"/>
Quarter: 
<select name="quarter" id="quarter">
  <option value="">Select One</option>
  <option value="Fall">Fall</option>
  <option value="Winter">Winter</option>
  <option value="Spring">Spring</option>
  <option value="Summer">Summer</option>
</select>
Year: <input type="text" name="year" size="5"/>
Enrolled:
<select name="enrolled" id="enrolled">
  <option value="">Select One</option>
  <option value="Yes">Yes</option>
  <option value="No">No</option>
</select>
<input type="submit" value="Insert"/>
</form>

<%
String action = request.getParameter("action");
if (action != null && action.equals("insert")) {
	Connection conn = ConnectionProvider.getCon();
	conn.setAutoCommit(false);
	// Create the prepared statement and use it to
	// INSERT the student attrs INTO the Course table.
	try{
	PreparedStatement pstmt = conn.prepareStatement(
	("INSERT INTO student_period_attendance VALUES (?, ?, ?, ?)"));
	pstmt.setInt(1, Integer.parseInt(request.getParameter("student_id")));
	pstmt.setString(2, request.getParameter("quarter"));
	pstmt.setInt(3, Integer.parseInt(request.getParameter("year")));
	pstmt.setString(4, request.getParameter("enrolled"));
	pstmt.executeUpdate();
	}catch(Exception e){
		out.println(e);
	}
	conn.commit();
	conn.setAutoCommit(true);
	conn.close();
}

if (action != null && action.equals("update")) {
	//try{
	Connection conn = ConnectionProvider.getCon();
	conn.setAutoCommit(false);
	// Create the prepared statement and use it to
	// UPDATE the student attributes in the Course table.
	try{
	PreparedStatement pstmt = conn.prepareStatement(
	"UPDATE student_period_attendance SET enrolled = ? WHERE student_id = ? AND quarter = ? AND year = ?");	
	pstmt.setString(1, request.getParameter("enrolled"));
	pstmt.setInt(2, Integer.parseInt(request.getParameter("student_id")));
	pstmt.setString(3, request.getParameter("quarter"));
	pstmt.setInt(4, Integer.parseInt(request.getParameter("year")));
	
	// out.println(pstmt.toString());
	// System.out.println(pstmt.toString());
	int rowCount = pstmt.executeUpdate();
	}catch(Exception e){
		out.println(e);
	}
	conn.commit();
	conn.setAutoCommit(true);
	conn.close();
	//}catch(Exception ex){
		//System.out.println(ex);
	//}
}

if (action != null && action.equals("delete")) {
	Connection conn = ConnectionProvider.getCon();
	conn.setAutoCommit(false);
	// Create the prepared statement and use it to
	// DELETE the student FROM the Course table.
	try{
	PreparedStatement pstmt = conn.prepareStatement(
	"DELETE FROM student_period_attendance WHERE student_id = ? AND quarter = ? AND year = ?");
	pstmt.setInt(1, Integer.parseInt(request.getParameter("student_id")));
	pstmt.setString(2, request.getParameter("quarter"));
	pstmt.setInt(3, Integer.parseInt(request.getParameter("year")));
	int rowCount = pstmt.executeUpdate();
	}catch(Exception e){
		out.println(e);
	}
	conn.commit();
	conn.setAutoCommit(true);
	conn.close();
}
%><br><br>

<H1>Attendance</H1>
       <%
           Connection connection = ConnectionProvider.getCon();
           Statement statement = connection.createStatement() ;
           ResultSet resultset = statement.executeQuery("select * from student_period_attendance order by student_id") ;
       %>
      <TABLE BORDER="1">
      <TR>
      <th>student_id</th>
      <th>year</th>
      <TH>quarter</TH>
      <TH>enrolled</TH>
      </TR>
      <% while(resultset.next()){
      %>
      <TR>
      <form action="student_period_attendance.jsp" method="get">
      <input type="hidden" value="update" name="action">
      <td><input value="<%= resultset.getInt(1) %>" name="student_id"></td>	        
      <TD><input value="<%= resultset.getInt(3) %>" name="year"></TD>
      <td><input value="<%= resultset.getString(2) %>" name="quarter"></td>
      <td><input value="<%= resultset.getString(4) %>" name="enrolled"></td>
      <td><input type="submit" value="Update"></td>
      </form>
       <form action="student_period_attendance.jsp" method="get">
		<input type="hidden" value="delete" name="action">
		<input type="hidden" value="<%= resultset.getInt(1) %>" name="student_id">
	  <input type="hidden" value="<%= resultset.getInt(3) %>" name="year">     
      <input type="hidden" value="<%= resultset.getString(2) %>" name="quarter">
		<td><input type="submit" value="Delete"></td>
		</form>
      </TR>
      <% } %>
     </TABLE>

</body>
</html>