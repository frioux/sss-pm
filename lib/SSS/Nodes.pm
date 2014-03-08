use strict;
use warnings;

package SSS::Nodes;

package SSS::Nodes::Property {
   sub new {
      my ($class, $name, $values) = @_;

      bless [$name, $values], $class
   }

   sub name   { shift->[0] }
   sub values { shift->[1] }

   sub to_css { $_[0]->name . ': ' . $_[0]->values . ';' }
}

package SSS::Nodes::Rule {
   sub new {
      my ($class, $selector, $props) = @_;

      bless [$selector, $props], $class
   }

   sub selector { shift->[0] }
   sub props    { shift->[1] }

   sub to_css {
      my $prop_css = join ' ', map $_->to_css, @{$_[0]->props};
      $_[0]->selector . " { $prop_css }"
   }
}

package SSS::Nodes::StyleSheet {
   sub new {
      my ($class, $rules) = @_;

      bless $rules, $class
   }

   sub rules { shift }

   sub to_css { join "\n", map $_->to_css, @{shift->rules} }
}

1;
