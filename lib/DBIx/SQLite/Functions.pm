package DBIx::SQLite::Functions;

use strict;

sub create_functions {
    my $self  = shift;
    my $dbh   = shift;

    my $class = shift;

    my @func = @_;

    if ($class eq 'main') {
	no strict 'refs';
	for (@func) {
	    my $s = eval "sub { return $_ shift }";
	    $dbh->sqlite_create_function($_, -1, sub { return $s->(@_) });
	}
    } else {
    
	eval "require $class; $class->import";
	
	no strict 'refs';
	for (@func) {
	    my $s = *{join '::', $class, $_ };
	    $dbh->sqlite_create_function($_, -1, sub { return $s->(@_) })
	}
    }
}


1;
