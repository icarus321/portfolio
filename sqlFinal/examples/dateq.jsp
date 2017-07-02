<%@page import="java.text.SimpleDateFormat"%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@page import="javax.servlet.*" %>

<%@page import="javax.servlet.http.*" %>

<%@page import="java.util.*,java.sql.*,java.io.*" %>

 

<html>

<%!Connection con1; %>

<%!Statement s1; %>

<%!ResultSet rs1; %>

<% String name=request.getParameter("q");
String name2=request.getParameter("r");
String name3=request.getParameter("s");
try{

Class.forName("org.postgresql.Driver");

con1=DriverManager.getConnection

("jdbc:postgresql://webdev.cs.uiowa.edu/jlmadden","jlmadden","KNLy3G5B_zUa");

s1=con1.createStatement();

rs1=s1.executeQuery("select ST_AsGeoJSON(geom) from myschema2.spatialdata3 where ptype='"+name+"' and mydates>'"+name2+"' and mydates<'"+name3+"'");

}catch(Exception e){ e.printStackTrace(); }

%>
;

<% while(rs1.next())

{ %>
<%=rs1.getString(1)%>;



<% } %>

</html>
