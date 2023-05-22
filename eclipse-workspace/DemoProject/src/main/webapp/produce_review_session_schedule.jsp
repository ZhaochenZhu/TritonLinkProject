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
<h1>Schedule a Review Session</h1>
<h2>Select Course</h2>


<form action="produce_review_session_schedule.jsp" method="get">
<input type="hidden" value="select_course" name="action">
Type in a course:
<input type="text" placeholder="course_number" name="course_number">
<input type="submit" value="Select">
</form>
<%
String action = request.getParameter("action");
ResultSet course_sections = null;
Connection connection = ConnectionProvider.getCon();
Statement statement = connection.createStatement() ;
String cur_course = "";
ResultSet course_info = null;
if(request.getParameter("course_number")==null || request.getParameter("course_number").equals("")){
	cur_course = "[SELECT COURSE]";
}else{
	course_info = statement.executeQuery(
			"select course_number, course_name from course_info Where course_number = '"
			+request.getParameter("course_number")+"'");
	course_info.next();
	cur_course = course_info.getString(1)+" "+ course_info.getString(2);
}
if(action != null && action.equals("select_course")){
	course_sections = statement.executeQuery("select section_id from section where year = 2023 AND quarter = 'Spring' AND course_number = '"
			+request.getParameter("course_number")+"'") ;
}


%>
<h2><%=cur_course %></h2>    
<form action="produce_review_session_schedule.jsp" method="get">
<input type="hidden" value="schedule" name="action">
<select name="Section" id="section">
  <option value="">Select one from below</option>
	<%if(course_sections!=null){
	while(course_sections.next()){  %>
  <%-- <option value="<%=resultset.getInt(1) %>"><%=resultset.getString(2)+ " "+ resultset.getString(3) %></option>--%>
  <option value="<%=course_sections.getString(1) %>"><%=course_sections.getString(1) %></option>
      <% } 
      }%>
</select>
Start Date: <input type="date" name="start_date" />
End Date: <input type="date" name="end_date" />
<input type="submit" value="Select">
</form>    
  
<%

ResultSet resultset = null;
ResultSet conflict_course = null;
if (action != null && action.equals("schedule")) {
	if(request.getParameter("Section").equals("")){
		out.println("Please select a section");
	}else{
		resultset = statement.executeQuery("select first_name, middle_name, last_name from student WHERE student_id = "+Integer.parseInt(request.getParameter("student"))) ;
		resultset.next();
		out.println(resultset.getString(1)+","+resultset.getString(2)+","+resultset.getString(3));	
	
		PreparedStatement pstmt = connection.prepareStatement(
				"with current_section as("
					+"select c.date, c.course_number, c.start_time, c.end_time, c.year, c.section_id "
					+"from enrollment_list_of_class e, class_meetings_times c "
					+"where e.year = c.year AND e.course_number = c.course_number AND e.section_id = c.section_id "
					+"AND e.student_id = ? AND c.type<>'review_session') "
					+"select distinct m.course_number, c.course_name "
					+"from current_section x, section y, class_meetings_times m, section z, course_info c "
					+"where y.year = m.year AND y.course_number = m.course_number AND y.section_id = m.section_id "
					+"and x.year = z.year AND x.course_number = z.course_number AND x.section_id = z.section_id "
					+"and m.date=x.date and x.course_number<>y.course_number and y.quarter = z.quarter and y.year=z.year "
					+"and c.course_number = m.course_number AND m.type<>'review_session'"
					+"and ((TO_TIMESTAMP(m.start_time,'HH24:MI')<=TO_TIMESTAMP(x.end_time,'HH24:MI') "
					+"and TO_TIMESTAMP(m.end_time,'HH24:MI')>=TO_TIMESTAMP(x.start_time,'HH24:MI')) "
					+"or (TO_TIMESTAMP(x.start_time,'HH24:MI')<=TO_TIMESTAMP(m.end_time,'HH24:MI') "
					+"and TO_TIMESTAMP(x.end_time,'HH24:MI')<=TO_TIMESTAMP(m.start_time,'HH24:MI')))");
		pstmt.setInt(1, Integer.parseInt(request.getParameter("student")));
		conflict_course = pstmt.executeQuery();
		//out.println(pstmt.toString());
	}
}
%>

<h2><%= "Available slots for review session for "+cur_course%></h2>
<TABLE BORDER="1">
<TR>
<TH>course_number</TH>
<TH>course_name</TH>
</TR>
<% 
if(conflict_course!=null){
while(conflict_course.next()){ %>
      <TR>
      <TD><%=conflict_course.getString(1) %></TD>
      <TD><%=conflict_course.getString(2) %></TD>
      </TR>
<% }
}%>
</TABLE>

<% 
//resultset.close();
connection.close();
%>
    
</body>
</html>