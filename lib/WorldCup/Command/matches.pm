package WorldCup::Command::matches;
# ABSTRACT: All match data, updated every minute.

use 5.012;
use strict;
use warnings;
use WorldCup -command;
use JSON;
use LWP::UserAgent;
use File::Basename;
use Term::ANSIColor;
use Data::Dump qw(dd);

sub opt_spec {
    return (    
	[ "outfile|o=s",  "A file to place the match data information" ],
	[ "datetime|d",   "Return output sorted by date and time"      ],
    );
}

sub validate_args {
    my ($self, $opt, $args) = @_;

    my $command = __FILE__;
    if ($self->app->global_options->{man}) {
	system([0..5], "perldoc $command");
    }
    else {
	$self->usage_error("Too many arguments.") if @$args;
    }
} 

sub execute {
    my ($self, $opt, $args) = @_;

    exit(0) if $self->app->global_options->{man};
    my $outfile  = $opt->{outfile};
    my $datetime = $opt->{datetime};

    my $result  = _fetch_matches($outfile, $datetime);
}

sub _fetch_matches {
    my ($outfile, $datetime) = @_;

    my $out;
    if ($outfile) {
	open $out, '>', $outfile or die "\nERROR: Could not open file: $!\n";
    }
    else {
	$out = \*STDOUT;
    }

    my $ua = LWP::UserAgent->new;

    my $urlbase = 'http://worldcup.sfg.io/matches';
    my $response = $ua->get($urlbase);

    unless ($response->is_success) {
	die "Can't get url $urlbase -- ", $response->status_line;
    }

    my $matches = decode_json($response->content);

    #dd $matches;

    printf $out "%14s %s %s ", "HOME", "  ", " AWAY";
    print $out "(";
    print $out colored( sprintf("%s ", 'Win'), 'yellow');
    print $out colored( sprintf("%s ", 'Loss'), 'red');
    print $out colored( sprintf("%s", 'Draw'), 'magenta');
    print $out ")\n";

    if ($datetime) {
	#my @sorted_matches = sort {
	    #next unless defined $_->{datetime};
	    #my ($datea, $timea) = ($_->{datetime} =~ /(\d\d\d\d-\d\d-\d\d)T(\d\d):/);
	    #my ($dateb, $timeb) = ($_->{datetime}{$b} =~ /(\d\d\d\d-\d\d-\d\d)T(\d\d):/);
	    #my ($ya, $da, $ma) = split /-/, $datea;
	    #my ($yb, $db, $mb) = split /-/, $dateb;
	    #$ya <=> $yb || $ma <=> $mb || $da <=> $db || $timea <=> $timeb;

	#} @$matches;
	#my @sorted_matches = map  { $_->[0] }
	#                     sort { $a->[1] cmp $b->[1] }
	#                     map  [ $_, join('', ($_->{datetime} =~ /(\d\d\d\d)-(\d\d)-(\d\d)T\d\d:/)[$1, $3, $2])
	#		     ], @$matches;


	#my @sorted = sort { $a->{datetime} cmp $b->{datetime} } 
	#             map  { $_->{datetime} =~ s/T.*// } @$matches; dd @sorted;
	my %timeh;
	for my $match (@$matches) { 
	    my ($year, $month, $day, $time) = $match->{datetime} =~ /(\d\d\d\d)-(\d\d)-(\d\d)T(\d\d:\d\d)/;
	    #$timeh{$day.$time};
	if ( $match->{status} eq "completed" ) {
	    print colored("$month/$day, $time", 'bold underline'), "\n" unless exists $timeh{$month.$day.$time};
	    $timeh{$month.$day.$time} = 1;
	    if ($match->{home_team}{goals} > $match->{away_team}{goals}) {
		print $out colored( sprintf("%14s ", $match->{home_team}{country}), 'yellow');
		printf $out "%d:%d", $match->{home_team}{goals}, $match->{away_team}{goals};
		print $out colored( sprintf(" %s\n", $match->{away_team}{country}), 'red');

	    }
	    elsif ($match->{home_team}{goals} < $match->{away_team}{goals}) {
		print $out colored( sprintf("%14s ", $match->{home_team}{country}), 'red');
                printf $out "%d:%d", $match->{home_team}{goals}, $match->{away_team}{goals};
                print $out colored( sprintf(" %s\n", $match->{away_team}{country}), 'yellow');
            }
	    else {
		print $out colored( sprintf("%14s ", $match->{home_team}{country}), 'magenta');
                printf $out "%d:%d", $match->{home_team}{goals}, $match->{away_team}{goals};
                print $out colored( sprintf(" %s\n", $match->{away_team}{country}), 'magenta');
	    }
	}
    }
    }
    close $out;
}
1;
__END__

=pod

=head1 NAME
                                                                       
 worldcup matches - Get the latest match information, up to the minute

=head1 SYNOPSIS    

 worldcup matches -o wcmatches

=head1 DESCRIPTION
                                                                   

=head1 AUTHOR 

S. Evan Staton, C<< <statonse at gmail.com> >>

=head1 REQUIRED ARGUMENTS

=over 2

=item -o, --outfile

A file to place the World Cup match information

=back

=head1 OPTIONS

=over 2

=item -h, --help

Print a usage statement. 

=item -m, --man

Print the full documentation.

=back

=cut
