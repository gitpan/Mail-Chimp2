#!/usr/bin/env perl
#

use strict;
use 5.010;
use lib 'lib';
use Mail::Chimp2;
use Data::Dump qw/dump/;

my $chimp = Mail::Chimp2->new(
    debug   => 1,
    api_key => 'cad1801c82903598ca1c00802372272c-us1'
);
dump $chimp->lists_batch_subscribe(
    id              => 'f8c74b85d3',
    double_optin    => 'false',
    update_existing => 'true',
    batch           => [ {
            email      => { email => 'lenz@ideegeo.com' },
            merge_vars => { FNAME => 'Lenz', LNAME => 'Gschwendtner', DOMAINS => 'manu.cx,xyz.cx' } } ]);
