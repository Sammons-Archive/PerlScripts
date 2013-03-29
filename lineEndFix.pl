my $filename;
if (@ARGV < 1) {
print("not enough info\n");
print("please enter file to fix: ");
$filename = <>;
chomp($filename);
} else {
$filename = $ARGV[0];
}
print ("proceeding to fix line endings\n");
open FILE, "<" , $filename or die "failed to open file\n";
my @lines = <FILE>;
close FILE;
unlink($filename);
open FILE, ">", $filename;
foreach $item (@lines) {
print FILE $item;
}
print "done";
print "\npress any key to finish: ";
my $finished = <>;