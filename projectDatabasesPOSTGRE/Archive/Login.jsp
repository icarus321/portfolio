<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Alpha Login</title>
</head>
<body>
	<p>
		<A href="/Login.jsp"><strong>Login</strong></A>
	</p>

	<font color="red"><c:if test="${not empty param.errMsg}">
            <c:out value="${param.errMsg}" />
            </c:if>
    </font>

	<div id="center">
		<form action="Login.jsp"  method="post">
			<fieldset>
				<legend>Login</legend>
				Username: <input type="text" name="username"/><br/>
           		Password: <input type="password" name="password"/><br/>
           		<input type="submit" />				
				<input	type="submit" name="submit" value="Cancel">
			</fieldset>
		</form>
	</div>
	    
    <c:if test="${not empty param.username and not empty param.password}">
      <sql:setDataSource var="jdbc" driver="org.postgresql.Driver" 
        url="jdbc:postgresql://neuromancer.icts.uiowa.edu/institutional_repository"
        user="jlmadden" password="ghazxvss"/>
 
      <sql:query dataSource="${jdbc}" var="selectQ">
        select count(*) as count from alpha.researchertest
        where email='${param.username}'
        and password='${param.password}'
      </sql:query>
 
      <c:forEach items="${selectQ.rows}" var="r">
        <c:choose>
          <c:when test="${r.count gt 0}">
            <c:set scope="session"
                   var="loginUser"
                   value="${param.username}"/>
            <c:redirect url="profile.jsp?name=${param.username}"/>
          </c:when>
          <c:otherwise>
            <c:redirect url="Login.jsp" >
              <c:param name="errMsg" value="Username/password does not match" />
            </c:redirect>
          </c:otherwise>
        </c:choose> 
      </c:forEach> 
    </c:if>	
</body>
</html>