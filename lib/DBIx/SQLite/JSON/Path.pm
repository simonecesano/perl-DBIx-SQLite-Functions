package DBIx::SQLite::JSON::Path;

use strict;

use Data::Dump qw/dump/;
use JSON::Path 'jpath';

sub create_functions {
    my $self = shift;
    my $dbh  = shift;

    my @func = @_;

    $dbh->sqlite_create_function( 'jpath', -1,
				  sub {
				      my ($json, $path, $sep) = @_;
				      my ($r, undef) = jpath($json, $path);
				      if ($sep =~ /sub {.+}/) {
					  my $sep = eval $sep;
					  return $sep->($r);
				      } elsif ($sep) {
					  return $r ? join $sep, @$r : '';
				      } else {
					  return ref $r ? dump $r : $r;
				      }
				  }
				);
}


1
