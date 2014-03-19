package SSS::Context;

use strict;
use warnings;

sub new {
   my ($class, $rule, $parent) = @_;

   bless [$rule, $parent], $class;
}

sub parent { shift->[1] }
sub rule   { shift->[0] }

sub selectors {
   my $self = shift;
   (
      ($self->parent ? ($self->parent->selectors) : ()),
      ($self->rule   ? ($self->rule->selector)   : ()),
   )
}

sub selector { join ' ', shift->selectors }

1;
