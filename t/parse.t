#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use Test::Deep;
use Devel::Dwarn;

use SSS::Grammar;

# $::RD_HINT = $::RD_TRACE = 1;
use Parse::RecDescent;
ok(my $parser = Parse::RecDescent->new(SSS::Grammar->as_string), 'instantiation');

cmp_deeply(
   $parser->stylesheet('h1 { p { } a { } }'),
   ss([
      rule(h1 => [
         rule(p => []),
         rule(a => [])
      ]),
   ]),
   'nested rules',
);

my $sss = <<'SSS';
h1 {
   font-size: 10px;
   p { }
   font-size: 10px;
   a { }
}
SSS
cmp_deeply(
   $parser->stylesheet($sss),
   ss([
      rule(h1 => [
         prop('font-size' => '10px'),
         rule(p => []),
         prop('font-size' => '10px'),
         rule(a => [])
      ]),
   ]),
   'nested rules',
);

cmp_deeply(
   $parser->stylesheet('h1 { foo: 1; bar: #333 } h2 { for: 1 }'),
   ss([
      rule(h1 => [ prop(foo => 1), prop(bar => '#333') ]),
      rule(h2 => [ prop(for => 1) ]),
   ]),
   'rules',
);

cmp_deeply(
   $parser->rules('h1 { foo: 1; bar: #333 } h2 { for: 1 }'),
   [
      rule(h1 => [ prop(foo => 1), prop(bar => '#333') ]),
      rule(h2 => [ prop(for => 1) ]),
   ],
   'rules',
);

cmp_deeply(
   $parser->rule('h1 { foo: 1; bar: #333 }'),
   rule(h1 => [ prop(foo => 1), prop(bar => '#333') ]),
   'complex rule',
);

cmp_deeply(
   $parser->rule('h1 { foo: 1 }'),
   rule(h1 => [ prop(foo => 1) ]),
   'medium rule',
);

cmp_deeply(
   $parser->rule('h1 { }'),
   rule(h1 => []),
   'simple rule',
);

cmp_deeply(
   $parser->declarations('foo: bar; baz: 1'),
   [
      prop(foo => 'bar'),
      prop(baz => 1),
   ],
   'declarations',
);

cmp_deeply(
   $parser->property('foo: bar'),
   prop(foo => 'bar'),
   'property',
);

is($parser->selector('frew'), 'frew', 'simple selector');
is($parser->selector('.frew'), '.frew', 'complex selector');
is($parser->selector('::frew'), '::frew', 'more complex selector');

is($parser->values('1 1 3px #444'), '1 1 3px #444', 'values');

is($parser->value('3px'), '3px', 'px dimension');
is($parser->value('3.1em'), '3.1em', 'em dimesion');
is($parser->value('3.1%'), '3.1%', '% dimension');

is($parser->value('3.1'), '3.1', 'floating point');
is($parser->value('44'), '44', 'integer');
is($parser->value('#444'), '#444', 'short color value');
is($parser->value('#4a4b43'), '#4a4b43', 'long color value');
is($parser->value('frew'), 'frew', 'identifier value');

done_testing;

sub rule { SSS::Nodes::Rule->new(@_) }
sub prop { SSS::Nodes::Property->new(@_) }
sub ss   { SSS::Nodes::StyleSheet->new(@_) }
