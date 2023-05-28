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

<h2>Select Student</h1>
<%
Connection connection = ConnectionProvider.getCon();
Statement statement = connection.createStatement() ;
ResultSet resultset = statement.executeQuery("select * from student") ;
%>

<form action="student_grade_report.jsp" method="get">
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
String grade_details = "";
if(request.getParameter("student")==null || request.getParameter("student").equals("")){
	cur_student = "";
}else{
	resultset = statement.executeQuery(
			"select first_name, last_name from student Where student_id = "
			+Integer.parseInt(request.getParameter("student")));
	resultset.next();
	cur_student = " for "+resultset.getString(1)+" "+ resultset.getString(2);
}
String action = request.getParameter("action");
ResultSet quarters = null;
if (action != null && action.equals("select_student")) {
	if(request.getParameter("student").equals("")){
		out.println("Please select a student");
	}else{
		resultset = statement.executeQuery("select first_name, middle_name, last_name, g.total_gpa from student s, student_grade g WHERE s.student_id = "
			+Integer.parseInt(request.getParameter("student"))+" AND s.student_id = g.student_id") ;
		if(resultset.next()){
			grade_details = resultset.getString(1)+","+resultset.getString(2)
			+","+resultset.getString(3)+", GPA: "+resultset.getFloat(4);	
		}	
		
		
		PreparedStatement pst = connection.prepareStatement(
				"select distinct c.quarter, t.year from courses_taken t, section c "
				+"where student_id = ? "
				+"AND t.year = c.year "
				+"AND t.section_id = c.section_id "
				+"AND t.course_number = c.course_number");
		pst.setInt(1, Integer.parseInt(request.getParameter("student")));
		quarters = pst.executeQuery();		
	}
}
%>

<h2><%= "Grade Report"+cur_student%></h2>

<% 
out.println(grade_details);
if(quarters!=null){
	ResultSet current_class = null;
	PreparedStatement query_cur_class = connection.prepareStatement(
			"Select t.course_number, t.section_id, t.unit, s.professor, t.grading_option "
					+"From enrollment_list_of_class t, section s "
					+"Where s.course_number = t.course_number "
					+"AND s.section_id = t.section_id "
					+"AND s.year = t.year "
					+"AND t.student_id = ?");
	query_cur_class.setInt(1, Integer.parseInt(request.getParameter("student")));	
	//out.println(query_cur_class.toString());
	current_class = query_cur_class.executeQuery();
	
%>	
<h3>Spring, 2023</h3>
		<TABLE BORDER="1">
		<TR>
		<TH>course_number</TH>
		<TH>section_id</TH>		
		<TH>unit</TH>
		<TH>grade</TH>
		<TH>preofessor</TH>
		<TH>grading_option</TH>
		</TR>
		<TR>
		<%
		if(current_class!=null){
		while(current_class.next()){ %>
		<TD><%=current_class.getString(1) %></TD>
		<TD><%=current_class.getString(2) %></TD>
		<TD><%=current_class.getInt(3) %></TD>
		<TD>WIP</TD>
		<TD><%=current_class.getString(4) %></TD>
		<TD><%=current_class.getString(5) %></TD>
		</TR>
		<%}
		}%>
		</TABLE>
		
<%	
while(quarters.next()){ 
	String current_quarter = quarters.getString(1);
	
	int year = quarters.getInt(2);
	//out.println(current_quarter+" " +year+" "+Integer.parseInt(request.getParameter("student")));
	PreparedStatement query_gpa = connection.prepareStatement(
			"With quarter_class AS ( " 
					+"Select t.course_number, t.section_id, t.unit, t.grade, t.professor, t.grading_option "
					+"From courses_taken t, section s "
					+"Where s.quarter = ? "
					+"AND s.course_number = t.course_number "
					+"AND s.section_id = t.section_id "
					+"AND s.year = t.year "
					+"AND s.year = ? "
					+"AND t.student_id = ? ) "
					+"select CAST(sum(c.unit*g.number_grade)/sum(c.unit) AS DECIMAL(10,2)) as quarter_gpa "
					+"from quarter_class c, grade_conversion g "
					+"where c.grade = g.letter_grade");
	query_gpa.setString(1, current_quarter);
	query_gpa.setInt(2, year);
	query_gpa.setInt(3, Integer.parseInt(request.getParameter("student")));
	
	//out.println(query_gpa.toString());
	ResultSet quarter_gpa = null;
	
	ResultSet quarter_class = null;
	PreparedStatement query_class = connection.prepareStatement(
			"Select t.course_number, t.section_id, t.unit, t.grade, t.professor, t.grading_option "
			+"From courses_taken t, section s "
			+"Where s.quarter = ? "
			+"AND s.course_number = t.course_number "
			+"AND s.section_id = t.section_id "
			+"AND s.year = t.year "
			+"AND s.year = ? "
			+"AND t.student_id = ?");
	query_class.setString(1, current_quarter);
	query_class.setInt(2, year);
	query_class.setInt(3, Integer.parseInt(request.getParameter("student")));
	quarter_gpa = query_gpa.executeQuery();
	
	quarter_class = query_class.executeQuery();
	//out.println(create_view.toString());
	quarter_gpa.next();
%>
<h3><%=current_quarter + ", " +year %></h3>
		<TABLE BORDER="1">
		<TR>
		<TH>course_number</TH>
		<TH>section_id</TH>		
		<TH>unit</TH>
		<TH>grade</TH>
		<TH>preofessor</TH>
		<TH>grading_option</TH>
		</TR>
		<TR>
		<%
		if(quarter_class!=null){
		while(quarter_class.next()){ %>
		<TD><%=quarter_class.getString(1) %></TD>
		<TD><%=quarter_class.getString(2) %></TD>
		<TD><%=quarter_class.getInt(3) %></TD>
		<TD><%=quarter_class.getString(4) %></TD>
		<TD><%=quarter_class.getString(5) %></TD>
		<TD><%=quarter_class.getString(6) %></TD>
		</TR>
		<%}
		}%>
		</TABLE>
		Quarter GPA: <%= quarter_gpa.getFloat(1) %>
<% }
}%>

<% 
//resultset.close();
connection.close();
%>
    
</body>
</html>