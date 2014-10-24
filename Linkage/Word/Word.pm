package Lingua::LinkParser::Linkage::Word;
use strict;

our $VERSION = "1.01";

sub new {
    my $class     = shift;
    my $linkage   = shift;
    my $position  = shift;
    my $i = 0;
    my @links;

    for my $link ($linkage->links) {
        $i++;
        my $label    = $link->label;
        my $linkword = '';
        my $lword = $linkage->get_word($link->lword); 
        my $rword = $linkage->get_word($link->rword);
        if ($linkage->get_word($position) eq $rword) {
            $linkword = $link->lword . ":" . $linkage->get_word($link->lword);
        } elsif ($linkage->get_word($position) eq $lword) {
            $linkword = $link->rword . ":" . $linkage->get_word($link->rword);
        }
        #print "label is $label, lword is $lword, rword is $rword, word is $linkword\n";
        if ($linkword) {
            push @links, Lingua::LinkParser::Linkage::Sublinkage::Link->new (
                $i, $linkage->{index}, $linkage->{linkage}, $label, $linkword );
        }
    }

    bless {
            _text     => $linkage->get_word($position),
            _position => $position,
            _links    => \@links
    }, $class;
}

sub text     { $_[0]->{_text} };
sub position { $_[0]->{_position} };
sub links    { @{$_[0]->{_links}} };

1;

