//handle point and line features
//checkbox for adding features
//option to delete last point
//add legend
//design unit testing
//organize the code
//fix the insert check and return array check
//need to return java string on insert and delete if call failed

    //declare global variables 
    var map;var testString;var myArrayResponse;var myGeo;var myGeo;var myGeo2;
	//declare json object for holding arrays
    //mA holds the lat lon for the last two POINTS
    //mA is at max an array of two lat/lng pairs, it is used to generate the line
    //mL holds the coordinates for every LINE
	var myJO = {myMarker:[],mA:[],mL:[],mF1:[],mF2:[],markArray:[],markArray2:[], editA:[],mFinalLine:[],myCor:[],geoArray:[]};

    //function creates the map object	
    function myFun(){    
        map = L.map('map',{ center: [41.600, -93.608], doubleClickZoom: false, zoom: 7});
        L.tileLayer('http://{s}.google.com/vt/lyrs=s&x={x}&y={y}&z={z}', { subdomains:['mt0','mt1','mt2','mt3'], attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>' }).addTo(map);
       }
	//end of function myFun	
		
		
	//ajax function for database calls
	var myDbConnection =0;
	function showUser(str, myInt) {
			//checks if the call was made on accident
           
            
            
				//if and else below handle different browsers 
                if (window.XMLHttpRequest) {xmlhttp = new XMLHttpRequest();}
                else {xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");}
               //two if statements make calls to different jsp pages
			   if(myInt == 1){alert(str);var str3 = encodeURIComponent(str);xmlhttp.open("GET","http://localhost:8080/jspTest/insertFeature.jsp?q="+str3,true);}
               if(myInt == 2){xmlhttp.open("POST","http://localhost:8080/jspTest/showFeature.jsp",true);}
               if(myInt == 3){xmlhttp.open("POST","http://localhost:8080/jspTest/showFeature.jsp",true);}
               if(myInt == 4){var str3 = encodeURI(str);xmlhttp.open("POST","http://localhost:8080/jspTest/deleteFeature.jsp?q="+str3,true);}
               //sends the ajax request
			   xmlhttp.send();
			   //function is called when the ready state changes
               xmlhttp.onreadystatechange = function() {
				              
                  if (this.readyState == 4 && this.status == 200 && myDbConnection<10) {
                    // if(theIter>=100){alert("Unable to connect to the database at this time.  Try again later.");theIter=0;return;}
                     //if(myInt == 1){alert("works");}
                     //if statement is called when adding features from the database
                     //on last delete map fails to empty
                     if(myInt==4){showUser('foo',3);return;}if(myInt==1){showUser('foo',2);return;}
					 if(myInt!=1){
                        myArrayResponse = this.responseText.split(";");
                        //map may fail to draw after deleting
                        if(myArrayResponse.length==2 && myInt!=3){myDbConnection++;showUser(str, myInt);return;}
						myArrayResponse.splice(0,1);myArrayResponse.splice(myArrayResponse.length-1,1);
						//alert(myArrayResponse[1]);return;
						addDB(myArrayResponse);
						}
                      }
                  if(myDbConnection>=10){alert("Unable to connect to the database at this time.  Please try again later.");myDbConnection=0;return;}
                };
                //end og xmlhttp.onreadystatechange function
                
            
        }
        //end of function show user
        
    function startFun(){
    	document.getElementById("map").style.cursor='context-menu';
        	//this is where points and lines are handled 
        	var isPoint="no";
    	 if (document.getElementById('featType').value == "Feature Type") {alert('need to pick a feature');return;}
        map.on('click', function(e) {
			testString = "nDBL";        
			setTimeout(function(){ if(map.on('click') ==true){startFun2();return;} }, 3000);
			myLatLon = e.latlng;
			myMarks = L.marker(myLatLon);
			myMarks.addTo(map);
			myJO.markArray.push(myMarks);
			myJO.mA.push(myLatLon);myJO.mF1.push(myLatLon.lat);myJO.mF2.push(myLatLon.lng);
			if(myJO.mA.length>2){myJO.mA.splice(0,1);}
			if(myJO.mA.length==2){
				mLine = L.polyline(myJO.mA,{color:'RGB(100,0,0)'})
				myJO.markArray.push(mLine);
				mLine.addTo(map);
				myJO.mL.push(mLine);
				}
		});
    }    
        
    function startFun2(){
        
        var prop2 = "bob";
        map.on('dblclick', function(e) {
			myJO.mFinalLine=[];
            if(myJO.mL.length>=3){
                myJO.myCor=[];
				for(j=0;j<myJO.mF1.length;j++){myJO.myCor.push([myJO.mF2[j],myJO.mF1[j]]);}
				var myTypeFeature = document.getElementById("featType").value;
				var states = [{"type": "Feature","properties": {"party": myTypeFeature,"party2":prop2},
								"geometry": {"type": "Polygon","coordinates":[myJO.myCor]}}];
            
			myGeo = L.geoJSON(states, {
			style: function(feature) {
			switch (feature.properties.party) {
            case 'gWaterway': return {color: "#00ff00"};
            case 'Wetland':   return {color: "#00ffff"};
            case 'Pond':   return {color: "#0000ff"};
            case 'bStrip':   return {color: "#ffff00"};
            case 'aPoint':   return {color: "#ff00ff"};
			}}})

			myJO.editA.push(myJO.myGeo);
			myJSON = JSON.stringify(states);
			alert(myJSON);
			showUser(myJSON,1);
			for(i=0;i<myJO.markArray.length;i++){map.removeLayer(myJO.markArray[i]);}
			myGeo.addTo(map);
			myJO.markArray2.push(myGeo);
			testString = "yDBL";
            myJO.mA=[];myJO.mF=[];myJO.mL=[];myJO.mF1=[];myJO.mF2=[];
            }
			else{return;}
        });
        

    }    
        var theItem2A=[];
        function alertTest(){for(i=0;i<myJO.geoArray.length;i++){myJO.geoArray[i-1].on('click', function(e) {alert(theItem2A[i]);})}}
    var myID=[];
    
        function addDB(theItem){
        	theItem2A=[];
    	//alert(theItem.length);
		for(i=0;i<myJO.markArray.length;i++){map.removeLayer(myJO.markArray[i]);}
		for(i=0;i<myJO.markArray2.length;i++){map.removeLayer(myJO.markArray2[i]);}
		for(i=0;i<myJO.geoArray.length;i++){map.removeLayer(myJO.geoArray[i]);}
		myJO.geoArray=[];
		var testI =0;
		for(i=0;i<theItem.length;i++){
			if(i%2==0){myID.push(theItem[i]);}
			else{
			
			theItem2 = theItem[i];
			theItem2A.push(theItem2)
			var myobj = JSON.parse(theItem[i]);
			myGeo2 = L.geoJSON(myobj, {
				style: function(feature) {
				switch (feature.properties.party) {
				case 'gWaterway': return {color: "#00ff00"};
				case 'Wetland':   return {color: "#00ffff"};
				case 'Pond':   return {color: "#0000ff"};
				case 'bStrip':   return {color: "#ffff00"};
				case 'aPoint':   return {color: "#ff00ff"};
			}}})
			
		myJO.geoArray.push(myGeo2);
			//this is where to start
			//i is off now
			//need to delete where id is equal 
		
			
		myGeo2.addTo(map);
			
		myGeo2.bindPopup("<b>"+theItem[i]+"</b><br><input type='button' value='Delete Feature' onclick='myDelete("+testI+");'>");
		testI++;
			}
		
		}
		//alertTest();
	}    
        
       
        
        function myDelete(tI){
        	myV=theItem2A[tI];
        	   //var j=0;
			  for(jK=0;jK<myV.length;jK++){if(myV[jK]=='['){
				  //alert(myV.length);
				  myV2=myV.slice(jK,myV.length);break;}}
			  //alert(myV2[myV2.length-1]);
       showUser(myV2,4);
        }
	
	
	 //$("html").keydown(function(event){if(event.which==46){alert("okay");}});
	
	
	function myFunTT(){alert('hello3');}        
	function checkEdits(){
		document.getElementById("map").style.cursor='';
		alert("Stop Editing");map.removeEventListener('click');map.removeEventListener('dblclick');map.clear();}    
	//function selectFeatures(){try{alert(myArrayResponse);}catch(err){}//deleteFeatures(event);}    
	//function deleteFeatures(event){var x = event.which || event.keyCode;}
