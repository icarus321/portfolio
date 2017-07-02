<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
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

<c:set var="trackingId" value="david-eichmann@uiowa.edu"/>
Logged in as: <c:out value="${trackingId }"/>

<sql:query var="prof" dataSource="${jdbc}">
select name, familyname, givenname, degree, phone, department, university, email, description, webpage from alpha.researchertest
where email='${trackingId }'
order by name ;
</sql:query>

<sql:query var="existingP" dataSource="${jdbc}">
select distinct pmidfor, emailfor, article.pmid, title
from alpha.authors
inner join medline.article
on article.pmid=authors.pmidfor
where emailfor='${trackingId }'
group by emailfor, pmidfor, article.pmid, title
order by title ;
</sql:query>

<c:choose>
<c:when test="${empty param.start }">
<c:set var="start" value="0" />
</c:when>
<c:otherwise>
<c:set var="start" value="${param.start}" />
</c:otherwise>
</c:choose>
<c:set var="end" value="${start+25}" />

<h2>Enter Search:</h2>

<form action="setPubs.jsp" method="get">
  <input type="radio" name="sType" value="gtitle" ${param.sType=='gtitle'?'checked':'checked'}> Title
  <input type="radio" name="sType" value="fname" ${param.sType=='fname'?'checked':''}> Last Name
    <input type="radio" name="sType" value="gname" ${param.sType=='gname'?'checked':''}> First Name
<table>
<tr><td>Search</td> <td><input type="text" size=40 name="fgo" value="${param.fgo}"></td></tr>
   <tr><td></td><td><input type="submit" value="Submit"> <input type="button" value="Reset" onclick="location='setPubs.jsp'"></td></tr>
</table>
</form>

<!-- Auto Search -->
<c:if test="${empty param.sType }">
<h2>Automatic Search Results:</h2>
<c:forEach items="${prof.rows }" var="row" varStatus="rowCounter">
<sql:query var="medli" dataSource="${jdbc}">
select distinct title, last_name, fore_name, article.pmid
from medline.article
inner join medline.author
on article.pmid=author.pmid
where fore_name LIKE '${row.givenname }%' and last_name LIKE '${row.familyname }%'
group by title, last_name, fore_name, article.pmid
order by last_name ;
</sql:query>
</c:forEach>
<c:choose>
<c:when test="${empty medli.rows}"><font color=#992222><b>There do not appear to be any results for your search. Check for spelling errors, and try again!</b></font>
</c:when>
<c:when test="${not empty medli.rows}">
<p class="msg">Total results: <c:out value="${medli.rowCount }" /></p>
<c:set var="allend" value="${medli.rowCount}" scope="page" />

<c:if test="${end>allend}">
 <c:set var="end" value="${allend}" scope="page" />
</c:if>
<p>Now showing <c:out value="${start }" /> to <c:out value="${end }" /> </p>

<form action="Pset2.jsp" method="post">
<table>
<tr><td colspan=4><input type="submit" value="Submit"> <input type="button" value="Reset" onclick="location='setPubs.jsp'"></td></tr>
<tr><th>Add</th><th>Title</th></tr>
<c:forEach items="${medli.rows }" var="tRow" varStatus="rowCounter">
<sql:query var="existingT" dataSource="${jdbc}">
select distinct pmidfor, emailfor
from alpha.authors
where emailfor='${trackingId }' and pmidfor='${tRow.pmid }'
group by emailfor, pmidfor
order by pmidfor ;
</sql:query>
<tr><td>
<center>
<c:choose>
<c:when test='${not empty existingT.rows}'>
<img src="checkmark.png" height=15>
</c:when>
<c:otherwise>
<input type="checkbox" name="${tRow.pmid}button" value="${tRow.pmid}" checked="checked"></c:otherwise></c:choose></center></td>
<td>
<b><c:if test="${not empty tRow.title}"><a href="pubs.jsp?id=${tRow.pmid }"><c:out value="${tRow.title }"/></a></c:if>
<c:if test="${not empty tRow.brief_title}">This is a problem.</c:if></b>
by <c:out value="${tRow.last_name }"/></td></tr>
</c:forEach>
</table>
</form>
</c:when>
</c:choose>
</c:if>
<!-- End Auto Search -->

<!-- Form Search -->

<c:if test="${not empty param.sType }">
<c:set var="quist" value	="" />       
<h2>Please select from the following publications: <c:out value="${row.name }"/></h2>

<c:choose>
<c:when test="${param.sType=='gname' }">
<sql:query var="searchN" dataSource="${jdbc}">
select distinct last_name, fore_name
from medline.author
where fore_name like '${param.fgo }%'
group by last_name, fore_name
order by last_name ;
</sql:query>

<c:if test="${empty searchN.rows}"><font color=#992222><b>There do not appear to be any results for your search. Check for spelling errors, and try again!</b></font>
</c:if>
<c:if test="${not empty searchN.rows}">

<p class="msg">Total results: <c:out value="${searchN.rowCount }" /></p>
<p>Now showing <c:out value="${start }" /> to <c:out value="${end }" /> </p>
<c:set var="allend" value="${searchN.rowCount}" scope="page" />
<form action="setPubs.jsp" method="get">
<input type="hidden" name="sType" value="clove">
<table>
<tr><th>Add</th><th>Title</th></tr>

<c:forEach items="${searchN.rows }" begin="${start}" end="${end}" var="tRow" varStatus="rowCounter">

<tr>
<td><input type="checkbox" name="${tRow.last_name}" value="${tRow.fore_name}"></td>
<c:set var="quist" value="${tRow.pmid}" />
<td>

<c:out value="${tRow.last_name }, ${tRow.fore_name }"/></td></tr>
</c:forEach>
<tr><td colspan=4><input type="submit" value="Submit"> <input type="button" value="Reset" onclick="location='setPubs.jsp'"></td></tr>

</table>
</form>
</c:if>
</c:when>

<c:when test="${param.sType=='fname' }">
<sql:query var="searchN" dataSource="${jdbc}">
select distinct last_name, fore_name
from medline.author
where last_name LIKE '${param.fgo }%'
group by last_name, fore_name
order by last_name ;
</sql:query>

<c:if test="${empty searchN.rows}"><font color=#992222><b>There do not appear to be any results for your search. Check for spelling errors, and try again!</b></font>
</c:if>
<c:if test="${not empty searchN.rows}">

<p class="msg">Total results: <c:out value="${searchN.rowCount }" /></p>
<p>Now showing <c:out value="${start }" /> to <c:out value="${end }" /> </p>
<c:set var="allend" value="${searchN.rowCount}" scope="page" />
<form action="setPubs.jsp" method="get">
<input type="hidden" name="sType" value="clove">
<table>
<tr><th>Add</th><th>Title</th></tr>

<c:forEach items="${searchN.rows }" begin="${start}" end="${end}" var="tRow" varStatus="rowCounter">

<tr>
<td><input type="checkbox" name="${tRow.last_name}" value="${tRow.fore_name}"></td>
<td>

<c:out value="${tRow.last_name }, ${tRow.fore_name }"/></td></tr>
</c:forEach>
<tr><td colspan=4><input type="submit" value="Submit"> <input type="button" value="Reset" onclick="location='setPubs.jsp'"></td></tr>

</table>
</form>
</c:if>
</c:when>


<c:when test="${param.sType=='gtitle' }">
<sql:query var="searchN" dataSource="${jdbc}">
select distinct title, last_name, fore_name, article.pmid
from medline.article
inner join medline.author
on article.pmid=author.pmid
where title like '%${param.fgo }%' 
group by title, last_name, fore_name, article.pmid
order by last_name  ;
</sql:query>



<c:if test="${empty searchN.rows}"><font color=#992222><b>There do not appear to be any results for your search. Check for spelling errors, and try again!</b></font>
</c:if>
<c:if test="${not empty searchN.rows}">

<p class="msg">Total results: <c:out value="${searchN.rowCount }" /></p>
<p>Now showing <c:out value="${start }" /> to <c:out value="${end }" /> </p>
<c:set var="allend" value="${searchN.rowCount}" scope="page" />
<form action="Pset2.jsp" method="post">
<table>
<tr><th>Add</th><th>Title</th></tr>

<c:forEach items="${searchN.rows }" begin="${start}" end="${end}" var="tRow" varStatus="rowCounter">

<tr>
<td><input type="checkbox" name="${tRow.pmid}button" value="${tRow.pmid}" ${button=='yes'?'checked':''}></td>
<c:set var="quist" value="${tRow.pmid}" />
<td>
<b><c:if test="${not empty tRow.title}"><a href="trial.jsp?id=${tRow.pmid }"><c:out value="${tRow.title }"/></a></c:if>
<c:if test="${empty tRow.title}">Missing information</c:if></b>
by <c:out value="${tRow.last_name }, ${tRow.fore_name }"/></td></tr>
</c:forEach>
<tr><td colspan=4><input type="submit" value="Submit"> <input type="button" value="Reset" onclick="location='setPubs.jsp'"></td></tr>

</table></form>
<c:if test="${end>allend}">
 <c:set var="end" value="${allend}" scope="page" />
</c:if>

</c:if>
</c:when>

<c:when test="${param.sType=='clove' }">
<form action="Pset2.jsp" method="post">
<table>
<tr><th>Add</th><th>Author</th><th>Title</th></tr>
<c:forEach var="par" items="${paramValues}">
<c:if test="${par.key ne 'sType'}">
<sql:query var="medli" dataSource="${jdbc}">
select distinct title, last_name, fore_name, article.pmid
from medline.article
inner join medline.author
on article.pmid=author.pmid
where fore_name='${par.value[0]}' and last_name='${par.key }'
group by title, last_name, fore_name, article.pmid
order by last_name ;
</sql:query>

<c:out value="${paramValues.rowCount }"/>
<c:forEach items="${medli.rows }" var="eRow" varStatus="rowCounter">
<sql:query var="existingT" dataSource="${jdbc}">
select distinct pmidfor, emailfor
from alpha.authors
where emailfor='${trackingId }' and pmidfor='${eRow.pmid }'
group by emailfor, pmidfor
order by pmidfor ;
</sql:query>
<tr><td>
<center>
<c:choose>
<c:when test='${tRow.id eq quist}'>
---
</c:when>
<c:when test='${not empty existingT.rows}'>
<img src="checkmark.png" height=15>
</c:when>
<c:otherwise>
<input type="checkbox" name="${eRow.pmid}button" value="${eRow.pmid}" ${button=='yes'?'checked':''}>
<c:set var="quist" value="${eRow.pmid}" />
</c:otherwise></c:choose>
</center></td>
<td><c:out value="${eRow.last_name}" />, <c:out value="${eRow.fore_name}" /></td><td><c:out value="${eRow.title}" /></td></tr>

</c:forEach>
</c:if>
</c:forEach>
<tr><td colspan=4><input type="submit" value="Submit"> <input type="button" value="Reset" onclick="location='setPubs.jsp'"></td></tr>

</table>
</form>

</c:when>
<c:otherwise>???</c:otherwise>
</c:choose>
</c:if>

<!-- End Form Searches -->
<c:if test="${end<allend}">...
<a href="setPubs.jsp?sType=${param.sType}&fgo=${param.fgo}&start=${start + 26}">NEXT</a>&nbsp;&nbsp;&nbsp;
</c:if>


<p>&nbsp;</p>
<p>&nbsp;</p>


</div>

<div id=div4>
<jsp:include page="footer.jsp"/>
</div>
</body>
</html>