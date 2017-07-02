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



<sql:query var="trial" dataSource="${jdbc}">
select distinct official_title, brief_title, clinical_study.id, overall_official.last_name, overall_official.seqnum, overall_official.affiliation, nct_id, source, start_date, completion_date, study_type
from clinical_trials.clinical_study
inner join clinical_trials.overall_official
on clinical_study.id=overall_official.id
where clinical_study.id = ${param.id}
group by official_title, brief_title, clinical_study.id, nct_id, source, start_date, completion_date, study_type, overall_official.last_name, overall_official.affiliation, overall_official.seqnum
order by official_title ;
</sql:query>


<c:forEach items="${trial.rows }" var="row" varStatus="rowCounter">
<c:if test="${empty row.id}">HELP</c:if>

<center><h2><c:out value="${row.brief_title}"/></h2></center>
<center><h3> - Trial Information - </h3></center>

<br>
<br>
<br>

<b>ClinicalTrials.gov identifier: </b> 
<a href="https://clinicaltrials.gov/ct2/show/<c:out value="${row.nct_id }"/>" target="_blank"><c:out value="${row.nct_id }"/></a> (*Click ID for more information)
<br>
<br>
<b>Sponsor: </b><c:out value="${row.source }"/><c:if test="${empty row.source}">(Not applicable)</c:if>
<br>
<br>
<b>Start at: </b><c:out value="${row.start_date }"/><c:if test="${empty row.start_date}">(Not applicable)</c:if>
<br>
<br>
<b>Completed at: </b><c:out value="${row.completion_date }"/><c:if test="${empty row.completion_date}">(Not applicable)</c:if>
<br>
<br>
<b>Study type: </b><c:out value="${row.study_type }"/><c:if test="${empty row.study_type}">(Not applicable)</c:if>
<br>
<br>
<sql:query var="author" dataSource="${jdbc}">
select distinct official_title, clinical_study.id, contact.last_name, phone, email, affiliation
from clinical_trials.clinical_study
inner join clinical_trials.contact
on clinical_study.id=contact.id
inner join clinical_trials.overall_official
on overall_official.id=clinical_study.id
where clinical_study.id = ${param.id}
group by official_title, clinical_study.id, contact.last_name, phone, email, affiliation
order by official_title, clinical_study.id;
</sql:query>

<h4>Investigator(s): </h4>
<ul>
<c:forEach items="${author.rows }" var="Arow" varStatus="rowCounter">
<c:if test="${empty row.id}">HELP</c:if>
<li>
<a href="profile.jsp?name=${Arow.email }"><c:out value="${Arow.last_name}"/></a> | <c:out value="${Arow.affiliation}"/>
</li>
</c:forEach>
</ul>
<br>
<br>



</c:forEach>





<p>&nbsp;</p>
<p>&nbsp;</p>


</div>

<div id=div4>
<jsp:include page="footer.jsp"/> 
</div>
</body>
</html>