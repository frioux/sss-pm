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

   sub to_css { $_[0]->name . ': ' . $_[0]->values }
}

package SSS::Nodes::Rule {
   use SSS::Context;

   sub new {
      my ($class, $selector, $props) = @_;

      bless [$selector, $props], $class
   }

   sub selector { shift->[0] }
   sub props    { shift->[1] }

   my $_isa = sub { shift->isa('SSS::Nodes::' . shift) };
   sub to_css {
      my ($self, $parent_ctx) = @_;

      my ($ctx, @prop_css, @nested_rule_css) = (SSS::Context->new($self, $parent_ctx));

      for my $decl (@{$self->props}) {
         my $css = $decl->to_css($ctx);

         if ($decl->$_isa('Property')) {
            push @prop_css, $css
         } elsif ($decl->$_isa('Rule')) {
            push @nested_rule_css, $css
         }
      }
      join "\n",
         $ctx->selector . ' { ' . ( join '; ', @prop_css ) . " }",
         @nested_rule_css
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
