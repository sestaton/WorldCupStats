#!/usr/bin/env perl

use 5.012;
use strict;
use warnings FATAL => 'all';
use autodie qw(open);
use IPC::System::Simple qw(system capture);
use Test::More tests => 4;

my @menu  = capture([0..5], "bin/worldcup help group_results");
my $file  = "t/wcgroup_results";
my $opts  = 0;
my $grps  = 0;
my $teams = 0;

for my $opt (@menu) {
    next if $opt =~ /^worldcup|^ *$/;
    $opt =~ s/^\s+//;
    my ($option, $desc) = split /\s+/, $opt;
    ++$opts if $option;
}

is($opts, 1, 'Correct number of options for worldcup group_results');

my $result = system([0..5], "bin/worldcup group_results -o $file");
    
ok(-e $file, 'Successfully fetched information for World Cup group resultss');

open my $in, '<', $file;

while (<$in>) {
    chomp;
    next unless /\S/;
    ++$grps if /^Group/;
    ++$teams unless /^Group/;
}

is($grps, 8, 'Correct number of groups in results');
is($teams, 32, 'Correct number of teams in group results');

unlink $file;
done_testing();
