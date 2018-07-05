# perl-DBIx-SQLite-Functions

This module allows for fast creation of functions in DBI with an SQLite backend.

## usage

    use DBI;
    use Data::Dump qw/dump/;
    
    use DBIx::SQLite::Statistics::Descriptive;
    use DBIx::SQLite::POSIX;
    use DBIx::SQLite::Number::Bytes::Human;
    
    $dsn = "dbi:SQLite:dbname=data.db";
    
    my $dbh = DBI->connect($dsn);
    
    
    DBIx::SQLite::Statistics::Descriptive->create_functions($dbh, qw/median percentile/);
    DBIx::SQLite::POSIX->create_functions($dbh, qw/floor ceil/);
    DBIx::SQLite::Number::Bytes::Human->create_functions($dbh, qw/format_bytes parse_bytes/);

    # or - if the package hasn't been provided

    DBIx::SQLite::Functions->create_functions($dbh, 'Digest::MD5', qw/md5_hex/);
