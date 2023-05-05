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
      <td><a href="student.jsp">student</a></td>
      <td><a href="faculty.jsp">faculty</a></td>
	  <td><a href="course.jsp">course</a></td>
      <td><a href="class.jsp">class</a></td>
	  <td><a href="degrees.jsp">degrees</a></td>
      </TR>
</TABLE>

<H1>Adding Degree</H1>
<form name = "f1" method="get">
<input type="hidden" value="insert" name="action">
Major: <input type="text" name="major" size="5"/>
Type: <input type="text" name="type" size="5"/>
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
	// INSERT the general_unit_requirement attrs INTO the general_unit_requirement table.
	PreparedStatement pstmt = conn.prepareStatement(
	("INSERT INTO general_unit_requirement VALUES (?, ?, ?, ?, ?)"));
	pstmt.setString(1, request.getParameter("major"));
	pstmt.setString(2, request.getParameter("type"));
	pstmt.setString(3, request.getParameter("category"));
	pstmt.setInt(4, Integer.parseInt(request.getParameter("minimum_unit")));
    pstmt.setString(5, request.getParameter("minimum_grade"));
	pstmt.executeUpdate();
	conn.commit();
	conn.setAutoCommit(true);
	conn.close();
}
if (action != null && action.equals("update")) {
	try{
	Connection conn = ConnectionProvider.getCon();
	conn.setAutoCommit(false);
	// Create the prepared statement and use it to
	// UPDATE the general_unit_requirement attributes in the general_unit_requirement table.
	PreparedStatement pstmt = conn.prepareStatement(
	"UPDATE general_unit_requirement SET minimum_unit = ?, minimum_grade = ? WHERE major = ? AND type = ? AND category = ?");	
	pstmt.setInt(1,Integer.parseInt(request.getParameter("minimum_unit")));
    pstmt.setString(2, request.getParameter("minimum_grade"));
	pstmt.setString(3, request.getParameter("major"));	
    pstmt.setString(4, request.getParameter("type"));
	pstmt.setString(5, request.getParameter("category"));
	
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
	// DELETE the general_unit_requirement FROM the general_unit_requirement table.
	PreparedStatement pstmt = conn.prepareStatement(
	"DELETE FROM general_unit_requirement WHERE major = ? AND type = ? AND category = ?");
	pstmt.setString(1, request.getParameter("major"));
	pstmt.setString(2, request.getParameter("type"));
	pstmt.setString(3, request.getParameter("category"));
    int rowCount = pstmt.executeUpdate();
	conn.commit();
	conn.setAutoCommit(true);
	conn.close();
}
%><br><br>

<H1>Current Degrees</H1>
       <%
           Connection connection = ConnectionProvider.getCon();
           Statement statement = connection.createStatement() ;
           ResultSet resultset = statement.executeQuery("select * from general_unit_requirement") ;
       %>
      <TABLE BORDER="1">
      <TR>
      <TH>major</TH>
      <TH>type</TH>
      <TH>category</TH>
      <TH>minimum_unit</TH>
      <TH>minimum_grade</TH>
      </TR>
      <% while(resultset.next()){ %>
      <TR>
      <form action="degrees.jsp" method="get">
      <input type="hidden" value="update" name="action">
      <td><input value="<%= resultset.getString(1) %>" name="major"></td>      
      <TD><input value="<%= resultset.getString(2) %>" name="type" ></TD>
      <TD><input value="<%= resultset.getString(3) %>" name="category"></TD>
      <TD><input value="<%= resultset.getInt(4) %>" name="minimum_unit"> </TD>
      <TD><input value="<%= resultset.getString(5) %>" name="minimum_grade"></TD>
      <td><input type="submit" value="Update"></td>
      </form>
       <form action="degrees.jsp" method="get">
		<input type="hidden" value="delete" name="action">
		<input type="hidden" value="<%= resultset.getString(1) %>" name="major">     
        <input type="hidden" value="<%= resultset.getString(2) %>" name="type">
        <input type="hidden" value="<%= resultset.getString(3) %>" name="category">
        <TD><input type="submit" value="Delete"></TD>
		</form>
      </TR>
      <% } %>
     </TABLE>

</body>
</html>