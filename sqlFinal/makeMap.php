<!DOCTYPE html>
<html>
<body>

<?php

$con = mysqli_connect("dbdev.cs.uiowa.edu:3306","jlmadden","KNLy3G5B_zUa", "db_jlmadden");
if (!$con) {
    die('Could not connect: ' . mysqli_error($con));
}

mysqli_select_db($con,"ajax_demo");

$sql="SELECT theLat,theLon FROM TransactionsF where theLat != 'NULL'";




$result = mysqli_query($con,$sql);




while($row = mysqli_fetch_array($result)) {
echo $row[0]. ", " .$row[1]. ": ";
}
mysqli_close($con);
?>
</body>
</html>
