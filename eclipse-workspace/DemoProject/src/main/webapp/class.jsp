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
      <td><a href="course.jsp">faculty</a></td>
      <td><a href="class.jsp">faculty</a></td>
      </TR>
</TABLE>

<H1>Adding Class</H1>
<form name = "f1" method="get">
<input type="hidden" value="insert" name="action">
Year: <input type="text" name="year" size="5"/>
Section id: <input type="text" name="section_id" size="5"/>
Course number: <input type="text" name="course_number" size="5"/>
Quarter: <input type="text" name="quarter" size="2"/>
Units: <input type="text" name="units" size="5"/>
Start date: <input type="text" name="start_date" size="2"/>
End date: <input type="text" name="end_date" size="5"/>
Professor: <input type="text" name="professor" size="5"/>
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
	("INSERT INTO section VALUES (?, ?, ?, ?, ?, ?, ?, ?)"));
	pstmt.setInt(1,Integer.parseInt(request.getParameter("year")));
	pstmt.setString(2, request.getParameter("section_id"));
	pstmt.setString(3, request.getParameter("course_number"));
	pstmt.setString(4, request.getParameter("quarter"));
	pstmt.setInt(5, Integer.parseInt(request.getParameter("units")));
	pstmt.setString(6, request.getParameter("start_date"));
	pstmt.setString(7, request.getParameter("end_date"));
	pstmt.setString(8, request.getParameter("professor"));
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
	"UPDATE section SET quarter = ?, units = ?, start_date = ?, end_date = ?, professor = ? WHERE year = ?, section_id = ?, course_number = ?");	
	pstmt.setString(1, request.getParameter("quartere"));
    pstmt.setInt(2, Integer.parseInt(request.getParameter("units")));
	pstmt.setString(3, request.getParameter("start_date"));
	pstmt.setString(4, request.getParameter("end_date"));	
	pstmt.setString(5, request.getParameter("professor"));
	pstmt.setInt(6,Integer.parseInt(request.getParameter("year")));
    pstmt.setString(7, request.getParameter("section_id"));
	pstmt.setString(8, request.getParameter("course_number"));
	
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
	// DELETE the class FROM the section table.
	PreparedStatement pstmt = conn.prepareStatement(
	"DELETE FROM section WHERE year = ?, section_id = ?, course_number = ?");
	pstmt.setInt(1,Integer.parseInt(request.getParameter("student_id")));
	pstmt.setString(2, request.getParameter("section_id"));
	pstmt.setString(3, request.getParameter("course_number"));
    int rowCount = pstmt.executeUpdate();
	conn.commit();
	conn.setAutoCommit(true);
	conn.close();
}
%><br><br>

<H1>Class Sections</H1>
       <%
           Connection connection = ConnectionProvider.getCon();
           Statement statement = connection.createStatement() ;
           ResultSet resultset = statement.executeQuery("select * from sectiont") ;
       %>
      <TABLE BORDER="1">
      <TR>
      <TH>year</TH>
      <TH>section_id</TH>
      <TH>course_number</TH>
      <TH>quarter</TH>
      <TH>units</TH>
      <TH>start_date</TH>
      <TH>end_date</TH>
      <TH>professor</TH>
      </TR>
      <% while(resultset.next()){ %>
      <TR>
      <form action="student.jsp" method="get">
      <input type="hidden" value="update" name="action">
      <td><input value="<%= resultset.getInt(1) %>" name="year"></td>
	  <td><input value="<%= resultset.getString(2) %>" name="section_id"></td>      
      <TD><input value="<%= resultset.getString(3) %>" name="course_number"></TD>
      <TD><input value="<%= resultset.getString(4) %>" name="quarter"></TD>
      <TD><input value="<%= resultset.getInt(5) %>" name="units"> </TD>
      <TD><input value="<%= resultset.getString(6) %>" name="start_date"></TD>
      <TD><input value="<%= resultset.getString(7) %>" name="end_date"> </TD>
      <TD><input value="<%= resultset.getString(8) %>" name="professor"></TD>
      <td><input type="submit" value="Update"></td>
      </form>
       <form action="class.jsp" method="get">
		<input type="hidden" value="delete" name="action">
		<input type="hidden" value="<%= resultset.getInt(1) %>" name="year">
        <td><input value="<%= resultset.getString(2) %>" name="section_id"></td>      
        <TD><input value="<%= resultset.getString(3) %>" name="course_number"></TD>  
		<td><input type="submit" value="Delete"></td>
		</form>
      </TR>
      <% } %>
     </TABLE>

</body>
</html>