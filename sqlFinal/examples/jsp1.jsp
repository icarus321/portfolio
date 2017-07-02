<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page import="java.sql.*" %>
<HTML>
<HEAD>
<TITLE>Query Results Using JSP (Postgresql)</TITLE>
<style>body{background-color:RGB(141,91,0);}</style>
</HEAD>
<BODY>

<% try 
{    // Load driver class
    Class.forName("org.postgresql.Driver");
}
catch (java.lang.ClassNotFoundException e) {
    System.err.println("ClassNotFoundException: " +e);
}
%>

<%
    Connection con = null;
    String url = "jdbc:postgresql://webdev.cs.uiowa.edu/jlmadden";
    String uid = "jlmadden";
    String pw = "KNLy3G5B_zUa";

   
        try {
        con = DriverManager.getConnection(url, uid, pw);
        Statement stmt = con.createStatement();      

  
String SQLSt = "SELECT ptype, ST_AsGeoJSON(geom) FROM myschema2.spatialdata3";
        out.println("<H2>Postgresql SQL Query: "+SQLSt+"</H2>");     

        ResultSet rst = stmt.executeQuery(SQLSt);
        out.print("<TABLE><TR><TH>Name</TH></TR>");
        while (rst.next())
        {       out.println("<TR><TD>"+rst.getString(1)+"</TD>"
        		+"<TD>"+rst.getString(2)+"</TD></TR>"
        		);

        }
                out.println("</TABLE></BODY></HTML>");
                out.close();
                
                
                
           }
    catch (SQLException ex)
    {     System.err.println(ex);
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
ppp
</BODY>
</HTML>
