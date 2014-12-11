#!/usr/bin/perl -w

# AUTHOR:               Marten Jäger
# VERSION:              0.1
# LAST REVISED:         11. March 2014
#
# The Bioinformatics Core at Medical Genetics CharitÃ© Berlin
# http://compbio.charite.de
# Copyright (c) 2014 Marten Jäger
# All rights reserved.


use strict;
use warnings;
use Getopt::Std;
use Getopt::Long;
use File::Spec;

my $version     = 0.1;
my $coverageFile;
my $outputFile;


GetOptions(     'out|o=s'       => \$outputFile,
		'cov|c=s'	=> \$coverageFile,
                'version|v'     => \$showVersion,
                'help|h'        => \$help);

if($showVersion){print "$version\n"; exit;}
if($help){printUsage()}
if(!$outputFile){printUsage()}
#else{$coverageFile = "${outputprefix}_exom.cov"; $outstatistic = "${outputprefix}_exom.sta"}



open(STA,">",$outputFile) || die $!;

getNucleotidesOnTarget();

close(STA);


##
# count Nucleotides on Target (laut BED file)
sub getNucleotidesOnTarget{
        open(COV,"<",$coverageFile) || die $!;
        my @fields;
        my $nuc = 0;
        while(<COV>){
                @fields = split("\t",$_);
                $nuc += $fields[1]*$fields[2];
        }
        close(COV);
        print(STA "Mapped nucleotides on target: $nuc");
}


