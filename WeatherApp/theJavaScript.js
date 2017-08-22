//gloabl variables 
var map, i=0;
var nexrad;
//functions that handle weather request
var dayA = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"];
var stringA=[]
	function myFor() {
			  city = $("#city").val(); 		
			  getWeatherF(function (data) {
			  displayData = "";
			 
			
			displayData = "<table style='background-color:RGB(91,155,213);'>"
				+"<tr><th colspan=4 style='border:1px solid white'>5 Day Forecast</th></tr>";
			row2="<tr style='border:1px solid white'><td style='border:1px solid white'>Day</td>"
				+"<td style='border:1px solid white'>Desc</td>"
				+"<td style='border:1px solid white'>Max</td><td style='border:1px solid white'>Min</td></tr>";
				stringA.push(displayData);stringA.push(row2);
			//$( "#leftContainer3" ).append( displayData+row2 );
			for(f=1;f<6;f++){
				myDay = data.list[f].dt;date = new Date(myDay*1000);
				//alert(date.getMonth());alert(date.getDay());
				theDay = date.getDay();
				row3 = "<tr style='border:1px solid white'><td style='border:1px solid white'>"+dayA[theDay]
					+"</td><td style='border:1px solid white'>"
					+data.list[f].weather[0].main+"</td>"
					+"<td style='border:1px solid white'>"+data.list[f].temp.max
					+"</td><td style='border:1px solid white'>"+data.list[f].temp.min+"</td></tr>";
				stringA.push(row3);
			}
			rowLast="</table><br>";stringA.push(rowLast);
		
		
		$( "#leftContainer3" ).append( stringA[0]+stringA[1]+stringA[2]+stringA[3]+stringA[4]+stringA[5]+stringA[6]+stringA[7]);
		//document.getElementById("leftContainer").scrollTop=document.getElementById("leftContainer").scrollHeight;
		//document.getElementById("leftContainer").style.height="50%";
			
			stringA=[];
			  });
				
			function getWeatherF(callback) {
		          var weatherF = 'http://api.openweathermap.org/data/2.5/forecast/daily?q='+city		
				+'&mode=json&units=imperial&APPID=b452c2adfadb2555d299e848a6ed2c78';
				for(timeT=0;timeT<1000;timeT++){myVarT="s";}
		         $.ajax({dataType: "jsonp",url: weatherF,success: callback});
			}
}
$( document ).ready(function() {
	var city = '';
	$("#get").click(function() {
			  city = $("#city").val(); 		
			  getWeather(function (data) {
			  displayData = "";
			  displayData = "<ul><li><strong>"+data.name+":</strong> "+data.weather[0].description
				+"</li>"+"<li><strong>Current Temp: </strong>"+data.main.temp+"&deg;F</li>"
				+"<li><strong>High: </strong>"+data.main.temp_max+"&deg;F</li>"
				+"<li><strong> Low: </strong>"+data.main.temp_min+"&deg;F</li>"
				+"<li><strong> Wind Speed: </strong>"+data.wind.speed+"mph</li></ul>";
			  	$( "#leftContainer3" ).empty().append( displayData );});myFor();
				
			function getWeather(callback) {
		          var weather = 'http://api.openweathermap.org/data/2.5/weather?q='+city	
			+'&mode=json&units=imperial&APPID=b452c2adfadb2555d299e848a6ed2c78';
		          $.ajax({dataType: "jsonp",url: weather,success: callback});
			}
})
});
//map function, creates the map 
require(["esri/map", "esri/dijit/BasemapToggle", "esri/layers/WebTiledLayer"], 
function(Map, BasemapToggle, WebTiledLayer){ 
	map = new Map("map", { basemap: "national-geographic",center: [-107.876175,38.478321],scaleControl: true,zoom: 5});
	var toggle = new BasemapToggle({map: map,basemap: "hybrid"}, "leftContainer2");
	toggle.startup();
	var subs = [ "mesonet", "mesonet1", "mesonet2", "mesonet3" ];
	nexrad = new esri.layers.WebTiledLayer("http://${subDomain}.agron.iastate.edu/cache/tile.py/1.0.0/nexrad-n0q-900913/${level}/${col}/${row}.png", {
        id: "nexrad",subDomains: subs});
})
	 
//function toggles mesonet layer and legend item on and off 
function myFun1(){
	if(i%2 == 0){map.addLayer(nexrad); $("#precipT").show();$("#precip").show();};		
	if(i%2 !=0){map.removeLayer(nexrad);$("#precipT").hide();$("#precip").hide();};
	i = i + 1;
} 
//function called when page loads, simply hides the legend item
function setVis(){
$("#precipT").hide();$("#precip").hide();
document.getElementById("precipT").style.visibility="visible";
document.getElementById("precip").style.visibility="visible";
}	
