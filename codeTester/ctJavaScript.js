var counter = 0;
$(function hi(){
   var link = document.getElementById('downloadlink');
       link.style.display = 'block';
       $("#btn2").click(function(){
          var bla = $(hello).val();
	  var textFile = null,
          makeTextFile = function (text) {var data = new Blob([text], {type: 'unicode'});
            if (textFile !== null) {window.URL.revokeObjectURL(textFile);}
            textFile = window.URL.createObjectURL(data);
            return textFile;
        };
    var create = document.getElementById('btn1'),
        textbox = document.getElementById('hello');
        link.href = makeTextFile(textbox.value);
    
	counter+=1;
	if(counter>0){$("#hello2").empty();counter=0;}
	
	$("#hello2").append(bla);
    });
    });
