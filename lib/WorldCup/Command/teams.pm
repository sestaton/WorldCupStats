package WorldCup::Command::teams;
# ABSTRACT: Returns the teams in the World Cup.

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
	[ "outfile|o=s",  "A file to place a listing of the teams" ],
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

    my $result  = _fetch_teams($outfile);
}

sub _fetch_teams {
    my ($outfile) = @_;

    my $out;
    if ($outfile) {
        open $out, '>', $outfile or die "\nERROR: Could not open file: $!\n";
    }
    else {
        $out = \*STDOUT;
    }

    my $ua = LWP::UserAgent->new;

    my $urlbase = 'http://worldcup.sfg.io/teams';
    my $response = $ua->get($urlbase);

    unless ($response->is_success) {
	die "Can't get url $urlbase -- ", $response->status_line;
    }

    my $matches = decode_json($response->content);

    my @teamlens;
    my %grouph;
    my %groups_seen;
    my $group_map = { '1' => 'A', '2' => 'B', '3' => 'C', '4' => 'D', 
		      '5' => 'E', '6' => 'F', '7' => 'G', '8' => 'H' };

    for my $group ( sort { $a->{group_id} <=> $b->{group_id} } @{$matches} ) {
	if (exists $group_map->{$group->{group_id}}) {
	    push @{$grouph{$group_map->{$group->{group_id}}}},  join "|", $group->{fifa_code}, $group->{country};
	    push @teamlens, length($group->{country});
	}
	else {
	    $grouph{$group_map->{$group->{group_id}}} =  join "|", $group->{fifa_code}, $group->{country};
	    push @teamlens, length($group->{country});
	}
    }

    my $namelen = max(@teamlens);
    my $len = $namelen + 2;
    for my $groupid (sort keys %grouph) {
	my $header = pack("A$len A*", "Group $groupid", "FIFA Code");
	if ($outfile) {
	    print $out $header, "\n";
	}
	else {
	    print $out colored($header, 'bold underline'), "\n";
	}

	for my $team (@{$grouph{$groupid}}) {
	    my ($code, $country) = split /\|/, $team;
	    print $out pack("A$len A*", $country, $code), "\n";
	}
	print "\n";
    }
    close $out;
}

1;
__END__

=pod

=head1 NAME
                                                                       
 worldcup teams - Get the team name, with 3-letter FIFA code, listed by group

=head1 SYNOPSIS    

 worldcup teams -o wcteams

=head1 DESCRIPTION
                                                                   

=head1 AUTHOR 

S. Evan Staton, C<< <statonse at gmail.com> >>

=head1 REQUIRED ARGUMENTS

=over 2

=item -o, --outfile

A file to place the World Cup team information

=back

=head1 OPTIONS

=over 2

=item -h, --help

Print a usage statement. 

=item -m, --man

Print the full documentation.

=back

=cut
