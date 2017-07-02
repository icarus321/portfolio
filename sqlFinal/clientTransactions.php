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
//this page should show a table with each client
//client, num transactions, third column
//third column will display each transaction and nested list of goods
$con = mysqli_connect("dbdev.cs.uiowa.edu:3306","jlmadden","KNLy3G5B_zUa", "db_jlmadden");
if (!$con) {
    die('Could not connect: ' . mysqli_error($con));
}

mysqli_select_db($con,"ajax_demo");
//$sql="select UserNameHasUser, count(*) from HasUser Group by UserNameHasUser ORDER by COUNT(*) DESC";
$sql="select UserName, count(*) from HasUserF Group by UserName ORDER by COUNT(*) DESC";
$result = mysqli_query($con,$sql);

echo "<table>
<tr style='width:100%;'>
<th style='border:1px solid white;width:20%;'>Client</th>
<th style='border:1px solid white;width:20%;'>Number of Transactions</th>
<th style='border:1px solid white;width:20%;'>Description</th>
</tr>";
while($row = mysqli_fetch_array($result)) {

	
//hasuser gives the username, transaction number
//hastransaction gives trans num, isbn
//goods gives isbn, description 
    echo "<td style='border:1px solid white;'>" . $row[0] . "</td>";
    echo "<td style='border:1px solid white;'>" . $row[1] . "</td><td style='border:1px solid white;'><div style='height:165px;overflow-y:auto;'><ul>";
//need to select all transactions where username equals row[0]
//then need to select all isbns where transNum1 = transNum2
//then select all item description where isbn equals isbn2
$sqlL1="select TransactionNumber from HasUserF where UserName = '$row[0]'";
$resultL1 = mysqli_query($con,$sqlL1);
while($rowL1 = mysqli_fetch_array($resultL1)) {
echo"<li>Transaction ".$rowL1[0]."<ol>";
$sqlL2="select ISBN from HasTransactionF where TransactionNumber = '$rowL1[0]'";
$resultL2 = mysqli_query($con,$sqlL2);
while($rowL2 = mysqli_fetch_array($resultL2)) {
$sqlL3="select ItemDescription from GoodsF where ISBN = '$rowL2[0]'";
$resultL3 = mysqli_query($con,$sqlL3);
$rowL3 = mysqli_fetch_array($resultL3);
echo "<li>".$rowL3[0]."</li>";
}
echo"</ol></li>";
}
    
    
   
    echo "</ul></div></td></tr>";
}
echo "</table>";
mysqli_close($con);
?>
</body>
</html>
