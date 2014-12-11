#!/usr/bin/perl -w

# AUTHOR: 		Marten Jäger
# VERSION:		0.1
# LAST REVISED: 	November 2013
#
# The Bioinformatics Core at Medical Genetics CharitÃ© Berlin
# http://combio.charite.de
# Copyright (c) 2013 Marten Jäger
# All rights reserved.

use strict;
use warnings;
use Getopt::Std;
use Getopt::Long;

my $HERE = dirname(__FILE__);
my $SUM = "$HERE/summe.awk";

my $infile;
my $help;
my $start=10;
my $step=10;
my $stop;

GetOptions(	'infile|i=s'	=> \$infile,
		'start|s=s'	=> \$start,
		'step|e=s'	=> \$step,
		'stop|t=s'	=> \$stop,
		'help|h'	=> \$help);

if(!$infile){print "[ERROR] missing File. Exit\n";exit;}
if(!$start){print "[INFO] missing start - defaults to $start\n";}
if(!$step){print "[INFO] missing step - defaults to $step\n";}


my $lines = `wc -l $infile | cut -f 1 -d ' '`;	# number of lines in the inputfile
if(!$stop or $stop > $lines){$stop = $lines;}


for(my $i=$start; $i <= $stop; $i+=10){
	my $go = $i+1;
	my $cov = `tail -n +$go $infile | cut -f 5 | $SUM`;
	printf("Fraction with cov. >= %d : %.4f\n",$i,$cov);
}

exit;
my $c10 = 0;
my $c20 = 0;
my $c30 = 0;
my $c40 = 0;
my $c50 = 0;
my $c60 = 0;
my $c70 = 0;
my $c80 = 0;
my $c90 = 0;
my $c100 = 0;
my $c110 = 0;
my $c120 = 0;
my $c130 = 0;
my $c140 = 0;
my $c150 = 0;
my $positions = `wc -l $infile | cut -f 1 -d ' '`;
chomp($positions);
print

my @fields;
open(IN,"<",$infile) || die $!;
while(<IN>){
	@fields = split(/\t/,$_);
	if($fields[5] >= 10){$c10++;}
	if($fields[5] >= 20){$c20++;}
	if($fields[5] >= 30){$c30++;}
	if($fields[5] >= 40){$c40++;}
	if($fields[5] >= 50){$c50++;}
	if($fields[5] >= 60){$c60++;}
	if($fields[5] >= 70){$c70++;}
	if($fields[5] >= 80){$c80++;}
	if($fields[5] >= 90){$c90++;}
	if($fields[5] >= 100){$c100++;}
#	if($fields[5] >= 110){$c110++;}
#	if($fields[5] >= 120){$c120++;}
#	if($fields[5] >= 130){$c130++;}
#	if($fields[5] >= 140){$c140++;}
#	if($fields[5] >= 150){$c150++;}
}
close(IN);

printf("Fraction with cov. >= 10 : %.4f\n",100.0/$positions*$c10);
printf("Fraction with cov. >= 20 : %.4f\n",100.0/$positions*$c20);
printf("Fraction with cov. >= 30 : %.4f\n",100.0/$positions*$c30);
printf("Fraction with cov. >= 40 : %.4f\n",100.0/$positions*$c40);
printf("Fraction with cov. >= 50 : %.4f\n",100.0/$positions*$c50);
printf("Fraction with cov. >= 60 : %.4f\n",100.0/$positions*$c60);
printf("Fraction with cov. >= 70 : %.4f\n",100.0/$positions*$c70);
printf("Fraction with cov. >= 80 : %.4f\n",100.0/$positions*$c80);
printf("Fraction with cov. >= 90 : %.4f\n",100.0/$positions*$c90);
printf("Fraction with cov. >= 100 : %.4f\n",100.0/$positions*$c100);
#printf("Fraction with cov. >= 110 : %.4f\n",100.0/$positions*$c110);
#printf("Fraction with cov. >= 120 : %.4f\n",100.0/$positions*$c120);
#printf("Fraction with cov. >= 130 : %.4f\n",100.0/$positions*$c130);
#printf("Fraction with cov. >= 140 : %.4f\n",100.0/$positions*$c140);
#printf("Fraction with cov. >= 150 : %.4f\n",100.0/$positions*$c150);
