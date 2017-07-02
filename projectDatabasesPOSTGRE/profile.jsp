<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
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
<c:set var="flag" value=""/>
<form action="profile.jsp" method="get">
   Search name: <input type="text" name="name">
   <input type="submit" value="Submit">
</form> 
<p></p>
<c:if test="${not empty param.name}"> 
   
<sql:query var="prof" dataSource="${jdbc}">
select name, familyname, givenname, degree, phone, department, university, email, description, webpage from alpha.researchertest 
where email LIKE '${param.name }'
or familyname LIKE '%${param.name }%' or givenname LIKE '%${param.name }%'
order by name ;
</sql:query>

<c:if test="${empty prof.rows}">
<p class="msg">This researcher (${param.name }) is not currently in our database. </p>
You can try searching the <a href="http://www.uiowa.edu/google-search?search=${param.name }" target="_blank">University of Iowa Website</a> or <a href="mailto:${param.name }">contact the researcher</a> directly.

<p class="msg">Researchers affiliated with the University of Iowa may <a href=form1.jsp>register their information</a> into the database to generate a profile.</p>
</c:if>
<c:forEach items="${prof.rows }" var="row" varStatus="rowCounter">

<table>
<th colspan=2><c:out value="${row.givenname }"/> <c:out value="${row.familyname }"/>, <c:out value="${row.degree }"/></th>
<tr>
<td>Department:</td>
<td><c:out value="${row.department }"/>, <c:out value="${row.university }"/></td>
</tr>
<tr>
<td>Description of Research:</td>
<td><c:out value="${row.description }"/></td>
</tr>
<tr>
<td>Contact details:</td>
<td><c:out value="${row.phone }"/><br><c:out value="${row.email }"/>
<br><a href="${row.webpage }" target="_blank">Webpage</a></td>
</tr>
</table>
<c:if test="${param.trackingId eq param.name}">
<p>Manage my: 
<a href="profileId.jsp"><button>Profile Information</button></a>
<a href="Pset2.jsp"><button>Publications</button></a>
<a href="Tset2.jsp"><button>Trials</button></a>
</p>
</c:if>
<p>&nbsp;</p>

<h2>Studies Including <c:out value="${row.name }"/></h2>

<sql:query var="titles" dataSource="${jdbc}">
select distinct brief_title, official_title, clinical_study.id, contact.email, contact.last_name
from clinical_trials.clinical_study
inner join clinical_trials.contact
on clinical_study.id=contact.id
where contact.email~'${row.email }'
group by clinical_study.official_title, brief_title, clinical_study.id, contact.email, contact.last_name
order by official_title ;
</sql:query>

<sql:query var="existingT" dataSource="${jdbc}">
select distinct clinicalidfor, emailfor, clinical_study.id, brief_title
from alpha.participating
inner join clinical_trials.clinical_study
on clinical_study.id=clinicalidfor
where emailfor='${row.email }'
group by emailfor, clinicalidfor, clinical_study.id, brief_title
order by brief_title ;
</sql:query>
<c:choose>
<c:when test="${not empty existingT.rows}"> 
<p class="msg">Researcher Curated Results:</p>
<ol>
<c:forEach items="${existingT.rows }" var="kRow" varStatus="rowCounter">
<sql:query var="people" dataSource="${jdbc}">
select distinct id, last_name
from clinical_trials.overall_official
where overall_official.id= ${kRow.id}
group by id, last_name
order by id, last_name;
</sql:query>
<c:if test="${not empty kRow.brief_title}"><li><b><a href="trial.jsp?id=${kRow.id }"><c:out value="${kRow.brief_title }"/></a></b>
with 
<c:forEach items="${people.rows }" var="prow" varStatus="rowCounter">
<c:out value="${prow.last_name}"/> / 
</c:forEach>
</li>
</c:if>
</c:forEach>
</ol>

</c:when>

<c:when test="${empty existingT.rows}"> 
<p class="msg">Note: These results have not been verified by the researcher.</p>
<ol>
<c:forEach items="${titles.rows }" var="kRow" varStatus="rowCounter">
<sql:query var="people" dataSource="${jdbc}">
select distinct contact.last_name, overall_official.affiliation, contact.email
from clinical_trials.contact
inner join clinical_trials.overall_official
on contact.id=overall_official.id
where contact.id= ${kRow.id}
group by contact.id, contact.last_name, overall_official.affiliation, contact.email
order by contact.last_name, overall_official.affiliation;
</sql:query>
<c:if test="${not empty kRow.brief_title}"><li><b><a href="trial.jsp?id=${kRow.id }"><c:out value="${kRow.brief_title }"/></a></b>
with 
<c:forEach items="${people.rows }" var="pRow" varStatus="rowCounter">
<c:out value="${pRow.last_name }"/>; </c:forEach></li></c:if>
<c:if test="${empty kRow.brief_title}"><br><font color="red">(+ <c:out value="${kRow.count }"/> Missing Titles)</font></c:if>
</c:forEach></ol>
</c:when>
</c:choose>

<h2>Articles by <c:out value="${row.name }"/></h2>

<sql:query var="medli" dataSource="${jdbc}">
select distinct title, last_name, fore_name, article.pmid
from medline.article
inner join medline.author 
on article.pmid=author.pmid
where fore_name LIKE '${row.givenname }%' and last_name LIKE '${row.familyname }%'
group by title, last_name, fore_name, article.pmid
order by last_name ;
</sql:query>

<sql:query var="existingM" dataSource="${jdbc}">
select distinct pmidfor, emailfor, pmid, title
from alpha.authors
inner join medline.article
on article.pmid=authors.pmidfor
where emailfor='${row.email }'
group by emailfor, pmidfor,pmid, title
order by title ;
</sql:query>


<c:choose>
<c:when test="${not empty existingM.rows}"> 
<p class="msg">Researcher Curated Results:</p>

<ol>
<c:forEach items="${existingM.rows }" var="mRow" varStatus="rowCounter">
<sql:query var="anything" dataSource="${jdbc}">
select distinct author.pmid,last_name,fore_name
from medline.author
where author.pmid=${mRow.pmid} 
group by author.pmid,last_name,fore_name
order by author.pmid ;
</sql:query>
<li><b><a href="pub.jsp?id=${mRow.pmid }"><c:out value="${mRow.title }"/></a></b>
by 
<c:forEach items="${anything.rows }" var="anyRow" varStatus="rowCounter">
<c:out value="${anyRow.fore_name }"/> <c:out value="${anyRow.last_name }"/> /  
</c:forEach>
</li>
</c:forEach></ol>
</c:when>
<c:when test="${empty existingM.rows}"> 
<p class="msg">Note: These results have not been verified by the researcher.</p>
<ol>
<c:forEach items="${medli.rows }" var="mRow" varStatus="rowCounter">
<sql:query var="anything" dataSource="${jdbc}">
select distinct author.pmid,last_name,fore_name
from medline.author
where author.pmid=${mRow.pmid} 
group by author.pmid,last_name,fore_name
order by author.pmid ;
</sql:query>
<li><b><a href="pub.jsp?id=${mRow.pmid }"><c:out value="${mRow.title }"/></a></b>
by 
<c:forEach items="${anything.rows }" var="anyRow" varStatus="rowCounter">
<c:out value="${anyRow.fore_name }"/> <c:out value="${anyRow.last_name }"/> / 
</c:forEach></li>
</c:forEach></ol>
</c:when>
</c:choose>






</c:forEach>
</c:if>
<p>&nbsp;</p>
<p>&nbsp;</p>


</div>

<div id=div4>
<jsp:include page="footer.jsp"/> 
</div>
</body>
</html>