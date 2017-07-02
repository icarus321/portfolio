<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
	<head>
		<meta charset="utf-8">
		<title>D3 Demo: Making a bar chart with value labels!</title>
		<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
		<style type="text/css">
			/* No style rules here yet */		
		</style>
	</head>
	<body>		
		<sql:setDataSource var="jdbc" driver="org.postgresql.Driver" 
	        url="jdbc:postgresql://neuromancer.icts.uiowa.edu/institutional_repository"
	        user="demo" password="demo"/>
			
		<script type="text/javascript">
			<sql:query var="rows" dataSource="${jdbc}">
				SELECT COUNT(*), EXTRACT(YEAR FROM CS.completion_date) date
				FROM clinical_trials.clinical_study CS INNER JOIN clinical_trials.overall_official OO ON CS.id=OO.id
				WHERE OO.affiliation LIKE '%University of Iowa%'
				GROUP BY EXTRACT(YEAR FROM CS.completion_date)
				ORDER BY EXTRACT(YEAR FROM CS.completion_date);
			</sql:query>
			
			var array = [];
			var row = [];
			row.push("Year","Count");
			array.push(row);
			<c:forEach items="${rows.rows}" var="row" varStatus="rowCounter">
			    row = [];
				row.push('${row.date}' === '' ? 'NA' : '${row.date}');
				row.push(parseInt('${row.count}'));
				array.push(row);
			</c:forEach>
			
			google.charts.load('current', {packages: ['corechart', 'bar']});
			google.charts.setOnLoadCallback(drawMultSeries);

			function drawMultSeries() {
			      var data = google.visualization.arrayToDataTable(array);
			      var options = {
			        title: 'Articles published per year',
			        chartArea: {width: '50%'},
			        hAxis: {
			          title: 'Publications per year',
			          minValue: 0			          
			        },
			        vAxis: {
			          title: 'Year',
			          pattern:'####'
			        },
			        width:1000,
                    height:750
			      };
			      var chart = new google.visualization.BarChart(document.getElementById('chart_div'));
			      chart.draw(data, options);
			    }
		</script>
		 <div id="chart_div"></div>
	</body>
</html>
