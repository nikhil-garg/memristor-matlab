#!/usr/bin/perl

@ARGV == 1 or die "error: input_file\n";

my %index_map;
my %branch_map;
my %G;
my %C;
my %Vsrc;
my $index_num = 1;
my $max_label_num = 1;
my $branch_label = 0;
my $totalR = 0;
my $totalC = 0;
my $totalL = 0;
my $totalI = 0;
my $totalV = 0;

#process inductance with 0 value 

#map 0 to 0 (gnd is 0)

$index_map{"0"} = 0;
open (INP_FILE, $ARGV[0]) or die "cannot open: $!\n";

while (<INP_FILE>) {
    chop;
    if (/^[rR](\S*)\s+(\S*)\s+(\S*)\s+.*/) {
	$index_map{$2} = $index_num ++ if !(exists $index_map{$2});
	$index_map{$3} = $index_num ++ if !(exists $index_map{$3});
	$totalR = $totalR + 1;
    }
    if (/^[cC](\S*)\s+(\S*)\s+(\S*)\s+.*/) {
	$index_map{$2} = $index_num ++ if !(exists $index_map{$2});
	$index_map{$3} = $index_num ++ if !(exists $index_map{$3});
	$totalC = $totalC + 1;
    }
    if (/^[lL](\S*)\s+(\S*)\s+(\S*)\s+.*/) {
        $index_map{$2} = $index_num ++ if !(exists $index_map{$2});
        $index_map{$3} = $index_num ++ if !(exists $index_map{$3});
	$totalL = $totalL + 1;
    }
    if (/^[vV](\S*)\s+(\S*)\s+(\S*)\s+.*/) {
        $index_map{$2} = $index_num ++ if !(exists $index_map{$2});
        $index_map{$3} = $index_num ++ if !(exists $index_map{$3});
	$totalV = $totalV + 1;
    }
    if (/^[iI](\S*)\s+(\S*)\s+(\S*)\s+.*/) {
        $index_map{$2} = $index_num ++ if !(exists $index_map{$2});
        $index_map{$3} = $index_num ++ if !(exists $index_map{$3});
	$totalI = $totalI + 1;
    }

    if ($max_label_num < $index_num - 1)
    {
	$max_label_num = $index_num - 1;
    }
}
close INP_FILE;

#label branch after node
$branch_label = $max_label_num;

open (INP_FILE, $ARGV[0]) or die "cannot open: $!\n";
while (<INP_FILE>) {
    chop;
    if (/^([lL]\S*)\s+(\S*)\s+(\S*)\s+(\d*\.?\d*[eE]?[+-]?\d+)(\S?)(.*)$/) {
	$branch_label = $branch_label + 1;
    }
    if (/^([vV]\S*)\s+(\S*)\s+(\S*)\s+(\d*\.?\d*[eE]?[+-]?\d+)(.*)$/) {
	$branch_label = $branch_label + 1;
    }
}

if ($branch_label > $max_label_num)
{
    $max_label_num = $branch_label;
}

close INP_FILE;

print "$ARGV[0]\t$totalR\t$totalC\t$totalL\t$totalI\t$totalV\t$max_label_num\n";
