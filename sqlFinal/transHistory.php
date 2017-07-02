<!DOCTYPE html>
<html>
<!--<input type='button' id='bob 'value='hello'> -->
<head>
<style>
table {
    width: 100%;
    collapse;
}

table, td, th {
    border: 1px solid black;
    padding: 5px;
}

th {text-align: left;}
</style>
</head>
<body>

<?php
//$q = intval($_GET['q']);
$q =$_GET['q'];









$con = mysqli_connect("dbdev.cs.uiowa.edu:3306","jlmadden","KNLy3G5B_zUa", "db_jlmadden");
if (!$con) {
    die('Could not connect: ' . mysqli_error($con));
}

mysqli_select_db($con,"ajax_demo");
//$sql="SELECT * FROM UserAccounts WHERE UserName = '".$q."'";
//$result = mysqli_query($con,$sql);

echo "<table style='border:2px solid white;color:white;'>
<tr style='border:1px solid white;'>
<th style='border:1px solid white;'><center>Transaction Number</center></th>
<th style='border:1px solid white;'><center>Total Price</center></th>
<th style='border:1px solid white;'><center>Delivery Option</center></th>
<th style='border:1px solid white;'><center>Date</center></th>
<th style='border:1px solid white;width:500px;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Goods</th>

</tr>";



//need to select all TransNumbers from HasUser where q = UserNameHasUser
//below expression will give us each transaction number belonging to current user

$sql="SELECT UserName, TransactionNumber FROM HasUserF WHERE UserName = '$q'";
$result = mysqli_query($con,$sql);
//$row = mysqli_fetch_array($result);

 

$regIter = 0;
while($row = mysqli_fetch_array($result)) {
echo "<td style='border:1px solid white;'><center>" . $row['TransactionNumber'] . "</center></td>";
//this is for getting the delivery option
$sqlChoice="Select myOption, TransactionNumber from ChoiceF where TransactionNumber='$row[1]'";
$resultChoice = mysqli_query($con,$sqlChoice);
$rowChoice = mysqli_fetch_array($resultChoice);

$sqlDate="SELECT TransactionNumber, DateT, TotalPrice, theLat, theLon FROM TransactionsF WHERE TransactionNumber = '$row[1]'";
    $resultDate = mysqli_query($con,$sqlDate);
	while($rowDate = mysqli_fetch_array($resultDate)) {
	echo "<td style='border:1px solid white;'><center>$" . $rowDate['TotalPrice'] . "</center></td>";
	echo "<td style='border:1px solid white;'><center>" . $rowChoice[0] . "</center></td>";
	echo "<td style='border:1px solid white;'><center>" . $rowDate['DateT'] . "</center></td>";
	
}
	//this is the button we want to reference and push to array, then we clear array
   // echo "<input type='button' id='bob 'value='hello'><tr>";
    
    
    //expression will link the transnumber to all goods purchased
    //want list of goods, price and option to leave comment
    $sql2="SELECT TransactionNumber, ISBN FROM HasTransactionF WHERE TransactionNumber = '$row[1]'";
    $result2 = mysqli_query($con,$sql2);
    echo "<td style='border:1px solid white;'><div style='height:165px;overflow-y:auto;'><ol>";
    while($row2 = mysqli_fetch_array($result2)) {
 $rowTest = "";


	$regIter+=1;
	
	$rIter = 'z';
	$rIterF = $rIter.$regIter; 
		

	//rIterF is the variable id we need to reference




       $sql3="SELECT ISBN, Price, ItemDescription, Category FROM GoodsF WHERE ISBN = '$row2[1]'";
       $result3 = mysqli_query($con,$sql3);
       $row3 = mysqli_fetch_array($result3);
		echo "<li>" . $row3['ItemDescription'] . ", $" . $row3['Price'] . 
		"<form onsubmit='return false'> <textarea placeholder='Leave a Review' id='".$rIterF."' text='hello' rows='3' cols='25' onclick='placeFun(this);'></textarea><br><input type='submit' onclick='reviewF(".$row3['ISBN']. ',' .$rIterF.");' value='Leave Review'></form>". "<ul>";



//this gives all reviews made by the current user for the particular good
// works due to transaction format
$sqlMyJ2 = "select ReviewsF.Comments,ReviewsF.ReviewID,HaveReviewsF.ReviewID,HaveReviewsF.ISBN,GoodsF.ISBN,HasTransactionF.ISBN,HasTransactionF.TransactionNumber,TransactionsF.TransactionNumber, HasUserF.UserName, HasUserF.TransactionNumber,UserAccountsF.UserName,WritesF.UserName,WritesF.ReviewID FROM ReviewsF INNER JOIN ( HaveReviewsF  INNER JOIN (GoodsF  INNER JOIN (HasTransactionF INNER JOIN (TransactionsF INNER JOIN (HasUserF INNER JOIN (UserAccountsF INNER JOIN WritesF ON UserAccountsF.UserName=WritesF.UserName) ON HasUserF.UserName=UserAccountsF.UserName) ON TransactionsF.TransactionNumber=HasUserF.TransactionNumber) ON HasTransactionF.TransactionNumber=TransactionsF.TransactionNumber) ON GoodsF.ISBN=HasTransactionF.ISBN) ON HaveReviewsF.ISBN=GoodsF.ISBN) ON ReviewsF.ReviewID=HaveReviewsF.ReviewID";

$resultJ = mysqli_query($con,$sqlMyJ2);
while($rowJ = mysqli_fetch_array($resultJ)) {
if($rowJ[1]==$rowJ[12] && $rowJ[7]==$row[1] && $rowJ[3]==$row2[1] && ($rowTest!=$row2[1])){
echo "<li>".$rowJ[0]."</li><button name='$rowJ[1]' onclick='delFun(this.name);'>Delete</button>";
$rowTest = $row2[1];
}
}
echo "</ul></li>";
	}
    echo "</ol></div></td>";
    echo "</tr>";
}
echo "</table>";
mysqli_close($con);
?>
</body>
</html>



