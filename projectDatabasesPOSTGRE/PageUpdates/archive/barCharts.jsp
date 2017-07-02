<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">



	<head>
		<meta charset="utf-8">
		<title>D3 Demo: Making a bar chart with value labels!</title>
		<script type="text/javascript" src="http://d3js.org/d3.v3.min.js"></script>
		<style type="text/css">
			/* No style rules here yet */		
		</style>
	</head>
	<body>
	
	
			
		
		
		<sql:setDataSource var="jdbc" driver="org.postgresql.Driver" 
	        url="jdbc:postgresql://neuromancer.icts.uiowa.edu/institutional_repository"
	        user="demo" password="demo"/>
	        
	 
	     
				
		
		
		
		
		
	
		

			
			
			
			
		<script type="text/javascript">
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		

			//Width and height
			var w = 500;
			var h = 100;
			var barPadding = 1;
			
			var dataset = [];
			var dataset2 = [];
			
			
			<sql:query var="rows" dataSource="${jdbc}">
			select clinical_trials.clinical_study.completion_date
			from clinical_trials.clinical_study
			inner join clinical_trials.overall_official
			on clinical_trials.clinical_study.id=clinical_trials.overall_official.id
			where clinical_trials.overall_official.affiliation like '%University of Iowa%'
			order by clinical_trials.clinical_study.completion_date;
			</sql:query>

			<c:forEach items="${rows.rows}" var="row" varStatus="rowCounter">
			var strR = '${row.completion_date}'.substring(0, 4);
			dataset.push(strR);
			


			</c:forEach>
			
		
			
			
			
				var count = [];
				var msg = '';
				var msg2 = '';

				for (var i = 0; i < dataset.length; i++) {
				if (count[dataset[i]]) {
				count[dataset[i]] += 1;
				} else {
				count[dataset[i]] = 1;
				}
				}

				for (i in count) msg += i + ' occurres ' + count[i] + ' times\n';
				for (i in count) {msg2 = count[i]; dataset2.push(msg2);} ;
				alert(msg);
				alert(dataset2);
			
			
			
			
			
			
			
			
			
			//Create SVG element
			var svg = d3.select("body")
						.append("svg")
						.attr("width", w)
						.attr("height", h);

			svg.selectAll("rect")
			   .data(dataset2)
			   .enter()
			   .append("rect")
			   .attr("x", function(d, i) {
			   		return i * (w / dataset2.length);
			   })
			   .attr("y", function(d) {
			   		return h - (d * 4);
			   })
			   .attr("width", w / dataset2.length - barPadding)
			   .attr("height", function(d) {
			   		return d * 4;
			   })
			   .attr("fill", function(d) {
					return "rgb(0, 0, " + (d * 10) + ")";
			   });

			svg.selectAll("text")
			   .data(dataset2)
			   .enter()
			   .append("text")
			   .text(function(d) {
			   		return d;
			   })
			   .attr("text-anchor", "middle")
			   .attr("x", function(d, i) {
			   		return i * (w / dataset2.length) + (w / dataset2.length - barPadding) / 2;
			   })
			   .attr("y", function(d) {
			   		return h - (d * 4) + 14;
			   })
			   .attr("font-family", "sans-serif")
			   .attr("font-size", "11px")
			   .attr("fill", "white");


			
		</script>
	</body>
</html>