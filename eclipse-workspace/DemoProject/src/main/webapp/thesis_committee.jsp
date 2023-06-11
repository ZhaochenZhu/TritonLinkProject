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
<title>Thesis Committee</title>
</head>
<body>
<TABLE>
      <TR>
		<td><a href="root.jsp">Go Back</a></td>
    </TR>
</TABLE>

<H1>Adding Degree</H1>
<form name = "f1" method="get">
<input type="hidden" value="insert" name="action">
Student_id: <input type="text" name="student_id" size="5"/>
Professor: <input type="text" name="faculty_name" size="5"/>
<input type="submit" value="Insert"/>
</form>

<%
String action = request.getParameter("action");
if (action != null && action.equals("insert")) {
	Connection conn = ConnectionProvider.getCon();
	Statement statement = conn.createStatement() ;
    ResultSet resultset = statement.executeQuery("select * from phd_student WHERE student_id = "+Integer.parseInt(request.getParameter("student_id"))); ;
	if(resultset.next() && resultset.getString(2).equals("Yes")){
		conn.setAutoCommit(false);
		// Create the prepared statement and use it to
		// INSERT the thesis_committee attrs INTO the thesis_committee table.
		PreparedStatement pstmt = conn.prepareStatement(
		("INSERT INTO thesis_committee VALUES (?, ?)"));
		pstmt.setInt(1, Integer.parseInt(request.getParameter("student_id")));
	    pstmt.setString(2, request.getParameter("faculty_name"));
		pstmt.executeUpdate();
		conn.commit();
		conn.setAutoCommit(true);
		conn.close();
	}else{
		out.println("Not a candidate!");
	}
	
}

//TODO what is cannot update can only delete and add new?
/**
if (action != null && action.equals("update")) {
	try{
	Connection conn = ConnectionProvider.getCon();
	conn.setAutoCommit(false);
	// Create the prepared statement and use it to
	// UPDATE the general_unit_requirement attributes in the general_unit_requirement table.
	PreparedStatement pstmt = conn.prepareStatement(
	"UPDATE thesis_committee SET minimum_unit = ?, minimum_grade = ? WHERE major = ? AND type = ? AND category = ?");	
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
}**/
if (action != null && action.equals("delete")) {
	Connection conn = ConnectionProvider.getCon();
	conn.setAutoCommit(false);
	// Create the prepared statement and use it to
	// DELETE the general_unit_requirement FROM the general_unit_requirement table.
	PreparedStatement pstmt = conn.prepareStatement(
	"DELETE FROM thesis_committee WHERE student_id = ? AND faculty_name = ?");
	pstmt.setInt(1, Integer.parseInt(request.getParameter("student_id")));
	pstmt.setString(2, request.getParameter("faculty_name"));
	int rowCount = pstmt.executeUpdate();
	conn.commit();
	conn.setAutoCommit(true);
	conn.close();
}
%><br><br>

<H1>thesis committees</H1>
       <%
           Connection connection = ConnectionProvider.getCon();
           Statement statement = connection.createStatement() ;
           ResultSet resultset = statement.executeQuery("select * from thesis_committee order by student_id") ;
       %>
      <TABLE BORDER="1">
      <TR>
      <TH>student_id</TH>
      <TH>faculty_name</TH>
      </TR>
      <% while(resultset.next()){ %>
      <TR>
      <form action="thesis_committee.jsp" method="get">
      <input type="hidden" value="update" name="action">
      <TD><input value="<%= resultset.getInt(1) %>" name="student_id"> </TD>
      <td><input value="<%= resultset.getString(2) %>" name="faculty_name"></td>      
      <input type="hidden" value="Update">
      </form>
       <form action="thesis_committee.jsp" method="get">
		<input type="hidden" value="delete" name="action">
		<input type="hidden" value="<%= resultset.getInt(1) %>" name="student_id">     
        <input type="hidden" value="<%= resultset.getString(2) %>" name="faculty_name">
        <TD><input type="submit" value="Delete"></TD>
		</form>
      </TR>
      <% } %>
     </TABLE>

</body>
</html>