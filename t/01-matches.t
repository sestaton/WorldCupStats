#!/usr/bin/env perl

use 5.012;
use strict;
use warnings FATAL => 'all';
use IPC::System::Simple qw(system capture);
use Test::More tests => 2;

my @menu = capture([0..5], "bin/worldcup help matches");
my $file = "t/wcmatches";
my $opts = 0;

for my $opt (@menu) {
    next if $opt =~ /^worldcup|^ *$/;
    $opt =~ s/^\s+//;
    my ($option, $desc) = split /\s+/, $opt;
    ++$opts if $option;
}

is($opts, 2, 'Correct number of options for worldcup matches');

my $result = system([0..5], "bin/worldcup matches -d -o $file");

ok(-e $file, 'Successfully fetched information for World Cup matches');

unlink $file;
done_testing();
