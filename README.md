WorldCupStats
=============

Command line access to World Cup results

[![Build Status](https://travis-ci.org/sestaton/WorldCupStats.svg?branch=master)](https://travis-ci.org/sestaton/WorldCupStats)

**INSTALLATION**

Perl must be installed to use WorldCupStats, and there are a couple of external modules required. If you have [cpanminus](https://metacpan.org/pod/App::cpanminus), installation can be done with a single command:

    cpanm git://github.com/sestaton/WorldCupStats.git

Alternatively, download the latest [release](https://github.com/sestaton/WorldCupStats/releases) and run the following command in the top directory:

    perl Makefile.PL

If any Perl dependencies are listed after running this command, install them through the CPAN shell (or any method you like). Then build and install the package.

    perl Makefile.PL
    make
    make test
    make install

**BRIEF USAGE**

Get a chronological listing of match result:

    $ worldcup matches

Get the results for each group:

    $ worldcup group_results

Get a listing of all the teams by group. This command displays the 3-letter FIFA code for each country, but not any scores (just showing the first group below):

    $ worldcup teams | head -5
    Group A                 FIFA Code
    Brazil                  BRA
    Croatia                 CRO
    Cameroon                CMR
    Mexico                  MEX

The team codes can be used for getting metadata for each team and match, and an option to return this information will be added in future release.

For any of the above commands, you can add `-o file` to the command the results will be saved to `file` in case you want to do some plotting or analysis with the results. For the `worldcup current` and `worldcup today` commands, the scores maybe optionally printing instead of "vs." by specifying the score option (e.g., `worldcup current --scores`).

**DOCUMENTATION**

Each subcommand can be executed with no arguments to generate a help menu. Alternatively, you may specify help message explicitly. For example,

    worldcup help matches

More information about each command is available by accessing the full documentation at the command line. For example,

    worldcup matches --man

**ISSUES**

Report any issues or feature requests at the WorldCupStats issue tracker: https://github.com/sestaton/WorldCupStats/issues

**ATTRIBUTION**

This project uses the Soccer for Good API: http://softwareforgood.com/soccer-good/

The idea for this project came from a Perl script I saw posted on [reddit](http://www.reddit.com/r/perl/comments/28kt0s/world_cup_results_in_perl/) for getting World Cup match results.

**LICENSE AND COPYRIGHT**

Copyright (C) 2014 S. Evan Staton

This program is distributed under the MIT (X11) License, which should be distributed with the package. 
If not, it can be found here: http://www.opensource.org/licenses/mit-license.php