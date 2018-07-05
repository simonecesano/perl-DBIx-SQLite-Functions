package DBIx::SQLite::POSIX;

use POSIX;

sub create_functions {
    my $self = shift;
    my $dbh  = shift;

    my @func = @_;

    for (@func) {
	my $s = *{'POSIX::' . $_ };
	$dbh->sqlite_create_function($_, -1, sub { return $s->(@_) })
    }
}

1;
