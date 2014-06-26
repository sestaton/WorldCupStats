#!/usr/bin/env perl

use 5.012;
use strict;
use warnings FATAL => 'all';
use IPC::System::Simple qw(capture);
use Test::More tests => 3;

BEGIN {
    use_ok( 'WorldCup' ) || print "Bail out!\n";
}

diag( "Testing WorldCup $WorldCup::VERSION, Perl $], $^X" );

my $worldcup = "bin/worldcup";
ok(-x $worldcup, 'Can execute worldcup');

my @menu = capture([0..5], "bin/worldcup help");

my $progs = 0;
for my $command (@menu) {
    next if $command =~ /^ *$|^Available/;
    $command =~ s/^\s+//;
    my ($prog, $desc) = split /\:/, $command;
    ++$progs if $prog;
}

is ($progs, 3, 'Correct number of subcommands listed');

done_testing();
