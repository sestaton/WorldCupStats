package WorldCup::Command::group_results;
# ABSTRACT: Returns the final match results for each group.

use strict;
use warnings;
use WorldCup -command;
use JSON;
use LWP::UserAgent;
use File::Basename;
use Term::ANSIColor;
use List::Util qw(max);

sub opt_spec {
    return (    
	[ "outfile|o=s",  "A file to place the group results information" ],
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

    my $result  = _fetch_group_results($outfile);
}

sub _fetch_group_results {
    my ($outfile) = @_;

    my $out;
    if ($outfile) {
        open $out, '>', $outfile or die "\nERROR: Could not open file: $!\n";
    }
    else {
        $out = \*STDOUT;
    }

    my $ua = LWP::UserAgent->new;

    my $urlbase = 'http://worldcup.sfg.io/group_results';
    my $response = $ua->get($urlbase);

    unless ($response->is_success) {
	die "Can't get url $urlbase -- ", $response->status_line;
    }

    my $matches = decode_json($response->content);

    my %groups_seen;
    my $group_map = { '1' => 'A', '2' => 'B', '3' => 'C', '4' => 'D', 
		      '5' => 'E', '6' => 'F', '7' => 'G', '8' => 'H' };

    my @teamlens = map { length($_->{country}) } @{$matches};
    my $len = max(@teamlens) + 2;

    for my $group ( sort { $a->{group_id} <=> $b->{group_id} } @{$matches} ) {
	print $out "\n" unless exists $groups_seen{$group->{group_id}};
	if (exists $group_map->{$group->{group_id}}) {
	    my $group_id = $group_map->{$group->{group_id}};
	    my $header = pack("A$len A*", "Group $group_id", "Wins Losses");
	    if ($outfile) {
		print $out $header, "\n" 
		    unless exists $groups_seen{$group->{group_id}};
	    }
	    else {
		print $out colored($header, 'bold underline'), "\n"
		    unless exists $groups_seen{$group->{group_id}};
	    }

	    print $out pack("A$len A5 A*", $group->{country}, $group->{wins}, $group->{losses}), "\n";
	    $groups_seen{$group->{group_id}}++;
	}
    }
    close $out;
}

1;
__END__

=pod

=head1 NAME
                                                                       
 worldcup group_results - Get the final match results for each group

=head1 SYNOPSIS    

 worldcup group_results -o wcgroup_results

=head1 DESCRIPTION
                                                                   
 Show the group results for all teams, displayed by group. By default the output
 is formatted as a table and the results are colored in the terminal, though if
 printing to a file there is no text formatting applied.

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
