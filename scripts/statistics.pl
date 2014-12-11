#!/usr/bin/perl -w

# AUTHOR:       Marten Jäger
# VERSION:      0.2
# LAST REVISED: 28. July 2014
#
# The Bioinformatics Core at Medical Genetics CharitÃ© Berlin
# http://compbio.charite.de
# Copyright (c) 2014 Marten Jäger
# All rights reserved.
#
# CHANGELOG
# version 0.2
# - removed "_exom" from the output
# version 0.2
# - added extra flag (-d) to remove duplicates in the coverage statistics


use strict;
use warnings;
use Getopt::Std;
use Getopt::Long;
use File::Spec;
use File::Basename;

my $HERE = dirname(__FILE__);

#my $cmdDuplicates = "samtools view -f 0x400 2695.markDup.bam | wc -l";		# the number of duplicate marked reads
#my $cmdNonDuplicates = "samtools view -F 0x400 2695.markDup.bam | wc -l";	# the number of non-duplicate reads (100% mapped)
#my $cmdMappedReads = "samtools view -F 0x4 2695.markDup.bam | wc -l";		# the number of mapped reads

my $BAMSTAT = "java -jar /home/ngsknecht/bin/picard/dist/BamIndexStats.jar QUIET=true";
my $BEDCOV = "/home/ngsknecht/bin/bedtools2/bin/coverageBed -hist";
my $PLOTCOV = "Rscript $HERE/plotCoverage.R";
my $CALCCOV = "perl $HERE/calcCoverageFraction.pl -t 100 -i";
my $SUM = "$HERE/summe.awk";

###
my $version	= 0.3;
my $showVersion;
my $help;
my $bam;
my $outputprefix;
my $bedfile;
my $coverageFile;
my $outstatistic;
my $rmDup;

## Statistics

my $nUnaligned;
my $nAligned;
my $nDuplicates;

GetOptions(	'bam|b=s'	=> \$bam,
		'out|o=s'	=> \$outputprefix,
		'bed|r=s'	=> \$bedfile,
		'rmdup|d'	=> \$rmDup,
		'version|v'	=> \$showVersion,
		'help|h'	=> \$help);

if($showVersion){print "$version\n"; exit;}
if($help){printUsage()}
if(!$bam){printUsage()}
if(!$outputprefix){printUsage()}
else{$coverageFile = "${outputprefix}.cov"; $outstatistic = "${outputprefix}.sta"}
#else{$coverageFile = "${outputprefix}_exom.cov"; $outstatistic = "${outputprefix}_exom.sta"}


### MAIN ###

if(-e $outstatistic){
	print "[WARN] existing statistics file: $outstatistic\n";
}
open(STA,">",$outstatistic) || die $!;
print STA "#$bedfile\n";

calcMapping();
calcDuplicates();
getCoverage();
getNucleotidesOnTarget();
getCoverageFraction();

close(STA);

### FUNCTIONS ###

##
# get the number of mapped and unmapped reads
sub calcMapping{
	my @cmdIdxBam = `$BAMSTAT I=$bam`;
	if(scalar(@cmdIdxBam) < 1){
		print "[ERROR] failed to get the BAM statistics from the file $bam - Exit\n";
		exit -1;
	}

	my @fields;
	foreach (@cmdIdxBam){
		@fields = split(/\s/,$_);
#		print scalar(@fields)."\n";
		if(scalar(@fields) == 2){
			$nUnaligned = $fields[1]."\n";
		}else{
#			print $fields[4]."\n";
			$nAligned += $fields[4];
		}
	}
	printf (STA "reads:\t%d\nreads aligned:\t%d\nreads unaligned:\t%d\n",$nUnaligned+$nAligned,$nAligned,$nUnaligned);
}

##
# get the number of duplicate marked Reads
sub calcDuplicates{
	$nDuplicates = `samtools view -f 0x400 $bam | wc -l`;
	chomp($nDuplicates);
	printf (STA "duplicates:\t%d\nduplication rate:\t%.2f\n",$nDuplicates,100.0/$nAligned*$nDuplicates);
}



##
# calc coverage counts and extract some statistics:
# coverage per exon
# covergae per nucleotide
sub getCoverage{
	## 1. calculate the coverages using Bedtools
	if(-e "$coverageFile"){
		return;
	}
	if($rmDup){
		system("samtools view -uF 0x400 $bam | $BEDCOV -abam - -b $bedfile | grep '^all' > $coverageFile");
	}
	else{
		system("$BEDCOV -abam $bam -b $bedfile | grep '^all' > $coverageFile");
	}
	## plot
#	system("$PLOTCOV $coverageFile ${outputprefix}_exom.pdf");
	system("$PLOTCOV $coverageFile ${outputprefix}.pdf");

}

##
# calc the percent of covered Fraction
sub getCoverageFraction{
#	system("$CALCCOV $coverageFile");
	my $start=10;
	my $step=10;
	my $stop= 100;
	my $lines = `wc -l $coverageFile | cut -f 1 -d ' '`;	# number of lines in the inputfile
	if(!$stop or $stop > $lines){$stop = $lines;}


	for(my $i=$start; $i <= $stop; $i+=10){
		my $go = $i+1;
		my $cov = `tail -n +$go $coverageFile | cut -f 5 | $SUM`;
		printf(STA "Fraction with cov. >= %d :\t%.4f\n",$i,$cov);
	}


}

##
# count Necleotides on Target (laut BED file)
sub getNucleotidesOnTarget{
	open(COV,"<",$coverageFile) || die $!;
	my @fields;
	my $nuc = 0;
	while(<COV>){
		@fields = split("\t",$_);
		$nuc += $fields[1]*$fields[2];
	}
	close(COV);
	print(STA "Mapped nucleotides on target:\t$nuc\n");
}

# Just print the help
sub printUsage{
	print while(<DATA>);
	exit;
}

### USAGE ###

__DATA__

	statistics.pl

SYNOPSIS

	perl statistics.pl -b bamfile -o outputfolder

	perl statistics.pl [-r bedfile] -b bamfile -o outputfolder

DESCRIPTION

	This will calculate some statistics for the given BAM file.

	The options for the program is as follows:

	-h --help	Print this help file and exit

	-v --version    Print the version of the program and exit

	-b --bam	The path to the BAM file

	-o --out	output prefix

	-r --bed	Path top the BED file for coverage analysis

