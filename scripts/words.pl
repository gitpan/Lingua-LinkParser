use Lingua::LinkParser;

my $parser = new Lingua::LinkParser;

my $sentence = $parser->create_sentence("Moses supposes his toses are roses.");
my $linkage  = $sentence->linkage(1);

my @words = $linkage->words;
foreach my $word (@words) {
    print $word->text, "\n";
    my @links = $word->links;
    foreach my $link (@links) {
        print "  link type ", $link->linklabel, " to word ", $link->linkword, "\n";
    }
} 

my $Moses = '"Moses" ';
my $does_something = 'Ss:\d+:(\w+)\.v';
my $action_by_moses = "$Moses$does_something";

if ($linkage =~ /$action_by_moses/o) {
    print "What does Moses do? He $1.\n";
} 


