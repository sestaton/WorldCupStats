#!/usr/bin/env perl

use strict;
use warnings FATAL => 'all';
use IPC::System::Simple qw(system capture);
use Test::More tests => 2;

my @menu = capture([0..5], "bin/worldcup help current");
my $file = "t/wccurent";
my $opts = 0;
my $skip = 0;

for my $opt (@menu) {
    next if $opt =~ /^worldcup|^ *$/;
    $opt =~ s/^\s+//;
    my ($option, $desc) = split /\s+/, $opt;
    ++$opts if $option =~ /^-/;
}

is($opts, 1, 'Correct number of options for worldcup current');

SKIP: {
    skip 'skip checking current matches', 1 unless $skip;

    my $result = system([0..5], "bin/worldcup current -o $file");
    
    ok(-e $file, 'Successfully fetched information for World Cup current matches');
}

unlink $file;
done_testing();
