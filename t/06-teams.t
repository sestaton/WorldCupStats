#!/usr/bin/env perl

use 5.012;
use strict;
use warnings FATAL => 'all';
use autodie qw(open);
use IPC::System::Simple qw(system capture);
use Test::More tests => 4;

my @menu  = capture([0..5], "bin/worldcup help teams");
my $file  = "t/wcteams";
my $opts  = 0;
my $grps  = 0;
my $teams = 0;

for my $opt (@menu) {
    next if $opt =~ /^worldcup|^ *$/;
    $opt =~ s/^\s+//;
    my ($option, $desc) = split /\s+/, $opt;
    ++$opts if $option =~ /^-/;
}

is($opts, 1, 'Correct number of options for worldcup teams');

my $result = system([0..5], "bin/worldcup teams -o $file");
    
ok(-e $file, 'Successfully fetched information for World Cup teams');

open my $in, '<', $file;

while (<$in>) {
    chomp;
    next unless /\S/;
    ++$grps if /^Group/;
    ++$teams unless /^Group/;
}

is($grps, 8, 'Correct number of groups in results');
is($teams, 32, 'Correct number of teams in team results');

unlink $file;
done_testing();
