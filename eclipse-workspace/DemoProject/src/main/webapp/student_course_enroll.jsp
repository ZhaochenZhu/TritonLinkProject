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
      <td><a href="root.jsp">Go Back</a></td>
      </TR>
</TABLE>

<%String action = request.getParameter("action"); %>

<H1>Enroll course</H1>
<table>
<TR>
<TD>
<form name = "f1" method="get">
<input type="hidden" value="sign_in" name="action"/>
Student ID: <input type="text" value="<%= action==null? "":request.getParameter("student_id")%>" name="student_id" />
<input type="submit" value="Sign in"/>
</form>
<form name = "f1" method="get">
<input type="hidden" value="check_prereq" name="action"/>
<input type="hidden" value="<%= action==null? "":request.getParameter("student_id")%>" name="student_id" />
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
		"SELECT * From section WHERE course_number = ? AND year = 2023 AND quarter ='Spring'");
	pstmt.setString(1, request.getParameter("course_number"));
	ResultSet section = pstmt.executeQuery();
%>
<TABLE BORDER="1">
      <TR>
      <TH>Course</TH>
      <TH>Section ID</TH>
      <TH>Professor</TH>
      <th>Units</th>
      <TH>Start Date</TH>
      <TH>End Date</TH>
      <TH>Grading Option</TH>
      <TH>Select unit</TH>
      <TH>Select grading option</TH>
      </TR>
      <% if(section!=null){
    	  boolean found = false;
      while(section.next()){ 
      found = true;%>
      <TR>
      <form action="student_course_enroll.jsp" method="get">
      <input type="hidden" value="update" name="action">
      <td><input type="text" value="<%= section.getString(3) %>" name="course_number" readonly></td>
	  <td><input type="text" value="<%= section.getString(2) %>" name="section_id" readonly></td> 
	  <td><input type="text" value="<%= section.getString(8) %>" name="professor" readonly></td>	  
      <TD><input type="text" value="<%= section.getString(5) %>" name="units" readonly></TD>
      <TD><input type="date" value="<%= section.getString(6) %>" name="start_date" readonly></TD>
      <TD><input type="date" value="<%= section.getString(7) %>" name="end_date" readonly></TD>
      <TD><input type="text" value="<%= section.getString(9) %>" name="grading_option" readonly></TD>      
      </form>
      <form action="student_course_enroll.jsp" method="get">
		<input type="hidden" value="enroll_class" name="action">
		<input type="hidden" value="<%= section.getInt(1) %>" name="year">
		<input type="hidden" value="<%= section.getString(2) %>" name="section_id">
		<input type="hidden" value="<%= section.getString(3) %>" name="course_number">
		<TD><select name="units" id="units">
		  <%if(section.getString(5).contains("-")){
			  String[] arr = section.getString(5).split("-");
			  int lower = Integer.parseInt(arr[0]);
			  int higher = Integer.parseInt(arr[1]);
			  for(int i=lower;i<=higher;i++){%>
				  <option value="<%=i%>"><%=i%></option>
			  <%}
		  }else{%>
			  <option value="<%=section.getString(5)%>"><%=section.getString(5)%></option>
		  <%}%>
		</select></TD>
		<input type="hidden" value="<%= request.getParameter("student_id") %>" name="student_id">
		<TD><select name="grading_option" id="grading_option">
		  <option value="letter_grade">Letter Grade</option>
		  <option value="s_u">S/U</option>
		</select></TD>
		<td><input type="submit" value="Enroll"></td>
		</form>
      </TR>
      <% }
      if(!found && (action!=null && !action.equals("sign_in"))) out.println("Course not offered in current quarter");
      }%>
     </TABLE>


<%

ResultSet preqs = null;
if (action != null && (action.equals("sign_in")||action.equals("enroll_class")||action.equals("change_grading")||action.equals("drop_class"))) {
	
}
     
if (action != null && (action.equals("check_prereq"))) {
	pstmt = connection.prepareStatement(
	("SELECT * FROM prerequisite WHERE course_number = ?"));
	pstmt.setString(1,request.getParameter("course_number"));
	preqs = pstmt.executeQuery();
}

if (action != null && action.equals("drop_course")) {
	
	try{
	connection.setAutoCommit(false);
	pstmt = connection.prepareStatement(
	("Delete FROM enrollment_list_of_class WHERE year = ? AND section_id = ? AND course_number = ? AND student_id = ?"));
	pstmt.setInt(1,Integer.parseInt(request.getParameter("year")));
	pstmt.setString(2,request.getParameter("section_id"));
	pstmt.setString(3,request.getParameter("course_number"));
	pstmt.setInt(4,Integer.parseInt(request.getParameter("student_id")));
	//out.println(pstmt.toString());
	int rowCount = pstmt.executeUpdate();
	connection.commit();
	connection.setAutoCommit(true);
	}catch(Exception ex){
		out.println(ex);
	}
}

if (action != null && action.equals("change_grading")) {
	try{
		connection.setAutoCommit(false);
	pstmt = connection.prepareStatement("SELECT grading_option, units FROM section WHERE year = ? AND section_id = ? AND course_number = ?");
	pstmt.setInt(1,2023);
	pstmt.setString(2,request.getParameter("section_id"));
	pstmt.setString(3,request.getParameter("course_number"));
	
	ResultSet resultset = pstmt.executeQuery();
	boolean has_grading_option = false;
	boolean unit_in_range = false;
	//out.println(pstmt.toString());
	
	if(resultset.next() && (resultset.getString(1).equals(request.getParameter("grading_option")))||resultset.getString(1).equals("both")){
		has_grading_option = true;
		//out.println("has grading option");
		String unit_range = resultset.getString(2);
		if(unit_range.contains("-")){
			//out.println("multi unit choice");
			String[] arr = unit_range.split("-");
			int lower = Integer.parseInt(arr[0]);
			int higher = Integer.parseInt(arr[1]);
			unit_in_range = (Integer.parseInt(request.getParameter("unit"))>=lower )
					&& (Integer.parseInt(request.getParameter("unit"))<=higher);
		}else{
			//out.println("single unit choice");
			unit_in_range = Integer.parseInt(request.getParameter("unit"))==Integer.parseInt(unit_range);
		}
	}
	if(has_grading_option && unit_in_range){
		out.println("update course");
	pstmt = connection.prepareStatement(
	("UPDATE enrollment_list_of_class SET grading_option = ?, unit = ? WHERE year = ? AND section_id = ? AND course_number = ? AND student_id = ?"));
	pstmt.setString(1,request.getParameter("grading_option"));
	pstmt.setInt(2,Integer.parseInt(request.getParameter("unit")));
	pstmt.setInt(3,Integer.parseInt(request.getParameter("year")));
	pstmt.setString(4,request.getParameter("section_id"));
	pstmt.setString(5,request.getParameter("course_number"));
	pstmt.setInt(6,Integer.parseInt(request.getParameter("student_id")));
	//out.println(pstmt.toString());
	int rowCount = pstmt.executeUpdate();
	connection.commit();
	}
	else{
		out.println("invalid update attempt");
	}
	connection.setAutoCommit(true);
	}catch(Exception ex){
		out.println(ex);
	}
}

if (action != null && action.equals("enroll_class")) {
	try{
		connection.setAutoCommit(false);	
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
	
	pstmt = connection.prepareStatement("SELECT grading_option FROM section WHERE year = ? AND section_id = ? AND course_number = ?");
	pstmt.setInt(1,2023);
	pstmt.setString(2,request.getParameter("section_id"));
	pstmt.setString(3,request.getParameter("course_number"));
	resultset = pstmt.executeQuery();
	boolean has_grading_option = false;
	if(resultset.next() && (resultset.getString(1).equals(request.getParameter("grading_option"))||resultset.getString(1).equals("both"))){
		has_grading_option = true;
	}
	if(pre_reqs.isEmpty() && has_grading_option){
		// can enroll in course
		try{
		pstmt = connection.prepareStatement(
		("INSERT INTO enrollment_list_of_class VALUES (?, ?, ?, ?, ?, ?)"));
		pstmt.setInt(1,2023);
		pstmt.setString(2,request.getParameter("section_id"));
		pstmt.setString(3,request.getParameter("course_number"));
		pstmt.setInt(4,Integer.parseInt(request.getParameter("student_id")));
		pstmt.setString(5,request.getParameter("grading_option"));
		pstmt.setInt(6,Integer.parseInt(request.getParameter("units")));
		pstmt.executeUpdate();
		}catch(Exception e){
			out.println(e.getMessage());
		}
		connection.commit();
		out.println("Enrolled");
	}
	else{
		out.println("Pre-req not statisfied");
	}
	connection.setAutoCommit(true);
	}catch(Exception ex){
		out.println(ex);
	}
}

%>

	<h2>Prerequisite of <%= (request.getParameter("course_number")==null)? "course (Type in course_number to show)":request.getParameter("course_number") %></h2>
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
      String requiredCourse = preqs.getString(2);
      pstmt = connection.prepareStatement(
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
     
     <h2>Enrolled course of <%= (request.getParameter("student_id")==null)? "student (Type in student_id to show)":request.getParameter("student_id")%></h2>
	<TABLE BORDER="1">
	<%
      pstmt = connection.prepareStatement(
    			("SELECT * FROM enrollment_list_of_class WHERE student_id = ? order by course_number"));
      ResultSet enrolled_course;
      if(action!=null && !request.getParameter("student_id").equals("")){
    	  pstmt.setInt(1,Integer.parseInt(request.getParameter("student_id")));    	  
    	  enrolled_course = pstmt.executeQuery();
      }else{
    	  enrolled_course = null;
      }
      
      %>
      <TR>
      <TH>Course</TH>
      <TH>Section ID</TH>
      <th>Grading_option</th>
      <TH>Unit</TH>
      </TR>
      <% if(enrolled_course!=null){
      while(enrolled_course.next()){ %>
      <TR>
      <form action="student_course_enroll.jsp" method="get">
      <input type="hidden" value="change_grading" name="action">
      <td><input value="<%= enrolled_course.getString(3) %>" name="course_number" readonly></td>
	  <td><input value="<%= enrolled_course.getString(2) %>" name="section_id" readonly></td>      
      <TD><input value="<%= enrolled_course.getString(5) %>" name="grading_option"></TD>
      <TD><input value="<%= enrolled_course.getInt(6) %>" name="unit"></TD>
      <input type="hidden" value="<%= enrolled_course.getInt(1) %>" name="year">
      <input type="hidden" value="<%= enrolled_course.getInt(4) %>" name="student_id">
		<td><input type="submit" value="Update"></td>
      </form>
      <form action="student_course_enroll.jsp" method="get">
      <input type="hidden" value="drop_course" name="action">
      <input type="hidden" value="<%= enrolled_course.getString(3) %>" name="course_number">
	  <input type="hidden" value="<%= enrolled_course.getString(2) %>" name="section_id">      
      <input type="hidden" value="<%= enrolled_course.getString(5) %>" name="grading_option">
      <input type="hidden" value="<%= enrolled_course.getInt(6) %>" name="unit">
      <input type="hidden" value="<%= enrolled_course.getInt(1) %>" name="year">
      <input type="hidden" value="<%= enrolled_course.getInt(4) %>" name="student_id">
		<td><input type="submit" value="Drop"></td>
		</form>		
      </TR>
      <% }
      }%>
     </TABLE>
</body>
</html>