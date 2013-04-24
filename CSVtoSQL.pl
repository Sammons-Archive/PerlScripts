use DBI;#database interface
use strict;
use warnings;
use Scalar::Util::Numeric qw(isnum isint isfloat);#methods to figure type of data read in from CSV

#get infrmation for connection
print("Welcome to the CSV to SQL importer\nThis program creates a table corresponding to a CSV file in a database\n");
print("\nusername:");
my $username = <>;
chomp($username);#chomp fixes whitespace issues from entries
print("\npassword:");
my $password = <>;
chomp($password);
print("\ndatabase name:");
my $database = <>;
chomp($database);
print("\nip:port (eg: 127.0.0.1:3306):");
my $ip = <>;
chomp($ip);

#begin connecting to the database
my $db = DBI->connect("dbi:mysql:$database:$ip",$username,$password) or die("failed to connect\n");

#request CSV file to read in from user
print ("\nGreat! Now enter a CSV filename to import:");
my $filename = <>;
chomp($filename);

#open file, declare some variables to help out
#note that $. is a built in variable that tells current line number of file
open FILE, "<" , $filename or die("\nfailed to open file.\n");
my $line1 = "";
my $line2 = "";
$. = 0;

#read in the first two rows
do { 
$line1 = $line2;
$line2 = <FILE>;
} until $. == 2;

#parse first two rows the first row to get the name, the second row to figure out the types
my $type = "int";
my @row2 = split(",",$line2);
my @row1 = split(",",$line1);
my @entries = @row1;
if (!isint $row2[0] ) {$type = "varchar(45)"}

#use the 1st column name and the type of the column data(row 2) to generate a table
$db->do("CREATE TABLE `$filename` (`$row1[0]` $type , PRIMARY KEY (`$row1[0]`))");

#pop off the first column name, we used it to make the table 
shift(@row1);

#last_update is built-in so we don't need to add it, add the rest of columns by names previously gotten
foreach my $item (@row1) {
if (!(chomp($item) eq "last_update")) {
	$db->do("ALTER TABLE `$filename` ADD `$item` varchar(45)");
	print("\nadded column $item");
		}
	}

#now add the values of the second row (the first data row)
$db->do("INSERT INTO `$filename` (`$entries[0]`) VALUES ($row2[0])");
for (my $i = 0;$i<@row2;$i++) {
	if (!(chomp($entries[$i]) eq 'last_update')) {
	$db->do("UPDATE "."`$filename`"." SET "."`$entries[$i]`"." = "."'$row2[$i]'"." WHERE "."`$entries[0]`"." = ".$row2[0]);
		}
	}
#now proceed to read the file in line by line, and add the data values to their respective rows
while (<FILE>) {
my $line = $_;
my @values = split(",",$line);
my $valueLength = @values;
my $keyVal = int($values[0]);
$db->do("INSERT INTO `$filename` (`$entries[0]`) VALUES ($keyVal)");
for (my $i = 0;$i<$valueLength;$i++) {
	if (!(chomp($entries[$i]) eq 'last_update')) {
	$db->do("UPDATE "."`$filename`"." SET "."`$entries[$i]`"." = "."'$values[$i]'"." WHERE "."`$entries[0]`"." = ".$keyVal);
		}
	}
}



