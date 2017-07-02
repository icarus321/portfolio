<%@ page import="java.sql.*" %>
<HTML>
<HEAD>
<TITLE>Query Results Using JSP (Mysql)</TITLE>
</HEAD>
<BODY>

<% try 
{	// Load driver class
	Class.forName("com.mysql.jdbc.Driver"); 
}
catch (java.lang.ClassNotFoundException e) {
	System.err.println("ClassNotFoundException: " +e); 
}
%>

<% 
	Connection con = null;
	String url = "jdbc:mysql://dbdev.cs.uiowa.edu/WorksOn";
	String uid = "dbdevtest";
	String pw = "XiuyD=jP";

	// Get parameters from request
        String empName = request.getParameter("empname");
        String deptNum = request.getParameter("deptnum");
        try {
		con = DriverManager.getConnection(url, uid, pw);
		Statement stmt = con.createStatement();      

		String SQLSt = "SELECT ename, salary, dno FROM Emp WHERE 1=1 ";
		if (empName != null && !empName.equals(""))               
			SQLSt = SQLSt + " and ename LIKE '%"+empName+"%'";
		if (deptNum != null && !deptNum.equals(""))
			SQLSt = SQLSt + " and dno ='"+deptNum+"'";

		out.println("<H2>SQL Query: "+SQLSt+"</H2>");     

		ResultSet rst = stmt.executeQuery(SQLSt);
		out.print("<TABLE><TR><TH>Name</TH><TH>Salary</TH><TH>dno</TH></TR>");
		while (rst.next())
		{       out.println("<TR><TD>"+rst.getString(1)+"</TD>"
                                           +"<TD>"+rst.getDouble(2)+"</TD>"
                                           +"<TD>"+rst.getString(3)+"</TD></TR>");

		}
                out.println("</TABLE></BODY></HTML>");
                out.close();
	}
	catch (SQLException ex) 
	{ 	System.err.println(ex); 
	}
	finally
	{
		if (con != null)
		try
		{
			con.close();
		}
		catch (SQLException ex)
		{
			System.err.println("SQLException: " + ex);
		}
	}
%>
</BODY>
</HTML>
