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
<title>Faculty</title>
</head>
<body>
<TABLE>
      <TR>
		<td><a href="root.jsp">Go Back</a></td>
    </TR>
</TABLE>

<H1>Adding Faculty</H1>
<form name = "f1" method="get">
<input type="hidden" value="insert" name="action">
faculty name: <input type="text" name="faculty_name" size="20"/>
<%--<input type="text" name="title" size="20"/> --%>
title: 
<select name="title" id="title">
  <option value="">Select One</option>
  <option value="Lecturer">Lecturer</option>
  <option value="Assistant Professor">Assistant Professor</option>
  <option value="Associate Professor">Associate Professor</option>
  <option value="Professor">Professor</option>
</select>
<input type="submit" value="Insert"/>
</form>

<form name = "f2" method="get">
<input type="hidden" value="insert_dpt" name="action">
faculty name: <input type="text" name="faculty_name" size="20"/>
department: <input type="text" name="department" size="20"/>
<input type="submit" value="Insert"/>
</form>

<%
String action = request.getParameter("action");
if (action != null && action.equals("insert")) {
	Connection conn = ConnectionProvider.getCon();
	conn.setAutoCommit(false);
	// Create the prepared statement and use it to
	// INSERT the student attrs INTO the Student table.
	try{
	PreparedStatement pstmt = conn.prepareStatement(
	("INSERT INTO faculty VALUES (?, ?)"));
	pstmt.setString(1,request.getParameter("faculty_name"));
	pstmt.setString(2, request.getParameter("title"));
	pstmt.executeUpdate();
	}catch(Exception ex){
		out.println(ex.getMessage());
	}
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
if (action != null && action.equals("insert_dpt")) {
	Connection conn = ConnectionProvider.getCon();
	conn.setAutoCommit(false);
	try{
	PreparedStatement pstmt = conn.prepareStatement(
	("INSERT INTO faculty_department VALUES (?, ?)"));
	pstmt.setString(1,request.getParameter("faculty_name"));
	pstmt.setString(2, request.getParameter("department"));
	pstmt.executeUpdate();
	}catch(Exception ex){
		out.println(ex.getMessage());		
	}
	conn.commit();
	conn.setAutoCommit(true);
	conn.close();
}
if (action != null && action.equals("update_dpt")) {
	Connection conn = ConnectionProvider.getCon();
	conn.setAutoCommit(false);
	// Create the prepared statement and use it to
	// UPDATE the student attributes in the Student table.
	PreparedStatement pstatement = conn.prepareStatement(
	"UPDATE faculty_department SET department = ? WHERE faculty_name = ?");
	pstatement.setString(1, request.getParameter("department"));
	pstatement.setString(2, request.getParameter("faculty_name"));
	int rowCount = pstatement.executeUpdate();
	conn.commit();
	conn.setAutoCommit(true);
	conn.close();
}
if (action != null && action.equals("delete_dpt")) {
	Connection conn = ConnectionProvider.getCon();
	conn.setAutoCommit(false);
	// Create the prepared statement and use it to
	// DELETE the student FROM the Student table.
	PreparedStatement pstmt = conn.prepareStatement(
	"DELETE FROM faculty_department WHERE faculty_name = ?");
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

<H1>Faculty-Department</H1>
       <%
           connection = ConnectionProvider.getCon();
           Statement statement_dpt = connection.createStatement() ;
          ResultSet resultset_dpt = statement_dpt.executeQuery("select * from faculty_department ") ;
       %>
      <TABLE BORDER="1">
      <TR>
      <TH>faculty_name</TH>
      <TH>department</TH>
      </TR>
      <% while(resultset_dpt.next()){ %>
      	<tr>
		<form action="faculty.jsp" method="get">
		<input type="hidden" value="update_dpt" name="action">
		<td><input value="<%= resultset_dpt.getString(1) %>" name="faculty_name"></td>
		<td><input value="<%= resultset_dpt.getString(2) %>" name="department"></td>
		<td><input type="submit" value="Update"></td>
		</form>
		<form action="faculty.jsp" method="get">
		<input type="hidden" value="delete_dpt" name="action">
		<input type="hidden" value="<%= resultset_dpt.getString(1) %>" name="faculty_name">
		<td><input type="submit" value="Delete"></td>
		</form>
		</tr>
      <% } %>
     </TABLE>


</body>
</html>