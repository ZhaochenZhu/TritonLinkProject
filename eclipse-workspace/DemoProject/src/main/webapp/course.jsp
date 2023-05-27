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
<title>Courses</title>
</head>
<body>
<TABLE>
      <TR>
        <td><a href="root.jsp">Go Back</a></td>
    </TR>
</TABLE>

<H1>Adding Course</H1>
<form name = "f1" method="get">
<input type="hidden" value="insert" name="action">
Course number: <input type="text" name="course_number" size="5"/>
Course name: <input type="text" name="course_name" size="5"/>
Department: <input type="text" name="department" size="5"/>
Lab requirement: 
<%--<input type="text" name="lab_requirement" size="2"/> --%>
<select name="lab_requirement" id="lab_requirement">
  <option value="">Select One</option>
  <option value="Yes">Yes</option>
  <option value="No">No</option>
</select>
<input type="submit" value="Insert"/>
</form>

<H2>Adding Prerequisite</H1>
<form name = "f2" method="get">
<input type="hidden" value="insert_pre_req" name="action">
Course number: <input type="text" name="course_number" size="5"/>
Prerequisite: <input type="text" name="prereq_number" size="5"/>
<input type="submit" value="Insert"/>
</form>

<%
String action = request.getParameter("action");
if (action != null && action.equals("insert")) {
	Connection conn = ConnectionProvider.getCon();
	conn.setAutoCommit(false);
	// Create the prepared statement and use it to
	// INSERT the student attrs INTO the Course table.
	PreparedStatement pstmt = conn.prepareStatement(
	("INSERT INTO course_info VALUES (?, ?, ?, ?)"));
	pstmt.setString(1, request.getParameter("course_number"));
	pstmt.setString(2, request.getParameter("course_name"));
	pstmt.setString(3, request.getParameter("department"));
	pstmt.setString(4, request.getParameter("lab_requirement"));
	pstmt.executeUpdate();
	conn.commit();
	conn.setAutoCommit(true);
	conn.close();
}

if (action != null && action.equals("insert_pre_req")) {
	Connection conn = ConnectionProvider.getCon();
	conn.setAutoCommit(false);
	// Create the prepared statement and use it to
	// INSERT the student attrs INTO the Course table.
	PreparedStatement pstmt = conn.prepareStatement(
	("INSERT INTO prerequisite  VALUES (?, ?)"));
	pstmt.setString(1, request.getParameter("course_number"));
	pstmt.setString(2, request.getParameter("prereq_number"));
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
	// UPDATE the student attributes in the Course table.
	PreparedStatement pstmt = conn.prepareStatement(
	"UPDATE course_info SET course_name = ?, department = ?, lab_requirement = ? WHERE course_number = ?");	
	pstmt.setString(4, request.getParameter("course_number"));
	pstmt.setString(1, request.getParameter("course_name"));
	pstmt.setString(2, request.getParameter("department"));	
	pstmt.setString(3, request.getParameter("lab_requirement"));
	
	// out.println(pstmt.toString());
	// System.out.println(pstmt.toString());
	int rowCount = pstmt.executeUpdate();
	conn.commit();
	conn.setAutoCommit(true);
	conn.close();
	}catch(Exception ex){
		System.out.println(ex);
	}
}
if (action != null && action.equals("delete")) {
	Connection conn = ConnectionProvider.getCon();
	conn.setAutoCommit(false);
	// Create the prepared statement and use it to
	// DELETE the student FROM the Course table.
	PreparedStatement pstmt = conn.prepareStatement(
	"DELETE FROM course_info WHERE course_number = ?");
	pstmt.setString(1,request.getParameter("course_number"));
	int rowCount = pstmt.executeUpdate();
	conn.commit();
	conn.setAutoCommit(true);
	conn.close();
}
%><br><br>

<H1>Courses</H1>
       <%
           Connection connection = ConnectionProvider.getCon();
           Statement statement = connection.createStatement() ;
           ResultSet resultset = statement.executeQuery("select * from course_info") ;
       %>
      <TABLE BORDER="1">
      <TR>
      <TH>course_number</TH>
      <TH>course_name</TH>
      <TH>department</TH>
      <TH>lab_requirement</TH>
      </TR>
      <% while(resultset.next()){ %>
      <TR>
      <form action="course.jsp" method="get">
      <input type="hidden" value="update" name="action">
      <td><input value="<%= resultset.getString(1) %>" name="course_number"></td>
	  <td><input value="<%= resultset.getString(2) %>" name="course_name"></td>      
      <TD><input value="<%= resultset.getString(3) %>" name="department"></TD>
      <TD><input value="<%= resultset.getString(4) %>" name="lab_requirement"></TD>
      <td><input type="submit" value="Update"></td>
      </form>
       <form action="course.jsp" method="get">
		<input type="hidden" value="delete" name="action">
		<input type="hidden" value="<%= resultset.getString(1) %>" name="course_number">
		<td><input type="submit" value="Delete"></td>
		</form>
      </TR>
      <% } %>
     </TABLE>

</body>
</html>