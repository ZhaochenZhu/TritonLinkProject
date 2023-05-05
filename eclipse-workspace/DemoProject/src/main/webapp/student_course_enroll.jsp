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
	  <td><a href="student_course_enroll.jsp">Webreg</a></td>
      </TR>
</TABLE>

<H1>Enroll course</H1>
<TR>
<form name = "f1" method="get">
<input type="hidden" value="check_prereq" name="action"/>
Student ID: <input type="text" name="student_id" />
Course number: <input type="text" name="course_number"/>
<input type="submit" value="Check prereq"/>
</form>
</form>
<form action="student_course_enroll.jsp" method="get">
<input type="hidden" value="enroll_class" name="action">
<input type="hidden" value=student_id name="student_id">
<td><input type="submit" value="Enroll"></td>
</form>
</TR>
<%
String action = request.getParameter("action");
ResultSet preqs = null;
if (action != null && action.equals("check_prereq")) {
	Connection conn = ConnectionProvider.getCon();
	//conn.setAutoCommit(false);
	// Create the prepared statement and use it to
	// INSERT the student attrs INTO the Student table.
	PreparedStatement pstmt = conn.prepareStatement(
	("SELECT * FROM prerequisite WHERE course_number = ?"));
	pstmt.setString(1,request.getParameter("course_number"));
	preqs = pstmt.executeQuery();
	//conn.commit();
	//conn.setAutoCommit(true);
	//conn.close();
}
if (action != null && action.equals("enroll_class")) {
	Connection conn = ConnectionProvider.getCon();
	conn.setAutoCommit(false);
	// Create the prepared statement and use it to
	// INSERT the student attrs INTO the Student table.
	PreparedStatement pstmt = conn.prepareStatement(
	("SELECT * FROM prerequisite WHERE course_number = ?"));
	pstmt.setString(1,request.getParameter("course_number"));
	preqs = pstmt.executeQuery();
	//conn.commit();
	conn.setAutoCommit(true);
	//conn.close();
}

%>
<TABLE BORDER="1">
      <TR>
      <TH>Prerequisites</TH>
      <TH>Taken?</TH>
      </TR>
      <% if(preqs!=null){
      while(preqs.next()){ %>
      <TR>
      <td><%= preqs.getString(2) %></td>
      <%
      Connection conn = ConnectionProvider.getCon();
      String requiredCourse = preqs.getString(2);
      PreparedStatement pstmt = conn.prepareStatement(
    			("SELECT * FROM courses_taken WHERE course_number = ? AND student_id = ?"));
      pstmt.setString(1, preqs.getString(2));
      pstmt.setInt(2,Integer.parseInt(request.getParameter("student_id")));
      ResultSet rst = pstmt.executeQuery();
      String taken = rst.next()? "Yes":"No";
      %>
      <td><%= taken%></td>
      </TR>
      <% }
      }%>
     </TABLE>
</body>
</html>