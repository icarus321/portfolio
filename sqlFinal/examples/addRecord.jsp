<%@page import="java.text.SimpleDateFormat"%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@page import="javax.servlet.*" %>

<%@page import="javax.servlet.http.*" %>

<%@page import="java.util.*,java.sql.*,java.io.*" %>

 

<html>

<%!Connection con1; %>

<%!Statement s2; %>






<% String name=request.getParameter("q");
String myLat=request.getParameter("r");
String myLon=request.getParameter("s");

try{

Class.forName("org.postgresql.Driver");

con1=DriverManager.getConnection

("jdbc:postgresql://webdev.cs.uiowa.edu/jlmadden","jlmadden","KNLy3G5B_zUa");

s2=con1.createStatement();
s2.executeQuery("INSERT INTO myschema2.spatialdata3 (ptype, geom) VALUES ('"+name+"', ST_SetSRID(ST_Point("+myLon+","+myLat+"),4326))");
//s2.executeQuery("INSERT INTO myschema2.spatialdata3 (ptype, geom) VALUES ('BOB', ST_SetSRID(ST_Point(-8,40),4326))");
//s1=con1.createStatement();



  
//rs1=s1.executeQuery("select ST_AsGeoJSON(geom) from myschema2.spatialdata3 where ptype='"+name+"'");

}catch(Exception e){ e.printStackTrace(); }

%>
;



</html>
