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



<sql:query var="trial" dataSource="${jdbc}">
select distinct official_title, brief_title, nct_id, source, start_date, completion_date, study_type
from clinical_trials.clinical_study
where clinical_study.id = ${param.id}
group by official_title, brief_title, nct_id, source, start_date, completion_date, study_type
order by official_title, brief_title, nct_id, source, start_date, completion_date, study_type;
</sql:query>

<br><br><br>

<c:forEach items="${trial.rows }" var="row" varStatus="rowCounter">
<center><h2><c:out value="${row.brief_title}"/></h2></center>
<center><h4>(<c:out value="${row.official_title}"/>)</h4></center>
<center><h3> - Trial Information - </h3></center>
<br><br><br>
<u><b>ClinicalTrials.gov identifier: </b></u>
<br><br><a href="https://clinicaltrials.gov/ct2/show/<c:out value="${row.nct_id }"/>" target="_blank"><c:out value="${row.nct_id }"/></a> (*Click ID for more information)
<br><br>
<u><b>Sponsor: </b></u><br><br><c:out value="${row.source }"/><c:if test="${empty row.source}">(Not applicable)</c:if>
<br><br>
<u><b>Start at: </b></u><br><br><c:out value="${row.start_date }"/><c:if test="${empty row.start_date}">(Not applicable)</c:if>
<br><br>
<u><b>Completed at: </b></u><br><br><c:out value="${row.completion_date }"/><c:if test="${empty row.completion_date}">(Not applicable)</c:if>
<br><br>
<u><b>Study type: </b></u><br><br><c:out value="${row.study_type }"/><c:if test="${empty row.study_type}">(Not applicable)</c:if>
<br><br>

</c:forEach>


<sql:query var="people" dataSource="${jdbc}">
select distinct overall_official.id, contact.last_name, contact.email
from clinical_trials.overall_official
inner join clinical_trials.contact
on contact.id = overall_official.id
where overall_official.id = ${param.id}
group by overall_official.id, contact.last_name, contact.email
order by overall_official.id, contact.last_name, contact.email;
</sql:query>

<u><b>Investigator(s): </b></u><br><br>
<c:forEach items="${people.rows }" var="row" varStatus="rowCounter">

<sql:query var="institution" dataSource="${jdbc}">
select distinct overall_official.id, affiliation
from clinical_trials.overall_official
where overall_official.id = ${param.id}
group by overall_official.id, affiliation
order by overall_official.id, affiliation;
</sql:query>
<c:choose>
<c:when test="${not empty row.email }">
<a href="profile.jsp?name=${row.email}"><c:out value="${row.last_name}"/></a>, works for:<br>
</c:when>
<c:otherwise>
<c:out value="${row.last_name}"/>, works for:<br>
</c:otherwise>
</c:choose>
<c:forEach items="${institution.rows }" var="row2" varStatus="rowCounter">
<ul><li><c:out value="${row2.affiliation}"/></li></ul>
</c:forEach>
</c:forEach>
<br><u>* Note 1: Sometimes there will be no investigators there; you may try another title.
<br>
<br>* Note 2: If there is person's name shown up among institutions, that's the database.</u>




<p>&nbsp;</p>
<p>&nbsp;</p>


</div>

<div id=div4>
<jsp:include page="footer.jsp"/> 
</div>
</body>
</html>