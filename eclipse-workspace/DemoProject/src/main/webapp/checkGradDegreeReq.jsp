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
ResultSet resultset = connection.createStatement().executeQuery("select * from student s, student_period_attendance a where s.current_degree = 'Graduate' AND s.student_id = a.student_id AND a.quarter = 'Spring' AND a.year = 2023 AND a.enrolled = 'Yes' ") ;
ResultSet degreeResultset = connection.createStatement().executeQuery("select * from total_unit_requirement where degree_type = 'Graduate'") ;

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
ResultSet conc_gpa = null;
ResultSet future_courses = null;

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
	// add past course names
	
	
	// get the remaining total units for grad student for a chosen major
	PreparedStatement tpstmt = connection.prepareStatement(
			"With met_unit AS (" + 
			"(select SUM(t.unit) AS unit " +
			"from courses_taken t, past_names p " +
			"where t.student_id = ? AND ((t.course_number IN(" +
			"select course_number from master_course_requirement " +
			"where major = ?)) OR ((t.course_number = p.past_names) AND p.course_number IN(" +
			"select course_number from master_course_requirement " +
			"where major = ?)"+
			"))) " +
			"union " +
			"(select 0 AS unit " +
			"from student s " +
			"where s.student_id = ? AND s.student_id NOT IN(" +
			"select t.student_id " +
			"from courses_taken t, past_names p " +
			"where t.student_id = ? AND (t.course_number IN(" +
			"select course_number from master_course_requirement " +
			"where major = ?)) OR (t.course_number = p.past_names AND p.course_number IN(" +
			"select course_number from master_course_requirement " +
			"where major = ?)))))" +
			
			"select DISTINCT IIF((u.total_unit - m.unit)<0,0.0 ,(u.total_unit - m.unit)) AS unit " +
			"from total_unit_requirement u, met_unit m " +
			"where u.type = 'Graduate' AND u.major = ?");
	tpstmt.setInt(1, student_id);
	tpstmt.setString(2, major);
	tpstmt.setString(3, major);
	tpstmt.setInt(4, student_id);
	tpstmt.setInt(5, student_id);
	tpstmt.setString(6, major);
	tpstmt.setString(7, major);
	tpstmt.setString(8, major);
	total_unit = tpstmt.executeQuery();
	
	// get the remaining units for grad student for all concentration
	PreparedStatement pstmt = connection.prepareStatement(
		"With met_unit AS (" +
		"select c.concentration, SUM(t.unit) AS unit " + 
		"from master_course_requirement c, courses_taken t, past_names p " +
		"where t.student_id = ? AND c.major = ? AND ((c.course_number = t.course_number) OR (p.course_number = c.course_number AND p.past_names = t.course_number)) " +
		"group by c.concentration)" +
		"(select DISTINCT u.concentration, IIF((u.minimum_unit - m.unit) < 0, 0.0, (u.minimum_unit - m.unit)) AS unit " +
		"from master_concentration_requirement u, met_unit m " +
		"where u.major = ? AND u.concentration = m.concentration)" +
		"union " +
		"(select DISTINCT u.concentration, u.minimum_unit AS unit " +
		"from master_concentration_requirement u " +
		"where u.major = ? AND u.concentration NOT IN (Select concentration from met_unit));"
	);
	pstmt.setInt(1, student_id);
	pstmt.setString(2, major);
	pstmt.setString(3, major);
	pstmt.setString(4, major);
	concentration_unit = pstmt.executeQuery();
	
	// get the completed concentration
	
	PreparedStatement met_concentration = connection.prepareStatement(
		"With  conc_gpa AS ( " 
		+"select CAST(sum(c.unit * g.number_grade)/sum(c.unit) AS DECIMAL(10,2)) as conc_gpa, c.concentration "
		+"from grade_conversion g, (Select t.course_number, t.unit, t.grade, t.grading_option, m.concentration  "
			+"From courses_taken t, master_course_requirement m, past_names p "	
			+"Where ((m.course_number = t.course_number) OR (p.course_number = m.course_number AND p.past_names = t.course_number))  "
		  +"AND m.major = ? "
			+"AND t.student_id = ? ) c "
		+"where c.grade = g.letter_grade  "
		+"GROUP BY c.concentration),  "
		
		+"met_unit AS (" 
		+"select c.concentration, SUM(t.unit) AS unit "  
		+"from master_course_requirement c, courses_taken t, past_names p " 
		+"where t.student_id = ? AND c.major = ? AND ((c.course_number = t.course_number) OR (p.course_number = c.course_number AND p.past_names = t.course_number)) " 
		+"GROUP BY c.concentration) "
		
		+"Select DISTINCT m.concentration, g.conc_gpa, u.unit "
		+"from master_concentration_requirement m, conc_gpa g, met_unit u, grade_conversion c "
		+"where m.major = ? "
		+"AND m.concentration = g.concentration "
		+"AND m.concentration = u.concentration "
		/* +"AND c.letter_grade = m.minimum_grade " */
		+"AND m.minimum_unit <= u.unit "
		+"AND m.minimum_grade <= g.conc_gpa " 
	);
	met_concentration.setString(1, major);
	met_concentration.setInt(2, student_id);
	met_concentration.setInt(3, student_id);
	met_concentration.setString(4, major);
	met_concentration.setString(5, major);

	conc_gpa = met_concentration.executeQuery();
				
	
	// get untaken future courses of all the concentrations.
	PreparedStatement ft = connection.prepareStatement(
		"With untaken AS ( "
		+"select distinct m.course_number "
		+"from master_course_requirement m "
		+"Where m.major = ? AND m.course_number NOT IN ("
			+"(SELECT t.course_number from courses_taken t "
			+"WHERE t.student_id = ?) "
			+"UNION"
			+"(SELECT p.course_number from courses_taken t, past_names p "
			+"WHERE t.student_id = ? AND t.course_number = p.past_names))), "
		+"quarter_number AS ( "
		+"select s.course_number, (q.number + s.year * 4) AS quarter_num, s.quarter, s.year, s.section_id "
		+"from section s, quarter_conversion q "
		+"where q.quarter = s.quarter)"
		+"select DISTINCT u.course_number, q.year, q.quarter "
		+"from untaken u, quarter_number q " 
		+"where u.course_number = q.course_number "
		+"AND q.quarter_num > (2023 *4 + 2) AND NOT EXISTS ( "
			+"select * from untaken x, quarter_number y "
			+"where x.course_number = u.course_number "
			+"AND y.course_number = x.course_number "
			+"AND y.quarter_num > (2023 *4 + 2) "
			+"AND y.quarter_num < q.quarter_num) "
	);
	ft.setString(1, major);
	ft.setInt(2, student_id);
	ft.setInt(3, student_id);
	
	future_courses = ft.executeQuery();
	
	
}

%>

<% 
if (total_unit != null ) {
	%><h2><%= "MS in " + major + ", Total Unit Requirements for " + student_name + ", " + student_id  %></h2>
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
<%}
if (concentration_unit != null) {%>
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


<% if(conc_gpa!=null){	%>
	<h3><%="Met Concentration"%></h3>
		<TABLE BORDER="1">
		<TR>
		<TH>concentration</TH>
		<TH>concentration GPA</TH>		
		<TH>concentration unit</TH>
		</TR>
		
		<% while(conc_gpa.next()) { %>
			<TR>
			<TD><%= conc_gpa.getString(1)%></TD>
			<TD><%=conc_gpa.getFloat(2) %></TD>
			<TD><%=conc_gpa.getInt(3) %></TD>
			</TR>
		<% } %>		
		
		</TABLE>
			
<% }%>

    
<% if(future_courses != null) { %>
	<h3><%="Untaken future courses"%></h3>
		<TABLE BORDER="1">
		<TR>
		<TH>Course Number</TH>
		<TH>Year</TH>		
		<TH>Quarter</TH>
		</TR>
		
		<% while(future_courses.next()) { %>
			<TR>
			<TD><%= future_courses.getString(1)%></TD>
			<TD><%= future_courses.getInt(2) %></TD>
			<TD><%= future_courses.getString(3) %></TD>
			</TR>
		<% } %>		
		
		</TABLE>


<%} %>
</body>
</html>
  