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

try{

Class.forName("org.postgresql.Driver");

con1=DriverManager.getConnection

("jdbc:postgresql://webdev.cs.uiowa.edu/jlmadden","jlmadden","KNLy3G5B_zUa");

s1=con1.createStatement();


int checker=0;
while(checker<=10){
rs1=s1.executeQuery("select count(*) from myschema2.spatialdata3 where ptype='"+name+"' group by date_trunc('month',mydates) order by date_trunc('month', mydates)");
if(!rs1.isBeforeFirst()){checker+=1;break;}else{checker=11;}
}




}catch(Exception e){ e.printStackTrace(); }

%>
;

<% while(rs1.next())

{ %>
<%=rs1.getString(1)%>;



<% }
try{rs1.close();}catch(Exception e){e.printStackTrace();}
try{s1.close();}catch(Exception e){e.printStackTrace();}
try{con1.close();}catch(Exception e){e.printStackTrace();}

 %>

</html>
