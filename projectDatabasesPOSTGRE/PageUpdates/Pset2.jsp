<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page import="java.io.*,java.util.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Alpha Researcher Database</title>
<link rel="stylesheet" type="text/css" href="style1.css">
</head>
<body>

      
<div id="div1"> 

<jsp:include page="title.jsp"/>   
</div>


<div id=div2>

<jsp:include page="menu.jsp"/>

</div>

<div id=div3>
<sql:setDataSource var="jdbc" driver="org.postgresql.Driver" 
        url="jdbc:postgresql://neuromancer.icts.uiowa.edu/institutional_repository"
        user="ruorhuang" password="bhetxmht"/>

<!-- This adds stuff -->
<c:forEach var="par" items="${paramValues}">
<c:if test="${fn:endsWith(par.key, 'button')}"> 
<c:set var="flag" value="1"/>
<sql:update var="input" dataSource="${jdbc}">
insert into alpha.authors (pmidfor, emailfor)
values ('${par.value[0]}', '${trackingId}')
</sql:update>
</c:if>
</c:forEach>

<!-- This deletes stuff -->
<c:forEach var="par1" items="${paramValues}">
<c:if test="${fn:startsWith(par1.key, '123')}"> 
<sql:update var="input" dataSource="${jdbc}">
delete from alpha.authors 
where emailfor='${trackingId }' and pmidfor='${par1.value[0] }'
</sql:update>
</c:if>
</c:forEach>

<!-- Search existing associations -->
<sql:query var="existingT" dataSource="${jdbc}">
select distinct pmidfor, emailfor, pmid, title
from alpha.authors
inner join medline.article
on article.pmid=authors.pmidfor
where emailfor='${trackingId }'
group by emailfor, pmidfor,pmid, title
order by title ;
</sql:query>

<h2>Studies Already Linked to Your Profile</h2>
<p class="msg">Check the boxes below if you wish to remove any studies from your profile.</p>
<table>
<tr><th>Remove?</th><th>Title</th></tr>
<form action="Pset2.jsp" method="post">
<input type="hidden" name="trackingId" value="${param.trackingId}">
<c:forEach items="${existingT.rows }" var="extRow" varStatus="rowCounter">
<sql:query var="anything" dataSource="${jdbc}">
select distinct author.pmid,last_name,fore_name
from medline.author
where author.pmid=${extRow.pmid} 
group by author.pmid,last_name,fore_name
order by author.pmid ;
</sql:query>
<tr><td><input type="checkbox" name="123${extRow.pmid}" value="${extRow.pmid}" ></td>
<td> 
<a href="pub.jsp?id=<c:out value="${extRow.pmid }"/>"><c:out value="${extRow.title }"/></a> by 
<c:forEach items="${anything.rows }" var="anyRow" varStatus="rowCounter">
<c:out value="${anyRow.fore_name }"/> <c:out value="${anyRow.last_name }"/>, 
</c:forEach></td></tr>

</c:forEach>
<tr><td colspan=4><input type="submit" value="Submit"> <input type="button" value="Update" onclick="location='Pset2.jsp'"></td></tr>
</form>
</table>

<h2>Newly Added:</h2>
<table width="100%" border="1" align="center">
<tr bgcolor="#949494">
<th>Trial ID</th><th>Study Name</th>
</tr>

<c:forEach var="par" items="${paramValues}">
<c:if test="${fn:endsWith(par.key, 'button')}"> 
<sql:query var="existing" dataSource="${jdbc}">
select distinct pmidfor, emailfor, article.pmid, title
from alpha.authors
inner join medline.article
on article.pmid=authors.pmidfor
where article.pmid='${par.value[0]}'
group by emailfor, pmidfor, article.pmid, title
order by title ;
</sql:query>
<c:forEach items="${existing.rows }" var="eRow" varStatus="rowCounter">

<tr><td>${par.value[0]}</td><td>${eRow.title}</td></tr>

</c:forEach>
</c:if>
</c:forEach>

<c:if test="${empty flag}">
<tr><td></td><td><p class="msg">No new values! All updates complete.</p></td></tr>
</c:if>

</table>


<h3><a href="setPubs.jsp">Add more publications...</a></h3>
<h3><a href="Tset2.jsp">Edit trial associations...</a></h3>


<p>&nbsp;</p>
<p>&nbsp;</p>



</div>

<div id=div4>
<jsp:include page="footer.jsp"/> 
</div>
</body>
</html>