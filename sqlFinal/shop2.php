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

if($q == 's'){$sql="SELECT ISBN, Price, ItemDescription, Category FROM GoodsF WHERE Category = 'Sporting Goods' ORDER BY Price";}
if($q == 'e'){$sql="SELECT ISBN, Price, ItemDescription, Category FROM GoodsF WHERE Category = 'Entertainment' ORDER BY Price";}
if($q == 'c'){$sql="SELECT ISBN, Price, ItemDescription, Category FROM GoodsF WHERE Category = 'Clothes' ORDER BY Price";}
$sql2="SELECT ReviewID, Comments, ISBNR FROM ReviewsF";$sqlCount="SELECT COUNT(*) FROM ReviewsF";



$result = mysqli_query($con,$sql);
$result2 = mysqli_query($con,$sql2);

$resultCount = mysqli_query($con,$sql2);
$rowC = mysqli_num_rows($resultCount);
//echo $rowC;
echo "<table id='myTable' style='border:1px solid white;'>
<tr>
<th style='width:300px;border:1px solid white;text-align:center;'>Item Description</th>
<th style='width:100px;border:1px solid white;text-align:center;'>Seller</th>
<th style='border:1px solid white;width:200px;text-align:center;'>Price</th>
<th style='border:1px solid white;width:600px;text-align:center;'>Reviews</th>

</tr>";
$varID = 1;$varID2 = -1;



while($row = mysqli_fetch_array($result)) {
$result3 = mysqli_query($con,$sql2);
$row3 = mysqli_fetch_array($result3);


$sqlSeller="SELECT UserName, ISBN FROM HasSellerF where ISBN = '$row[0]'";
$resultSeller = mysqli_query($con,$sqlSeller);
$rowSeller = mysqli_fetch_array($resultSeller);

$sqlRating="SELECT UserName, Rating FROM SellerF where UserName = '$rowSeller[0]'";
$resultRating = mysqli_query($con,$sqlRating);
$rowRating = mysqli_fetch_array($resultRating);
    
    $varName = 'myCheckBox';
    $varIDF = $varName.$varID;
	
    
    echo "<td id='".$varID."' style='border:1px solid white;'><input id='".$varIDF."' type='button' value='Add Item'style='background-color:grey;border-style:solid;color:white;width:65px;'onclick='buyFun(".$varIDF.");'> " . $row['ItemDescription'] . "</td>";
    echo"<td style='border:1px solid white;'><center>" . $rowSeller[0] . "<br>Rating: ". $rowRating[1]."</center></td>";

    echo "<td id='".$varID2."' style='border:1px solid white;text-align:center'>" . $row['Price'] . "</td><td style='border:1px solid white;'><div style='height:100px;overflow-y:scroll'><ol>";

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
