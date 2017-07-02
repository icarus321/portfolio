<%@ page import="java.util.ArrayList" %>
<HTML>
<HEAD>
<TITLE>Receiving Data Page</TITLE>
</HEAD>
<BODY>

<%
	ArrayList ar = (ArrayList) session.getAttribute("arraydata");
	if (ar == null)
		out.println("<H2>No data sent to page using session variable.</H2>");
	else
	{
		out.println("<H2>Received the following array from the session variable:</H2>");
		for (int i = 0; i < 20; i++)
			out.println(ar.get(i)+"<BR>");
	}
%>

</BODY>
</HTML>

