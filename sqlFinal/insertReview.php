<!DOCTYPE html>
<html>

<head>
  <style>
    table {width: 100%;border-collapse: collapse;}
    table, td, th {border: 1px solid black;padding: 5px;}
    th {text-align: left;}
  </style>
</head>

<body>



<?php
//m is the isbn, q is username, n is review text
$q =$_GET['q'];$m =$_GET['m'];$n=$_GET['n'];


//making connection to the database
$con = mysqli_connect("dbdev.cs.uiowa.edu:3306","jlmadden","KNLy3G5B_zUa", "db_jlmadden");

//checks if connection failed
if (!$con) {die('Could not connect: ' . mysqli_error($con));}

//below code select db, figure out ajax demo
mysqli_select_db($con,"ajax_demo");

//query to insert review
$sql5="INSERT INTO ReviewsF(Comments, ISBNR) VALUES ('$n','$m')";
$result5 = mysqli_query($con,$sql5);
$recentID = mysqli_insert_id($con);
$recentID2 = $recentID;
$sql6="INSERT INTO HaveReviewsF(ReviewID,ISBN) VALUES ('$recentID2','$m')";
$result6 = mysqli_query($con,$sql6);
$sql7="INSERT INTO WritesF(UserName,ReviewID) VALUES ('$q','$recentID2')";
$result7 = mysqli_query($con,$sql7);
	
	

mysqli_close($con);
?>
</body>
</html>
