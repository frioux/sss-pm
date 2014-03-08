#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use Test::Deep;
use Devel::Dwarn;

$::RD_HINT = 1;
use Parse::RecDescent;
my $grammar = <<'GRAMMAR';
stylesheet: statements EOF

statements: ''
#statements: statement(s /;/)

statement: variableDeclaration

property: identifier ':' value { $return = $item[1]}

variableDeclaration: variable ':' values

values: value(s /\s+/)

value: identifier
value: color
value: number
value: dimension
value: string
value: uri
value: variable


# originally lexer rules
comment: /\/\//
ws     : /\s+/

color     : '#' /[0-9A-Fa-f]{6}/ { $return = [shift @item, join "", @item] }
color     : '#' /[0-9A-Fa-f]{3}/ { $return = [shift @item, join "", @item] }

dimension : number 'px' { $return = [shift @item, join "", @item] }
dimension : number 'em' { $return = [shift @item, join "", @item] }
dimension : number '%'  { $return = [shift @item, join "", @item] }

identifier: name

string    : /"[^"]*?"/
string    : /'[^']*?'/

selector  : partial_selector
selector  : name partial_selector

uri       : 'url(' /[^)]+?/ ')'

variable  : '@' name

# originally lexer macros
number  : /[0-9]+\.[0-9]+/ { $return = $item[1] }
number  : /[0-9]+/ { $return = $item[1] }
name    : /[a-zA-Z][\w-]*/
partial_selector: /(?:\:\:|[.#:])/ name

LBRACE   : '{'
RBRACE   : '}'
PLUS     : '+'
COLON    : ':'
SEMICOLON: ';'
EOF      : /^\Z/

GRAMMAR

ok(my $parser = Parse::RecDescent->new($grammar), 'instantiation');
cmp_deeply($parser->stylesheet('hr { }'), ['hr', []]);

done_testing;
