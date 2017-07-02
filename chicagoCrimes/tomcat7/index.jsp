<%@ page import="java.sql.*" %>

<html>
<head>
<title>Example JSP Page</title>
</head>
<body>
<p>This is a test dynamic jsp file.
<br>
<p> These numbers are produced in a for loop
<br>
<% int i;
	for(i = 0; i< 10; i++) {
		out.println("i = " + i);
		out.println("<br>");
	}
%>

<hr>

<h2>Testing JDBC - MySQL</h2>

<p>Attempting to query WorksOn database hosted on MySQL 5.x at dbdev.cs.uiowa.edu:</p>

<%
Connection con_mysql = null;
String url_mysql = "jdbc:mysql://dbdev.cs.uiowa.edu/WorksOn";
String uid_mysql = "dbdevtest";                       
String pw_mysql = "XiuyD=jP";

try {   // Load driver class            
        Class.forName("com.mysql.jdbc.Driver");                
}        
catch (java.lang.ClassNotFoundException e) 
{
        out.println("ClassNotFoundException: " +e);
}

con_mysql = null;
try {
        con_mysql = DriverManager.getConnection(url_mysql, uid_mysql, pw_mysql);
        Statement stmt_mysql = con_mysql.createStatement();
        ResultSet rst_mysql = stmt_mysql.executeQuery("SELECT ename,salary FROM Emp");

        out.print("<TABLE BORDER=1><TR><TH>Employee Name</TH><TH>Salary</TH>"); 
        while (rst_mysql.next())
        {       out.println("<TR><TD>"+rst_mysql.getString(1)+"</TD><TD>"+rst_mysql.getDouble(2)+"</TD></TR>");
        }
        con_mysql.close();
	out.println("</TABLE>");
}
catch (SQLException ex) 
{
        out.println("SQLException: " + ex); 
}
%>                 

<h2>End Testing JDBC - MySQL</h2>

<hr>
<h2>Testing JDBC - PostgreSQL</h2>

<p>Attempting to query dbdevtest database hosted on PostgreSQL 8.x at dbdev.cs.uiowa.edu:</p>

<%
Connection con_psql = null;
String url_psql = "jdbc:postgresql://dbdev.cs.uiowa.edu/dbdevtest";
String uid_psql = "dbdevtest";                       
String pw_psql = "XiuyD=jP";

try {   // Load driver class            
        Class.forName("org.postgresql.Driver");                
}        
catch (java.lang.ClassNotFoundException e) 
{
        out.println("ClassNotFoundException: " +e);
}

con_psql = null;
try {
        con_psql = DriverManager.getConnection(url_psql, uid_psql, pw_psql);
        Statement stmt_psql = con_psql.createStatement();
        ResultSet rst_psql = stmt_psql.executeQuery("SELECT ename,salary FROM Emp");

        out.print("<TABLE BORDER=1><TR><TH>Employee Name</TH><TH>Salary</TH>"); 
        while (rst_psql.next())
        {       out.println("<TR><TD>"+rst_psql.getString(1)+"</TD><TD>"+rst_psql.getDouble(2)+"</TD></TR>");
        }
        con_psql.close();
	out.println("</TABLE>");
}
catch (SQLException ex) 
{
        out.println("SQLException: " + ex); 
}
%>                 

<h2>End Testing JDBC - PostgreSQL</h2>

</body>
</html>




