import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;

public class JdbcServlet_psql extends HttpServlet {

	private Connection con;

	public void init(ServletConfig cfg) throws ServletException {
		super.init(cfg);
		try {
			Class.forName("org.postgresql.Driver");
		} catch (java.lang.ClassNotFoundException e) {
			System.err.println("ClassNotFoundException: " +e);
		}

		String url = "jdbc:postgresql://dbdev.cs.uiowa.edu/dbdevtest";
		String uid = "dbdevtest";
		String pw = "XiuyD=jP";
		con = null;
		try {
			con = DriverManager.getConnection(url, uid, pw);
		} catch (SQLException e)
		{	throw new ServletException("SQLException: "+e); }
   	}

	public void destroy()
	{	try {
			if (con != null)
				con.close();
		}
		catch (SQLException e)
		{	System.err.println("SQLException: "+e); }
	}

	public void doGet(HttpServletRequest request, HttpServletResponse response)
      		throws ServletException, java.io.IOException {
	        doTable(request, response);
	}

	public void doPost(HttpServletRequest request, HttpServletResponse response)
      		throws ServletException, java.io.IOException {
	        doTable(request, response);
	}

	private void doTable(HttpServletRequest request,HttpServletResponse response)
				throws ServletException, java.io.IOException {
		response.setContentType("text/html");
		java.io.PrintWriter out = response.getWriter();
		out.println("<html><head><title></title></head>");

		if (con == null)
			out.println("<BODY><H1>Unable to connect to DB</H1></BODY></HTML>");
		else
		{	try {
				Statement stmt = con.createStatement();
                                out.println("<h2>Postgresql</h2>");
				ResultSet rst = stmt.executeQuery("SELECT ename,salary FROM Emp");

				out.print("<TABLE><TR><TH>Name</TH><TH>Salary</TH></TR>");
				while (rst.next())
				{	
					out.println("<TR><TD>"+rst.getString(1)+"</TD>"+"<TD>"+rst.getDouble(2)+"</TD></TR>");
				}
				out.println("</TABLE></BODY></HTML>");
			} catch (SQLException ex) { System.err.println(ex); }
		}
	}
}

