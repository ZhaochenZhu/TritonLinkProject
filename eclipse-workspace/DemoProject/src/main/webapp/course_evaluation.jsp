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

<h2>Grade distribution of selected quarter</h2>
<%
Connection connection = ConnectionProvider.getCon();
Statement statement = connection.createStatement() ;
ResultSet resultset = statement.executeQuery("select * from section") ;
%>

<form action="course_evaluation.jsp" method="get">
<input type="hidden" value="quarter_distribution" name="action">
Year: <input type="text" name="year" size="5"/>
Course number: <input type="text" name="course_number" size="10"/>
professor: <input type = "text" name = "professor" size = "10"/> 
Quarter: 
<%--<input type="text" name="quarter" size="2"/> --%>
<select name="quarter" id="quarter">
  <option value="">Select One</option>
  <option value="Fall">Fall</option>
  <option value="Winter">Winter</option>
  <option value="Spring">Spring</option>
  <option value="Summer">Summer</option>
</select>
<input type="submit" value="Check Distribution">
</form>    
<br>  
<%
String cur_course = "";
ResultSet quarter_dis = null;
String action = request.getParameter("action");
if (action != null && action.equals("quarter_distribution")) {
	if(request.getParameter("quarter").equals("")){
		out.println("Please select a quarter");
	}else if(request.getParameter("quarter").equals("Spring")&&request.getParameter("year").equals("2023")){
		out.println("Grade is not available for current quarter");
	}
	else{
		PreparedStatement check_valid_input = connection.prepareStatement("select * "
				+"from courses_taken c, section s "
				+"where c.course_number = s.course_number "
				+"and c.section_id = s.section_id "
				+"and c.year = s.year "
				+"and s.professor = ? "
				+"and c.year = ? "
				+"and s.quarter = ? "
				+"and c.course_number = ?");
		check_valid_input.setString(1, request.getParameter("professor"));
		check_valid_input.setInt(2, Integer.parseInt(request.getParameter("year")));
		check_valid_input.setString(3, request.getParameter("quarter"));
		check_valid_input.setString(4, request.getParameter("course_number"));
		ResultSet is_valid_input = check_valid_input.executeQuery();
		if(!is_valid_input.next()){
			out.println(request.getParameter("professor")+" didn't teach this course in "+request.getParameter("quarter")+", "+request.getParameter("year"));
		}else{
			cur_course = request.getParameter("course_number")+" in "+request.getParameter("quarter")
				+", "+request.getParameter("year")+" by professor: "+request.getParameter("professor");
			PreparedStatement pstmt = connection.prepareStatement("With student_course As( "
					+"select * "
					+"from courses_taken c, section s "
					+"where c.course_number = s.course_number "
					+"and c.section_id = s.section_id "
					+"and c.year = s.year "
					+"and s.professor = ? "
					+"and c.year = ? "
					+"and s.quarter = ? "
					+"and c.course_number = ?) "
					+"(select 'A' as grade, SUM(iif(grade like 'A%', 1, 0)) "
					+"from student_course) "
					+"union( "
					+"select 'B' as grade, SUM(iif(grade like 'B%', 1, 0)) "
					+"from student_course "
					+")union( "
					+"select 'C' as grade, SUM(iif(grade like 'C%', 1, 0)) "
					+"from student_course "
					+")union( "
					+"select 'D' as grade, SUM(iif(grade like 'D%', 1, 0)) "
					+"from student_course "
					+") "
					+"order by grade asc ");
			pstmt.setString(1, request.getParameter("professor"));
			pstmt.setInt(2, Integer.parseInt(request.getParameter("year")));
			pstmt.setString(3, request.getParameter("quarter"));
			pstmt.setString(4, request.getParameter("course_number"));
			
			quarter_dis = pstmt.executeQuery();
		}
	}
}
%>

<p><%=cur_course %></p>
<TABLE BORDER="1">
<TR>
<TH>grade</TH>
<TH>count</TH>
</TR>
<% 
if(quarter_dis!=null){
while(quarter_dis.next()){ %>
      <TR>
      <TD><%=quarter_dis.getString(1) %></TD>
      <TD><%=quarter_dis.getInt(2) %></TD>
      </TR>
<% }
}%>
</TABLE>



<h2>Grade distribution over the years</h2>
<form action="course_evaluation.jsp" method="get">
<input type="hidden" value="grade_distribution" name="action">
Course number: <input type="text" name="course_number" size="10"/>
professor: <input type = "text" name = "professor" size = "10"/> 
<input type="submit" value="Check Distribution">
</form>    

<%
String grade_summary = "";
ResultSet grade_dis = null;
if (action != null && action.equals("grade_distribution")) {
	PreparedStatement check_valid_input = connection.prepareStatement("select * "
			+"from courses_taken "
			+"where professor = ? "
			+"and course_number = ?");
	check_valid_input.setString(1, request.getParameter("professor"));
	check_valid_input.setString(2, request.getParameter("course_number"));
	ResultSet is_valid_input = check_valid_input.executeQuery();
	if(!is_valid_input.next()){
		out.println(request.getParameter("professor")+" didn't teach this course ");
	}else{
		grade_summary = request.getParameter("course_number")+" by professor: "+request.getParameter("professor");
		PreparedStatement pstmt = connection.prepareStatement("With student_course As( "
				+"select * "
				+"from courses_taken c, section s "
				+"where c.course_number = s.course_number "
				+"and c.section_id = s.section_id "
				+"and c.year = s.year "
				+"and s.professor = ? "
				+"and c.course_number = ?) "
				+"(select 'A' as grade, SUM(iif(grade like 'A%', 1, 0)) "
				+"from student_course) "
				+"union( "
				+"select 'B' as grade, SUM(iif(grade like 'B%', 1, 0)) "
				+"from student_course "
				+")union( "
				+"select 'C' as grade, SUM(iif(grade like 'C%', 1, 0)) "
				+"from student_course "
				+")union( "
				+"select 'D' as grade, SUM(iif(grade like 'D%', 1, 0)) "
				+"from student_course "
				+") "
				+"order by grade asc ");
		pstmt.setString(1, request.getParameter("professor"));
		pstmt.setString(2, request.getParameter("course_number"));
		//out.println(pstmt.toString());
		grade_dis = pstmt.executeQuery();
	}
}
%>
<br>
<p><%=grade_summary %></p>
<TABLE BORDER="1">
<TR>
<TH>grade</TH>
<TH>count</TH>
</TR>
<% 
if(grade_dis!=null){
while(grade_dis.next()){ %>
      <TR>
      <TD><%=grade_dis.getString(1) %></TD>
      <TD><%=grade_dis.getInt(2) %></TD>
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