use strict;
use warnings;

package SSS::Nodes;

package SSS::Nodes::Property {
   sub new {
      my ($class, $key, $value) = @_;

      bless [$key, $value], $class
   }
};

package SSS::Nodes::Rule {
   sub new {
      my ($class, $key, $props) = @_;

      bless [$key, $props], $class
   }
};

package SSS::Nodes::StyleSheet {
   sub new {
      my ($class, $rules) = @_;

      bless $rules, $class
   }
};


1;
