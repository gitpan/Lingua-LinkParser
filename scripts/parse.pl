#!/usr/bin/perl

require "LinkParser.pm";

$parser = new Lingua::LinkParser("/home/garron/softwork/parse/3.0.dict","/home/garron/softwork/parse/3.0.knowledge");

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
      $sublinkage = $linkage->sublinkage($linkage->num_sublinkages - 1);
      print $parser->get_diagram($sublinkage);
  }

}

