package Lingua::LinkParser::Linkage::Sublinkage::Link;
      use strict;

      our $VERSION = "1.0";

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
          return Lingua::LinkParser::call_linkage_get_link_domain_names($self->{linkage}, $self->{index});
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

