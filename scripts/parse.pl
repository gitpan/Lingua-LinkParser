#!/usr/bin/perl

use Lingua::LinkParser;

$parser = new Lingua::LinkParser;

$parser->opts('disjunct_cost' => 2);
$parser->opts('linkage_limit' => 101);

while (1) {

  print "Enter a sentence: ";
  $text = <STDIN>;
  my $sentence = $parser->create_sentence($text);
  print "linkages found: ", $sentence->num_linkages, "\n";
  for $i (1 .. $sentence->num_linkages) {
      $linkage = $sentence->linkage($i);
      $linkage->compute_union;
      print $parser->get_diagram($linkage);
  }
}

