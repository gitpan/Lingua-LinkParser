# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

# Change 1..1 below to 1..last_test_to_print .
# (It may become useful if the test is moved to ./t subdirectory.)

BEGIN { $| = 1; print "1..15\n"; }
END {print "not ok 1\n" unless $loaded;}
use Lingua::LinkParser;
$loaded = 1;
print "ok 1\n";

# Insert your test code below (better if it prints "ok 13"
# (correspondingly "not ok 13") depending on the success of chunk 13
# of the test code):

$parser = new Lingua::LinkParser;
print "ok 2\n";

$parser->opts('disjunct_cost' => 2);
$parser->opts('linkage_limit' => 101);
$parser->opts('verbosity' => 1);
if ($parser->opts('linkage_limit') == 101) {
  print "ok 3\n";
} else {
  print "not ok 3\n";
}


$sentence = $parser->create_sentence("We tried to make the tests exhaustive.");
if (defined $sentence) { print "ok 4\n"; } else
                       { print "not ok 4\n"; }


$num_linkages = $sentence->num_linkages;
if ($num_linkages > 0) { print "ok 5\n"; } else 
                       { print "not ok 5\n"; }

$linkage = $sentence->linkage(1);
if (defined $linkage) { print "ok 6\n"; } else
                      { print "not ok 6\n"; }

$diagram = $parser->get_diagram($linkage);
if ($diagram =~ /we tried\.v to make\.v/) { print "ok 7\n"; } else 
                           { print "not ok 7\n"; }

$num_sublinkages = $linkage->num_sublinkages;
if ($num_sublinkages > 0) { print "ok 8\n"; } else 
                          { print "not ok 8\n"; }

$sublinkage = $linkage->sublinkage(1);
if (defined $sublinkage) { print "ok 9\n"; } else
                         { print "not ok 9\n"; }

$num_links = $sublinkage->num_links;
if ($num_links > 0) { print "ok 10\n"; } else 
                    { print "not ok 10\n"; }

$link = $sublinkage->link(7);

if ($link->num_domains > 0) { print "ok 11\n"; } else 
                            { print "not ok 11\n"; }

@domain_names = $link->domain_names;
if (@domain_names > 0) { print "ok 12\n"; } else 
                       { print "not ok 12\n"; }

if ($parser->print_constituent_tree($linkage,1) =~ 
     /\(S \(NP We\)/ )   { print "ok 13\n"; } else 
                         { print "not ok 13\n"; }

if ($linkage->num_links > 0) { print "ok 14\n"; } else 
                             { print "not ok 14\n"; }

if ($linkage->words > 0) { print "ok 15\n"; } else 
                         { print "not ok 15\n"; }

