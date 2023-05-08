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
<title>Review session</title>
</head>
<body>
<TABLE>
      <TR>
			<td><a href="root.jsp">Go Back</a></td>
    </TR>
</TABLE>

<H1>Adding review session</H1>
<form name = "f1" method="get">
<input type="hidden" value="insert" name="action">
year: <input type="text" name="year" size="20"/>
section id: <input type="text" name="section_id" size="20"/>
course number: <input type="text" name="course_number" size="20"/>
day: <input type="text" name="day" size="20"/>
date: <input type="text" name="date" size="20"/>
start time: <input type="text" name="start_time" size="20"/>
end time: <input type="text" name="end_time" size="20"/>
<input type="submit" value="Insert"/>
</form>



<%
String action = request.getParameter("action");
if (action != null && action.equals("insert")) {
 Connection conn = ConnectionProvider.getCon();
 conn.setAutoCommit(false);
 // Create the prepared statement and use it to
 // INSERT the review session attrs INTO the class_meetings_time table.
 PreparedStatement pstmt = conn.prepareStatement(
 ("INSERT INTO class_meetings_times VALUES (?, ?, ?, ?, ?, ?, ?, ?)"));
 pstmt.setInt(1, Integer.parseInt(request.getParameter("year")));
    pstmt.setString(2,request.getParameter("section_id"));
 	pstmt.setString(3, request.getParameter("course_number"));
    pstmt.setString(4, "review_session");
    pstmt.setString(5, request.getParameter("day"));
    pstmt.setString(6, request.getParameter("date"));    
    pstmt.setString(7, request.getParameter("start_time"));
    pstmt.setString(8, request.getParameter("end_time"));
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
 "UPDATE class_meetings_times SET start_time = ?, end_time = ? WHERE year = ? AND section_id = ? AND course_number = ? AND type = ? AND day = ? AND date = ?");
 pstatement.setString(1, request.getParameter("start_time"));
 pstatement.setString(2, request.getParameter("end_time"));
 pstatement.setInt(3, Integer.parseInt(request.getParameter("year")));
 pstatement.setString(4,request.getParameter("section_id"));
 pstatement.setString(5, request.getParameter("course_number"));
 pstatement.setString(6, request.getParameter("type"));    
 pstatement.setString(7, request.getParameter("day"));
 pstatement.setString(8, request.getParameter("date"));    
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
 "DELETE FROM class_meetings_times WHERE year = ? AND section_id = ? AND course_number = ? AND type = ? AND day = ? AND date = ?");
 pstmt.setInt(1, Integer.parseInt(request.getParameter("year")));
 pstmt.setString(2,request.getParameter("section_id"));
 pstmt.setString(3, request.getParameter("course_number"));
 pstmt.setString(4, "review_session");
 pstmt.setString(5, request.getParameter("day"));
 pstmt.setString(6, request.getParameter("date"));
 int rowCount = pstmt.executeUpdate();
 conn.commit();
 conn.setAutoCommit(true);
 conn.close();
}

%><br><br>

<H1>Review Sessions</H1>
       <%
           Connection connection = ConnectionProvider.getCon();
           Statement statement = connection.createStatement() ;
          ResultSet resultset = statement.executeQuery("select * from class_meetings_times WHERE type = 'review_session'") ;
       %>
      <TABLE BORDER="1">
      <TR>
      <TH>Year</TH>
      <TH>Course Number</TH>
      <TH>Section ID</TH>
      <TH>Days of Week</TH>
      <TH>Date</TH>
      <TH>Start Time</TH>
      <TH>End Time</TH>
      </TR>
      <% while(resultset.next()){ %>
       <tr>
  <form action="review_session.jsp" method="get">
  <input type="hidden" value="update" name="action">
  <td><input value="<%= resultset.getInt(1) %>" name="year"></td>
  <td><input value="<%= resultset.getString(3) %>" name="course_number"></td>
  <td><input value="<%= resultset.getString(2) %>" name="section_id"></td>
  <input type="hidden" value="<%= resultset.getString(4) %>" name="type">
  <td><input value="<%= resultset.getString(5) %>" name="day"></td>
  <td><input value="<%= resultset.getString(6) %>" name="date"></td>
  <td><input value="<%= resultset.getString(7) %>" name="start_time"></td>
  <td><input value="<%= resultset.getString(8) %>" name="end_time"></td>
  <td><input type="submit" value="Update"></td>
  </form>
  <form action="review_session.jsp" method="get">
  <input type="hidden" value="delete" name="action">
  <input type="hidden" value="<%= resultset.getInt(1) %>" name="year">
        <input type="hidden" value="<%= resultset.getString(2) %>" name="section_id">
        <input type="hidden" value="<%= resultset.getString(3) %>" name="course_number">
        <input type="hidden" value="<%= resultset.getString(5) %>" name="day">
        <input type="hidden" value="<%= resultset.getString(6) %>" name="date">
        <input type="hidden" value="<%= resultset.getString(4) %>" name="type">
        
  <td><input type="submit" value="Delete"></td>
  </form>
  </tr>
      <% } %>
     </TABLE>


</body>
</html>