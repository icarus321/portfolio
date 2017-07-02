<%@ page import="java.sql.*" %>
<html>
<head>
<title>Query Results Using JSP</title>
</head>
<body>

<h2>Mysql</h2>
<% try 
{	// Load driver class
	Class.forName("com.mysql.jdbc.Driver"); 
}
catch (java.lang.ClassNotFoundException e) {
	System.err.println("ClassNotFoundException: " +e); 
}
%>

<% 
Connection con_mysql = null;
String url_mysql = "jdbc:mysql://dbdev.cs.uiowa.edu/WorksOn";
String uid_mysql = "dbdevtest";
String pw_mysql = "XiuyD=jP";

try {	
	con_mysql = DriverManager.getConnection(url_mysql, uid_mysql, pw_mysql);
	Statement stmt_mysql = con_mysql.createStatement();
	ResultSet rst_mysql = stmt_mysql.executeQuery("SELECT ename,salary FROM Emp");		
	out.print("<table><tr><th>Name</th>");
	out.println("<th>Salary</th></tr>");
	while (rst_mysql.next())
	{	out.println("<tr><td>"+rst_mysql.getString(1)+"</td>"+"<td>"+rst_mysql.getDouble(2)+"</td></tr>");
	}
	out.println("</table>");
	con_mysql.close();
}
catch (SQLException ex) 
{ 	out.println(ex); 
}
%>
<h2>Postgresql</h2>
<% try 
{	// Load driver class
	Class.forName("org.postgresql.Driver"); 
}
catch (java.lang.ClassNotFoundException e) {
	System.err.println("ClassNotFoundException: " +e); 
}
%>

<% 
Connection con_psql = null;

String url_psql = "jdbc:postgresql://dbdev.cs.uiowa.edu/dbdevtest";
String uid_psql = "dbdevtest";
String pw_psql = "XiuyD=jP";

try {	
	con_psql = DriverManager.getConnection(url_psql, uid_psql, pw_psql);
	Statement stmt_psql = con_psql.createStatement();
	ResultSet rst_psql = stmt_psql.executeQuery("SELECT ename,salary FROM Emp");		
	out.print("<table><tr><th>Name</th>");
	out.println("<th>Salary</th></tr>");
	while (rst_psql.next())
	{	out.println("<tr><td>"+rst_psql.getString(1)+"</td>"+"<td>"+rst_psql.getDouble(2)+"</td></tr>");
	}
	out.println("</table>");
	con_psql.close();
}
catch (SQLException ex) 
{ 	out.println(ex); 
}
%>
</body>
</html>
