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

<h2>Grade Distribution</h1>
<%
Connection connection = ConnectionProvider.getCon();
Statement statement = connection.createStatement() ;
ResultSet resultset = statement.executeQuery("select * from section") ;
%>

<form action="course_evaluation.jsp" method="get">
<input type="hidden" value="grade_distribution" name="action">
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
  
<%
String cur_course = "";
ResultSet grade_dis = null;
String action = request.getParameter("action");
if (action != null && action.equals("grade_distribution")) {
	if(request.getParameter("quarter").equals("")){
		out.println("Please select a quarter");
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
		
		grade_dis = pstmt.executeQuery();
	}
}
%>
<br>
<p><%=cur_course %></p>
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