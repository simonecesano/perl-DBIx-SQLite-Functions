package DBIx::SQLite::Number::Bytes::Human;

our $package = 'Number::Bytes::Human';

sub import { eval "require $package" }

sub create_functions {
    my $self = shift;
    my $dbh  = shift;

    my @func = @_;
    
    for (@func) {
	my $s = *{$package . '::' . $_ };
	$dbh->sqlite_create_function($_, -1, sub { return $s->(@_) })
    }
}

1
