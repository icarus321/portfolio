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
$sql="SELECT * FROM UserAccounts2 WHERE UserName = '".$q."'";
$result = mysqli_query($con,$sql);

echo "<table>
<tr>
<th>UserName</th>
<th>Password</th>
<th>Card Type</th>
<th>Card Number</th>
<th>Account Balance</th>
</tr>";
while($row = mysqli_fetch_array($result)) {

	//this is the button we want to reference and push to array, then we clear array
   
    echo "<td>" . $row['UserName'] . "</td>";
    echo "<td>" . $row['Password'] . "</td>";
    echo "<td>" . $row['CardType'] . "</td>";
    echo "<td>" . $row['CardNum'] . "</td>";
    echo "<td>" . $row['Balance'] . "</td>";
   
    echo "</tr>";
}
echo "</table>";
mysqli_close($con);
?>
</body>
</html>
