#this program fixes the unix line endings to be windows line endings

#accept the filname as an argument for the program
my $filename;

if (@ARGV < 1)#if no argument given
{
	print("not enough info\n");
#but prompt for the file as input if not given it as an arg
	print("\nplease enter file to fix: ");
	$filename = <>;
	chomp($filename);#remove newline

} else {#if argument given just use it
	$filename = $ARGV[0];
}

#read all lines into an array
print ("proceeding to fix line endings\n");
open FILE, "<" , $filename or die "failed to open file\n";
my @lines = <FILE>;
close FILE;

#delete old file
unlink($filename);

#create new file and print each line back
#perl is nice and as it copies the lines, it automatically uses windows line endings to seperate entries
#this fixes the problem
open FILE, ">", $filename;
foreach $item (@lines) {
print FILE $item;
}

#finished
print "done";
print "\npress any key to finish: ";
my $finished = <>;