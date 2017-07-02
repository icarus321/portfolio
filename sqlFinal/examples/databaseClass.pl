#!/usr/bin/perl -w

use strict;
use LWP::Simple;
use CGI qw(:standard); # import shortcuts
use DBI;

sub bail {             # function to handle errors gracefully
    my $error = "@_";
    print h1("Unexpected Error"), p($error), end_html;
    exit;
}

# Print out necessary headers for the server
print("Content-type: text/html\n\n");
print("<html><head><title>Perl Sqlite Example page</title><head>\n<body>\n");


#connect db
my $dbh = DBI->connect("DBI:SQLite:/webdev/user/jlmadden/examples/data.db") or bail("Failed to connect to database\n");

my $html = get("http://webdev.cs.uiowa.edu/~jlmadden/examples/temp.txt") or bail("Can't get file!\n");
#drop table
my $stmt = "DROP TABLE IF EXISTS name;";
my $sql = $dbh->prepare($stmt);
$sql->execute;

#create table
$stmt = "CREATE TABLE name
  (vid integer NOT NULL,
     FName CHAR(64),
        LName CHAR(64),
	      PRIMARY KEY(vid));";
$sql = $dbh->prepare($stmt);
$sql->execute;

#row for storing data
my @row;
my $id = 0;

while($html =~ /:Person:(.+?):\*Person:/gs){
	my $person = $1;
	my $counter = 0;
	while($person =~ /:(.+?): (.+?) :\*(.+?):/gs){
		$row[$counter++] = $2;
		#$year = $1; $make = $4; $model = $7;
	}
	#insert into database
	$stmt = "INSERT INTO name VALUES ($id,'$row[0]','$row[1]');";
	$sql = $dbh->prepare($stmt);
	$sql->execute;
	$id++;
}


#test see if works
$stmt = "SELECT * FROM name;";
$sql = $dbh->prepare($stmt);
$sql->execute;
while (my @tuple = $sql->fetchrow_array()) {
   print("FName= $tuple[1]  LName= $tuple[2] <br>\n");
}

print("\n<br>");

print("\nJohn's below:<br>\n");
$stmt = "SELECT * FROM name WHERE FName='John';";
$sql = $dbh->prepare($stmt);
$sql->execute;
while (my @tuple = $sql->fetchrow_array()) {
   print("FName= $tuple[1]  LName= $tuple[2] <br>\n");
}

print("\nDoe's below:<br>\n");
$stmt = "SELECT * FROM name WHERE LName='Doe';";
$sql = $dbh->prepare($stmt);
$sql->execute;
while (my @tuple = $sql->fetchrow_array()) {
   print("FName= $tuple[1]  LName= $tuple[2] <br>\n");
}
print("</body></html>\n");
