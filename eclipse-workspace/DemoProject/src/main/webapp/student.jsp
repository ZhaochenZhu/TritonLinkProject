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
		<td><a href="class.jsp">class</a></td>
		<td><a href="degrees.jsp">degrees</a></td>
		<td><a href="student_probation.jsp">student probation</a></td>  
		<td><a href="thesis_committee.jsp">thesis committee</a></td>  
		<td><a href="courses_taken.jsp">courses taken</a></td>  
    </TR>
</TABLE>

<H1>Adding Student</H1>
<form name = "f1" method="get">
<input type="hidden" value="insert" name="action">
Student ID: <input type="text" name="student_id" size="5"/>
First name: <input type="text" name="first_name" size="5"/>
Last name: <input type="text" name="last_name" size="5"/>
Middle name: <input type="text" name="middle_name" size="2"/>
SSN: <input type="text" name="ssn" size="5"/>
Enrolled: <input type="text" name="enrolled" size="2"/>
Residential_status: <input type="text" name="residential_status" size="5"/>
Current Degree: <input type="text" name="current_degree" size="5"/>
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
	("INSERT INTO student VALUES (?, ?, ?, ?, ?, ?, ?, ?)"));
	pstmt.setInt(1,Integer.parseInt(request.getParameter("student_id")));
	pstmt.setString(2, request.getParameter("first_name"));
	pstmt.setString(3, request.getParameter("last_name"));
	pstmt.setString(4, request.getParameter("middle_name"));
	pstmt.setInt(5, Integer.parseInt(request.getParameter("ssn")));
	pstmt.setString(6, request.getParameter("enrolled"));
	pstmt.setString(7, request.getParameter("residential_status"));
	pstmt.setString(8, request.getParameter("current_degree"));
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
	"UPDATE student SET first_name = ?, last_name = ?, middle_name = ?, ssn = ?, enrolled = ?, residential_status = ?, current_degree = ? WHERE student_id = ?");	
	pstmt.setString(1, request.getParameter("first_name"));
	pstmt.setString(2, request.getParameter("last_name"));
	pstmt.setString(3, request.getParameter("middle_name"));	
	pstmt.setInt(4, Integer.parseInt(request.getParameter("ssn")));
	pstmt.setString(5, request.getParameter("enrolled"));
	pstmt.setString(6, request.getParameter("residential_status"));
	pstmt.setString(7, request.getParameter("current_degree"));
	pstmt.setInt(8,Integer.parseInt(request.getParameter("student_id")));
	
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
	// DELETE the student FROM the Student table.
	PreparedStatement pstmt = conn.prepareStatement(
	"DELETE FROM student WHERE student_id = ?");
	pstmt.setInt(1,Integer.parseInt(request.getParameter("student_id")));
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
           ResultSet resultset = statement.executeQuery("select * from student") ;
       %>
      <TABLE BORDER="1">
      <TR>
      <TH>student_id</TH>
      <TH>first_name</TH>
      <TH>last_name</TH>
      <TH>middle_name</TH>
      <TH>ssn</TH>
      <TH>enrolled</TH>
      <TH>residential_status</TH>
      <TH>current_degree</TH>
      </TR>
      <% while(resultset.next()){ %>
      <TR>
      <form action="student.jsp" method="get">
      <input type="hidden" value="update" name="action">
      <td><input value="<%= resultset.getInt(1) %>" name="student_id"></td>
	  <td><input value="<%= resultset.getString(2) %>" name="first_name"></td>      
      <TD><input value="<%= resultset.getString(3) %>" name="last_name"></TD>
      <TD><input value="<%= resultset.getString(4) %>" name="middle_name"></TD>
      <TD><input value="<%= resultset.getInt(5) %>" name="ssn"> </TD>
      <TD><input value="<%= resultset.getString(6) %>" name="enrolled"></TD>
      <TD><input value="<%= resultset.getString(7) %>" name="residential_status"> </TD>
      <TD><input value="<%= resultset.getString(8) %>" name="current_degree"></TD>
      <td><input type="submit" value="Update"></td>
      </form>
       <form action="student.jsp" method="get">
		<input type="hidden" value="delete" name="action">
		<input type="hidden" value="<%= resultset.getInt(1) %>" name="student_id">
		<td><input type="submit" value="Delete"></td>
		</form>
      </TR>
      <% } %>
     </TABLE>

</body>
</html>