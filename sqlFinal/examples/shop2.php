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

if($q == 's'){$sql="SELECT * FROM Goods WHERE Category = 'Sporting Goods' ORDER BY Price";}
if($q == 'e'){$sql="SELECT * FROM Goods WHERE Category = 'Entertainment' ORDER BY Price";}
if($q == 'c'){$sql="SELECT * FROM Goods WHERE Category = 'Clothes' ORDER BY Price";}
$sql2="SELECT * FROM Reviews";$sqlCount="SELECT COUNT(*) FROM Reviews";



$result = mysqli_query($con,$sql);
$result2 = mysqli_query($con,$sql2);

$resultCount = mysqli_query($con,$sql2);
$rowC = mysqli_num_rows($resultCount);
//echo $rowC;
echo "<table id='myTable'>
<tr>
<th style='min-width:50%;'>Item Description</th>
<th>Price</th>
<th>Reviews</th>

</tr>";
$varID = 1;$varID2 = -1;



while($row = mysqli_fetch_array($result)) {
$result3 = mysqli_query($con,$sql2);
$row3 = mysqli_fetch_array($result3);
//while($row2 = mysqli_fetch_array($result2)){
	//this is the button we want to reference and push to array, then we clear array
	//create a while loop to go through and show all comments where good is same 
	//need joins
	//push reviews into div styled to show overflow in the column td
    
    $varName = 'myCheckBox';
    $varIDF = $varName.$varID;
	
    
    echo "<td id='".$varID."'><input id='".$varIDF."' type='button' value='Add Item'style='background-color:grey;border-style:solid;color:white;width:65px;'onclick='buyFun(".$varIDF.");'> " . $row['ItemDescription'] . "</td>";
    echo "<td id='".$varID2."'>" . $row['Price'] . "</td><td><div style='height:100px;overflow-y:scroll'><ol>";

for ($myI=0;$myI<$rowC;$myI++){
if($row3['ISBNR']==$row['ISBN']){
echo "<li>" . $row3['Comments'] . "<br></li>";
}
$row3 = mysqli_fetch_array($result3);
}
    echo "</ol></div></td></tr>";
    $varID+=1;$varID2-=1;
}
echo "</table>";
mysqli_close($con);
?>
</body>
</html>
