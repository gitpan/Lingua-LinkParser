package Lingua::LinkParser::Dictionary;
use strict;

use vars qw($VERSION);

$VERSION = '1.05';

sub new {
    my $class = shift;
    my %arg = @_;
    $arg{DictFile}  ||= "$Lingua::LinkParser::DATA_DIR/4.0.dict";
    $arg{KnowFile}  ||= "$Lingua::LinkParser::DATA_DIR/4.0.knowledge";
    $arg{ConstFile} ||= "$Lingua::LinkParser::DATA_DIR/4.0.constituent-knowledge";
    $arg{AffixFile} ||= "$Lingua::LinkParser::DATA_DIR/4.0.affix";
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

