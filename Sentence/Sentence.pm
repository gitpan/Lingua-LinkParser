  package Lingua::LinkParser::Sentence;
  
  use strict;
  use Lingua::LinkParser::Linkage;
  use overload '""' => "as_string";

  our $VERSION = "1.0";

  sub new {
      my $class = shift;
      my $text = shift || "";
      my $parser = shift;
      my $self = {};
      bless $self, $class;
      $self->{sent} = Lingua::LinkParser::sentence_create($text,$parser->{dict});
      $self->{opts} = $parser->{opts};
      Lingua::LinkParser::sentence_parse($self->{sent}, $parser->{opts});
      return $self;
  }

  sub as_string {
      my $self = shift;
      my $_linkage = new Lingua::LinkParser::Linkage(1, $self->{sent}, $self->{opts});
      Lingua::LinkParser::get_diagram($_linkage);
  }

  sub null_count {
      my $self = shift;
      return Lingua::LinkParser::sentence_null_count
          ($self->{sent});
  }

  sub num_linkages {
      my $self = shift;
      return Lingua::LinkParser::sentence_num_linkages_found
          ($self->{sent});
  }

  sub num_valid_linkages {
      my $self = shift;
      return Lingua::LinkParser::sentence_num_valid_linkages
          ($self->{sent});
  }

  sub num_linkages_post_processed {
      my $self = shift;
      return Lingua::LinkParser::sentence_num_linkages_post_processed
          ($self->{sent});
  }

  sub num_violations {
      my $self = shift;
      my $i = shift;
      return Lingua::LinkParser::sentence_num_violations
          ($self->{sent},$i);
  }

  sub disjunct_cost {
      my $self = shift;
      my $i = shift;
      return Lingua::LinkParser::sentence_num_linkages_post_processed
          ($self->{sent},$i);
  }

  sub linkage {
      my $self = shift;
      my $index = shift;
      my $_linkage = new Lingua::LinkParser::Linkage($index,$self->{sent},$self->{opts});
      return $_linkage;
  }

  sub linkages {
      my $self = shift;
      my @linkages;
      my $i;
      for $i (1 .. $self->num_linkages) {
          push(@linkages, new Lingua::LinkParser::Linkage($i,$self->{sent},$self->{opts}));
      }
      return @linkages;
  }

  sub get_word {
      my $self = shift;
      my $index = shift;
      return Lingua::LinkParser::sentence_get_word($self->{sent},$index);
  }

  sub get_bigstruct {
      my $self = shift;
      my @bigstruct;
      my $i;
      my $link;
      foreach ($self->linkages) {
          $_->compute_union;
          my $sublinkage = $_->sublinkage($_->num_sublinkages - 1);
          for $i (0 .. ($sublinkage->num_words - 1)) {
              $bigstruct[$i]->{word} = $sublinkage->get_word($i);
          }
          foreach $link ($sublinkage->links) {
              $bigstruct[$link->lword]->{links}->{$link->label} = $link->rword;
              $bigstruct[$link->rword]->{links}->{$link->label} = $link->lword;
          }
      }
      return @bigstruct;
  }

  sub close {
      my $self = shift;
      $self->DESTROY();
  }

  sub DESTROY {
      my $self = shift;
      Lingua::LinkParser::sentence_delete($self->{sent});
      undef $self;
  }

1;

