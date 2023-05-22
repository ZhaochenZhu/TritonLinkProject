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
<title>Insert title here</title>
</head>
<body>
<TABLE>
      <TR>
		<td><a href="root.jsp">Go Back</a></td>
    </TR>
</TABLE>

<H1>Adding Student</H1>
<form name = "f1" method="get">
<input type="hidden" value="insert" name="action">
Student ID: <input type="text" name="student_id" size="5"/>
First name: <input type="text" name="first_name" size="5"/>
Last name: <input type="text" name="last_name" size="5"/>
Middle name: <input type="text" name="middle_name" size="2"/>
SSN: <input type="text" name="ssn" size="5"/>
<%--Enrolled: <input type="text" name="enrolled" size="2"/>--%>
Enrolled:
<select name="enrolled" id="enrolled">
  <option value="">Select One</option>
  <option value="Yes">Yes</option>
  <option value="No">No</option>
</select>
<%--Residential_status: <input type="text" name="residential_status" size="5"/>--%>
Residential_status:
<select name="residential_status" id="residential_status">
  <option value="">Select One</option>
  <option value="California resident">California resident</option>
  <option value="foreign student">foreign student</option>
  <option value="non-CA US student">non-CA US student</option>
</select>
<%-- Current Degree: <input type="text" name="current_degree" size="5"/>--%>
Current Degree:
<select name="current_degree" id="current_degree">
  <option value="">Select One</option>
  <option value="Undergraduate">Undergraduate</option>
  <option value="Graduate">Graduate</option>
  <option value="PhD">PhD</option>
</select>
<input type="submit" value="Insert"/>
</form>
<%
String action = request.getParameter("action"); 
if (action != null && action.equals("insert")) {
	Connection conn = ConnectionProvider.getCon();
	conn.setAutoCommit(false);
	// Create the prepared statement and use it to
	// INSERT the student attrs INTO the Student table.
	PreparedStatement pstmt = conn.prepareStatement(
	("INSERT INTO student VALUES (?, ?, ?, ?, ?, ?, ?, ?)"));
	pstmt.setInt(1,Integer.parseInt(request.getParameter("student_id")));
	pstmt.setString(2, request.getParameter("first_name"));
	pstmt.setString(3, request.getParameter("last_name"));
	pstmt.setString(4, request.getParameter("middle_name"));
	pstmt.setInt(5, Integer.parseInt(request.getParameter("ssn")));
	pstmt.setString(6, request.getParameter("enrolled"));
	pstmt.setString(7, request.getParameter("residential_status"));
	pstmt.setString(8, request.getParameter("current_degree"));
	pstmt.executeUpdate();
	conn.commit();
	conn.setAutoCommit(true);
	conn.close();
}%>

<H1>Register major&minor&college(undergraduate only)</H1>
<form method="get">
<input type="hidden" value="insert_major" name="action">
Student ID: <input type="text" name="student_id" size="5"/>
Major: <input type="text" name="major" size="5"/>
<input type="submit" value="Insert"/>
</form>

<form method="get">
<input type="hidden" value="insert_minor" name="action">
Student ID: <input type="text" name="student_id" size="5"/>
Minor: <input type="text" name="minor" size="5"/>
<input type="submit" value="Insert"/>
</form>

<form method="get">
<input type="hidden" value="insert_college" name="action">
Student ID: <input type="text" name="student_id" size="5"/>
College: 
<select name="college" id="college">
  <option value="">Select One</option>
  <option value="Revelle College">Revelle College</option>
  <option value="John Muir College">John Muir College</option>
  <option value="Thurgood Marshall College">Thurgood Marshall College</option>
  <option value="Earl Warren College">Earl Warren College</option>
  <option value="Eleanor Roosevelt College">Eleanor Roosevelt College</option>
  <option value="Sixth College">Sixth College</option>
  <option value="Seventh College">Seventh College</option>
</select>
<input type="submit" value="Insert"/>
</form>

<%
action = request.getParameter("action"); 
if (action != null && action.equals("insert_major")) {
	Connection conn = ConnectionProvider.getCon();
	conn.setAutoCommit(false);
	// Create the prepared statement and use it to
	// INSERT the student attrs INTO the Student table.
	Statement statement = conn.createStatement() ;
    ResultSet resultset = statement.executeQuery("select * from student WHERE student_id = "+Integer.parseInt(request.getParameter("student_id"))); ;
	if(resultset.next() && (resultset.getString(8).equals("Undergraduate"))){
		PreparedStatement pstmt = conn.prepareStatement(
		("INSERT INTO undergraduate_major VALUES (?, ?)"));
		pstmt.setInt(1,Integer.parseInt(request.getParameter("student_id")));
		pstmt.setString(2, request.getParameter("major"));
		pstmt.executeUpdate();
		conn.commit();
		conn.setAutoCommit(true);
		conn.close();
	}else{
		out.println("Student is not a Undergraduate student");
	}
}

if (action != null && action.equals("insert_minor")) {
	Connection conn = ConnectionProvider.getCon();
	conn.setAutoCommit(false);
	// Create the prepared statement and use it to
	// INSERT the student attrs INTO the Student table.
	Statement statement = conn.createStatement() ;
    ResultSet resultset = statement.executeQuery("select * from student WHERE student_id = "+Integer.parseInt(request.getParameter("student_id"))); ;
	if(resultset.next() && (resultset.getString(8).equals("Undergraduate"))){
		PreparedStatement pstmt = conn.prepareStatement(
		("INSERT INTO undergraduate_minor VALUES (?, ?)"));
		pstmt.setInt(1,Integer.parseInt(request.getParameter("student_id")));
		pstmt.setString(2, request.getParameter("minor"));
		pstmt.executeUpdate();
		conn.commit();
		conn.setAutoCommit(true);
		conn.close();
	}else{
		out.println("Student is not a Undergraduate student");
	}
}

if (action != null && action.equals("insert_college")) {
	Connection conn = ConnectionProvider.getCon();
	conn.setAutoCommit(false);
	// Create the prepared statement and use it to
	// INSERT the student attrs INTO the Student table.
	Statement statement = conn.createStatement() ;
    ResultSet resultset = statement.executeQuery("select * from student WHERE student_id = "+Integer.parseInt(request.getParameter("student_id"))); ;
	if(resultset.next() && (resultset.getString(8).equals("Undergraduate"))){
		PreparedStatement pstmt = conn.prepareStatement(
		("INSERT INTO undergraduate_student VALUES (?, ?)"));
		pstmt.setInt(1,Integer.parseInt(request.getParameter("student_id")));
		pstmt.setString(2, request.getParameter("college"));
		pstmt.executeUpdate();
		conn.commit();
		conn.setAutoCommit(true);
		conn.close();
	}else{
		out.println("Student is not a Undergraduate student");
	}
}%>

<H1>Register Department(Graduate only)</H1>
<form name = "f2" method="get">
<input type="hidden" value="insert_master" name="action">
Student ID: <input type="text" name="student_id" size="5"/>
Department: <input type="text" name="department" size="5"/>
<input type="submit" value="Insert"/>
</form>

<%
action = request.getParameter("action"); 
if (action != null && action.equals("insert_master")) {
	Connection conn = ConnectionProvider.getCon();
	conn.setAutoCommit(false);
	// Create the prepared statement and use it to
	// INSERT the student attrs INTO the Student table.
	Statement statement = conn.createStatement() ;
    ResultSet resultset = statement.executeQuery("select * from student WHERE student_id = "+Integer.parseInt(request.getParameter("student_id"))); ;
	if(resultset.next() && (resultset.getString(8).equals("Graduate") || resultset.getString(8).equals("PhD") )){
		PreparedStatement pstmt = conn.prepareStatement(
		("INSERT INTO master_student VALUES (?, ?)"));
		pstmt.setInt(1,Integer.parseInt(request.getParameter("student_id")));
		pstmt.setString(2, request.getParameter("department"));
		pstmt.executeUpdate();
		conn.commit();
		conn.setAutoCommit(true);
		conn.close();
	}else{
		out.println("Student is not a Graduate student");
	}
}%>

<H1>Register Candidacy (Phd only)</H1>
<form name = "f3" method="get">
<input type="hidden" value="insert_Phd" name="action">
Student ID: <input type="text" name="student_id" size="5"/>
<%--<input type="text" name="candidacy" size="5"/> --%>
Candidacy: 
<select name="candidacy" id="candidacy">
  <option value="">Select One</option>
  <option value="Yes">Yes</option>
  <option value="No">No</option>
</select>
<input type="submit" value="Insert"/>
</form>
<%
action = request.getParameter("action"); 
if (action != null && action.equals("insert_Phd")) {
	Connection conn = ConnectionProvider.getCon();
	conn.setAutoCommit(false);
	// Create the prepared statement and use it to
	// INSERT the student attrs INTO the Student table.
	Statement statement = conn.createStatement() ;
    ResultSet resultset = statement.executeQuery("select * from student WHERE student_id = "+Integer.parseInt(request.getParameter("student_id"))); ;
	if(resultset.next() && resultset.getString(8).equals("Phd")){
		PreparedStatement pstmt = conn.prepareStatement(
		("INSERT INTO phd_student VALUES (?, ?)"));
		pstmt.setInt(1,Integer.parseInt(request.getParameter("student_id")));
		pstmt.setString(2, request.getParameter("candidacy"));
		pstmt.executeUpdate();
		conn.commit();
		conn.setAutoCommit(true);
		conn.close();
	}else{
		out.println("Student is not a Phd student");
	}
}%>

<br>
<%
action = request.getParameter("action"); 
if (action != null && action.equals("update")) {
	try{
	Connection conn = ConnectionProvider.getCon();
	conn.setAutoCommit(false);
	// Create the prepared statement and use it to
	// UPDATE the student attributes in the Student table.
	PreparedStatement pstmt = conn.prepareStatement(
	"UPDATE student SET first_name = ?, last_name = ?, middle_name = ?, ssn = ?, enrolled = ?, residential_status = ?, current_degree = ? WHERE student_id = ?");	
	pstmt.setString(1, request.getParameter("first_name"));
	pstmt.setString(2, request.getParameter("last_name"));
	pstmt.setString(3, request.getParameter("middle_name"));	
	pstmt.setInt(4, Integer.parseInt(request.getParameter("ssn")));
	pstmt.setString(5, request.getParameter("enrolled"));
	pstmt.setString(6, request.getParameter("residential_status"));
	pstmt.setString(7, request.getParameter("current_degree"));
	pstmt.setInt(8,Integer.parseInt(request.getParameter("student_id")));
	
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
	// DELETE the student FROM the Student table.
	PreparedStatement pstmt = conn.prepareStatement(
	"DELETE FROM student WHERE student_id = ?");
	pstmt.setInt(1,Integer.parseInt(request.getParameter("student_id")));
	int rowCount = pstmt.executeUpdate();
	conn.commit();
	conn.setAutoCommit(true);
	conn.close();
}%>
<H1>Current Students</H1>
       <%
           Connection connection = ConnectionProvider.getCon();
           Statement statement = connection.createStatement() ;
           ResultSet resultset = statement.executeQuery("select * from student") ;
       %>
      <TABLE BORDER="1">
      <TR>
      <TH>student_id</TH>
      <TH>first_name</TH>
      <TH>last_name</TH>
      <TH>middle_name</TH>
      <TH>ssn</TH>
      <TH>enrolled</TH>
      <TH>residential_status</TH>
      <TH>current_degree</TH>
      </TR>
      <% while(resultset.next()){ %>
      <TR>
      <form action="student.jsp" method="get">
      <input type="hidden" value="update" name="action">
      <td><input value="<%= resultset.getInt(1) %>" name="student_id" readonly></td>
	  <td><input value="<%= resultset.getString(2) %>" name="first_name"></td>      
      <TD><input value="<%= resultset.getString(3) %>" name="last_name"></TD>
      <TD><input value="<%= resultset.getString(4) %>" name="middle_name"></TD>
      <TD><input value="<%= resultset.getInt(5) %>" name="ssn"> </TD>
      <TD><input value="<%= resultset.getString(6) %>" name="enrolled"></TD>
      <TD><input value="<%= resultset.getString(7) %>" name="residential_status"> </TD>
      <TD><input value="<%= resultset.getString(8) %>" name="current_degree"></TD>
      <td><input type="submit" value="Update"></td>
      </form>
       <form action="student.jsp" method="get">
		<input type="hidden" value="delete" name="action">
		<input type="hidden" value="<%= resultset.getInt(1) %>" name="student_id">
		<td><input type="submit" value="Delete"></td>
		</form>
      </TR>
      <% }
      resultset.close();
      connection.close();
      %>
     </TABLE>

<%
action = request.getParameter("action"); 
if (action != null && action.equals("update_college")) {
	try{
	Connection conn = ConnectionProvider.getCon();
	conn.setAutoCommit(false);
	PreparedStatement pstmt = conn.prepareStatement(
	"UPDATE undergraduate_student SET college = ? WHERE student_id = ?");	
	pstmt.setString(1, request.getParameter("college"));
	pstmt.setInt(2,Integer.parseInt(request.getParameter("student_id")));
	int rowCount = pstmt.executeUpdate();
	conn.commit();
	conn.setAutoCommit(true);
	conn.close();
	}catch(Exception ex){
		System.out.println(ex);
	}
}
if (action != null && action.equals("delete_college")) {
	Connection conn = ConnectionProvider.getCon();
	conn.setAutoCommit(false);
	PreparedStatement pstmt = conn.prepareStatement(
	"DELETE FROM undergraduate_student WHERE student_id = ?");
	pstmt.setInt(1,Integer.parseInt(request.getParameter("student_id")));
	int rowCount = pstmt.executeUpdate();
	conn.commit();
	conn.setAutoCommit(true);
	conn.close();
}
if (action != null && action.equals("delete_major")) {
	Connection conn = ConnectionProvider.getCon();
	conn.setAutoCommit(false);
	PreparedStatement pstmt = conn.prepareStatement(
	"DELETE FROM undergraduate_major WHERE student_id = ? AND major = ?");
	pstmt.setInt(1,Integer.parseInt(request.getParameter("student_id")));
	pstmt.setString(2, request.getParameter("major"));
	//out.println(pstmt.toString());
	int rowCount = pstmt.executeUpdate();
	conn.commit();
	conn.setAutoCommit(true);
	conn.close();
}
if (action != null && action.equals("delete_minor")) {
	Connection conn = ConnectionProvider.getCon();
	conn.setAutoCommit(false);
	PreparedStatement pstmt = conn.prepareStatement(
	"DELETE FROM undergraduate_minor WHERE student_id = ? AND minor = ?");
	pstmt.setInt(1,Integer.parseInt(request.getParameter("student_id")));
	pstmt.setString(2, request.getParameter("minor"));
	int rowCount = pstmt.executeUpdate();
	conn.commit();
	conn.setAutoCommit(true);
	conn.close();
}


%> 
<H1>Undergraduate Students</H1>
       <%
           connection = ConnectionProvider.getCon();
           statement = connection.createStatement() ;
           ResultSet college = statement.executeQuery("select * from undergraduate_student");          
       %>
      <TABLE BORDER="1">
      <TR>
      <TH>student_id</TH>
      <TH>college</TH>
      </TR>
      <% while(college.next()){ %>
      <TR>
      <form action="student.jsp" method="get">
      <input type="hidden" value="update_college" name="action">
      <td><input value="<%= college.getInt(1) %>" name="student_id" readonly></td>
	  <td><input value="<%= college.getString(2) %>" name="college"></td>      
      <td><input type="submit" value="Update"></td>
      </form>
       <form action="student.jsp" method="get">
		<input type="hidden" value="delete_college" name="action">
		<input type="hidden" value="<%= college.getInt(1) %>" name="student_id">
		<td><input type="submit" value="Delete"></td>
		</form>
      </TR>
      <% }
      %>
     </TABLE>
     <TABLE BORDER="1">
      <TR>
      <TH>student_id</TH>
      <TH>major</TH>
      </TR>
      <br>
      <% 
      ResultSet major = statement.executeQuery("select * from undergraduate_major");
      while(major.next()){ %>
      <TR>
      <form action="student.jsp" method="get">
      <input type="hidden" value="delete_major" name="action">
      <td><input value="<%= major.getInt(1) %>" name="student_id" readonly></td>
	  <td><input value="<%= major.getString(2) %>" name="major" readonly></td>      
      <td><input type="submit" value="Delete"></td>
      </TR>
      <% }
      %>
     </TABLE>
     <TABLE BORDER="1">
      <TR>
      <TH>student_id</TH>
      <TH>minor</TH>
      </TR>
      <br>
      <% 
      ResultSet minor = statement.executeQuery("select * from undergraduate_minor");
      while(minor.next()){ %>
      <TR>
      <form action="student.jsp" method="get">
      <input type="hidden" value="delete_minor" name="action">
      <td><input value="<%= minor.getInt(1) %>" name="student_id" readonly></td>
	  <td><input value="<%= minor.getString(2) %>" name="minor" readonly></td>      
      <td><input type="submit" value="Delete"></td>
      </form>       
      </TR>
      <% }
      %>
     </TABLE>

<%
action = request.getParameter("action"); 
if (action != null && action.equals("update_master")) {
	try{
	Connection conn = ConnectionProvider.getCon();
	conn.setAutoCommit(false);
	// Create the prepared statement and use it to
	// UPDATE the student attributes in the Student table.
	PreparedStatement pstmt = conn.prepareStatement(
	"UPDATE master_student SET department = ? WHERE student_id = ?");	
	pstmt.setString(1, request.getParameter("department"));
	pstmt.setInt(2,Integer.parseInt(request.getParameter("student_id")));
	
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
if (action != null && action.equals("delete_master")) {
	Connection conn = ConnectionProvider.getCon();
	conn.setAutoCommit(false);
	// Create the prepared statement and use it to
	// DELETE the student FROM the Student table.
	PreparedStatement pstmt = conn.prepareStatement(
	"DELETE FROM master_student WHERE student_id = ?");
	pstmt.setInt(1,Integer.parseInt(request.getParameter("student_id")));
	int rowCount = pstmt.executeUpdate();
	conn.commit();
	conn.setAutoCommit(true);
	conn.close();
}%>  
<H1>Graduate Students</H1>
       <%
           connection = ConnectionProvider.getCon();
           statement = connection.createStatement() ;
           resultset = statement.executeQuery("select * from master_student") ;
       %>
      <TABLE BORDER="1">
      <TR>
      <TH>student_id</TH>
      <TH>department</TH>
      </TR>
      <% while(resultset.next()){ %>
      <TR>
      <form action="student.jsp" method="get">
      <input type="hidden" value="update_master" name="action">
      <td><input value="<%= resultset.getInt(1) %>" name="student_id" readonly></td>
	  <td><input value="<%= resultset.getString(2) %>" name="department"></td>      
      <td><input type="submit" value="Update"></td>
      </form>
       <form action="student.jsp" method="get">
		<input type="hidden" value="delete_master" name="action">
		<input type="hidden" value="<%= resultset.getInt(1) %>" name="student_id">
		<td><input type="submit" value="Delete"></td>
		</form>
      </TR>
      <% }
      resultset.close();
      connection.close();
      %>
     </TABLE>
   
<%
action = request.getParameter("action"); 
if (action != null && action.equals("update_phd")) {
	try{
	Connection conn = ConnectionProvider.getCon();
	conn.setAutoCommit(false);
	// Create the prepared statement and use it to
	// UPDATE the student attributes in the Student table.
	PreparedStatement pstmt = conn.prepareStatement(
	"UPDATE phd_student SET candidacy = ? WHERE student_id = ?");	
	pstmt.setString(1, request.getParameter("candidacy"));
	pstmt.setInt(2,Integer.parseInt(request.getParameter("student_id")));
	
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

if (action != null && action.equals("delete_phd")) {
	Connection conn = ConnectionProvider.getCon();
	conn.setAutoCommit(false);
	// Create the prepared statement and use it to
	// DELETE the student FROM the Student table.
	PreparedStatement pstmt = conn.prepareStatement(
	"DELETE FROM phd_student WHERE student_id = ?");
	pstmt.setInt(1,Integer.parseInt(request.getParameter("student_id")));
	int rowCount = pstmt.executeUpdate();
	conn.commit();
	conn.setAutoCommit(true);
	conn.close();
} %>     
<H1>Phd Students</H1>
       <%
           connection = ConnectionProvider.getCon();
           statement = connection.createStatement() ;
           resultset = statement.executeQuery("select * from phd_student") ;
       %>
      <TABLE BORDER="1">
      <TR>
      <TH>student_id</TH>
      <TH>candidacy</TH>
      </TR>
      <% while(resultset.next()){ %>
      <TR>
      <form action="student.jsp" method="get">
      <input type="hidden" value="update_phd" name="action">
      <td><input value="<%= resultset.getInt(1) %>" name="student_id" readonly></td>
	  <td><input value="<%= resultset.getString(2) %>" name="candidacy"></td>      
      <td><input type="submit" value="Update"></td>
      </form>
       <form action="student.jsp" method="get">
		<input type="hidden" value="delete_phd" name="action">
		<input type="hidden" value="<%= resultset.getInt(1) %>" name="student_id">
		<td><input type="submit" value="Delete"></td>
		</form>
      </TR>
      <% }
      resultset.close();
      connection.close();
      %>
     </TABLE>


</body>
</html>