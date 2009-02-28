use ExtUtils::MakeMaker;

# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.

WriteMakefile(
    'NAME'         => 	"Lingua::LinkParser",
    'VERSION_FROM' => 	"lib/Lingua/LinkParser.pm",
    'LIBS'	   => 	"-llink-grammar", 
    'OBJECT'       => 	"",
    'DEFINE'	   => 	"-DDICTIONARY_DIR=\\\".\\\"", 
    'INC'	   => 	"-I/usr/local/include/link-grammar/"
);

