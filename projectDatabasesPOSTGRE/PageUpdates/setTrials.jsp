<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Alpha Researcher Database - Trials Search</title>
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

<c:set var="quist" value="" />   

<c:if test="${param.trackingId ne 'undefined' }">
<sql:query var="existingT" dataSource="${jdbc}">
select distinct clinicalidfor, emailfor, clinical_study.id, brief_title
from alpha.participating
inner join clinical_trials.clinical_study
on clinical_study.id=clinicalidfor
where emailfor='${param.trackingId }'
group by emailfor, clinicalidfor, clinical_study.id, brief_title
order by brief_title ;
</sql:query>
</c:if>

<c:choose>
<c:when test="${empty param.start }">
<c:set var="start" value="0" />
</c:when>
<c:otherwise>
<c:set var="start" value="${param.start}" />
</c:otherwise>
</c:choose>
<c:set var="end" value="${start+24}" />

<h2>Search for Trials:</h2>

<form action="setTrials.jsp" method="get">
<table>
<tr><td>Search</td> <td><input type="text" size=40 name="fgo" value="${param.sType=='gmail'?param.trackingId:param.fgo}"></td></tr>
  <input type="radio" name="sType" value="gtitle" ${param.sType=='gtitle'?'checked':'checked'}> Title 
  <input type="radio" name="sType" value="gname" ${param.sType=='gname'?'checked':''}> Name 
  <c:if test="${param.trackingId ne 'undefined'}">
  <input type="radio" name="sType" value="gmail" ${param.sType=='gmail'?'checked':''}> Email (automatic)
  </c:if>
   <tr><td></td><td><input type="submit" value="Submit"> <input type="button" value="Reset" onclick="location='setTrials.jsp'"></td></tr>
</table>
</form> 

<c:choose>

<c:when test="${param.sType=='gmail' }">
<sql:query var="searchE" dataSource="${jdbc}">
select distinct clinical_study.brief_title, clinical_study.official_title, clinical_study.id
from clinical_trials.clinical_study
left join (select distinct contact.email, contact.last_name, contact.id from clinical_trials.contact group by contact.email, contact.last_name, contact.id)
as foo
on clinical_study.id=foo.id
left join (select distinct overall_contact.email, overall_contact.last_name, overall_contact.id from clinical_trials.overall_contact group by overall_contact.email, overall_contact.last_name, overall_contact.id)
as foo2
on clinical_study.id=foo2.id
where foo.email='${param.trackingId }' or foo2.email='${param.trackingId }'
group by clinical_study.official_title, clinical_study.brief_title, clinical_study.id
order by official_title ;
</sql:query>

<c:if test="${empty searchE.rows}">
<p class="msg">There do not appear to be any results for your search. Check for spelling errors, and try again!</p>
</c:if>

<c:if test="${not empty searchE.rows}">
<p class="msg">Total results: <c:out value="${searchE.rowCount }" /></p>
<c:set var="allend" value="${searchE.rowCount}" scope="page" />
<c:if test="${end>allend}">
 <c:set var="end" value="${allend}" scope="page" />
</c:if>

<c:if test="${allend>25}">
<p>Now showing <c:out value="${start +1}" /> to <c:out value="${end +1}" /> </p>
<form action="setTrials.jsp" method="get"><p class="msg">
   Skip to number: <input type="number" name="start">
   <input type="hidden" name="sType" value="${param.sType}">
   <input type="hidden" name="fgo" value="${param.fgo}">
   <input type="submit" value="Submit"></p>
</form>  
</c:if>
<c:if test="${start>allend}">
 <p class="msg">Ummm... there are not that many search results. Try again!</p>
</c:if>


<table>
<form action="Tset2.jsp" method="post">
<input type="hidden" name="trackingId" value="${param.trackingId}">

<c:forEach items="${searchE.rows }" var="tRow" varStatus="rowCounter">
<sql:query var="people" dataSource="${jdbc}">
select distinct last_name, role, id
from clinical_trials.overall_official
where overall_official.id='${tRow.id}'
group by last_name, role, id
order by role
</sql:query>
<tr><td colspan=4><input type="submit" onclick="call2()" value="Submit"> <input type="button" value="Reset" onclick="location='setTrials.jsp'"></td></tr>
<tr><th>Add</th><th>Title</th></tr>
<tr><td>
<c:if test="${param.trackingId ne 'undefined'}">
<input type="checkbox" name="${tRow.id}button" value="${tRow.id}" checked="checked">
</c:if>
</td>
<td> 
<b><c:if test="${not empty tRow.brief_title}"><a href="trial.jsp?id=${tRow.id }"><c:out value="${tRow.brief_title }"/></a></c:if>
<c:if test="${empty tRow.brief_title}"><a href="trial.jsp?id=${tRow.id }"><c:out value="${tRow.official_title }"/></a></c:if></b>

<c:forEach items="${people.rows }" var="p2Row" varStatus="rowCounter">
with <c:out value="${p2Row.last_name }"/> (<c:out value="${p2Row.role }"/>) 
</c:forEach></td></tr>
</c:forEach> 
</form>
</table>
</c:if>
</c:when>


<c:when test="${not empty param.fgo }">
   
<h2>Please select from the following trials: <c:out value="${row.name }"/></h2>

<%-- Search by Name --%>
<c:if test="${param.sType=='gname' }">
<sql:query var="searchN" dataSource="${jdbc}">
select distinct brief_title, official_title, clinical_study.id, overall_official.last_name, overall_official.role, clinical_study.nct_id,
count(distinct clinical_study.id)
from clinical_trials.clinical_study
inner join clinical_trials.overall_official
on clinical_study.id=overall_official.id
where overall_official.last_name~'${param.fgo }'
group by clinical_study.official_title, brief_title, clinical_study.id, overall_official.last_name, overall_official.role, clinical_study.nct_id
order by official_title 
</sql:query>

<c:if test="${empty searchN.rows}"><font color=#992222><b>There do not appear to be any results for your search. Check for spelling errors, and try again!</b></font>
</c:if>
<c:if test="${not empty searchN.rows}">


<p class="msg">Total results: <c:out value="${searchN.rowCount }" /></p>
<c:set var="allend" value="${searchN.rowCount}" scope="page" />
<c:if test="${end>allend}">
 <c:set var="end" value="${allend}" scope="page" />
</c:if>

<c:if test="${allend>25}">
<p>Now showing <c:out value="${start +1}" /> to <c:out value="${end +1}" /> </p>
<form action="setTrials.jsp" method="get"><p class="msg">
   Skip to number: <input type="number" name="start">
   <input type="hidden" name="sType" value="${param.sType}">
   <input type="hidden" name="fgo" value="${param.fgo}">
   <input type="submit" value="Submit"></p>
</form>  
</c:if>
<c:if test="${start>allend}">
 <p class="msg">Ummm... there are not that many search results. Try again!</p>
</c:if>
<table>
<tr><th>Add</th><th>Title</th></tr>

<form action="Tset2.jsp" method="post">
<input type="hidden" name="trackingId" value="${param.trackingId}">
<c:forEach items="${searchN.rows }" begin="${start}" end="${end}" var="tRow" varStatus="rowCounter">
<c:if test="${param.trackingId ne 'undefined'}">

<sql:query var="existingT" dataSource="${jdbc}">
select distinct clinicalidfor, emailfor
from alpha.participating
where emailfor='${param.trackingId }' and clinicalidfor='${tRow.id }' 
group by emailfor, clinicalidfor
order by clinicalidfor ;
</sql:query>
</c:if>
<tr><td> 
<center>
<c:choose>
<c:when test='${tRow.id eq quist}'>
---
</c:when>
<c:when test='${not empty existingT.rows}'>
<img src="checkmark.png" height=15>
</c:when>
<c:when test="${param.trackingId ne 'undefined'}">
<input type="checkbox" name="${tRow.id}button" value="${tRow.id}" ${button=='yes'?'checked':''}>
<c:set var="quist" value="${tRow.id}" />
</c:when></c:choose></center></td>
<td> 
<b>

<c:if test="${not empty tRow.brief_title}"><a href="trial.jsp?id=${tRow.id }"><c:out value="${tRow.brief_title }"/></a></c:if>
<c:if test="${empty tRow.brief_title}"><br><a href="trial.jsp?id=${tRow.id }"><c:out value="${tRow.official_title }"/></a></c:if></b>
with <c:out value="${tRow.last_name }"/> (<c:out value="${tRow.role }"/>) </td></tr>

</c:forEach>
<c:if test="${param.trackingId ne 'undefined'}">
<tr><td colspan=4><input type="submit" value="Submit"> <input type="button" value="Reset" onclick="location='setTrials.jsp'"></td></tr>
</c:if>
</form>
</table>

</c:if>
</c:if>

<c:if test="${param.sType=='gtitle' }">
<sql:query var="searchT" dataSource="${jdbc}">
select distinct brief_title, official_title, clinical_study.id, clinical_study.source, count(*)
from clinical_trials.clinical_study
where official_title~'${param.fgo }' or brief_title~'${param.fgo }'
group by clinical_study.official_title, brief_title, clinical_study.id, clinical_study.source
order by official_title ;
</sql:query>

<c:if test="${empty searchT.rows}"><p class="msg">There do not appear to be any results for your search. Check for spelling errors, and try again!</p></c:if>
<c:if test="${not empty searchT.rows}">

<p class="msg">Total results: <c:out value="${searchT.rowCount }" /></p>
<c:set var="allend" value="${searchT.rowCount}" scope="page" />
<c:if test="${end>allend}">
 <c:set var="end" value="${allend}" scope="page" />
</c:if>

<c:if test="${allend>25}">
<p>Now showing <c:out value="${start +1}" /> to <c:out value="${end +1}" /> </p>
<form action="setTrials.jsp" method="get"><p class="msg">
   Skip to number: <input type="number" name="start">
   <input type="hidden" name="sType" value="${param.sType}">
   <input type="hidden" name="fgo" value="${param.fgo}">
   <input type="submit" value="Submit"></p>
</form>  
</c:if>
<c:if test="${start>allend}">
 <p class="msg">Ummm... there are not that many search results. Try again!</p>
</c:if>

<table>
<tr><th>Add</th><th>Title</th></tr>
<form action="Tset2.jsp" method="post">
<input type="hidden" name="trackingId" value="${param.trackingId}">
<c:forEach items="${searchT.rows }" begin="${start}" end="${end}" var="tRow" varStatus="rowCounter">
<c:if test="${param.trackingId ne 'undefined'}">
<sql:query var="existingT" dataSource="${jdbc}">
select distinct clinicalidfor, emailfor
from alpha.participating
where emailfor='${param.trackingId }' and clinicalidfor='${tRow.id }' 
group by emailfor, clinicalidfor
order by clinicalidfor ;
</sql:query>
</c:if>


<tr><td><center>
<c:choose>
<c:when test='${tRow.id eq quist}'>
---
</c:when>
<c:when test='${not empty existingT.rows}'>
<img src="checkmark.png" height=15>
</c:when>
<c:when test="${param.trackingId ne 'undefined'}">
<input type="checkbox" name="${tRow.id}button" value="${tRow.id}" ${button=='yes'?'checked':''}>
<c:set var="quist" value="${tRow.id}" />
</c:when></c:choose>
</center></td>
<td> 
<b><c:if test="${not empty tRow.brief_title}"><a href="trial.jsp?id=${tRow.id }"><c:out value="${tRow.brief_title }"/></a></c:if>
<c:if test="${empty tRow.brief_title}"><br><a href="trial.jsp?id=${tRow.id }"><c:out value="${tRow.official_title }"/></a></c:if></b>
with 

<sql:query var="people" dataSource="${jdbc}">
select distinct overall_official.last_name, overall_official.role, overall_official.id, clinical_study.source
from clinical_trials.overall_official
inner join clinical_trials.clinical_study
on overall_official.id= clinical_study.id
where overall_official.id='${tRow.id}'
group by overall_official.last_name, overall_official.role, overall_official.id, clinical_study.source
order by overall_official.role;
</sql:query>

<c:if test="${empty people.rows }" >
<c:out value="${tRow.source }"/>
(*Participants not applicable. See <a href="https://clinicaltrials.gov/ct2/show/<c:out value="${tRow.nct_id }"/>" target="_blank">trial page</a>.)
</c:if>

<c:forEach items="${people.rows }" var="Prow" varStatus="rowCounter">
<c:if test="${flag ne Prow.last_name }" >
<a href="profile.jsp?name=${Prow.last_name}"><c:out value="${Prow.last_name}"/></a> (<c:out value="${Prow.role}"/>) / </c:if>
<c:set var="flag" value="${Prow.last_name}"/>
</c:forEach>

</td></tr>


</c:forEach>

<c:if test="${param.trackingId ne 'undefined'}">
<tr><td colspan=4>
<input type="submit" onclick="call2()" value="Submit"> <input type="button" value="Reset" onclick="location='setTrials.jsp'">
</td></tr></c:if>
</form>
</table>
</c:if>
</c:if>
</c:when>
<c:otherwise>
</c:otherwise>  
</c:choose>
<c:if test="${start>25-1}"> 
 <a href="setTrials.jsp?sType=${param.sType}&fgo=${param.fgo}&start=${start - 25}">PREVIOUS</a></c:if>
 
<c:if test="${end<allend}">...
<a href="setTrials.jsp?sType=${param.sType}&fgo=${param.fgo}&start=${start + 25}">NEXT</a>&nbsp;&nbsp;&nbsp;
</c:if>



<p>&nbsp;</p>
<p>&nbsp;</p>


</div>

<div id=div4>
<jsp:include page="footer.jsp"/> 
</div>
</body>
</html>