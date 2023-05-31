<%@ page language="java" contentType="text/html; charset=UTF-8"
 pageEncoding="UTF-8" import="java.sql.*, com.mit.*"%>
<!DOCTYPE html>
<html>
<head>
<style>
table { 
	border-collapse: separate; border-spacing: 5px; 
}
</style>
<meta charset="UTF-8">
<title>Degrees</title>
</head>
<body>
<TABLE>
 <TR>
	<td><a href="root.jsp">Go Back</a></td>
 </TR>
</TABLE>

<H2>Adding Degree Total Unit Requirement</H2>
<form name = "f1" method="get">
<input type="hidden" value="insert_t" name="action_t">
Discipline: <input type="text" name="discipline" size="5"/>
Degree Type: <input type="text" name="type" id="type" size="5"/>
<%--<input type="text" name="type" size="5"/> --%>
<!-- <select name="degree type" id="type">
  <option value="">Select One</option>
  <option value="Bachelor of Science">Bachelor of Science</option>
  <option value="Bachelor of Arts">Bachelor of Arts</option>
  <option value="Graduate">Master</option>
</select> -->
Degree Focus: <select name="focus" id="focus">
  <option value="">Select One</option>
  <option value="major">Major</option>
  <option value="minor">Minor</option>
  </select> 
Total unit: <input type="text" name="total_unit" size="5"/>
<input type="submit" value="Insert"/>
</form>

<%
String action_t = request.getParameter("action_t");
if (action_t != null && action_t.equals("insert_t")) {
	Connection conn = ConnectionProvider.getCon();
	conn.setAutoCommit(false);
	// Create the prepared statement and use it to
	// INSERT INTO the total_unit_requirement table.
	try{
	PreparedStatement pstmt = conn.prepareStatement(
	("INSERT INTO total_unit_requirement VALUES (?, ?, ?, ?)"));
	pstmt.setString(1, request.getParameter("discipline"));
	pstmt.setString(2, request.getParameter("type"));
	pstmt.setString(3, request.getParameter("focus"));
	pstmt.setInt(4, Integer.parseInt(request.getParameter("total_unit")));
	//out.println(pstmt.toString());
	pstmt.executeUpdate();
	}catch(Exception e){
		out.println(e.getMessage());
	}
	conn.commit();
	conn.setAutoCommit(true);
	conn.close();
}

if (action_t != null && action_t.equals("update_t")) {
	try{
	Connection conn = ConnectionProvider.getCon();
	conn.setAutoCommit(false);
	// Create the prepared statement and use it to
	// UPDATE the total_unit_requirement attributes 
	PreparedStatement pstmt = conn.prepareStatement(
	"UPDATE total_unit_requirement SET total_unit = ? WHERE discipline = ? AND degree_type = ? AND degree_focus = ?");	
	pstmt.setInt(1,Integer.parseInt(request.getParameter("total_unit")));
	pstmt.setString(2, request.getParameter("discipline"));	
 	pstmt.setString(3, request.getParameter("type"));
 	pstmt.setString(4, request.getParameter("focus"));


	// out.println(pstmt.toString());
	// System.out.println(pstmt.toString());
	int rowCount = pstmt.executeUpdate();
	conn.commit();
	conn.setAutoCommit(true);
	conn.close();
	}catch(Exception ex){
		System.out.println(ex);
	}
}

if (action_t != null && action_t.equals("delete_t")) {
	Connection conn = ConnectionProvider.getCon();
	conn.setAutoCommit(false);
	// Create the prepared statement and use it to
	// DELETE the total_unit_requirement attribute.
	PreparedStatement pstmt = conn.prepareStatement(
	"DELETE FROM total_unit_requirement WHERE discipline = ? AND degree_type = ? AND degree_focus = ?");
	pstmt.setString(1, request.getParameter("discipline"));
	pstmt.setString(2, request.getParameter("type"));
	pstmt.setString(3, request.getParameter("focus"));
 int rowCount = pstmt.executeUpdate();
	conn.commit();
	conn.setAutoCommit(true);
	conn.close();
}
%>
<H2>Current Degrees Total Unit requirement</H2>
 <%
 Connection connection = ConnectionProvider.getCon();
 ResultSet total_unit = connection.createStatement().executeQuery("select * from total_unit_requirement") ;
 %>

 <TABLE BORDER="1">
 <TR>
 <TH>Discipline</TH>
 <TH>Degree Type</TH>
 <TH>Degree Focus</TH>
 <TH>total_unit</TH>
 </TR>
 <% while(total_unit.next()){ %>
 <TR>
<form action="degrees.jsp" method="get">
 <input type="hidden" value="update_t" name="action_t">
 <td><input value="<%= total_unit.getString(1) %>" name="discipline"></td> 
 <TD><input value="<%= total_unit.getString(2) %>" name="type" ></TD>
 <TD><input value="<%= total_unit.getString(3) %>" name="focus" ></TD>
 <TD><input value="<%= total_unit.getInt(4) %>" name="total_unit"> </TD>
 <td><input type="submit" value="Update"></td>
 </form>

 <form action="degrees.jsp" method="get">
	<input type="hidden" value="delete_t" name="action_t">
	<input type="hidden" value="<%= total_unit.getString(1) %>" name="discipline"> 
 <input type="hidden" value="<%= total_unit.getString(2) %>" name="type">
 <input type="hidden" value="<%= total_unit.getString(3) %>" name="focus">
  <TD><input type="submit" value="Delete"></TD>
	</form>
 </TR>
 <% } %>
 </TABLE>
 <br><br>


<H2>Adding Undergraduate Degree Category Unit Requirement</H2>
<form name = "f1" method="get">
<input type="hidden" value="insert" name="action">
Discipline: <input type="text" name="discipline" size="5"/>
Degree Type: <input type="text" name="type" size="5"/> 
Degree Focus:
<select name="focus" id="focus">
  <option value="">Select One</option>
  <option value="major">Major</option>
  <option value="minor">Minor</option>
</select>
Category: <input type="text" name="category" size="5"/>
Minimum unit: <input type="text" name="minimum_unit" size="2"/>
Minimum grade: <input type="text" name="minimum_grade" size="5"/>
<input type="submit" value="Insert"/>
</form>


<%
String action = request.getParameter("action");
if (action != null && action.equals("insert")) {
	Connection conn = ConnectionProvider.getCon();
	conn.setAutoCommit(false);
	// Create the prepared statement and use it to
	// INSERT into undergrad_unit_requirement
	try{
	PreparedStatement pstmt = conn.prepareStatement(
	("INSERT INTO undergrad_unit_requirement VALUES (?, ?, ?, ?, ?, ?)"));
	pstmt.setString(1, request.getParameter("discipline"));
	pstmt.setString(2, request.getParameter("type"));
	pstmt.setString(3, request.getParameter("focus"));
	pstmt.setString(4, request.getParameter("category"));
	pstmt.setInt(5, Integer.parseInt(request.getParameter("minimum_unit")));
 	pstmt.setFloat(6, Float.parseFloat(request.getParameter("minimum_grade")));
	pstmt.executeUpdate();
	}catch(Exception e){
		out.println(e.getMessage());
	}
	conn.commit();
	conn.setAutoCommit(true);
	conn.close();
}

if (action != null && action.equals("update")) {
	try{
	Connection conn = ConnectionProvider.getCon();
	conn.setAutoCommit(false);
	// Create the prepared statement and use it to
	// UPDATE the undergrad_unit_requirement attributes 
	PreparedStatement pstmt = conn.prepareStatement(
	"UPDATE undergrad_unit_requirement SET minimum_unit = ?, minimum_grade = ? WHERE discipline = ? AND degree_type = ? AND degree_focus = ? AND category = ?");	
	pstmt.setInt(1,Integer.parseInt(request.getParameter("minimum_unit")));
 	pstmt.setFloat(2, Float.parseFloat(request.getParameter("minimum_grade")));
	pstmt.setString(3, request.getParameter("discipline"));	
 	pstmt.setString(4, request.getParameter("type"));
 	pstmt.setString(5, request.getParameter("focus"));
	pstmt.setString(6, request.getParameter("category"));	

	// out.println(pstmt.toString());
	// System.out.println(pstmt.toString());
	int rowCount = pstmt.executeUpdate();
	conn.commit();
	conn.setAutoCommit(true);
	conn.close();
	}catch(Exception ex){
		System.out.println(ex);
	}
}

if (action != null && action.equals("delete")) {
	Connection conn = ConnectionProvider.getCon();
	conn.setAutoCommit(false);
	// Create the prepared statement and use it to
	// DELETE 
	PreparedStatement pstmt = conn.prepareStatement(
	"DELETE FROM undergrad_unit_requirement WHERE discipline = ? AND degree_type = ? AND degree_focus = ? AND category = ?");
	pstmt.setString(1, request.getParameter("discipline"));
	pstmt.setString(2, request.getParameter("type"));
	pstmt.setString(3, request.getParameter("focus"));
	pstmt.setString(4, request.getParameter("category"));
 	int rowCount = pstmt.executeUpdate();
	conn.commit();
	conn.setAutoCommit(true);
	conn.close();
}
%><br><br>



<H2>Current Undergraduate Degrees</H2>
 <%
 Statement statement = connection.createStatement() ;
 ResultSet resultset = statement.executeQuery("select * from undergrad_unit_requirement") ;
 %>

 <TABLE BORDER="1">
 <TR>
 <TH>Discipline</TH>
 <TH>Degree Type</TH>
 <TH>Degree Focus</TH>
 <TH>Category</TH>
 <TH>Minimum Unit</TH>
 <TH>Minimum Grade</TH>
 </TR>

 <% while(resultset.next()){ %>
 <TR>
 <form action="degrees.jsp" method="get">
 <input type="hidden" value="update" name="action">
 <td><input value="<%= resultset.getString(1) %>" name="discipline"></td> 
 <TD><input value="<%= resultset.getString(2) %>" name="type" ></TD>
 <TD><input value="<%= resultset.getString(3) %>" name="focus" ></TD>
 <TD><input value="<%= resultset.getString(4) %>" name="category"></TD>
 <TD><input value="<%= resultset.getInt(5) %>" name="minimum_unit"> </TD>
 <TD><input value="<%= resultset.getFloat(6) %>" name="minimum_grade"></TD>
 <td><input type="submit" value="Update"></td>
 </form>

 <form action="degrees.jsp" method="get">
	<input type="hidden" value="delete" name="action">
	<input type="hidden" value="<%= resultset.getString(1) %>" name="discipline"> 
 <input type="hidden" value="<%= resultset.getString(2) %>" name="type">
  <input type="hidden" value="<%= resultset.getString(3) %>" name="focus">
 <input type="hidden" value="<%= resultset.getString(4) %>" name="category">
  <TD><input type="submit" value="Delete"></TD>
	</form>
 </TR>
 <% } %>
 </TABLE>
 <br><br>


 

<H2>Adding Undergraduate Degree Course Category requirements</H2>
<form name = "f1" method="get">
<input type="hidden" value="insert_cr" name="action_cr">
Discipline: <input type="text" name="discipline" size="5"/>
Degree Type:
<input type="text" name="type" id = "type" size="10"/> 
Degree Focus:
<select name="focus" id="focus">
  <option value="">Select One</option>
  <option value="major">Major</option>
  <option value="minor">Minor</option>
</select>
Category: <input type="text" name="category" size="5"/>
Course Number: <input type="text" name="course_number" size="10"/>
<input type="submit" value="Insert"/>
</form>



<%
String action_cr = request.getParameter("action_cr");
if (action_cr != null && action_cr.equals("insert_cr")) {
	Connection conn = ConnectionProvider.getCon();
	conn.setAutoCommit(false);
	// Create the prepared statement and use it to
	// INSERT the undergrad_unit_requirement attrs INTO the undergrad_course_requirement table.
	try{
	PreparedStatement pstmt = conn.prepareStatement(
	("INSERT INTO undergrad_course_requirement VALUES (?, ?, ?, ?, ?)"));
	pstmt.setString(1, request.getParameter("discipline"));
	pstmt.setString(2, request.getParameter("type"));
	pstmt.setString(3, request.getParameter("focus"));
	pstmt.setString(4, request.getParameter("category"));
	pstmt.setString(5, request.getParameter("course_number"));
	pstmt.executeUpdate();
	}catch(Exception e){
		out.println(e.getMessage());
	}
	conn.commit();
	conn.setAutoCommit(true);
	conn.close();
}



if (action_cr != null && action_cr.equals("delete_cr")) {
	Connection conn = ConnectionProvider.getCon();
	conn.setAutoCommit(false);
	// Create the prepared statement and use it to
	// DELETE the 
	PreparedStatement pstmt = conn.prepareStatement(
	"DELETE FROM undergrad_course_requirement WHERE discipline = ? AND degree_type = ? AND degree_focus = ? AND category = ? AND course_number = ?");
	pstmt.setString(1, request.getParameter("discipline"));
	pstmt.setString(2, request.getParameter("type"));
	pstmt.setString(3, request.getParameter("focus"));
	pstmt.setString(4, request.getParameter("category"));
	pstmt.setString(5, request.getParameter("course_number"));
 int rowCount = pstmt.executeUpdate();
	conn.commit();
	conn.setAutoCommit(true);
	conn.close();
}

%><br><br>





<H2>Current Undergraduate Degree Course Category Requirements</H2>
<%
 Connection conn_cr = ConnectionProvider.getCon();
 Statement statement_cr = conn_cr.createStatement() ;
 ResultSet resultset_cr = statement_cr.executeQuery("select * from undergrad_course_requirement") ;
 %>
 <TABLE BORDER="1">
 <TR>
 <TH>Discipline</TH>
 <TH>Degree Type</TH>
 <TH>Degree Focus</TH>
 <TH>Category</TH>
 <TH>Course Number</TH>
 </TR>

 <% while(resultset_cr.next()){ %>
 <TR>
 <form action="degrees.jsp" method="get">
 <input type="hidden" value="update" name="action">
	 <td><input value="<%= resultset_cr.getString(1) %>" name="discipline"></td> 
	 <TD><input value="<%= resultset_cr.getString(2) %>" name="type" ></TD>
	 <TD><input value="<%= resultset_cr.getString(3) %>" name="focus" ></TD>
	 <TD><input value="<%= resultset_cr.getString(4) %>" name="category"></TD>
	 <TD><input value="<%= resultset_cr.getString(5) %>" name="course_number"></TD>
 <input type="hidden" value="Update">
 </form> 

 <form action="degrees.jsp" method="get">
	<input type="hidden" value="delete_cr" name="action_cr">
	<input type="hidden" value="<%= resultset_cr.getString(1) %>" name="discipline"> 
	<input type="hidden" value="<%= resultset_cr.getString(2) %>" name="type">
	<input type="hidden" value="<%= resultset_cr.getString(3) %>" name="focus">
	<input type="hidden" value="<%= resultset_cr.getString(4) %>" name="category">
	<input type="hidden" value="<%= resultset_cr.getString(5) %>" name="course_number">
	<TD><input type="submit" value="Delete"></TD>
</form>
 </TR>
 <% } %>
 </TABLE>
 <br><br>







<H2>Adding Master Concentration requirement</H2>
<form name = "f1" method="get">
<input type="hidden" value="insert_mc" name="action_mc">
Discipline: <input type="text" name="discipline" size="10"/>
Concentration: <input type="text" name="concentration" size="5"/>
Minimum unit: <input type="text" name="minimum_unit" size="2"/>
Minimum grade: <input type="text" name="minimum_grade" size="5"/>
<input type="submit" value="Insert"/>

</form>



<%

String action_mc = request.getParameter("action_mc");
if (action_mc != null && action_mc.equals("insert_mc")) {
	Connection conn = ConnectionProvider.getCon();
	
	// Create the prepared statement and use it to
	// INSERT the master_concentration_requirement attrs INTO the master_concentration_requirement table.
	PreparedStatement pstmt = conn.prepareStatement(
	("INSERT INTO master_concentration_requirement VALUES (?, ?, ?, ?, ?, ?)"));
	pstmt.setString(1, request.getParameter("discipline"));
	pstmt.setString(2, "Graduate");
	pstmt.setString(3, "major");
	pstmt.setString(4, request.getParameter("concentration"));
	pstmt.setInt(5, Integer.parseInt(request.getParameter("minimum_unit")));
 	pstmt.setFloat(6, Float.parseFloat(request.getParameter("minimum_grade")));
	pstmt.executeUpdate();

	conn.close();
}

if (action_mc != null && action_mc.equals("update_mc")) {
	
	Connection conn = ConnectionProvider.getCon();
	conn.setAutoCommit(false);
	// Create the prepared statement and use it to
	// UPDATE the master_course_requirement attributes 
	PreparedStatement pstmt = conn.prepareStatement(
	"UPDATE master_concentration_requirement SET minimum_unit = ?, minimum_grade = ? WHERE discipline = ? AND concentration = ? AND degree_type = 'Graduate' AND degree_focus = 'major'");	
	pstmt.setInt(1,Integer.parseInt(request.getParameter("minimum_unit")));
 	pstmt.setFloat(2, Float.parseFloat(request.getParameter("minimum_grade")));
	pstmt.setString(3, request.getParameter("discipline"));	
	pstmt.setString(4, request.getParameter("concentration"));


	// out.println(pstmt.toString());
	// System.out.println(pstmt.toString());
	int rowCount = pstmt.executeUpdate();
	conn.commit();
	conn.setAutoCommit(true);
	conn.close();
	
}

if (action_mc != null && action_mc.equals("delete_mc")) {
	Connection conn = ConnectionProvider.getCon();
	conn.setAutoCommit(false);
	// Create the prepared statement and use it to
	// DELETE the master_concentration_requirement 
	PreparedStatement pstmt = conn.prepareStatement(
	"DELETE FROM master_concentration_requirement WHERE discipline = ? AND concentration = ? AND degree_type = 'Graduate' AND degree_focus = 'major'");
	pstmt.setString(1, request.getParameter("discipline"));
	pstmt.setString(2, request.getParameter("concentration"));
 	pstmt.executeUpdate();
	conn.commit();
	conn.setAutoCommit(true);
	conn.close();
}
%><br><br>



<H2>Current Master Concentration requirement</H2>
 <%
 /* Connection connection = ConnectionProvider.getCon();
 Statement statement = connection.createStatement() ; */
 ResultSet resultset_mc = statement.executeQuery("select * from master_concentration_requirement") ;
 %>
 <TABLE BORDER="1">
 <TR>
 <TH>discipline</TH>
 <TH>concentration</TH>
 <TH>minimum_unit</TH>
 <TH>minimum_grade</TH>
 </TR>
 <% while(resultset_mc.next()){ %>
 <TR>
 <form action="degrees.jsp" method="get">
 <input type="hidden" value="update_mc" name="action_mc">
 <td><input value="<%= resultset_mc.getString(1) %>" name="discipline"></td> 
 <TD><input value="<%= resultset_mc.getString(4) %>" name="concentration" ></TD>
 <TD><input value="<%= resultset_mc.getInt(5) %>" name="minimum_unit"> </TD>
 <TD><input value="<%= resultset_mc.getFloat(6) %>" name="minimum_grade"></TD>
 <td><input type="submit" value="Update"></td>
 </form>
 <form action="degrees.jsp" method="get">
	<input type="hidden" value="delete_mc" name="action_mc">
	<input type="hidden" value="<%= resultset_mc.getString(1) %>" name="discipline"> 
 	<input type="hidden" value="<%= resultset_mc.getString(4) %>" name="concentration">
 <TD><input type="submit" value="Delete"></TD>
	</form>
 </TR>
 <% } %>
 </TABLE>
 <br><br>



<H2>Adding Master Course requirement</H2>
<form name = "f1" method="get">
<input type="hidden" value="insert_mr" name="action_mr">
Discipline: <input type="text" name="discipline" size="5"/>
Concentration: <input type="text" name="concentration" size="5"/>
Course Number: <input type="text" name="course_number" size="5"/>
<input type="submit" value="Insert"/>
</form>



<%

String action_mr = request.getParameter("action_mr");
if (action_mr != null && action_mr.equals("insert_mr")) {
	Connection conn = ConnectionProvider.getCon();
	conn.setAutoCommit(false);
	// Create the prepared statement and use it to
	// INSERT the master_course_requirement 
	PreparedStatement pstmt = conn.prepareStatement(
	("INSERT INTO master_course_requirement VALUES (?, ?, ?, ?, ?)"));
	pstmt.setString(1, request.getParameter("discipline"));
	pstmt.setString(2, "Graduate");
	pstmt.setString(3, "major");
	pstmt.setString(4, request.getParameter("concentration"));
 	pstmt.setString(5, request.getParameter("course_number"));
	pstmt.executeUpdate();
	conn.commit();
	conn.setAutoCommit(true);
	conn.close();
}



if (action_mr != null && action_mr.equals("delete_mr")) {
	Connection conn = ConnectionProvider.getCon();
	conn.setAutoCommit(false);
	// Create the prepared statement and use it to
	// DELETE the master_course_requirement
	PreparedStatement pstmt = conn.prepareStatement(
	"DELETE FROM master_course_requirement WHERE discipline = ? AND degree_type = 'Graduate' AND degree_focus = 'major' AND concentration = ? AND course_number = ?");
	pstmt.setString(1, request.getParameter("discipline"));
	pstmt.setString(2, request.getParameter("concentration"));
	pstmt.setString(3, request.getParameter("course_number"));
 	pstmt.executeUpdate();
 	
	conn.commit();
	conn.setAutoCommit(true);
	conn.close();
}
%><br><br>


<H2>Current Master Course requirement</H2>
<%
 ResultSet resultset_mr = statement.executeQuery("select * from master_course_requirement") ;
 %>

 <TABLE BORDER="1">
 <TR>
 <TH>discipline</TH>
 <TH>concentration</TH>
 <TH>course_number</TH>
 </TR>

 <% while(resultset_mr.next()){ %>
  <TR>
   <form action="degrees.jsp" method="get">
    <input type="hidden" value="update" name="action">
 <td><input value="<%= resultset_mr.getString(1) %>" name="discipline"></td> 
 <TD><input value="<%= resultset_mr.getString(4) %>" name="concentratione" ></TD>
 <TD><input value="<%= resultset_mr.getString(5) %>" name="course_number"></TD>
 <input type="hidden" value="Update">
 </form> 

 <form action="degrees.jsp" method="get">
 	<input type="hidden" value="delete_mr" name="action_mr">
	<input type="hidden" value="<%= resultset_mr.getString(1) %>" name="discipline"> 
	 <input type="hidden" value="<%= resultset_mr.getString(4) %>" name="concentration">
	 <input type="hidden" value="<%= resultset_mr.getString(5) %>" name="course_number">
	 <TD><input type="submit" value="Delete"></TD>
	</form>
 </TR>
 <% } %>
 </TABLE>
 <br><br>
</body>
</html>