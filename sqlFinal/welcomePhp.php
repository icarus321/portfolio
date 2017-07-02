<?php

//  username, password
$num1 =$_REQUEST['userLogin'];$num2=$_REQUEST['userPass'];

//database parameters
$dbcnx = mysql_connect("dbdev.cs.uiowa.edu:3306","jlmadden","KNLy3G5B_zUa");

if (!$dbcnx) { exit();}

//database selection
mysql_select_db("db_jlmadden",$dbcnx);
if (! @mysql_select_db("db_jlmadden") ) {exit();}

// select the account from db where username and password are correct
$sql_query="SELECT UserName,Password FROM UserAccountsF WHERE UserName='$num1' AND Password='$num2'";
$result_set2 = mysql_query($sql_query);
//check if the connection failed, if so it exits, may do a header location change hear too
if (!$result_set2) {exit();}

//set the query equal to variable row2
$row2 = mysql_fetch_array($result_set2);
//if condition checks that both the params are true, equal to input
if($row2["UserName"]==$num1 and $row2["Password"]==$num2){
	//checks for admin login
	if($row2["UserName"]=="admin"){
		header("Location: adminPage.html?userLogin=$num1&userPass=$num2");
		exit;}
	//checks for regular client login
	else{
		header("Location: userPage.html?userLogin=$num1&userPass=$num2");
		exit;}
}
//else condition is excuted if username and/or password are incorrect
else{header("Location: welcome.html?attempt=Retry");exit;}

?>
