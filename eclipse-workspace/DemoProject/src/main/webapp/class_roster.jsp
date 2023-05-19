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
<title>Insert title here</title>
</head>
<body>
<TABLE>
 <TR>
	<td><a href="root.jsp">Go Back</a></td>
 </TR>
</TABLE>

<h2>Enter Student</h1>
<%
Connection connection = ConnectionProvider.getCon();
Statement statement = connection.createStatement() ;
ResultSet resultset = statement.executeQuery("select * from section") ;
%>

<form action="class_roster.jsp" method="get">
<input type="hidden" value="select_class" name="action">
Year: <input type="text" name="year" size="5"/>
Course name: <input type="text" name="course_name" size="30"/>
Quarter: 
<%--<input type="text" name="quarter" size="2"/> --%>
<select name="quarter" id="quarter">
  <option value="">Select One</option>
  <option value="Fall">Fall</option>
  <option value="Winter">Winter</option>
  <option value="Spring">Spring</option>
  <option value="Summer">Summer</option>
</select>
<input type="submit" value="Search">
</form>    
  
<%
String cur_course = "";

String action = request.getParameter("action");
ResultSet roster_course = null;
if (action != null && action.equals("select_class")) {
	if(request.getParameter("quarter").equals("")){
		out.println("Please select a quarter");
	}else{
		resultset = statement.executeQuery("select course_number "
				+"from course_info "
				+"Where course_name = '"
			+request.getParameter("course_name") + "'");
		resultset.next();
		cur_course = " of "+resultset.getString(1)+", "+ request.getParameter("course_name")+" in quarter "+request.getParameter("quarter")+" "+request.getParameter("year");
		
		
		if(request.getParameter("quarter").equals("Spring") && request.getParameter("year").equals("2023")){		
			PreparedStatement pstmt = connection.prepareStatement(
					"select s.student_id, s.first_name, s.last_name, e.course_number, e.section_id, e.grading_option, e.unit "
							+"from enrollment_list_of_class e, student s, course_info i "
							+"Where e.student_id = s.student_id "
							+"AND e.course_number = i.course_number "
							+"AND i.course_name = ? ");
			
			pstmt.setString(1, request.getParameter("course_name"));
			roster_course = pstmt.executeQuery();
		}else{		
			PreparedStatement pstmt = connection.prepareStatement(
					"select s.student_id, s.first_name, s.last_name, c.course_number, e.section_id, c.grading_option, c.unit "
						+"from courses_taken c, student s, course_info i "
						+"Where c.student_id = s.student_id "
						+"AND c.course_number = i.course_number "
						+"AND i.course_name = ? "
						+"AND year = ? ");
			pstmt.setString(1, request.getParameter("course_name"));
			pstmt.setInt(2, Integer.parseInt(request.getParameter("year")));
			roster_course = pstmt.executeQuery();
		}
	}
}
%>

<h2><%= "Roster"+cur_course%></h2>
<TABLE BORDER="1">
<TR>
<TH>student_id</TH>
<TH>first_name</TH>
<TH>last_name</TH>
<TH>course_number</TH>
<TH>section_id</TH>
<TH>grading_option</TH>
<TH>unit</TH>
</TR>
<% 
if(roster_course!=null){
while(roster_course.next()){ %>
      <TR>
      <TD><%=roster_course.getInt(1) %></TD>
      <TD><%=roster_course.getString(2) %></TD>
      <TD><%=roster_course.getString(3) %></TD>
      <TD><%=roster_course.getString(4) %></TD>
      <TD><%=roster_course.getString(5) %></TD>
      <TD><%=roster_course.getString(6) %></TD>
      <TD><%=roster_course.getInt(7) %></TD>
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