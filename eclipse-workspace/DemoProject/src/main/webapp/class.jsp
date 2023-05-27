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

<H1>Adding Class</H1>
<form name = "f1" method="get">
<input type="hidden" value="insert" name="action">
Year: <input type="text" name="year" size="5"/>
Section id: <input type="text" name="section_id" size="5"/>
Course number: <input type="text" name="course_number" size="5"/>
Quarter: 
<%--<input type="text" name="quarter" size="2"/> --%>
<select name="quarter" id="quarter">
  <option value="">Select One</option>
  <option value="Fall">Fall</option>
  <option value="Winter">Winter</option>
  <option value="Spring">Spring</option>
  <option value="Summer">Summer</option>
</select>
Units: <input type="text" name="units" size="5"/>
Start date: <input type="date" name="start_date" size="2"/>
End date: <input type="date" name="end_date" size="5"/>
Professor: <input type="text" name="professor" size="5"/>
Grading option:
<select name="grading_option" id="grading_option">
  <option value="">Select One</option>
  <option value="letter_grade">Letter Grade</option>
  <option value="s_u">S/U</option>
  <option value="both">Both</option>
</select>
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
	("INSERT INTO section VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)"));
	pstmt.setInt(1,Integer.parseInt(request.getParameter("year")));
	pstmt.setString(2, request.getParameter("section_id"));
	pstmt.setString(3, request.getParameter("course_number"));
	pstmt.setString(4, request.getParameter("quarter"));
	pstmt.setString(5, request.getParameter("units"));
	pstmt.setString(6, request.getParameter("start_date"));
	pstmt.setString(7, request.getParameter("end_date"));
	pstmt.setString(8, request.getParameter("professor"));
	pstmt.setString(9, request.getParameter("grading_option"));
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
	"UPDATE section SET quarter = ?, units = ?, start_date = ?, end_date = ?, professor = ?, grading_option = ? WHERE year = ? AND section_id = ? AND course_number = ?");	
	pstmt.setString(1, request.getParameter("quarter"));
    pstmt.setString(2, request.getParameter("units"));
	pstmt.setString(3, request.getParameter("start_date"));
	pstmt.setString(4, request.getParameter("end_date"));	
	pstmt.setString(5, request.getParameter("professor"));
	pstmt.setString(6, request.getParameter("grading_option"));
	pstmt.setInt(7,Integer.parseInt(request.getParameter("year")));
    pstmt.setString(8, request.getParameter("section_id"));
	pstmt.setString(9, request.getParameter("course_number"));
	
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
	"DELETE FROM section WHERE year = ? AND section_id = ? AND course_number = ?");
	pstmt.setInt(1,Integer.parseInt(request.getParameter("year")));
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
           ResultSet resultset = statement.executeQuery("select * from section") ;
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
      <TH>grading option</TH>
      </TR>
      <% while(resultset.next()){ %>
      <TR>
      <form action="class.jsp" method="get">
      <input type="hidden" value="update" name="action">
      <td><input value="<%= resultset.getInt(1) %>" name="year"></td>
	  <td><input value="<%= resultset.getString(2) %>" name="section_id"></td>      
      <TD><input value="<%= resultset.getString(3) %>" name="course_number"></TD>
      <TD><input value="<%= resultset.getString(4) %>" name="quarter"></TD>
      <TD><input value="<%= resultset.getString(5) %>" name="units"> </TD>
      <TD><input type = "date" value="<%= resultset.getString(6) %>" name="start_date"></TD>
      <TD><input type = "date" value="<%= resultset.getString(7) %>" name="end_date"> </TD>
      <TD><input value="<%= resultset.getString(8) %>" name="professor"></TD>
      <TD><input value="<%= resultset.getString(9) %>" name="grading_option"></TD>
      <td><input type="submit" value="Update"></td>
      </form>
       <form action="class.jsp" method="get">
		<input type="hidden" value="delete" name="action">
		<input type="hidden" value="<%= resultset.getInt(1) %>" name="year">
        <input type="hidden" value="<%= resultset.getString(2) %>" name="section_id">     
        <input type="hidden" value="<%= resultset.getString(3) %>" name="course_number">
        <td><input type="submit" value="Delete"></td>
		</form>
      </TR>
      <% } %>
     </TABLE>

<H1>Adding a Class Meeting</H1>
<form name = "f1" method="get">
<input type="hidden" value="insert" name="actionMeeting">
Year: <input type="text" name="year" size="5"/>
Section id: <input type="text" name="section_id" size="5"/>
Course number: <input type="text" name="course_number" size="5"/>
Type: <%-- <input type="text" name="type" size="6"/>--%>
<select name="type" id="type">
  <option value="">Select One</option>
  <option value="lecture">lecture</option>
  <option value="discussion">discussion</option>
  <option value="lab">lab</option>
  <option value="review_session">review session</option>
</select>
Day:  <input type="text" name="day" size="6"/>
Date: <input type="date" name="date" />
Start time: <input type="time" name="start_time" size="12"/>
End time: <input type="time" name="end_time" size="12"/>
<input type="submit" value="Insert"/>
</form>

<%
String actionMeeting = request.getParameter("actionMeeting");
if (actionMeeting != null && actionMeeting.equals("insert")) {
	Connection conn = ConnectionProvider.getCon();
	conn.setAutoCommit(false);
	// Create the prepared statement and use it to
	// INSERT the student attrs INTO the Student table.
	PreparedStatement pstmt = conn.prepareStatement(
	("INSERT INTO class_meetings_times VALUES (?, ?, ?, ?, ?, ?, ?, ?)"));
	pstmt.setInt(1,Integer.parseInt(request.getParameter("year")));
	pstmt.setString(2, request.getParameter("section_id"));
	pstmt.setString(3, request.getParameter("course_number"));
	pstmt.setString(4, request.getParameter("type"));
	pstmt.setString(5, request.getParameter("day"));
	pstmt.setString(6, request.getParameter("date"));
	pstmt.setString(7, request.getParameter("start_time"));
	pstmt.setString(8, request.getParameter("end_time"));
	pstmt.executeUpdate();
	conn.commit();
	conn.setAutoCommit(true);
	conn.close();
}
if (actionMeeting != null && actionMeeting.equals("update")) {
	try{
	Connection conn = ConnectionProvider.getCon();
	conn.setAutoCommit(false);
	// Create the prepared statement and use it to
	// UPDATE the student attributes in the Student table.
	PreparedStatement pstmt = conn.prepareStatement(
	"UPDATE class_meetings_times SET start_time= ?, end_time = ? WHERE year = ? AND section_id = ? AND course_number = ? AND type = ? AND day = ? AND date = ?");	
	pstmt.setString(1, request.getParameter("start_time"));
    pstmt.setString(2, request.getParameter("end_time"));
    pstmt.setInt(3, Integer.parseInt(request.getParameter("year")));	
    pstmt.setString(4, request.getParameter("section_id"));
    pstmt.setString(5, request.getParameter("course_number"));
	pstmt.setString(6, request.getParameter("type"));
	pstmt.setString(7, request.getParameter("day"));
	pstmt.setString(8, request.getParameter("date"));

	
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
if (actionMeeting != null && actionMeeting.equals("delete")) {
	Connection conn = ConnectionProvider.getCon();
	conn.setAutoCommit(false);
	// Create the prepared statement and use it to
	// DELETE the class FROM the section table.
	PreparedStatement pstmt = conn.prepareStatement(
	"DELETE FROM class_meetings_times WHERE year = ? AND section_id = ? AND course_number = ? AND type = ? AND day = ? AND date = ?");
	pstmt.setInt(1, Integer.parseInt(request.getParameter("year")));	
    pstmt.setString(2, request.getParameter("section_id"));
    pstmt.setString(3, request.getParameter("course_number"));
	pstmt.setString(4, request.getParameter("type"));
	pstmt.setString(5, request.getParameter("day"));
	pstmt.setString(6, request.getParameter("date"));
	
    int rowCount = pstmt.executeUpdate();
	conn.commit();
	conn.setAutoCommit(true);
	conn.close();
}
%><br><br>

<H1>Section Meeting Times</H1>
       <%
           Connection connectionMeeting = ConnectionProvider.getCon();
           Statement statementMeeting = connection.createStatement() ;
           ResultSet resultsetMeeting = statement.executeQuery("select * from class_meetings_times") ;
       %>
      <TABLE BORDER="1">
      <TR>
      <TH>year</TH>
      <TH>section_id</TH>
      <TH>course_number</TH>
      <TH>type</TH>
      <TH>day</TH>
      <TH>date</TH>
      <TH>start_time</TH>
      <TH>end_time</TH>
      </TR>
      <% while(resultsetMeeting.next()){ %>
      <TR>
      <form action="class.jsp" method="get">
      <input type="hidden" value="update" name="actionMeeting">
      <td><input value="<%= resultsetMeeting.getInt(1) %>" name="year" readonly></td>
	  <td><input value="<%= resultsetMeeting.getString(2) %>" name="section_id" readonly></td>      
      <TD><input value="<%= resultsetMeeting.getString(3) %>" name="course_number" readonly></TD>
      <TD><input value="<%= resultsetMeeting.getString(4) %>" name="type" readonly></TD>
      <TD><input value="<%= resultsetMeeting.getString(5) %>" name="day" readonly> </TD>
      <TD><input type = "date" value="<%= resultsetMeeting.getString(6) %>" name="date" readonly></TD>
      <TD><input type = "time" value="<%= resultsetMeeting.getString(7) %>" name="start_time"> </TD>
      <TD><input type = "time" value="<%= resultsetMeeting.getString(8) %>" name="end_time"></TD>
      <td><input type="submit" value="Update"></td>
      </form>
       <form action="class.jsp" method="get">
		<input type="hidden" value="delete" name="actionMeeting">
		<input type="hidden" value="<%= resultsetMeeting.getInt(1) %>" name="year">
        <input type="hidden" value="<%= resultsetMeeting.getString(2) %>" name="section_id">     
        <input type="hidden" value="<%= resultsetMeeting.getString(3) %>" name="course_number">
        <input type="hidden" value="<%= resultsetMeeting.getString(4) %>" name="type">
        <input type="hidden" value="<%= resultsetMeeting.getString(5) %>" name="day">
        <input type="hidden" value="<%= resultsetMeeting.getString(6) %>" name="date">
        <td><input type="submit" value="Delete"></td>
		</form>
      </TR>
      <% } %>
     </TABLE>

</body>
</html>