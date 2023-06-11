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
<title>Student Probation</title>
</head>
<body>
<TABLE>
      <TR>
      <td><a href="root.jsp">Go Back</a></td> 
    </TR>
</TABLE>

<H1>Adding Student Probation</H1>
<form name = "f1" method="get">
<input type="hidden" value="insert" name="action">
Student id: <input type="text" name="student_id" size="5"/>
Probation year: <input type="text" name="probation_year" size="5"/>
Probation quarter: <input type="text" name="probation_quarter" size="5"/>
Probation reason: <input type="text" name="probation_reason" size="2"/>
<input type="submit" value="Insert"/>
</form>

<%
String action = request.getParameter("action");
if (action != null && action.equals("insert")) {
	Connection conn = ConnectionProvider.getCon();
	conn.setAutoCommit(false);
	// Create the prepared statement and use it to
	// INSERT the student attrs INTO the Student table.
	PreparedStatement pstmt = conn.prepareStatement(
	("INSERT INTO student_probation VALUES (?, ?, ?, ?)"));
	pstmt.setInt(1,Integer.parseInt(request.getParameter("student_id")));
	pstmt.setInt(2,Integer.parseInt(request.getParameter("probation_year")));
	pstmt.setString(3, request.getParameter("probation_quarter"));
	pstmt.setString(4, request.getParameter("probation_reason"));
	pstmt.executeUpdate();
	conn.commit();
	conn.setAutoCommit(true);
	conn.close();
}
if (action != null && action.equals("update")) {
	try{
	Connection conn = ConnectionProvider.getCon();
	conn.setAutoCommit(false);
	// Create the prepared statement and use it to
	// UPDATE the student attributes in the Student table.
	PreparedStatement pstmt = conn.prepareStatement(
	"UPDATE student_probation SET probation_reason = ? WHERE student_id = ? AND probation_year = ? AND probation_quarter = ?");	
	pstmt.setString(1, request.getParameter("probation_reason"));
	pstmt.setInt(2, Integer.parseInt(request.getParameter("student_id")));
	pstmt.setInt(3,Integer.parseInt(request.getParameter("probation_year")));
    pstmt.setString(4, request.getParameter("probation_quarter"));
	
	//out.println(pstmt.toString());
	int rowCount = pstmt.executeUpdate();
	conn.commit();
	conn.setAutoCommit(true);
	conn.close();
	}catch(Exception ex){
		out.println(ex.getMessage());
	}
}
if (action != null && action.equals("delete")) {
	Connection conn = ConnectionProvider.getCon();
	conn.setAutoCommit(false);
	// Create the prepared statement and use it to
	// DELETE the student FROM the Student table.
	PreparedStatement pstmt = conn.prepareStatement(
	"DELETE FROM student_probation WHERE student_id = ? AND probation_year = ? AND probation_quarter = ?");
	pstmt.setInt(1,Integer.parseInt(request.getParameter("student_id")));
	pstmt.setInt(2,Integer.parseInt(request.getParameter("probation_year")));
	pstmt.setString(3, request.getParameter("probation_quarter"));
	
    int rowCount = pstmt.executeUpdate();
	conn.commit();
	conn.setAutoCommit(true);
	conn.close();
}
%><br><br>

<H1>Student Probation</H1>
       <%
           Connection connection = ConnectionProvider.getCon();
           Statement statement = connection.createStatement() ;
           ResultSet resultset = statement.executeQuery("select * from student_probation") ;
       %>
      <TABLE BORDER="1">
      <TR>
      <TH>student_id</TH>
      <TH>probation_year</TH>
      <TH>probation_quarter</TH>
      <TH>probation_reason</TH>
      </TR>
      <% while(resultset.next()){ %>
      <TR>
      <form action="student_probation.jsp" method="get">
      <input type="hidden" value="update" name="action">
      <td><input value="<%= resultset.getInt(1) %>" name="student_id" readonly></td>
	  <TD><input value="<%= resultset.getInt(2) %>" name="probation_year" readonly> </TD>
      <td><input value="<%= resultset.getString(3) %>" name="probation_quarter" readonly></td>      
      <TD><input value="<%= resultset.getString(4) %>" name="probation_reason"></TD>
      <td><input type="submit" value="Update"></td>
      </form>
       <form action="student_probation.jsp" method="get">
		<input type="hidden" value="delete" name="action">
		<input type="hidden" value="<%= resultset.getInt(1) %>" name="student_id">
		<input type="hidden" value="<%= resultset.getInt(2) %>" name="probation_year">
		<input type="hidden" value="<%= resultset.getString(3) %>" name="probation_quarter">
        <td><input type="submit" value="Delete"></td>
		</form>
      </TR>
      <% } %>
     </TABLE>

</body>
</html>