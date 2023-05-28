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

<h2>Select Student</h2>
<%
Connection connection = ConnectionProvider.getCon();
Statement statement = connection.createStatement() ;
ResultSet resultset = statement.executeQuery("select * from student where enrolled = 'Yes'") ;
%>

<form action="produce_class_schedule.jsp" method="get">
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
ResultSet conflict_course = null;
if (action != null && action.equals("select_student")) {
	if(request.getParameter("student").equals("")){
		out.println("Please select a student");
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
					+"and TO_TIMESTAMP(x.end_time,'HH24:MI')<=TO_TIMESTAMP(m.start_time,'HH24:MI')))"
					+"and y.course_number NOT in (select course_number from current_section)");
		pstmt.setInt(1, Integer.parseInt(request.getParameter("student")));//out.println(pstmt.toString());
		conflict_course = pstmt.executeQuery();
		//out.println(pstmt.toString());
	}
}
%>

<h2><%= "Conflict courses in current quarter"+cur_student%></h2>
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
resultset.close();
connection.close();
%>
    
</body>
</html>