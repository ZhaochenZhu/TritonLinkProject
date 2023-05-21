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
<title>CheckUndergradDegree</title>
</head>
<body>
<TABLE>
 <TR>
	<td><a href="root.jsp">Go Back</a></td>
 </TR>
</TABLE>
    
<h2>Select an Undergraduate Student and a major</h2>
<%
Connection connection = ConnectionProvider.getCon();
//Statement statement = connection.createStatement() ;
ResultSet resultset = connection.createStatement().executeQuery("select * from student where current_degree = 'Undergraduate' AND enrolled = 'Yes'") ;
ResultSet degreeResultset = connection.createStatement().executeQuery("select * from general_unit_requirement where type = 'Undergraduate'") ;

%>

<form action="checkUndergradDegreeReq.jsp" method="get">
<input type="hidden" value="select_student" name="action_student">
<label for="student">Choose a student:</label>
<select name="student" id="student">
  <option value="">Select one from below</option>
	<%while(resultset.next()){  %>
  <%-- <option value="<%=resultset.getInt(1) %>"><%=resultset.getString(2)+ " "+ resultset.getString(3) %></option>--%>
  <option value="<%=resultset.getInt(1) %>"><%=resultset.getInt(1) %></option>
      <% } %>
</select>
<br><br>
<input type="hidden" value="select_major" name="action_major">
<label for="major">Choose a major:</label>
<select name="major" id="major">
  <option value="">Select one from below</option>
	<%while(degreeResultset.next()){  %>
  <%-- <option value="<%=resultset.getInt(1) %>"><%=resultset.getString(2)+ " "+ resultset.getString(3) %></option>--%>
  <option value="<%=degreeResultset.getString(1) %>"><%=degreeResultset.getString(1) %></option>
      <% } %>
</select>
<input type="submit" value="Select">
</form> 





<%  
String curr_major = null;
String curr_student = null;
ResultSet minimum_unit = null;
ResultSet unmet_unit = null;

%>

<%
String action_student = request.getParameter("action_student");
String action_major = request.getParameter("action_major");
String major = null;

Integer student_id = null;
String student_name = null;
ResultSet student_name_rs = null;

if (action_student != null && action_student.equals("select_student")) {
	if(request.getParameter("student").equals("")){
		out.println("Please select a student");
	}else{
		student_id = Integer.parseInt(request.getParameter("student"));
		student_name_rs = connection.createStatement().executeQuery("select first_name, middle_name, last_name from student WHERE student_id = "+ student_id) ;
		student_name_rs.next();
		
		student_name = student_name_rs.getString(1) + ",";
		if (student_name_rs.getString(2) != null && !student_name_rs.getString(2).equals("")) {
			student_name += student_name_rs.getString(2) + ",";
		}
		student_name += student_name_rs.getString(3);
		
		out.println(student_name);	
	}

}
if (action_major != null && action_major.equals("select_major")) {
	if(request.getParameter("major").equals("")){
		out.println("Please select a major");
	} else {
		major = request.getParameter("major");
		out.println(major);
	}
}
%>

<%
if (student_id != null && major != null) {
	
	minimum_unit = connection.createStatement().executeQuery("select * from general_unit_requirement where type ='Undergraduate' AND major = '" + major + "'");
	PreparedStatement pstmt = connection.prepareStatement(
		"With met_unit AS (" +
		"select c.category, SUM(t.unit) AS unit " + 
		"from general_course_requirement c, courses_taken t " +
		"where t.student_id = ? AND c.type = 'Undergraduate' AND c.major = ? AND c.course_number = t.course_number " +
		"group by c.category)" +
		"(select u.category, (u.minimum_unit - m.unit) AS unit " +
		"from general_unit_requirement u, met_unit m " +
		"where u.type = 'Undergraduate' AND u.major = ? AND u.category = m.category)" +
		"union " +
		"(select u.category, u.minimum_unit " +
		"from general_unit_requirement u " +
		"where u.type = 'Undergraduate' AND u.major = ? AND u.category NOT IN (Select category from met_unit));"
		
			
	);
	pstmt.setInt(1, student_id);
	pstmt.setString(2, major);
	pstmt.setString(3, major);
	pstmt.setString(4, major);
	unmet_unit = pstmt.executeQuery();
}

%>

<% 
if (minimum_unit != null) {
	%><h2><%= major + " unit requirements"  %></h2>
	<TABLE BORDER = "1">
	<TR>
	<TH>category</TH>
	<TH>minimum_unit</TH>
	</TR> <%
	while(minimum_unit.next()) { %>
		 <TR>
      <TD><%=minimum_unit.getString(3) %></TD>
      <TD><%=minimum_unit.getInt(4) %></TD>
      </TR>
	<%}
}
if (unmet_unit != null) {
	%><h2><%= "unmet unit requirement for " + student_name  %></h2>
	<TABLE BORDER = "1">
	<TR>
	<TH>category</TH>
	<TH>unmet unit</TH>
	</TR> <%
	while(unmet_unit.next()) { %>
		 <TR>
      <TD><%=unmet_unit.getString(1) %></TD>
      <TD><%=unmet_unit.getInt(2) %></TD>
      </TR>
	<%}
}
%>
</TABLE>

<% 
/* resultset.close(); */
/* connection.close(); */
%>
    
</body>
</html>
  