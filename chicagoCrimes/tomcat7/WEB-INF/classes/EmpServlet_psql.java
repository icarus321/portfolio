import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;

public class EmpServlet_psql extends HttpServlet {

	private Connection con;

	public void init(ServletConfig cfg) throws ServletException {
		super.init(cfg);
		try {	
			Class.forName("org.postgresql.Driver"); 
		} catch (java.lang.ClassNotFoundException e) {
			System.err.println("ClassNotFoundException: " +e); 
		}

		String url = "jdbc:postgresql://dbdev.cs.uiowa.edu/dbdevtest";
		con = null;
		try {
			con = DriverManager.getConnection(url,"dbdevtest","XiuyD=jP");
		} catch (SQLException e)
		{	throw new ServletException("SQLException: "+e); }
   	}

	public void doGet(HttpServletRequest request, HttpServletResponse response)
      				throws ServletException, java.io.IOException {
	        doQuery(request, response);    
	} 

	public void doPost(HttpServletRequest request, HttpServletResponse response)
      				throws ServletException, java.io.IOException {
        	doQuery(request, response); 
	}

	public void destroy()
	{	try {
			if (con != null)
				con.close();
		}
		catch (SQLException e)
		{	System.err.println("SQLException: "+e); }
	}	

	private void doQuery(HttpServletRequest request,HttpServletResponse response)
			throws ServletException, java.io.IOException 
	{        
		response.setContentType("text/html");
		
		java.io.PrintWriter out = response.getWriter();
		out.println("<html><head><title></title></head>");
		if (con == null)
		{	out.println("<BODY><H1>Unable to connect to DB</H1></BODY></HTML>");
			out.close(); 
			return;
		}

		// Get parameters from request
		String empName = request.getParameter("empname");
		String deptNum = request.getParameter("deptnum");
		try {	
			Statement stmt = con.createStatement();

			String SQLSt = "SELECT ename, salary, dno FROM Emp WHERE 1=1 ";
			if (!empName.equals(""))
				SQLSt = SQLSt + " and ename LIKE '%"+empName+"%'";
			if (!deptNum.equals(""))
				SQLSt = SQLSt + " and dno ='"+deptNum+"'"; 	

			out.println("<H2>Postgresql SQL Query: "+SQLSt+"</H2>");

			ResultSet rst = stmt.executeQuery(SQLSt);
			out.print("<TABLE><TR><TH>Name</TH><TH>Salary</TH><TH>dno</TH></TR>");
			while (rst.next())
			{	out.println("<TR><TD>"+rst.getString(1)+"</TD>"
 						+"<TD>"+rst.getDouble(2)+"</TD>"
						+"<TD>"+rst.getString(3)+"</TD></TR>");

			}
			out.println("</TABLE></BODY></HTML>");
			out.close();
		}
		catch (SQLException ex) { System.err.println(ex); }
	}
}

