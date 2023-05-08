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
		<td><a href="root.jsp">Go Back</a></td>
    </TR>
</TABLE>

<H1>Adding Courses taken</H1>
<form name = "f1" method="get">
<input type="hidden" value="insert" name="action">
Student ID: <input type="text" name="student_id" size="5"/>
Course number: <input type="text" name="course_number" size="5"/>
Section ID: <input type="text" name="section_id" size="5"/>
Year: <input type="text" name="year" size="2"/>
Unit: <input type="text" name="unit" size="5"/>
Grade: <input type="text" name="grade" size="2"/>
Professor: <input type="text" name="professor" size="5"/>
<input type="submit" value="Insert"/>
</form>

<%
String action = request.getParameter("action");
if (action != null && action.equals("insert")) {
	Connection conn = ConnectionProvider.getCon();
	conn.setAutoCommit(false);
	// Create the prepared statement and use it to
	// INSERT the courses_taken attrs INTO the courses_taken table.
	PreparedStatement pstmt = conn.prepareStatement(
	("INSERT INTO courses_taken VALUES (?, ?, ?, ?, ?, ?, ?)"));
	pstmt.setInt(1,Integer.parseInt(request.getParameter("student_id")));
	pstmt.setString(2, request.getParameter("course_number"));
	pstmt.setString(3, request.getParameter("section_id"));
	pstmt.setInt(4, Integer.parseInt(request.getParameter("year")));
	pstmt.setInt(5, Integer.parseInt(request.getParameter("unit")));
	pstmt.setString(6, request.getParameter("grade"));
	pstmt.setString(7, request.getParameter("professor"));
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
	// UPDATE the courses taken attributes in the courses_taken table.
	PreparedStatement pstmt = conn.prepareStatement(
	"UPDATE courses_taken SET unit = ?, grade = ?, professor = ? WHERE student_id = ? AND course_number = ? AND section_id = ? AND year = ?");	
	pstmt.setInt(1,Integer.parseInt(request.getParameter("unit")));
	pstmt.setString(2, request.getParameter("grade"));
	pstmt.setString(3, request.getParameter("professor"));	
	pstmt.setInt(4, Integer.parseInt(request.getParameter("student_id")));
	pstmt.setString(5, request.getParameter("course_number"));
	pstmt.setString(6, request.getParameter("section_id"));
	pstmt.setInt(7,Integer.parseInt(request.getParameter("year")));
	
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
	// DELETE the courses_taken FROM the courses_taken table.
	PreparedStatement pstmt = conn.prepareStatement(
	"DELETE FROM courses_taken WHERE student_id = ? AND course_name = ? AND section_id = ? AND year = ?");
	pstmt.setInt(1,Integer.parseInt(request.getParameter("student_id")));
    pstmt.setString(1,request.getParameter("course_number"));
    pstmt.setString(1,request.getParameter("section_id"));
    pstmt.setInt(1,Integer.parseInt(request.getParameter("year")));
    

	int rowCount = pstmt.executeUpdate();
	conn.commit();
	conn.setAutoCommit(true);
	conn.close();
}
%><br><br>

<H1>Current Students</H1>
       <%
           Connection connection = ConnectionProvider.getCon();
           Statement statement = connection.createStatement() ;
           ResultSet resultset = statement.executeQuery("select * from courses_taken") ;
       %>
      <TABLE BORDER="1">
      <TR>
      <TH>student_id</TH>
      <TH>course_number</TH>
      <TH>section_id</TH>
      <TH>year</TH>
      <TH>unit</TH>
      <TH>grade</TH>
      <TH>professor</TH>
      </TR>
      <% while(resultset.next()){ %>
      <TR>
      <form action="courses_taken.jsp" method="get">
      <input type="hidden" value="update" name="action">
      <td><input value="<%= resultset.getInt(1) %>" name="student_id"></td>
	  <td><input value="<%= resultset.getString(2) %>" name="course_number"></td>      
      <TD><input value="<%= resultset.getString(3) %>" name="section_id"></TD>
      <TD><input value="<%= resultset.getInt(4) %>" name="year"></TD>
      <TD><input value="<%= resultset.getInt(5) %>" name="unit"> </TD>
      <TD><input value="<%= resultset.getString(6) %>" name="grade"></TD>
      <TD><input value="<%= resultset.getString(7) %>" name="professor"> </TD>
      <td><input type="submit" value="Update"></td>
      </form>
       <form action="courses_taken.jsp" method="get">
		<input type="hidden" value="delete" name="action">
		<input type="hidden" value="<%= resultset.getInt(1) %>" name="student_id">
		<input type="hidden" value="<%= resultset.getString(2) %>" name="course_number">
		<input type="hidden" value="<%= resultset.getString(3) %>" name="section_id">
		<input type="hidden" value="<%= resultset.getInt(1) %>" name="year">
		<td><input type="submit" value="Delete"></td>
		</form>
      </TR>
      <% } %>
     </TABLE>

</body>
</html>