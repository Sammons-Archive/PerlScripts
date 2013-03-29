my $filename;
my $found;
my $replaced;

if (@ARGV < 3) {
print("not enough info\n");
print("args =".@ARGV);
print "\nenter filename: ";
$filename = <>;
chomp($filename);
print "enter thing to replace: ";
$found = <>;
chomp($found);
print "enter thing to replace it with: ";
$replaced = <>;
chomp($replaced);
}else {
my $filename = $ARGV[0];
my $found = $ARGV[1];
my $replaced = $ARGV[2];
}
print ("proceeding to replace ".$found." with ".$replaced." in ".$filename."\n");
open FILE, "<" , $filename or die "failed to open file\n";
open FILE2, ">", $filenae."out";

while (<FILE>) {
my $line = <FILE>;
$line =~ s{$found}{$replaced}g;
print FILE2 $line;
}


print "done, press anything to continue\n";
my $end = <>;