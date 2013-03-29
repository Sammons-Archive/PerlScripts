use DBI;
use strict;
use warnings;
use Scalar::Util::Numeric qw(isnum isint isfloat);

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
my $db = DBI->connect("dbi:mysql:$database:$ip",$username,$password) or die("failed to connect\n");
#$db->do("DROP TABLE `actors.csv`");
print ("\nGreat! Now enter a CSV filename to import:");
my $filename = <>;
chomp($filename);
open FILE, "<" , $filename or die("\nfailed to open file.\n");
my $line1 = "";
my $line2 = "";
$. = 0;

do { 
$line1 = $line2;
$line2 = <FILE>;
} until $. == 2;
my $type = "int";
my @row2 = split(",",$line2);
my @row1 = split(",",$line1);
my @entries = @row1;
if (!isint $row2[0] ) {$type = "varchar(45)"}
$db->do("CREATE TABLE `$filename` (`$row1[0]` $type , PRIMARY KEY (`$row1[0]`))");
shift(@row1);
foreach my $item (@row1) {
if (!(chomp($item) eq "last_update")) {
	$db->do("ALTER TABLE `$filename` ADD `$item` varchar(45)");
	print("\nadded column $item");
		}
	}
$db->do("INSERT INTO `$filename` (`$entries[0]`) VALUES ($row2[0])");
for (my $i = 0;$i<@row2;$i++) {
	if (!(chomp($entries[$i]) eq 'last_update')) {
	$db->do("UPDATE "."`$filename`"." SET "."`$entries[$i]`"." = "."'$row2[$i]'"." WHERE "."`$entries[0]`"." = ".$row2[0]);
		}
	}
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

sub prepareDbTable {
my $line = shift;
my $line2 = shift;
my $d = shift;
my $file = shift;
$line =~ s/\s//g;
my @row1 = split(',',$line);
my @row2 = split(',',$line2);
my $rowName = shift(@row1);
my $col1 = shift(@row2);
my $type = "int";
if (!isint($col1)) {
 $type = "varchar(45)";
	}
$d->do("CREATE TABLE `$file`(`$rowName` $type NOT NULL, PRIMARY KEY ('$rowName`))");
foreach my $item (@row1) {
$d->do("ALTER TABLE `$file` ADD $item varchar(45)");
print"loginfunct\n";
return;
	}
}

