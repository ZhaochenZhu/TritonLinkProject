<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.sql.*, com.mit.*, java.text.SimpleDateFormat, java.util.*"%>
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
	//out.println(request.getParameter("course_number"));
	cur_course = course_info.getString(1)+", "+course_info.getString(2);
}
if(action != null && action.equals("select_course")){
	course_sections = statement.executeQuery("select section_id from section where year = 2023 AND quarter = 'Spring' AND course_number = '"
			+request.getParameter("course_number")+"'") ;
}


%>
<h2><%=cur_course %></h2>    
<form action="produce_review_session_schedule.jsp" method="get">
<input type="hidden" value="schedule" name="action">
<input type="hidden" value="<%=request.getParameter("course_number")!=null? request.getParameter("course_number"):null %>" name="course_number">
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
ResultSet available_slots = null;
if (action != null && action.equals("schedule")) {
	if(request.getParameter("Section").equals("")){
		out.println("Please select a section");
	}else{
		String start_date = request.getParameter("start_date");
		String end_date = request.getParameter("end_date");
		
		//add dates into table
		try{
			Calendar c = Calendar.getInstance();
			statement.executeUpdate("DELETE FROM review_session_range");
			PreparedStatement pstmt = connection.prepareStatement("Insert into review_session_range values (?)");
	        while(!start_date.equals(end_date)){
	        	pstmt.setString(1, start_date);
	        	int rowCount = pstmt.executeUpdate();
	        	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");		        
		        c.setTime(sdf.parse(start_date));
		        c.add(Calendar.DATE, 1);  // add 1 day
		        start_date = sdf.format(c.getTime());  
	        }
	        pstmt.setString(1, start_date);
        	int rowCount = pstmt.executeUpdate(); //append end date
		}catch(Exception ex){
			out.println(ex);
		}
		
		PreparedStatement query_slot = connection.prepareStatement("with available_spot as( "
				+"select * "
				+"from review_session_range r, review_session_times t "
				+"), "
				+"other_classes as( "
				+"SELECT DISTINCT o.year, o.course_number, o.section_id "
				+"FROM student s, section c, enrollment_list_of_class e, section o, enrollment_list_of_class e_o "
				+"WHERE e.course_number = c.course_number AND e.year = c.year AND e.section_id = c.section_id AND e.student_id = s.student_id AND "
				+"e.course_number = ? AND e.section_id = ? AND e_o.course_number = o.course_number AND e_o.year = o.year "
				+"AND e_o.section_id = o.section_id AND e_o.student_id = s.student_id " 
				+"), "
				+"conflict_slot as( "
				+"select distinct a.date, a.start_time, a.end_time "
				+"from available_spot a, other_classes y, class_meetings_times m "
				+"where y.year = m.year AND y.course_number = m.course_number AND y.section_id = m.section_id "
				+"and a.date = m.date "
				+"and ((TO_TIMESTAMP(m.start_time,'HH24:MI')<=TO_TIMESTAMP(a.end_time,'HH24:MI') " 
				+"and TO_TIMESTAMP(m.end_time,'HH24:MI')>=TO_TIMESTAMP(a.start_time,'HH24:MI')) "
				+"or (TO_TIMESTAMP(a.start_time,'HH24:MI')<=TO_TIMESTAMP(m.end_time,'HH24:MI') " 
				+"and TO_TIMESTAMP(a.end_time,'HH24:MI')>=TO_TIMESTAMP(m.start_time,'HH24:MI'))) "
				+"), "
				+"valid_timestamp as( "
				+"select date, TO_TIMESTAMP(start_time,'HH24:MI')::TIME as start_time, TO_TIMESTAMP(end_time,'HH24:MI')::TIME as end_time from available_spot "
				+"EXCEPT (select date, TO_TIMESTAMP(start_time,'HH24:MI')::TIME as start_time, TO_TIMESTAMP(end_time,'HH24:MI')::TIME as end_time from conflict_slot) "
				+"order by date, start_time "
				+") "
				+"SELECT date, to_char(start_time, 'HH24:MI'), to_char(end_time, 'HH24:MI') "
				+"from valid_timestamp");
		query_slot.setString(1, request.getParameter("course_number"));
		query_slot.setString(2, request.getParameter("Section"));
		available_slots = query_slot.executeQuery();
		//out.println(request.getParameter("course_number")+request.getParameter("section_id"));
		//out.println(request.getParameter("course_number"));
		//out.println(query_slot.toString());
		
	}
}
%>

<h2><%= "Available slots for review session for "+cur_course%></h2>
<TABLE BORDER="1">
<TR>
<TH>date</TH>
<TH>start_time</TH>
<TH>end_time</TH>
</TR>
<% 
if(available_slots!=null){
while(available_slots.next()){ %>
      <TR>
      <TD><%=available_slots.getString(1) %></TD>
      <TD><%=available_slots.getString(2) %></TD>
      <TD><%=available_slots.getString(3) %></TD>
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