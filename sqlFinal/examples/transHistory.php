<!DOCTYPE html>
<html>
<!--<input type='button' id='bob 'value='hello'> -->
<head>
<style>
table {
    width: 100%;
    border-collapse: collapse;
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

echo "<table style='outline:2px solid white;color:white;'>
<tr style='outline:1px solid white;'>
<th style='outline:1px solid white;'><center>Transaction Number</center></th>
<th style='outline:1px solid white;'><center>Total Price</center></th>
<th style='outline:1px solid white;'><center>Delivery Option</center></th>
<th style='outline:1px solid white;'><center>Date</center></th>
<th style='outline:1px solid white;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Goods</th>

</tr>";



//need to select all TransNumbers from HasUser where q = UserNameHasUser
//below expression will give us each transaction number belonging to current user

$sql="SELECT * FROM HasUser WHERE UserNameHasUser = '$q'";
$result = mysqli_query($con,$sql);
//$row = mysqli_fetch_array($result);

 

$regIter = 0;
while($row = mysqli_fetch_array($result)) {
echo "<td style='outline:1px solid white;'><center>" . $row['TransactionNumberHasUser'] . "</center></td>";
//this is for getting the delivery option
$sqlChoice="Select * from Choice where TransactionNumberChoice='$row[1]'";
$resultChoice = mysqli_query($con,$sqlChoice);
$rowChoice = mysqli_fetch_array($resultChoice);

$sqlDate="SELECT * FROM Transactions WHERE TransactionNumber = '$row[1]'";
    $resultDate = mysqli_query($con,$sqlDate);
	while($rowDate = mysqli_fetch_array($resultDate)) {
	echo "<td style='outline:1px solid white;'><center>$" . $rowDate['TotalPrice'] . "</center></td>";
	echo "<td style='outline:1px solid white;'><center>" . $rowChoice[0] . "</center></td>";
	echo "<td style='outline:1px solid white;'><center>" . $rowDate['DateT'] . "</center></td>";
	
}
	//this is the button we want to reference and push to array, then we clear array
   // echo "<input type='button' id='bob 'value='hello'><tr>";
    
    
    //expression will link the transnumber to all goods purchased
    //want list of goods, price and option to leave comment
    $sql2="SELECT * FROM HasTransaction WHERE TransactionNumberHasTransaction = '$row[1]'";
    $result2 = mysqli_query($con,$sql2);
    echo "<td style='outline:1px solid white;'><div style='height:165px;overflow-y:auto;'><ol>";
    while($row2 = mysqli_fetch_array($result2)) {



	$regIter+=1;
	
	$rIter = 'z';
	$rIterF = $rIter.$regIter; 
		

	//rIterF is the variable id we need to reference




       $sql3="SELECT * FROM Goods WHERE ISBN = '$row2[1]'";
       $result3 = mysqli_query($con,$sql3);
       $row3 = mysqli_fetch_array($result3);
		echo "<li>" . $row3['ItemDescription'] . ", $" . $row3['Price'] . 
		"<form onsubmit='return false'> <textarea placeholder='Leave a Review' id='".$rIterF."' text='hello' rows='3' cols='25' onclick='placeFun(this);'></textarea><br><input type='submit' onclick='reviewF(".$row3['ISBN']. ',' .$rIterF.");' value='Leave Review'></form>"	. "

<ul>";



//this gives all reviews made by the current user for the particular good
// works due to transaction format
$sqlMyJ2 = "select Reviews.Comments,Reviews.ReviewID,HaveReviews.ReviewIdHaveReviews,HaveReviews.IsbnHaveReviews,Goods.ISBN,HasTransaction.IsbnHasTransaction,HasTransaction.TransactionNumberHasTransaction,Transactions.TransactionNumber, HasUser.UserNameHasUser, HasUser.TransactionNumberHasUser,UserAccounts2.UserName,Writes.UserNameWrites,Writes.ReviewWrites FROM Reviews INNER JOIN ( HaveReviews  INNER JOIN (Goods  INNER JOIN (HasTransaction INNER JOIN (Transactions INNER JOIN (HasUser INNER JOIN (UserAccounts2 INNER JOIN Writes ON UserAccounts2.UserName=Writes.UserNameWrites) ON HasUser.UserNameHasUser=UserAccounts2.UserName) ON Transactions.TransactionNumber=HasUser.TransactionNumberHasUser) ON HasTransaction.TransactionNumberHasTransaction=Transactions.TransactionNumber) ON Goods.ISBN=HasTransaction.IsbnHasTransaction) ON HaveReviews.IsbnHaveReviews=Goods.ISBN) ON Reviews.ReviewID=HaveReviews.ReviewIdHaveReviews";

$resultJ = mysqli_query($con,$sqlMyJ2);
while($rowJ = mysqli_fetch_array($resultJ)) {
if($rowJ[1]==$rowJ[12] && $rowJ[7]==$row[1] && $rowJ[3]==$row2[1]){
echo "<li>".$rowJ[0]."</li><button value='$rowJ[1]' onclick='delFun(this.value);'>Delete</button>";
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



