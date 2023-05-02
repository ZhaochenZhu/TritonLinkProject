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
      </TR>
</TABLE>

<H1>Adding Student</H1>
<form name = "f1" method="get" action="success.jsp">
Student ID: <input type="text" name="student_id" size="5"/>
First name: <input type="text" name="first_name" size="5"/>
Last name: <input type="text" name="last_name" size="5"/>
Middle name: <input type="text" name="middle_name" size="2"/>
SSN: <input type="text" name="ssn" size="5"/>
Enrolled: <input type="text" name="enrolled" size="2"/>
Residential_status: <input type="text" name="residential_status" size="5"/>
Current Degree: <input type="text" name="current_degree" size="5"/>
<input type="submit" value="Submit"/>
</form>

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
       <TD> <%= resultset.getInt(1) %></TD>
       <TD> <%= resultset.getString(2) %></TD>
       <TD> <%= resultset.getString(3) %></TD>
       <TD> <%= resultset.getString(4) %></TD>
       <TD> <%= resultset.getInt(5) %></TD>
       <TD> <%= resultset.getString(6) %></TD>
       <TD> <%= resultset.getString(7) %></TD>
       <TD> <%= resultset.getString(8) %></TD>
      </TR>
      <% } %>
     </TABLE>

</body>
</html>