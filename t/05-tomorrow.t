#!/usr/bin/env perl

use 5.012;
use strict;
use warnings FATAL => 'all';
use IPC::System::Simple qw(system capture);
use Test::More tests => 2;

my @menu = capture([0..5], "bin/worldcup help tomorrow");
my $file = "t/wctomorrow";
my $opts = 0;
my $skip = 0;

for my $opt (@menu) {
    next if $opt =~ /^worldcup|^ *$/;
    $opt =~ s/^\s+//;
    my ($option, $desc) = split /\s+/, $opt;
    ++$opts if $option;
}

is($opts, 1, 'Correct number of options for worldcup tomorrow');

SKIP: {
    skip 'skip checking matches scheduled for current day', 1 unless $skip;

    my $result = system([0..5], "bin/worldcup tomorrow -o $file");
    ok(-e $file, 'Successfully fetched information for World Cup matches');
}

unlink $file;
done_testing();
