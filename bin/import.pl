#!/usr/bin/env perl 
#
## no critic
#
# PODNAME: import.pl
our $VERSION = '0.2'; # VERSION:
# ABSTRACT: simple CSV importer
#
## use critic

use strict;
use 5.010;
use lib 'lib';
use Mail::Chimp2;
use Text::CSV;
use Data::Dump qw/dump/;

#### CONFIG SECTION ###
my $api_key = 'API KEY';
my $list_id = 'LIST ID';
my $sep_char = ';';
#######################


my $file     = shift;
die "Usage: $0 [CSV File]\n" unless $file;

my $csv = Text::CSV->new ( { binary => 1, sep_char => $sep_char } ) 
    or die "Cannot use CSV: ".Text::CSV->error_diag ();

open my $fh, "<:encoding(utf8)", $file or die "Could not open $file: $!";
my $batch;
while ( my $row = $csv->getline( $fh ) ) {
    push(@{$batch}, {
            email      => { email => $row->[0] },
            merge_vars => {
                FNAME   => $row->[1],
                LNAME   => $row->[2],
                DOMAINS => $row->[3],
        }});
}

my $chimp = Mail::Chimp2->new(api_key => $api_key);
my $ok = $chimp->lists_batch_subscribe(
    id              => $list_id,
    double_optin    => 'false',
    update_existing => 'true',
    batch           => $batch);
dump $ok;

__END__

=pod

=head1 NAME

import.pl - simple CSV importer

=head1 VERSION

version 0.2

=head1 AUTHOR

Lenz Gschwendtner <lenz@springtimesoft.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by ideegeo Group Limited.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
