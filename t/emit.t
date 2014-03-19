#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use Test::Deep;
use Devel::Dwarn;

use SSS::Grammar;

$::RD_HINT = 1;
use Parse::RecDescent;
ok(my $parser = Parse::RecDescent->new(SSS::Grammar->as_string), 'instantiation');

is($parser->stylesheet('h1 { } p { }')->to_css,
   "h1 {  }\n" .
   'p {  }',
   'simple compilation'
);

is($parser->stylesheet('h1 {
   p { font-size: 10px }
}')->to_css,
   "h1 {  }\n" .
   'p { font-size: 10px; }',
   'nested rule'
);

my $code = 'h1 { font-size: 10px; padding: 10px 20px }';
is($parser->stylesheet($code)->to_css, $code, 'properties');

done_testing;
