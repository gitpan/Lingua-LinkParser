package Lingua::LinkParser::Dictionary;
use strict;

our $VERSION = "1.03";

sub new {
    my $class = shift;
    my %arg = @_;
    return Lingua::LinkParser::dictionary_create($arg{DictFile},$arg{KnowFile},$arg{ConstFile},$arg{AffixFile});
}

sub close {
    my $self = shift;
    $self->DESTROY();
}

sub DESTROY {
    my $self = shift;
    Lingua::LinkParser::dictionary_delete($self);
}

1;

