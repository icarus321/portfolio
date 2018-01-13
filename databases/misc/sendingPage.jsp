<%@ page import="java.util.ArrayList,java.util.Random" %>
<HTML>
<HEAD>
<TITLE>Sending Data Page</TITLE>
</HEAD>
<BODY>

<%
	// Generate and print array
	ArrayList ar = new ArrayList(20);
	Random generator = new Random();

	out.println("<H2>Created the following array and storing in a session variable:</H2>");
	for (int i = 0; i < 20; i++)
	{	ar.add(new Integer(generator.nextInt(10)));
		out.println(ar.get(i)+"<BR>");
	}

	// Store arraylist in a session variable
	session.setAttribute("arraydata",ar);
%>

</BODY>
</HTML>

