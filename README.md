WorldCup
========

Command line access to latest World Cup results

**INSTALLATION**

Perl version 5.10 (or greater) must be installed to use WorldCup, and there are a couple of external modules required. If you have [cpanminus](https://metacpan.org/pod/App::cpanminus), installation can be done with a single command:

    cpanm git://github.com/sestaton/HMMER2GO.git

Alternatively, download the latest [release](https://github.com/sestaton/WorldCup/releases) and run the following command in the top directory:

    perl Makefile.PL

If any Perl dependencies are listed after running this command, install them through the CPAN shell (or any method you like). Then build and install the package.

    perl Makefile.PL
    make
    make test
    make install

**BRIEF USAGE**


**DOCUMENTATION**

Each subcommand can be executed with no arguments to generate a help menu. Alternatively, you may specify help message explicitly. For example,

    hmmer2go help search

More information about each command is available by accessing the full documentation at the command line. For example,

    worldcup today --man

Also, the [WorldCup wiki](https://github.com/sestaton/WorldCup/wiki) is a source of online documentation.

**ISSUES**

Report any issues at the WorldCup issue tracker: https://github.com/sestaton/WorldCup/issues

**LICENSE AND COPYRIGHT**

Copyright (C) 2014 S. Evan Staton

This program is distributed under the MIT (X11) License, which should be distributed with the package. 
If not, it can be found here: http://www.opensource.org/licenses/mit-license.php