    package NewLinkage;
    use strict;
    use Lingua::LinkParser::Linkage;
    our @ISA = qw(Lingua::LinkParser::Linkage);

    use overload q("") => "new_as_string";

    sub new_as_string {
        my $linkage = @_;
        my $return = '';
        my $i = 0;
        foreach my $word ($linkage->words) {
            foreach my $link ($word->links) {
                my ($before,$after) = '';
                my ($type, $position, $text)  =
                        split /:/, $link->linkword;
                if ($position < $i) {
                    $before .= "$type:$position:$text ";
                } elsif ($position > $i) {
                    $after.= "$type:$position:$text ";
                }
                $return .= "(" . $before . " \"" . $word->text . "\" " .
                    $after . ")" ;
            }
            $i++;
        }
        $return;
    }

