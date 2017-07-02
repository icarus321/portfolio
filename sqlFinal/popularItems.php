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
$sql="select ISBN,count(*) from HasTransactionF group by ISBN ORDER BY COUNT(*) DESC";
$result = mysqli_query($con,$sql);

echo "<table>
<tr style='width:100%;'>
<th style='border:1px solid white;width:20%;'>ISBN</th>
<th style='border:1px solid white;width:20%;'>Item Description</th>
<th style='border:1px solid white;width:20%;'>Count</th>
</tr>";
while($row = mysqli_fetch_array($result)) {

	
$sql2="select ItemDescription from GoodsF where ISBN='$row[0]'";
$result2 = mysqli_query($con,$sql2);
 $row2 = mysqli_fetch_array($result2);  
    echo "<td style='border:1px solid white;'>" . $row[0] . "</td>";
    echo "<td style='border:1px solid white;'>" . $row2[0] . "</td>";
    echo "<td style='border:1px solid white;'>" . $row[1] . "</td>";
    
   
    echo "</tr>";
}
echo "</table>";
mysqli_close($con);
?>
</body>
</html>
