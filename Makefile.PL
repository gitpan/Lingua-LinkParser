use ExtUtils::MakeMaker;

if ($ARGV[0] ne "clean") {
  print "Enter the path to your Link Parser distribution directory: ";
  $LP_DIR = <STDIN>;
  chop($LP_DIR);
}

print "Finding headers and object files ...\n";
chomp(@headers = `ls $LP_DIR/include/*.h`);
chomp(@objects = `ls $LP_DIR/obj/*.o`);

if (scalar(@headers) < 30)  { die "You are missing headers; check your LP package's include/ directory."; }
if (scalar(@objects) < 26)  { die "You are missing object files; check you LP package's obj/ directory."; }

print "Setting data file path in LinkParser.pm ....\n";
print " (if you move this location, change the path entry for global \$DATA_DIR)\n";
link("LinkParser.pm","LinkParser.pm.old");
unlink("LinkParser.pm");
open FILE, "LinkParser.pm.old";
open NEWFILE, ">LinkParser.pm";
while (<FILE>) {
    if (/^\s*our\s*\$DATA_DIR\s*=/) {
        print NEWFILE "our \$DATA_DIR='$LP_DIR\/data'\;\n";
    } else {
        print NEWFILE;
    }
}
close NEWFILE;
close FILE;
unlink("LinkParser.pm.old");


# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.

WriteMakefile(
    'NAME'         => 	"Lingua::LinkParser",
    'VERSION_FROM' => 	"LinkParser.pm",
    'LIBS'	   => 	"", 
    'OBJECT'       => 	"LinkParser.o @objects",
    'DEFINE'	   => 	"", 
    'INC'	   => 	"-L$LP_DIR/obj -I$LP_DIR/include"
);

