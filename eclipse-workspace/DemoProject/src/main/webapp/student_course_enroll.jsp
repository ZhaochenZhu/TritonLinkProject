<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.sql.*, com.mit.*, java.util.*"%>
<!DOCTYPE html>
<html>
<head>
<style>
table { 
	border-collapse: separate; border-spacing: 5px; 
}
</style>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<TABLE>
      <TR>
      <td><a href="student.jsp">student</a></td>
      <td><a href="faculty.jsp">faculty</a></td>
	  <td><a href="course.jsp">course</a></td>
      <td><a href="class.jsp">class</a></td>
	  <td><a href="degrees.jsp">degrees</a></td>
	  <td><a href="student_course_enroll.jsp">Webreg</a></td>
	  <td><a href="review_session.jsp">review_session</a></td>
      </TR>
</TABLE>

<H1>Enroll course</H1>
<table>
<TR>
<TD>
<form name = "f1" method="get">
<input type="hidden" value="check_prereq" name="action"/>
Student ID: <input type="text" name="student_id" />
Course number: <input type="text" name="course_number"/>
<input type="submit" value="Search Class"/>
</form>
</TD>
<%-- 
<TD>
</form>
<form action="student_course_enroll.jsp" method="get">
<input type="hidden" value="enroll_class" name="action">
<input type="hidden" value=student_id name="student_id">
<td><input type="submit" value="Enroll"></td>
</form>
</TD> --%>
</TR>
</table>
<h2>Class Info</h2>
<%
	Connection connection = ConnectionProvider.getCon();
	PreparedStatement pstmt = connection.prepareStatement(
		"SELECT * From section WHERE course_number = ? AND year = 2023 AND quarter ='SP'");
	pstmt.setString(1, request.getParameter("course_number"));
	ResultSet section = pstmt.executeQuery();
	boolean search = false;
	//int student_id = -1;
%>
<TABLE BORDER="1">
      <TR>
      <TH>Course</TH>
      <TH>Section ID</TH>
      <TH>Professor</TH>
      <th>Units</th>
      <TH>Start Date</TH>
      <TH>End Date</TH>
      </TR>
      <% if(section!=null){
    	  boolean found = false;
      while(section.next()){ 
      found = true;%>
      <TR>
      <form action="student_course_enroll.jsp" method="get">
      <input type="hidden" value="update" name="action">
      <td><%= section.getString(3) %></td>
	  <td><%= section.getString(2) %></td>      
      <TD><%= section.getString(8) %></TD>
      <TD><%= section.getInt(5) %></TD>
      <TD><%= section.getString(6) %> </TD>
      <TD><%= section.getString(7) %></TD>
      </form>
      <form action="student_course_enroll.jsp" method="get">
		<input type="hidden" value="enroll_class" name="action">
		<input type="hidden" value="<%= section.getInt(1) %>" name="year">
		<input type="hidden" value="<%= section.getString(2) %>" name="section_id">
		<input type="hidden" value="<%= section.getString(3) %>" name="course_number">
		<input type="hidden" value="<%= section.getInt(5) %>" name="units">
		<input type="hidden" value="<%= request.getParameter("student_id") %>" name="student_id">
		<td><input type="submit" value="Enroll"></td>
		</form>
      </TR>
      <% }
      if(!found&&search) out.println("Course not offered in current quarter");
      }%>
     </TABLE>


<%
String action = request.getParameter("action");
ResultSet preqs = null;
if (action != null && (action.equals("check_prereq")||action.equals("enroll_class"))) {
	search = true;
	//student_id = Integer.parseInt(request.getParameter("student_id"));
	Connection conn = ConnectionProvider.getCon();
	//conn.setAutoCommit(false);
	// Create the prepared statement and use it to
	// INSERT the student attrs INTO the Student table.
	pstmt = conn.prepareStatement(
	("SELECT * FROM prerequisite WHERE course_number = ?"));
	pstmt.setString(1,request.getParameter("course_number"));
	preqs = pstmt.executeQuery();
	//conn.commit();
	//conn.setAutoCommit(true);
	//conn.close();
}
if (action != null && action.equals("enroll_class")) {
	try{
	Connection conn = ConnectionProvider.getCon();
	conn.setAutoCommit(false);
	// Create the prepared statement and use it to
	// INSERT the student attrs INTO the Student table.
	
	// check for prereq
	Statement stmt = connection.createStatement() ;
	String query = "select * from prerequisite WHERE course_number = '"+
			request.getParameter("course_number")+"'";
	ResultSet resultset = stmt.executeQuery(query);
	List<String> pre_reqs = new ArrayList<>();
	while(resultset.next()){
		pre_reqs.add(resultset.getString(2));
	}
	//out.println(pre_reqs.size());
	query = "select * from courses_taken WHERE student_id = "+request.getParameter("student_id");
	resultset = stmt.executeQuery(query);
	//out.println(student_id);
	while(resultset.next()){
		//System.err.println(resultset.getString(2));
		for(int i=0;i<pre_reqs.size();i++){
			if(pre_reqs.get(i).equals(resultset.getString(2))){
				pre_reqs.remove(i);
				break;
			}
		}
	}
	if(pre_reqs.isEmpty()){
		// can enroll in course
		pstmt = conn.prepareStatement(
		("INSERT INTO enrollment_list_of_class VALUES (?, ?, ?, ?, ?)"));
		pstmt.setInt(1,2023);
		pstmt.setString(2,request.getParameter("section_id"));
		pstmt.setString(3,request.getParameter("course_number"));
		pstmt.setInt(4,Integer.parseInt(request.getParameter("student_id")));
		pstmt.setString(5,request.getParameter("units"));
		pstmt.executeUpdate();
		conn.commit();
		out.println("Enrolled");
	}
	else{
		out.println("Pre-req not statisfied");
	}
	conn.setAutoCommit(true);
	}catch(Exception ex){
		out.println(ex.getClass().getSimpleName());
	}
}

%>

<h2>Prerequisite of <%= (request.getParameter("course_number")==null)? "(Type in course to show)":request.getParameter("course_number")%></h2>
<TABLE BORDER="1">
      <TR>
      <TH>Course</TH>
      <TH>Taken?</TH>
      </TR>
      <% if(preqs!=null){
      while(preqs.next()){ %>
      <TR>
      <td><%= preqs.getString(2) %></td>
      <%
      Connection conn = ConnectionProvider.getCon();
      String requiredCourse = preqs.getString(2);
      pstmt = conn.prepareStatement(
    			("SELECT * FROM courses_taken WHERE course_number = ? AND student_id = ?"));
      pstmt.setString(1, preqs.getString(2));
      pstmt.setInt(2,Integer.parseInt(request.getParameter("student_id")));
      ResultSet rst = pstmt.executeQuery();
      String taken = rst.next()? "Yes":"No";
      %>
      <td><%= taken%></td>
      </TR>
      <% }
      }%>
     </TABLE>
</body>
</html>