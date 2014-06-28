package WorldCup::Command::today;
# ABSTRACT: Returns the matches scheduled for the current day

use strict;
use warnings;
use WorldCup -command;
use JSON;
use LWP::UserAgent;
use File::Basename;

sub opt_spec {
    return (    
	[ "outfile|o=s",  "A file to place the match information for the current day" ],
	[ "score|s",      "Provide the current score of the matches, along with progress" ],
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
    my $outfile    = $opt->{outfile};
    my $show_score = $opt->{score};
    my $result     = _fetch_matches_today($outfile, $show_score);
}

sub _fetch_matches_today {
    my ($outfile, $show_score) = @_;

    my $out;
    if ($outfile) {
        open $out, '>', $outfile or die "\nERROR: Could not open file: $!\n";
    }
    else {
        $out = \*STDOUT;
    }

    my $ua = LWP::UserAgent->new;

    my $urlbase = 'http://worldcup.sfg.io/matches/today';
    my $response = $ua->get($urlbase);

    unless ($response->is_success) {
	die "Can't get url $urlbase -- ", $response->status_line;
    }

    my $matches = decode_json($response->content);

    if ( @{$matches} ) {
	for my $match ( @{$matches} ) {
	    my ($year, $day, $month, $time) = ($match->{datetime} =~ /(\d\d\d\d)-(\d\d)-(\d\d)T(\d\d):/);
	    my $timestring = $month."/".$day." ".$time.":00";
	    my $score = $match->{home_team}{goals}.":".$match->{away_team}{goals};
	    $score = $show_score ? $score : "vs.";
	    print $out sprintf "%-14s %-5s %-12s %-20s %-20s\n", 
	            $match->{home_team}{country}, 
                    $score,
                    $match->{away_team}{country},
	            $match->{location}, 
	            $timestring;
	}
    }
    else {
	print "No matches scheduled today.\n";
    }
    close $out;
}

1;
__END__

=pod

=head1 NAME
                                                                       
 worldcup today - Get the matches scheduled for the current day

=head1 SYNOPSIS    

 worldcup today -o wcmatches_today

=head1 DESCRIPTION

 Show the matches scheduled for the current day. By default, the scores are not shown but
 the scores may be optionally shown.                                         

=head1 AUTHOR 

S. Evan Staton, C<< <statonse at gmail.com> >>

=head1 REQUIRED ARGUMENTS

=over 2

=item -o, --outfile

A file to place the World Cup match information

=back

=head1 OPTIONS

=over 2

=item -s, --score

 Show the scores for the matches (Default: False).

=item -h, --help

Print a usage statement. 

=item -m, --man

Print the full documentation.

=back

=cut
