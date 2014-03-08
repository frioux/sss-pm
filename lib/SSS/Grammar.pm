package SSS::Grammar;

use strict;
use warnings;

use SSS::Nodes;

sub as_string {
<<'GRAMMAR';

stylesheet: rules eof { SSS::Nodes::StyleSheet->new($item[1]) }

rules: rule(s)

rule: selector '{' properties '}' { SSS::Nodes::Rule->new($item[1], $item[3]) }

selector: identifier | actual_selector

properties: property(s? /;/) ';' { $item[1] }
properties: property(s? /;/)

property: identifier ':' values { SSS::Nodes::Property->new($item[1], $item[3]) }

values: value(s) { join ' ', @{$item[1]} }

value: identifier | color | dimension | number

dimension : number 'px' { $item[1] . 'px' }
dimension : number 'em' { $item[1] . 'em' }
dimension : number '%'  { $item[1] . '%' }

number    : /[0-9]+\.[0-9]+/
number    : /[0-9]+/

color     : /\#[0-9A-Fa-f]{6}/
color     : /\#[0-9A-Fa-f]{3}/

actual_selector: /(\:\:|[.#:])/ identifier { $item[1] . $item[2] }

identifier: /[a-zA-z][\w-]*/

eof       : /^\Z/

GRAMMAR
}

1;
