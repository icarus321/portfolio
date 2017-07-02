<!DOCTYPE html>
<html>

<body>

<?php
//$q = intval($_GET['q']);
$q =$_GET['q'];









$con = mysqli_connect("dbdev.cs.uiowa.edu:3306","jlmadden","KNLy3G5B_zUa", "db_jlmadden");
if (!$con) {
    die('Could not connect: ' . mysqli_error($con));
}

mysqli_select_db($con,"ajax_demo");


$sql="DELETE FROM Writes WHERE ReviewWrites = '$q'";
$result = mysqli_query($con,$sql);
$sql2="DELETE FROM HaveReviews WHERE ReviewIdHaveReviews = '$q'";
$result2 = mysqli_query($con,$sql2);
$sql3="DELETE FROM Reviews WHERE ReviewID = '$q'";
$result3 = mysqli_query($con,$sql3);



mysqli_close($con);
?>
</body>
</html>



