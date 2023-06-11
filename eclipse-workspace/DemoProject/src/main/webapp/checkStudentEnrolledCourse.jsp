<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.sql.*, com.mit.*"%>
<!DOCTYPE html>
<html>
<head>
<style>
table { 
	border-collapse: separate; border-spacing: 5px; 
}
<%--
body {
  text-align: center;
  max-width: max-content;
margin: auto;
}--%>
</style>
<meta charset="UTF-8">
<title>Check Student Enrollment</title>
</head>
<body>
<TABLE>
 <TR>
	<td><a href="root.jsp">Go Back</a></td>
 </TR>
</TABLE>

<h2>Select Student</h1>
<%
Connection connection = ConnectionProvider.getCon();
Statement statement = connection.createStatement() ;
ResultSet resultset = statement.executeQuery("select * from student_period_attendance where quarter = 'Spring' "
 +"AND year = 2023 AND enrolled = 'Yes'") ;
%>

<form action="checkStudentEnrolledCourse.jsp" method="get">
<input type="hidden" value="select_student" name="action">
<label for="student">Choose a student:</label>
<select name="student" id="student">
  <option value="">Select one from below</option>
	<%while(resultset.next()){  %>
  <%-- <option value="<%=resultset.getInt(1) %>"><%=resultset.getString(2)+ " "+ resultset.getString(3) %></option>--%>
  <option value="<%=resultset.getInt(1) %>"><%=resultset.getInt(1) %></option>
      <% } %>
</select>
<input type="submit" value="Select">
</form>    
  
<%
String cur_student = "";
if(request.getParameter("student")==null || request.getParameter("student").equals("")){
	cur_student = "";
}else{
	resultset = statement.executeQuery(
			"select first_name, last_name from student Where student_id = "
			+Integer.parseInt(request.getParameter("student")));
	resultset.next();
	cur_student = " by "+resultset.getString(1)+" "+ resultset.getString(2);
}
String action = request.getParameter("action");
ResultSet student_course = null;
if (action != null && action.equals("select_student")) {
	if(request.getParameter("student").equals("")){
		out.println("Please select a student");
	}else{
		resultset = statement.executeQuery("select first_name, middle_name, last_name from student WHERE student_id = "+Integer.parseInt(request.getParameter("student"))) ;
		resultset.next();
		out.println(resultset.getString(1)+","+resultset.getString(2)+","+resultset.getString(3));	
	
		PreparedStatement pstmt = connection.prepareStatement(
				"select e.section_id, e.course_number, e.grading_option, e.unit "
					+"FROM enrollment_list_of_class e, section s "
					+"WHERE e.student_id = ? "
					+"AND e.year = 2023 "
					+"and e.course_number = s.course_number "
					+"AND e.section_id = s.section_id "
					+"AND s.quarter = 'Spring' order by course_number");
		pstmt.setInt(1, Integer.parseInt(request.getParameter("student")));
		student_course = pstmt.executeQuery();
	}
}
%>

<h2><%= "Course enrolled in current quarter"+cur_student%></h2>
<TABLE BORDER="1">
<TR>
<TH>section_id</TH>
<TH>course_number</TH>
<TH>grading_option</TH>
<TH>unit</TH>
</TR>
<% 
if(student_course!=null){
while(student_course.next()){ %>
      <TR>
      <TD><%=student_course.getString(1) %></TD>
      <TD><%=student_course.getString(2) %></TD>
      <TD><%=student_course.getString(3) %></TD>
      <TD><%=student_course.getInt(4) %></TD>
      </TR>
<% }
}%>
</TABLE>

<% 
resultset.close();
connection.close();
%>
    
</body>
</html>