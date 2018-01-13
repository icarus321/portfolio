<HTML>
<HEAD>
<TITLE>Hello World in JSP</TITLE>
</HEAD>
<BODY>

<% out.println("<H1>Hello World Hey!</H1>"); %>

<%! int num=0; %>

<% 
num++;
out.println("<H3>This JSP file has been called: "+num+" times.</H3>");
%>

<%
out.println("<h3>This page was requested from this IP address:");
out.println(request.getRemoteHost());
out.println("</h3>");
%>

</BODY>
</HTML>
