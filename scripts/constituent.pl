use Lingua::LinkParser;
$parser = new Lingua::LinkParser;

#$parser->opts('disjunct_cost' => 2);
#$parser->opts('linkage_limit' => 101);
#$parser->opts('verbosity' => 1);
$parser->opts('max_null_count' => 3);
$parser->opts('min_null_count' => 1);

$sentence = $parser->create_sentence("We met in New York.");

print "linkages: ", $sentence->num_linkages, "\n";

for $i (1 .. $sentence->num_linkages) {
    print $i, ": ", $parser->print_constituent_tree($sentence->linkage($i),2), "\n";
}

