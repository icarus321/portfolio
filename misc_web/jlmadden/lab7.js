
  $(function() {
    $( "#tabs" ).tabs({active:0,collapsible: true});
	 $( "#datepicker" ).datepicker({maxDate: '-18y'});
	 
  });


  
  

	$(function() {
		$( "#tabs" ).tabs({
			beforeLoad: function( event, ui ) {
				ui.jqXHR.fail(function() {
					ui.panel.html(
						"Couldn't load this tab. We'll try to fix this as soon as possible. " +
						"If this wouldn't be a demo." );
				});
			}
		});
	});

 
  function askServer() {
       

   var req = new XMLHttpRequest();
  var name1 = document.getElementById("name").value;
  var email1 = document.getElementById("email").value;
  var datepicker1 = document.getElementById("datepicker").value;

  var dataToSend = "?name1=" + name1 + "&email1=" + email1 + "&datepicker1=" + datepicker1;
  req.open("GET", "myPHPLab7.php" + dataToSend, true);
  req.onreadystatechange = handleServerResponse;
  req.send();
  
 

  document.getElementById("result").innerHTML = "The request has been sent.";
  function handleServerResponse() {
  if ((req.readyState == 4) && (req.status == 200))
 {
    var result = 
req.responseText;
    document.getElementById("result").innerHTML = result;
  }
}
  return false;
}
  
  
 
