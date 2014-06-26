package WorldCup::Command::current;
# ABSTRACT: Returns the days matches

use 5.012;
use strict;
use warnings;
use WorldCup -command;
use JSON;
use LWP::UserAgent;
use File::Basename;

sub opt_spec {
    return (    
	[ "outfile|o=s",  "A file to place the current match data information" ],
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
    my $outfile = $opt->{outfile};

    my $result  = _fetch_current_matches($outfile);
}

sub _fetch_current_matches {
    my ($outfile) = @_;

    my $out;
    if ($outfile) {
        open $out, '>', $outfile or die "\nERROR: Could not open file: $!\n";
    }
    else {
        $out = \*STDOUT;
    }

    my $ua = LWP::UserAgent->new;

    my $urlbase = 'http://worldcup.sfg.io/matches/current';
    my $response = $ua->get($urlbase);

    unless ($response->is_success) {
	die "Can't get url $urlbase -- ", $response->status_line;
    }

    my $matches = decode_json($response->content);

    if ( @{$matches} ) {
	for my $match ( @{$matches} ) {
	    if ($match->{home_team}{country}) {
		print $out sprintf "%-14s -- %-12s %-20s\n", 
		      $match->{home_team}{country}, 
		      $match->{away_team}{country},
	              $match->{location};
	    }
	}
    }
    else {
	say "No current matches, try the 'today' command to see if there are matches today.";
    }

    close $out;
}

1;
__END__

=pod

=head1 NAME
                                                                       
 worldcup today - Get the matches scheduled to the current day

=head1 SYNOPSIS    

 worldcup today -o wcmatches_today

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
