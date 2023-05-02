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

<H1>Adding Faculty</H1>
<form name = "f1" method="get" action="faculty.jsp">
faculty name: <input type="text" name="faculty_name" size="20"/>
title: <input type="text" name="title" size="20"/>
<input type="submit" value="Submit"/>
</form>

<jsp:useBean id="obj" class="com.mit.FacultyBean"></jsp:useBean>
<jsp:setProperty property="*" name="obj"/>
<%
int status = FacultyDAO.insertFaculty(obj);
if(status>0)
	out.println("Inserted successfully..");
else
	out.println("Insertion Failure..");
%><br><br>

<H1>Current Faculty</H1>
       <%
           Connection connection = ConnectionProvider.getCon();
           Statement statement = connection.createStatement() ;
          ResultSet resultset = statement.executeQuery("select * from faculty") ;
       %>
      <TABLE BORDER="1">
      <TR>
      <TH>faculty_name</TH>
      <TH>title</TH>
      </TR>
      <% while(resultset.next()){ %>
      <TR>
       <TD> <%= resultset.getString(1) %></TD>
       <TD> <%= resultset.getString(2) %></TD>
      </TR>
      <% } %>
     </TABLE>


</body>
</html>