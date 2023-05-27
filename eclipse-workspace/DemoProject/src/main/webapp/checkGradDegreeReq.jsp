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
    
   
<h2>Select a Graduate Student and a major</h2>
<%
Connection connection = ConnectionProvider.getCon();
//Statement statement = connection.createStatement() ;
ResultSet resultset = connection.createStatement().executeQuery("select * from student where current_degree = 'Graduate' AND enrolled = 'Yes'") ;
ResultSet degreeResultset = connection.createStatement().executeQuery("select * from total_unit_requirement where type = 'Graduate'") ;

%>

<form action="checkGradDegreeReq.jsp" method="get">
<input type="hidden" value="select_student" name="action_student">
<label for="student">Choose a student:</label>
<select name="student" id="student">
  <option value="">Select one from below</option>
	<%while(resultset.next()){  %>
  <option value="<%=resultset.getInt(1) %>"><%=resultset.getInt(1) %></option>
      <% } %>
</select>
<br><br>
<input type="hidden" value="select_major" name="action_major">
<label for="major">Choose a major:</label>
<select name="major" id="major">
  <option value="">Select one from below</option>
	<%while(degreeResultset.next()){  %>
  <option value="<%=degreeResultset.getString(1) %>"><%=degreeResultset.getString(1) %></option>
      <% } %>
</select>
<input type="submit" value="Select">
</form> 





<%  
String curr_major = null;
String curr_student = null;
ResultSet total_unit = null;
ResultSet concentration_unit = null;
ResultSet complete_conc = null;
ResultSet incomplete_conc = null;

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
	// get the remaining total units for grad student for a chosen major
	PreparedStatement tpstmt = connection.prepareStatement(
			"With met_unit AS (" + 
			"(select SUM(t.unit) AS unit " +
			"from courses_taken t " +
			"where t.student_id = ? AND t.course_number IN(" +
			"select course_number from master_course_requirement " +
			"where major = ?)) " +
			"union " +
			"(select 0 AS unit " +
			"from student s " +
			"where s.student_id = ? AND s.student_id NOT IN(" +
			"select t.student_id " +
			"from courses_taken t " +
			"where t.student_id = ? AND t.course_number IN(" +
			"select course_number from master_course_requirement " +
			"where major = ?))))" +
			"select (u.total_unit - m.unit) AS unit " +
			"from total_unit_requirement u, met_unit m " +
			"where u.type = 'Graduate' AND u.major = ?");
	tpstmt.setInt(1, student_id);
	tpstmt.setString(2, major);
	tpstmt.setInt(3, student_id);
	tpstmt.setInt(4, student_id);
	tpstmt.setString(5, major);
	tpstmt.setString(6, major);
	total_unit = tpstmt.executeQuery();
	
	// get the remaining units for grad student for all concentration
	PreparedStatement pstmt = connection.prepareStatement(
		"With met_unit AS (" +
		"select c.concentration, SUM(t.unit) AS unit " + 
		"from master_course_requirement c, courses_taken t " +
		"where t.student_id = ? AND c.major = ? AND c.course_number = t.course_number " +
		"group by c.concentration)" +
		"(select u.concentration, (u.minimum_unit - m.unit) AS unit " +
		"from master_concentration_requirement u, met_unit m " +
		"where u.major = ? AND u.concentration = m.concentration)" +
		"union " +
		"(select u.concentration, u.minimum_unit " +
		"from master_concentration_requirement u " +
		"where u.major = ? AND u.concentration NOT IN (Select concentration from met_unit));"
	);
	pstmt.setInt(1, student_id);
	pstmt.setString(2, major);
	pstmt.setString(3, major);
	pstmt.setString(4, major);
	concentration_unit = pstmt.executeQuery();
	
	// get the completed concentration
	
	/* PreparedStatement cpstmt = connection.prepareStatement(
			); */
	
	// get untaken future courses of all the concentrations.
}

%>

<% 
if (total_unit != null && concentration_unit != null && complete_conc != null) {
	%><h2><%= major + " Total Unit Requirements for " + student_name + ", " + student_id  %></h2>
	<TABLE BORDER = "1">
	<TR>
	<TH>remaining total_unit</TH>
	</TR> <%
	total_unit.next(); %>
		 <TR>
      <TD><%=total_unit.getInt(1) %></TD>
      </TR>
	
	</TABLE>
<br><br>

	<h2><%= "Remaining Concentration Unit Requirement for " + student_name + ", " + student_id %></h2>
	<TABLE BORDER = "1">
	<TR>
	<TH>concentration</TH>
	<TH>remaining unit</TH>
	</TR> <%
	while(concentration_unit.next()) { %>
		 <TR>
      <TD><%=concentration_unit.getString(1) %></TD>
      <TD><%=concentration_unit.getInt(2) %></TD>
      </TR>
	<%}%>
	</TABLE>
<%}%>

    
</body>
</html>
  