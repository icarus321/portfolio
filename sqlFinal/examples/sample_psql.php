<?php
echo("<html><head><title>Sample PHP Script</title></head>\n");

$dbcnx = pg_connect("host='dbdev.cs.uiowa.edu' port='5432' dbname='dbdevtest' user='dbdevtest' password='XiuyD=jP'");
if (!$dbcnx) {
  echo( "<P>Unable to connect to the " .
        "database server at this time.</P>\n" );
  exit();
}
# do a simple query and print it out
// Prepare a query for execution
$sql_query="SELECT ename, salary, dno FROM Emp";

$result_set = pg_query($dbcnx, $sql_query);
if (!$result_set) {
  echo("<P>Error performing query: " .
       pg_result_error() . "</P>");
  exit();
}


echo("<h2>" . $sql_query . "</h2>");
echo("<table><tr><th>Name</th><th>Salary</th><th>dno</th></tr>\n");

while ( $row = pg_fetch_array($result_set) ) {
  echo("<tr><td>" . $row["ename"] . "</td>\n" .
       "     <td>" . $row["salary"] . "</td>\n" .
       "     <td>" . $row["dno"] . "</td>\n" .
       "</tr>\n");
}
echo ("</table>\n");
echo ("</body></html>");
?>
