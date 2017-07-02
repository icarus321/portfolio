<HTML>
<HEAD>
<TITLE>Password Protected Page</TITLE>
</HEAD>
<BODY>

<%@ include file="auth.jsp"%>

<%
	String userName = (String) session.getAttribute("authenticatedUser");
	out.println("<H1>You have access to this page: "+userName+"</H1>");
%>

</BODY>
</HTML>

