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


echo "<table style='border:2px solid white;color:white;'>
<tr style='border:1px solid white;'>
<th style='border:1px solid white;'><center>Time Period</center></th>
<th style='border:1px solid white;'><center>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Number of Transactions</center></th>
<th style='border:1px solid white;'><center>Items</center></th>


</tr>";



$sql="SELECT (CASE WHEN TIME(dateT) BETWEEN '00:00:00' AND '08:00:00' THEN 'Early Morning'   WHEN TIME(dateT) BETWEEN '08:00:00' AND '12:00:00' THEN 'Morning'  WHEN TIME(dateT) BETWEEN '12:00:00' AND '17:00:00' THEN 'Afternoon'  WHEN TIME(dateT) BETWEEN '17:00:00' AND '20:00:00' THEN 'Evening' WHEN TIME(dateT) BETWEEN '20:00:00' AND '24:00:00' THEN 'Night'   ELSE 'NA'  END) AS time_period,COUNT(TransactionNumber) as countT  FROM TransactionsF GROUP BY time_period order by FIELD(time_period,'Early Morning','Morning','Afternoon','Evening','Night')";


$result = mysqli_query($con,$sql);

while($row = mysqli_fetch_array($result)) {
echo "<td style='border:1px solid white;'><center>" . $row['time_period'] . "<br>";
if($row['time_period']=='Early Morning'){echo"12AM-8AM";}
if($row['time_period']=='Morning'){echo"8AM-12PM";}
if($row['time_period']=='Afternoon'){echo"12PM-5PM";}
if($row['time_period']=='Evening'){echo"5PM-8PM";}
if($row['time_period']=='Night'){echo"8PM-12AM";}
echo"</center></td>";
echo "<td style='border:1px solid white;'><center>" . $row['countT'] . "</center></td>";
//this is for getting the items for each transaction
$sqlChoice="SELECT (CASE WHEN TIME(dateT) BETWEEN '00:00:00' AND '08:00:00' THEN 'Early Morning'   WHEN TIME(dateT) BETWEEN '08:00:00' AND '12:00:00' THEN 'Morning'  WHEN TIME(dateT) BETWEEN '12:00:00' AND '17:00:00' THEN 'Afternoon'  WHEN TIME(dateT) BETWEEN '17:00:00' AND '20:00:00' THEN 'Evening' WHEN TIME(dateT) BETWEEN '20:00:00' and '24:00:00' THEN 'Night'  ELSE 'NA'  END) AS time_period,  TransactionsF.TransactionNumber,GoodsF.ISBN,GoodsF.ItemDescription  FROM TransactionsF inner join (HasTransactionF INNER JOIN GoodsF ON HasTransactionF.ISBN=GoodsF.ISBN) on TransactionsF.TransactionNumber = HasTransactionF.TransactionNumber";
$resultChoice = mysqli_query($con,$sqlChoice);

echo "<td style='border:1px solid white;overflow:auto'><div style='height:80px;overflow-y:auto;'><center><ul>";
  
	while($rowChoice = mysqli_fetch_array($resultChoice)) {

              if($rowChoice['time_period']==$row['time_period']){
                echo "<li>".$rowChoice['ItemDescription']."</li>";
                   }
             }
echo "</ul></center></div></td>";

	
    echo "</tr>";
}
echo "</table>";
mysqli_close($con);
?>
</body>
</html>



