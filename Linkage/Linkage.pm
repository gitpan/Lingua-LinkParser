package Lingua::LinkParser::Linkage;
use strict;
use Lingua::LinkParser::Linkage::Sublinkage;
use Lingua::LinkParser::Linkage::Sublinkage::Link;
use overload q("") => "as_string";

  our $VERSION = "1.0";

  sub new {
    my $class = shift;
    my $index = shift;
    my $sent = shift;                                                                  my $opts = shift;                                                                  my $self = {};                                                                     bless $self, $class;
    $self->{linkage} =  Lingua::LinkParser::linkage_create
        ($index-1,$sent,$opts);
    return $self;
  }

  sub as_string {
    my $self = shift;
    Lingua::LinkParser::get_diagram('',$self);
  }

  sub num_sublinkages {
    my $self = shift;
    return Lingua::LinkParser::linkage_get_num_sublinkages($self->{linkage});
  }

  sub sublinkage {
    my $self = shift;
    my $index = shift;
    my $sublinkage = Lingua::LinkParser::Linkage::Sublinkage->new($index,$self->{linkage});
    return $sublinkage;
  }

  sub sublinkages {
    my $self = shift;
    my @sublinkages;
    my $i;
    for $i (0 .. ($self->num_sublinkages - 1)) {
      push(@sublinkages,Lingua::LinkParser::Linkage::Sublinkage->new($i,$self->{linkage}));
    }
    @sublinkages;
  }

  sub compute_union {
    my $self = shift;
    Lingua::LinkParser::linkage_compute_union($self->{linkage});
  } 

  sub num_words {
    my $self = shift;
    return Lingua::LinkParser::linkage_get_num_words($self->{linkage});
  }

  sub get_word {
    my $self = shift;
    my $index = shift;
    return Lingua::LinkParser::linkage_get_word($self->{linkage},$index);
  }

  sub get_words {
    my $self = shift;
    return Lingua::LinkParser::call_linkage_get_words($self->{linkage});
  }

  sub violation_name {
     my $self = shift;
     return Lingua::LinkParser::linkage_get_violation_name($self->{linkage});
  }

  sub close {
      my $self = shift;
      $self->DESTROY();
  }

  sub DESTROY {
      my $self = shift;
      Lingua::LinkParser::linkage_delete($self->{linkage});
      undef $self;
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
      return $link;
  }

 sub links {
        my $self = shift;
        my @links;
        my $i;
        for $i (0 .. ($self->num_links - 1)) {
            push(@links, Lingua::LinkParser::Linkage::Sublinkage::Link->new($i,$self->{index},$self->{linkage}));
        }
        return @links;
  }

  sub get_word {
        my $self = shift;
        my $index = shift;
        Lingua::LinkParser::linkage_set_current_sublinkage($self->{linkage}, $self->{index});
        return Lingua::LinkParser::linkage_get_word($self->{linkage},$index);
  }

  sub num_words {
        my $self = shift;
        return Lingua::LinkParser::linkage_get_num_words($self->{linkage});
  }
1;

