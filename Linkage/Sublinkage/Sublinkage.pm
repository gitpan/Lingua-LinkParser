package Lingua::LinkParser::Linkage::Sublinkage;
    
    use strict;
    use Lingua::LinkParser::Linkage::Sublinkage::Link;
    use overload '""' => "as_string";

    our $VERSION = "1.0";

    sub new {
        my $class = shift;
        my $index = shift;
        my $linkage = shift;
        my $self = {};
        bless $self, $class;
        $self->{index} = $index;
        $self->{linkage} = $linkage;
        return $self;
    }

    sub as_string {
        my $self = shift;
        Lingua::LinkParser::get_diagram($self->{linkage});
    }

    sub num_links {
        my $self = shift;
        Lingua::LinkParser::linkage_set_current_sublinkage                                     ($self->{linkage},$self->{index}-1);
        return Lingua::LinkParser::linkage_get_num_links($self->{linkage});
    }

    sub link {
        my $self = shift;
        my $index = shift;
        my $link = Lingua::LinkParser::Linkage::Sublinkage::Link->new($index,$self->{index},$self->{linkage});
        return $link;                                                                  }

    sub links {
        my $self = shift;
        my @links;
        my $i;
        for $i (0 .. ($self->num_links - 1)) {
            push(@links, Lingua::LinkParser::Linkage::Sublinkage::Link->new($i,$self->{index},$self->{linkage}));                                                             }
        return @links;
    }
    sub get_word {
        my $self = shift;                                                                  my $index = shift;
        Lingua::LinkParser::linkage_set_current_sublinkage($self->{linkage}, $self->{index});
        return Lingua::LinkParser::linkage_get_word($self->{linkage},$index);
    }

    sub num_words {
        my $self = shift;
        return Lingua::LinkParser::linkage_get_num_words($self->{linkage});
    }

    sub close {
        my $self = shift;
        $self->DESTROY();
    }

    sub DESTROY {
        my $self = shift;
        undef $self;
    }   

1;

