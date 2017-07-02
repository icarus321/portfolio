 <?php
/* Attempt MySQL server connection. Assuming you are running MySQL
server with default setting (user 'root' with no password) */
$dbcnx = mysqli_connect("dbdev.cs.uiowa.edu:3306","jlmadden","KNLy3G5B_zUa", "db_jlmadden");

// Check connection
if (!$dbcnx) {exit();}

// Escape user inputs for security

$uName = mysqli_real_escape_string($dbcnx, $_REQUEST['userName']);
$uPass = mysqli_real_escape_string($dbcnx, $_REQUEST['userPassword']);
$cNum = mysqli_real_escape_string($dbcnx, $_REQUEST['cardNum']);
$cType = mysqli_real_escape_string($dbcnx, $_REQUEST['cardType']);
$cBal = mysqli_real_escape_string($dbcnx, $_REQUEST['cardBalance']);

// attempt insert query execution
$sql_query = "INSERT INTO UserAccounts2 (UserName, Password, CardType, CardNum, Balance) VALUES ('$uName', '$uPass', '$cType','$cNum', '$cBal')";

if(mysqli_query($dbcnx, $sql_query)){
	mysqli_close($dbcnx);
        header("Location: userPage.html?userLogin=$uName&userPass=$uPass");
	exit;

    } 
else{ mysqli_close($dbcnx);header("Location: signUp3.html?attempt=Retry");exit;}

?>


