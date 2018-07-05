use strict;
use warnings;
package DBIx::SQLite::Statistics::Descriptive;
use Statistics::Descriptive;

my $functions = {
		 percentile => 1,
		 median     => 0,
		 harmonic_mean => 0,
		 geometric_mean => 0,
		 skewness => 0,
		 standard_deviation => 0,
		 variance => 0,
		 mean => 0,
		};


sub create_functions {
    my $self = shift;
    my $dbh  = shift;
    my @func = @_;
    for (@func) { $dbh->sqlite_create_aggregate($_, $functions->{$_} + 1, 'DBIx::SQLite::Statistics::Descriptive::' . ucfirst $_) }
}

package DBIx::SQLite::Statistics::Descriptive::Generator;

sub new { 
    my $class = shift;
    my ($function, $parameters) = @_;

    my $h = {
	     accumulator     => [],
	     function        => $function,
	     parameter_count => $parameters,
	     parameters      => undef
	    };
    bless $h, $class;
}

sub step {
    my $self = shift;
    push @{$self->{accumulator}}, shift;
    $self->{parameters} = [ @_[0..($self->{parameter_count} - 1)] ];
}

sub finalize {
    my $self = shift;
    my $stat = Statistics::Descriptive::Full->new();
    $stat->add_data(@{ $self->{accumulator} });
    my $function = $self->{function}; 
    return $stat->$function(@{ $self->{parameters} });
};

my $p =<<P
package DBIx::SQLite::Statistics::Descriptive::%s;
use base 'DBIx::SQLite::Statistics::Descriptive::Generator';
sub new { return shift->SUPER::new('%s', %d) }
P
;


for (keys %$functions) {
     eval sprintf $p, ucfirst $_, $_, $functions->{$_};
}


1;
