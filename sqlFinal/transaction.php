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
//m is the total price, q is username, n is items being purchased, items is split of n, o is delivery price
$q =$_GET['q'];$m =$_GET['m'];$n=$_GET['n'];$items = explode(',',$n);$o=$_GET['o'];
//v is lat z is lon
$v =$_GET['v'];$z =$_GET['z'];

//making connection to the database
$con = mysqli_connect("dbdev.cs.uiowa.edu:3306","jlmadden","KNLy3G5B_zUa", "db_jlmadden");

//checks if connection failed
if (!$con) {die('Could not connect: ' . mysqli_error($con));}

//below code select db, figure out ajax demo
mysqli_select_db($con,"ajax_demo");

//first query is to do the subtraction, sql3 query is for getting the delivery attributes for the selected option
$sql="SELECT Balance-'$m' FROM UserAccountsF WHERE UserName = '$q'";
$sql3 = "SELECT myOption,Cost,DeliveryDesc from DeliveryF where Cost = '$o'";



//four expressions below handle the sql and sql3 queries
$result = mysqli_query($con,$sql);
$row = mysqli_fetch_array($result);
$result3 = mysqli_query($con,$sql3);
$row3 = mysqli_fetch_array($result3);




//for($iItem=0;$iItem<sizeof($items);$iItem++){echo $items[$iItem]."<br>";}

//if statement that checks if subtraction expression from sql is greater than or equal to zero
if($row[0]>=0){
    //two expressions below print the new balance and update the database with the new balance
    //echo $row[0]; 
    settype($row[0],"double");
    $sql2 = "UPDATE UserAccountsF SET Balance = '$row[0]' WHERE UserName='$q'";
    
    //two expressions below print the delivery COST, maybe delete the if and else conditions
    //need to restructure the if and else conditions below
    if($con->query($sql2)==TRUE){
        //original echo delivery
	//move the four funtions below to new area
	date_default_timezone_set('America/Chicago');
	//echo "<br>Default time " . date_default_timezone_get() . "<br>";
        $myDate = date("Y-m-d H:i:sa");
	$myDate2 = date("Y-m-d h:i:sa");
	$sql4="INSERT INTO TransactionsF(DateT, TotalPrice, theLat, theLon) VALUES ('$myDate','$m','$v','$z')";
    	$result4 = mysqli_query($con,$sql4);
	echo "&nbsp;Transaction Information<br>&nbsp;Total Price: $". $m . "<br>&nbsp;Transaction Time: ". $myDate2 . "<br>";
	$recentID = mysqli_insert_id($con);
	echo "&nbsp;Delivery Time: ". $row3['DeliveryDesc'] . "<br>&nbsp;Items<ol>" ;
	//echo $recentID . "<br>";

	//two expressions insert into HasUser table
	$sql5="INSERT INTO HasUserF(UserName,TransactionNumber) VALUES ('$q','$recentID')";
    	$result5 = mysqli_query($con,$sql5);
	
	//two expressions insert into Choice table
	$sql6="INSERT INTO ChoiceF(myOption,TransactionNumber) VALUES ('$row3[0]','$recentID')";
    	$result6 = mysqli_query($con,$sql6);

	//for loop inserts into HasTransaction, this is the link of goods to transactions
	for($iItem=0;$iItem<sizeof($items);$iItem++){

		//myVarT is the item in the array without the leading whitespace char
		$myVarT = substr($items[$iItem], 1);
		//first sql expressions, selects from Goods
		$sql7="SELECT ISBN,Price,ItemDescription,Category from GoodsF where ItemDescription = '$myVarT'";
	    	$result7 = mysqli_query($con,$sql7);
		$row7 = mysqli_fetch_array($result7);
		echo "<li>".$items[$iItem] .": $".$row7['Price']. "</li>";
	
		//inserts into has transactions
		$sql8="INSERT INTO HasTransactionF(TransactionNumber, ISBN) VALUES ('$recentID','$row7[0]')";
	    	$result8 = mysqli_query($con,$sql8);
	}
	//end of for loop
	echo "</ol>";
	}
	//end of if block

    //else condition executes if no connection
    else{echo "not working";}
}



//need to insert based on delivery option
//insert into 4 tables, transactions, choice and hastransaction, has user
//choice will have $row3['myOption'],transaction number
//transactions will have transaction number, date, totalprice($m)
//hastransaction will have transaction number, ISBN for each good (will need to connect to Goods table)
//hasuser will have current username ($q) and current transaction number

//$sqlT1="INSERT INTO Transactions (DateT,TotalPrice) VALUES ('$myDate', '$m')";
//$resultT1 = mysqli_query($con,$sql);
//$rowT1 = mysqli_fetch_array($result);


//else condition prints insufficient funds if not enough money in balance
else{echo "<br><br><center>Insufficient funds</center>";}

mysqli_close($con);
?>
</body>
</html>
