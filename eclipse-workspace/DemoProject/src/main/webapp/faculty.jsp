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
<title>Insert title here</title>
</head>
<body>
<TABLE>
      <TR>
      <td><a href="student.jsp">student</a></td>
      <td><a href="faculty.jsp">faculty</a></td>
	  <td><a href="course.jsp">course</a></td>  
	  <td><a href="class.jsp">faculty</a></td>
      <td><a href="degrees.jsp">faculty</a></td>
	</TR>
</TABLE>

<H1>Adding Faculty</H1>
<form name = "f1" method="get">
<input type="hidden" value="insert" name="action">
faculty name: <input type="text" name="faculty_name" size="20"/>
title: <input type="text" name="title" size="20"/>
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
	("INSERT INTO faculty VALUES (?, ?)"));
	pstmt.setString(1,request.getParameter("faculty_name"));
	pstmt.setString(2, request.getParameter("title"));
	pstmt.executeUpdate();
	conn.commit();
	conn.setAutoCommit(true);
	conn.close();
}
if (action != null && action.equals("update")) {
	Connection conn = ConnectionProvider.getCon();
	conn.setAutoCommit(false);
	// Create the prepared statement and use it to
	// UPDATE the student attributes in the Student table.
	PreparedStatement pstatement = conn.prepareStatement(
	"UPDATE faculty SET title = ? WHERE faculty_name = ?");
	pstatement.setString(1, request.getParameter("title"));
	pstatement.setString(2, request.getParameter("faculty_name"));
	int rowCount = pstatement.executeUpdate();
	conn.commit();
	conn.setAutoCommit(true);
	conn.close();
}
if (action != null && action.equals("delete")) {
	Connection conn = ConnectionProvider.getCon();
	conn.setAutoCommit(false);
	// Create the prepared statement and use it to
	// DELETE the student FROM the Student table.
	PreparedStatement pstmt = conn.prepareStatement(
	"DELETE FROM faculty WHERE faculty_name = ?");
	pstmt.setString(1,request.getParameter("faculty_name"));
	int rowCount = pstmt.executeUpdate();
	conn.commit();
	conn.setAutoCommit(true);
	conn.close();
}
%><br><br>

<H1>Current Faculty</H1>
       <%
           Connection connection = ConnectionProvider.getCon();
           Statement statement = connection.createStatement() ;
          ResultSet resultset = statement.executeQuery("select * from faculty") ;
       %>
      <TABLE BORDER="1">
      <TR>
      <TH>faculty_name</TH>
      <TH>title</TH>
      </TR>
      <% while(resultset.next()){ %>
      	<tr>
		<form action="faculty.jsp" method="get">
		<input type="hidden" value="update" name="action">
		<td><input value="<%= resultset.getString(1) %>" name="faculty_name"></td>
		<td><input value="<%= resultset.getString(2) %>" name="title"></td>
		<td><input type="submit" value="Update"></td>
		</form>
		<form action="faculty.jsp" method="get">
		<input type="hidden" value="delete" name="action">
		<input type="hidden" value="<%= resultset.getString(1) %>" name="faculty_name">
		<td><input type="submit" value="Delete"></td>
		</form>
		</tr>
      <% } %>
     </TABLE>


</body>
</html>