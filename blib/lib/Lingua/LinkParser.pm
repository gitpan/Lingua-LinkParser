package Lingua::LinkParser;

require 5.005;
use strict;
use vars qw($VERSION @ISA @EXPORT_OK @EXPORT $DICTFILE $PPFILE);

require Exporter;
require DynaLoader;

@ISA = qw(Exporter DynaLoader);
$VERSION = '0.04';

=head1 NAME

Lingua::LinkParser - Perl module implementing the Link Grammar Parser by Sleator, Temperley and Lafferty at CMU.

=head1 SYNOPSIS

  use Lingua::LinkParser;
 
  my $parser = new Lingua::LinkParser;
  my $sentence = $parser->parse_sentence("This is the turning point.");
  my @linkages = $parser->get_linkages($sentence);
  foreach $linkage (@linkages) {
      print ($parser->get_diagram($linkage));
  }

=head1 DESCRIPTION

To quote the Link Grammar documentation, "the Link Grammar Parser is a syntactic parser of English, based on link grammar, an original theory of English syntax. Given a sentence, the system assigns to it a syntactic structure, which consists of set of labeled links connecting pairs of words."

This module provides acccess to the parser API using Perl objects to easily analyze linkages. The module organizes data returned from the parser API into an object hierarchy consisting of, in order, sentence, linkage, sublinkage, and link. If this is unclear to you, see the several examples in the 'eg/' directory for a jumpstart on using these objects.

The objects within this module should not be confused with the types familiar to users of the Link Parser API. The objects used in this module reorganize the API data in a way more usable and friendly to Perl users, and do not exactly represent the types used in the API.

This documentation must be supplemented with the extensive texts included with the Link Parser and on the Link Parser web site.

=over

=item $parser = new Lingua::LinkParser(DICT_PATH,KNOWLEDGE_PATH)

This returns a new Lingua::LinkParser object, loads the specified dictionary
files, and sets basic configuration. If no dictionary files are specified, the
parser will attempt to open the default files specified in the header files.

=item $parser->opts(OPTION_NAME,OPTION_VALUE)

This sets the parser option OPTION_NAME to the value specified by OPTION_VALUE.
A full list of these options is found at the end of this document, as well as
in the Link Parser distribution documentation.

=item $sentence = $parser->create_sentence(TEXT)

Creates and assigns a sentence object (Lingua::LinkParser::Sentence) using the supplied value. This object is used in subsequent creation and analysis of linkages.

=item $sentence->num_linkages

Returns the number of linkages found for $sentence.

=item $linkage = $sentence->linkage(NUM)

Assigns a linkage object (Lingua::LinkParser::Linkage) for linkage NUM of sentence $sentence.

=item @linkages = $sentence->linkages

Assigns a list of linkage objects for all linkages of $sentence.

=item $linkage->num_sublinkages

Returns the number of sublinkages for linkage $linkage.

=item $sublinkage = $linkage->sublinkage(NUM)

Assigns a sublinkage object (Lingua::LinkParser::Linkage::Sublinkage) for sublinkage NUM of linkage $linkage.

=item @sublinkages = $linkage->sublinkages

Assigns an array of sublinkage objects.

=item $sublinkage->num_links

Returns the number of links for sublinkage $sublinkage.

=item $link = $sublinkage->link(NUM)

Assigns a link object (Lingua::LinkParser::Link) for link NUM of sublinkage
$sublinkage.

=item @links = $sublinkage->links

Assigns an array of link objects.

=item $link->length

Returns the number of words spanned by $link.

=item $link->label

Returns the "intersection" label for $link.

=item $link->llabel

Returns the left label for $link.

=item $link->rlabel

Returns the right label for $link.

=item $link->lword

Returns the number of the left word for $link.

=item $link->rword

Returns the number of the right word for $link.

=item $parser->get_diagram($linkage)

Returns an ASCII pretty-printed diagram of the specified linkage or sublinkage.

=item $parser->get_postscript($linkage)

Returns Postscript code for a diagram of the specified linkage or sublinkage.

=item $parser->get_domains($linkage)

Returns formatted ASCII text showing the links and domains for the specified linkage or sublinkage.

=back


=head1 OTHER FUNCTIONS

A few high-level functions have also been provided.

=over

=item @bigstruct = $sentence->get_bigstruct
 

Assigns a potentially large data structure merging all linkages/sublinkages/links for $sentence. This structure is an array of hashes, with a single array entry for each word in the sentence. This function is only useful for high-level analysis of sentence grammar; most applications should be served by using the below functions.
 
This array has the following structure:

 @bigstruct ( %{ 'word'  => 'WORD',
                'links' => %{
                    'LINKTYPE_LINKAGENUM' => 'TARGETWORDNUM',...
                 },
                }, ...
             }
           , ...);

Where LINKAGENUM is the number of the linkage for $sentence, and LINKTYPE is the link type label. TARGETWORDNUM is the number of the word to which each link connects.
 
get_bigstruct() can be useful in finding, for example, all links for a given word in a given sentence:
 
   $sentence = $parser->create_sentence(
        "Architecture is present in nearly every civilized society.");
   @bigstruct = $sentence->get_bigstruct;
   while (($k,$v) = each %{$bigstruct[6]->{links}} )
        { print "$k => ", $bigstruct[$v]->{word}, "\n"; }
 
This would output:
 
    A => civilized.a
    Jp => in
    Dsu => every.d
 
Signifying that for word "society", links are found of type A (pre-noun adjective) with "civilized" (tagged 'a' for adjective), type Jp (preposition to object) with "in", and type Dsu (noun determiner, singular-mass) with word "every", which is tagged 'd' for determiner.

=back

=head1 LINK PARSER OPTIONS

The following list of options may be set or retrieved with Lingua::LinkParser object with the function:

    $parser->opts(OPTION, [VALUE])

Supplying no VALUE returns the current value for OPTION. Note that not all of the options are implemented by the API, and instead are intended for use by the program.

 verbosity
  The level of detail reported during processing, 0 reports nothing.

 linkage_limit
  The maximum number of linkages to process for a sentence.

 disjunct_cost
  Determines the maximum disjunct cost used during parsing, where the cost of a disjunct is equal to the maximum cost of all of its connectors.

 min_null_count
 max_null_count
  The range of null links to parse.

 null_block
  Sets the block count ratio for null linkages; a value of '4' causes a linkage of 1, 2, 3, or 4 null links to have a null cost of 1.

 short_length
  Limits the number length of links to this value (the number of words a link can span).

 islands_ok
  Allows 'islands' of links (links not connected to the 'wall') when set.

 max_parse_time
  Determines the approximate maximum time permitted for parsing.

 max_memory
  Determines the maximum memory allowed during parsing.

 timer_expired
 memory_exhausted
 resources_exhausted
 reset_resources
  These options tell whether the timer or memory constraints have been exceeded during parsing.

 cost_model_type

 screen_width
  Sets the screen width for pretty-print functions.

 allow_null
  Allow or disallow null links in linkages.

 display_walls
  Toggles the display of linkage "walls".

 all_short_connectors
  If true, then all connectors have length restrictions imposed on them.


=head1 BUGS/TODO

- I suspect the docs are lacking. This is a very-beta release. Please supply me with input as to the accuracy and any bugs or enhancements you may have.

- Add domain functions

=head1 AUTHOR

Daniel Brian, dbrian@clockwork.net

=head1 SEE ALSO

perl(1).
http://www.link.cs.cmu.edu/link/.

=cut

{
  package Lingua::LinkParser::Linkage;
  use strict;

  sub new {
    my $class = shift;
    my $index = shift;
    my $sent = shift;
    my $opts = shift;
    my $self = {};
    bless $self, $class;
    $self->{linkage} =  Lingua::LinkParser::linkage_create
        ($index-1,$sent,$opts);
    return $self;
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

  sub close {
      my $self = shift;
      $self->DESTROY(); 
  }
  
  sub DESTROY {
      my $self = shift;
      Lingua::LinkParser::linkage_delete($self->{linkage});
      undef $self;
  }

  {
    package Lingua::LinkParser::Linkage::Sublinkage;
    use strict;

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

    sub num_links {
        my $self = shift;
        Lingua::LinkParser::linkage_set_current_sublinkage 
            ($self->{linkage},$self->{index}-1);
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

    sub violation_name {
        my $self = shift;
        Lingua::LinkParser::linkage_set_current_sublinkage($self->{linkage}, $self->{index});
        return Lingua::LinkParser::linkage_get_violation_name($self->{linkage});
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

    sub close {
        my $self = shift;
        $self->DESTROY();
    }
 
    sub DESTROY {
        my $self = shift;
        undef $self;
    }

    {
      package Lingua::LinkParser::Linkage::Sublinkage::Link;
      use strict;

      sub new {
          my $class = shift;
          my $index = shift;
          my $subindex = shift;
          my $linkage = shift;
          my $self = {};
          bless $self, $class;
          $self->{index} = $index;
          $self->{subindex} = $subindex;
          $self->{linkage} = $linkage;
          return $self; 
      }

      sub length {
          my $self = shift;
          Lingua::LinkParser::linkage_set_current_sublinkage($self->{linkage}, $self->{subindex});
          return Lingua::LinkParser::linkage_get_link_length($self->{linkage}, $self->{index});
      }

      sub lword {
          my $self = shift;
          Lingua::LinkParser::linkage_set_current_sublinkage($self->{linkage}, $self->{subindex});
          return Lingua::LinkParser::linkage_get_link_lword($self->{linkage}, $self->{index});
      }

      sub rword {
          my $self = shift;
          Lingua::LinkParser::linkage_set_current_sublinkage($self->{linkage}, $self->{subindex});
          return Lingua::LinkParser::linkage_get_link_rword($self->{linkage}, $self->{index});
      }

      sub label {
          my $self = shift;
          Lingua::LinkParser::linkage_set_current_sublinkage($self->{linkage}, $self->{subindex});
          return Lingua::LinkParser::linkage_get_link_label($self->{linkage}, $self->{index});
      }

      sub llabel {
          my $self = shift;
          Lingua::LinkParser::linkage_set_current_sublinkage($self->{linkage}, $self->{subindex});
          return Lingua::LinkParser::linkage_get_link_llabel($self->{linkage}, $self->{index});
      }

      sub rlabel {
          my $self = shift;
          Lingua::LinkParser::linkage_set_current_sublinkage($self->{linkage}, $self->{subindex});
          return Lingua::LinkParser::linkage_get_link_rlabel($self->{linkage}, $self->{index});
      }

      sub num_domains {
          my $self = shift;
          Lingua::LinkParser::linkage_set_current_sublinkage($self->{linkage}, $self->{subindex});
          return Lingua::LinkParser::linkage_get_link_num_domains($self->{linkage}, $self->{index});
      }

      sub domain_names {
          my $self = shift;
          Lingua::LinkParser::linkage_set_current_sublinkage($self->{linkage}, $self->{subindex});
          return Lingua::LinkParser::linkage_get_link_domain_names($self->{linkage}, $self->{index});
      }

      sub close {
          my $self = shift;
          $self->DESTROY();
      }
 
      sub DESTROY {
          my $self = shift;
          undef $self;
      }

    }
  }
}

{
  package Lingua::LinkParser::Sentence;
  use strict;

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
}

sub new {
    my $class = shift;
    my ($dictpath,$pppath) = @_;
    my $self = {};
    bless $self, $class;
    $self->{opts} = parse_options_create();
    $self->{dict} = dictionary_create($dictpath,$pppath);
    return $self;
}
 
sub opts {
    my $self = shift;
    my ($option,$setting) = @_;
    my $return = "";
    if (!defined $option) {
        die "Lingua::LinkParser::opts must be called with an option.";
    }
    if (defined $setting) {
        eval("Lingua::LinkParser::parse_options_set_$option(\$self->{opts},'$setting')");
    } else {
        eval("\$return = Lingua::LinkParser::parse_options_get_$option(\$self->{opts})");
    }
    if ($@) { die $@; }
    $return;
}
 
sub create_sentence {
    my $self = shift;
    my $text = shift;
    my $sentence = new Lingua::LinkParser::Sentence($text,$self);
    return $sentence;
}
 
sub get_diagram {
    my $self = shift;
    my $linkage = shift;
    return linkage_print_diagram($linkage->{linkage});
}
 
sub get_postscript {
    my $self = shift;
    my $linkage = shift;
    return linkage_print_postscript($linkage->{linkage});
}

sub get_domains {
    my $self = shift;
    my $linkage = shift;
    return linkage_print_links_and_domains($linkage->{linkage});
}

sub DESTROY {
    my $self = shift;
    dictionary_delete($self->{dict});
    parse_options_delete($self->{opts});
    $self = {};
}
 
sub close {
    my $self = shift;
    $self->DESTROY();
}                                                                                                              

bootstrap Lingua::LinkParser $VERSION;


1;

