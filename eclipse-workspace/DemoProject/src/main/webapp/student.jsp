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
Enrolled: <input type="text" name="enrolled" size="2"/>
Residential_status: <input type="text" name="residential_status" size="5"/>
Current Degree: <input type="text" name="current_degree" size="5"/>
<input type="submit" value="Insert"/>
</form>

<H1>Register Department(master only)</H1>
<form name = "f2" method="get">
<input type="hidden" value="insert_master" name="action">
Student ID: <input type="text" name="student_id" size="5"/>
Department: <input type="text" name="department" size="5"/>
<input type="submit" value="Insert"/>
</form>

<H1>Register Candidacy (Phd only)</H1>
<form name = "f3" method="get">
<input type="hidden" value="insert_Phd" name="action">
Student ID: <input type="text" name="student_id" size="5"/>
Candidacy: <input type="text" name="candidacy" size="5"/>
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
}
if (action != null && action.equals("insert_master")) {
	Connection conn = ConnectionProvider.getCon();
	conn.setAutoCommit(false);
	// Create the prepared statement and use it to
	// INSERT the student attrs INTO the Student table.
	Statement statement = conn.createStatement() ;
    ResultSet resultset = statement.executeQuery("select * from student WHERE student_id = "+Integer.parseInt(request.getParameter("student_id"))); ;
	if(resultset.next() && (resultset.getString(8).equals("master") || resultset.getString(8).equals("Phd") )){
		PreparedStatement pstmt = conn.prepareStatement(
		("INSERT INTO master_student VALUES (?, ?)"));
		pstmt.setInt(1,Integer.parseInt(request.getParameter("student_id")));
		pstmt.setString(2, request.getParameter("department"));
		pstmt.executeUpdate();
		conn.commit();
		conn.setAutoCommit(true);
		conn.close();
	}else{
		out.println("Student is not a master(lowercase) student");
	}
}
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
}
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
}

%><br><br>

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
      <td><input value="<%= resultset.getInt(1) %>" name="student_id"></td>
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
      <td><input value="<%= resultset.getInt(1) %>" name="student_id"></td>
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
      <td><input value="<%= resultset.getInt(1) %>" name="student_id"></td>
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