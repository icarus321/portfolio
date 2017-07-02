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
$sql="SELECT UserName,Password,CardType,CardNum,Balance FROM UserAccountsF WHERE UserName = '".$q."'";
$result = mysqli_query($con,$sql);

echo "<table>
<tr style='width:100%;'>
<th style='border:1px solid white;width:20%;'>UserName</th>
<th style='border:1px solid white;width:20%;'>Password</th>
<th style='border:1px solid white;width:20%;'>Card Type</th>
<th style='border:1px solid white;width:20%;'>Card Number</th>
<th style='border:1px solid white;width:1000px;'>Account Balance</th>
</tr>";
while($row = mysqli_fetch_array($result)) {

	//this is the button we want to reference and push to array, then we clear array
   
    echo "<td style='border:1px solid white;'>" . $row['UserName'] . "</td>";
    echo "<td style='border:1px solid white;'>" . $row['Password'] . "</td>";
    echo "<td style='border:1px solid white;'>" . $row['CardType'] . "</td>";
    echo "<td style='border:1px solid white;'>" . $row['CardNum'] . "</td>";
    echo "<td style='border:1px solid white;'>" . $row['Balance'] . "</td>";
   
    echo "</tr>";
}
echo "</table>";
mysqli_close($con);
?>
</body>
</html>
