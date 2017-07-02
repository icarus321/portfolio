<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Menu</title>

<body onload="call()">

<c:if test="${empty param.trackingId }" >
<script language="javascript" type="text/javascript">
function removeLoggedInUser(){
	  localStorage.removeItem(loggedInUser);

	   }


function call(){
var name = localStorage.loggedInUser;
var str = window.location.href;
if(str.indexOf("?") !== -1){
	window.location.replace(window.location +"&trackingId="+name);}
	else {
	window.location.replace(window.location +"?trackingId="+name);};


}
</script>
</c:if>
<c:if test="${not empty param.trackingId }" >
<script language="javascript" type="text/javascript">
function call(){
var name = localStorage.loggedInUser;
var str = window.location.href;
if(str.indexOf(localStorage.loggedInUser) == -1){
	alert ("Something is wrong; Please log in again.")
	document.location = "Login.jsp";}
	else {
	};


}
</script>
<c:choose>
 <c:when test="${param.trackingId=='undefined'}">
 
Welcome, Guest.
 
 </c:when>
<c:otherwise>
<p> Logged in as: <c:out value="${param.trackingId }" /></p>
</c:otherwise>
</c:choose>
</c:if>    


<h2><img src="alpha-2.png" alt="Alpha" width=50px height=20px align="middle" /><em>Menu</em>
</h2><h3><a href="index.jsp">Home Page</a></h3>
<h3><a href="profile.jsp">Profile</a></h3>
<h3><a href="searchPubs.jsp">Publications</a></h3>
<c:if test="${not empty turnip }">
<a href="setPubs.jsp">Manage Publications</a>
</c:if>
<h3><a href="searchTrials.jsp">Trials</a></h3>


<h3><a href="Login.jsp">Login</a></h3>
<button onclick="removeLoggedInUser()">Logout</button>


<p>&nbsp;</p>
<p>&nbsp;</p>
<img src="caduceus.png" width=80% alt="Caduceus"/>
</body>
</html>