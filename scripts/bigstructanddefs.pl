use Lingua::LinkParser;
use Lingua::LinkParser::Definitions qw(define);

$parser = new Lingua::LinkParser;

$sentence = $parser->create_sentence(
        "Perl is a great language.");
@bigstruct = $sentence->get_bigstruct;

#$i = 8;
for $i (0 .. scalar(@bigstruct)) {
    print "\nword $i: ", $bigstruct[$i]->{word}, "\n";

    while (($k,$v) = each %{$bigstruct[$i]->{links}} )
       { print " $k => ", $bigstruct[$v]->{word}, " (", define($k,"link"), ")\n"; }

}

