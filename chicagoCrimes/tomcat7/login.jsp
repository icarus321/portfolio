<HTML>
<HEAD>
<TITLE>Login Screen</TITLE>
</HEAD>
<BODY>

<center>

<H3>Please Login to System</H3>

<%
// Print prior error login message if present
if (session.getAttribute("loginMessage") != null)
	out.println("<P>"+session.getAttribute("loginMessage").toString()+"</P>");
%>

<br>
<form name="MyForm" method=post action="validateLogin.jsp">
<table width="40%" border="0" cellspacing="0" cellpadding="0">
<tr>
	<td><div align="right"><font face="Arial, Helvetica, sans-serif" size="2">Username:</font></div></td>
	<td><input type="text" name="username"  size=10 maxlength=10></td>
</tr>
<tr>
	<td><div align="right"><font face="Arial, Helvetica, sans-serif" size="2">Password:</font></div></td>
	<td><input type="password" name="password"  size=10 maxlength=10"></td>
</tr>
</table>

<input class="submit" type="submit" name="Submit2" value="Log In">
</form>
<br>
</center>

</BODY>
</HTML>

