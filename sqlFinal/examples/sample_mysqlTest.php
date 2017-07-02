<?php
echo("<html><head><title>Sample PHP Script</title></head>\n");

//  hostname, username, password
$dbcnx = mysql_connect("dbdev.cs.uiowa.edu:3306","jlmadden","KNLy3G5B_zUa");
if (!$dbcnx) {
  echo( "<P>Unable to connect to the " .
        "database server at this time.</P>\n" );
  exit();
}
mysql_select_db("db_jlmadden",$dbcnx);
if (! @mysql_select_db("db_jlmadden") ) {
  echo( "<P>Unable to locate the sample " .
        "database at this time.</P>" );
  exit();
}
# do a simple query and print it out
$sql_query="SELECT * FROM UserAccounts";

$result_set = mysql_query($sql_query);
if (!$result_set) {
  echo("<P>Error performing query: " .
       mysql_error() . "</P>");
  exit();
}

echo("<h2>" . $sql_query . "</h2>");
echo("<table><tr><th>Name</th><th>Salary</th><th>dno</th></tr>\n");
while ( $row = mysql_fetch_array($result_set) ) {
  echo("<tr><td>" . $row["UserName"] . "</td>\n" .
       "     <td>" . $row["Password2"] . "</td>\n" .
       "     <td>" . $row["CardNum"] . "</td>\n" .
       "</tr>\n");
}
echo ("</table>\n");
echo ("</body></html>");
?>
