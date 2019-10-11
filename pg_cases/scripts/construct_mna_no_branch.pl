#!/usr/bin/perl

@ARGV == 1 or die "error: input_file\n";

my %index_map;
my %branch_map;
my %G;
my %C;
my %Vsrc;
my %outNodes;
my $index_num = 1;
my $num_Isrc = 0;
my $max_label_num = 1;
my $branch_label = 0;
my @nodeArray;
my %scales;


#mapping of scale
$scale{"p"} = 1e-12;
$scale{"f"} = 1e-15;
$scale{"n"} = 1e-9;
$scale{"u"} = 1e-6;
$scale{"ps"} = 1e-12;
$scale{"fs"} = 1e-15;
$scale{"ns"} = 1e-9;
$scale{"us"} = 1e-6;

#map 0 to 0 (gnd is 0)
$index_map{"0"} = 0;

open (INP_FILE, $ARGV[0]) or die "cannot open: $!\n";

while (<INP_FILE>) {
    chop;
    #parse resistance
    if (/^[rR](\S*)\s+(\S*)\s+(\S*)\s+.*/) {
	$index_map{$2} = $index_num ++ if !(exists $index_map{$2});
	$index_map{$3} = $index_num ++ if !(exists $index_map{$3});
    }
    #parse capacitance
    if (/^[cC](\S*)\s+(\S*)\s+(\S*)\s+.*/) {
	$index_map{$2} = $index_num ++ if !(exists $index_map{$2});
	$index_map{$3} = $index_num ++ if !(exists $index_map{$3});
    }
    #parse inductance
    if (/^[lL](\S*)\s+(\S*)\s+(\S*)\s+.*/) {
        $index_map{$2} = $index_num ++ if !(exists $index_map{$2});
        $index_map{$3} = $index_num ++ if !(exists $index_map{$3});
    }
    #parse voltage sources
    if (/^[vV](\S*)\s+(\S*)\s+(\S*)\s+.*/) {
        $index_map{$2} = $index_num ++ if !(exists $index_map{$2});
        $index_map{$3} = $index_num ++ if !(exists $index_map{$3});
    }
    #parse current sources
    if (/^[iI](\S*)\s+(\S*)\s+(\S*)\s+.*/) {
        $index_map{$2} = $index_num ++ if !(exists $index_map{$2});
        $index_map{$3} = $index_num ++ if !(exists $index_map{$3});
	$num_Isrc = $num_Isrc + 1;
    }
    #parse output nodes
    if (/^\.[pP][rR][iI][nN][tT]\s+(\S*)\s+(.*)/) {
	if (lc($1) eq "tran") {
	    $outputline = $2;
	    $first_time = 1;
	    do {
		if ($line =~ /^\+\s*(.*)/ || $first_time == 1) {
		    if ($first_time != 1) {
			$outputline = $1;
		    }
		    $first_time = 0;
		    @nodeArray = split(/\s/, $outputline);
		    foreach $node (@nodeArray) {
			if ($node =~ /v\((.*)\)/) {
			    $index_map{$1} = $index_num ++ if !(exists $index_map{$1});
			    $outNodes{$1} = $index_map{$1};
			} else {
			    print "error: only voltage node is supported\n";
			}
		    }
		} else {
		    seek( INP_FILE, -length($line), 3);
		    next;
		}
	    } while ($line = <INP_FILE>);
	} else {
	    print "error: only support 'tran' in .print\n";
	}
    }
    #parse transistors
    if (/^[mM](\S*)\s+(\S*)\s+(\S*)\s+(\S*)\s+(\S*)\s+(.*)/) {
        $index_map{$2} = $index_num ++ if !(exists $index_map{$2}); #D
        $index_map{$3} = $index_num ++ if !(exists $index_map{$3}); #G
        $index_map{$4} = $index_num ++ if !(exists $index_map{$4}); #S
        $index_map{$5} = $index_num ++ if !(exists $index_map{$5}); #B
    }

    if ($max_label_num < $index_num - 1)
    {
	$max_label_num = $index_num - 1;
    }
}
close INP_FILE;

#label branch after node
$branch_label = $max_label_num;

open (PULSE_CURRENT_FILE, ">PulseIsrc.dat") or die "cannot open: $!\n";
open (PWL_CURRENT_FILE, ">PWLIsrc.dat") or die "cannot open: $!\n";
open (MOS_FILE, ">mos.dat") or die "cannot open: $!\n";
open (INP_FILE, $ARGV[0]) or die "cannot open: $!\n";

#write number of Isrcs
print PWL_CURRENT_FILE "$num_Isrc\n";
while (<INP_FILE>) {
    chop;
    if (/^([rR]\S*)\s+(\S*)\s+(\S*)\s+(\d*\.?\d*[eE]?[+-]?\d+)(\S?)(.*)$/) {
	$x = $index_map{$2};
	$y = $index_map{$3};
	$val = $4;

	if ($x != 0) {
	    $org_val = exists $G{"$x,$x"} ? $G{"$x,$x"} : 0;
	    $G{"$x,$x"} = $org_val + 1/$val; 
	}
	
	if ($y != 0) {
	    $org_val = exists $G{"$y,$y"} ? $G{"$y,$y"} : 0;
	    $G{"$y,$y"} = $org_val + 1/$val; 
	}

	if ($x != 0 && $y != 0) {
	    $org_val = exists $G{"$x,$y"} ? $G{"$x,$y"} : 0;
	    $G{"$x,$y"} = $org_val - 1/$val; 

	    $org_val = exists $G{"$y,$x"} ? $G{"$y,$x"} : 0;
	    $G{"$y,$x"} = $org_val - 1/$val; 
	}
    }
    if (/^([lL]\S*)\s+(\S*)\s+(\S*)\s+(\d*\.?\d*[eE]?[+-]?\d+)(\S?)(.*)$/) {
	$x = $index_map{$2};
	$y = $index_map{$3};
	$val = $4;

	$branch_label = $branch_label + 1;
	$tmp = $branch_label;

	#add incidence value 
	$org_val = exists $C{"$tmp,$tmp"} ? $C{"$tmp,$tmp"} : 0;
	$C{"$tmp,$tmp"} = $org_val + $val;

	if ($x != 0) {
	    $G{"$x,$tmp"} = 1; 
	    $G{"$tmp,$x"} = -1; 
	}

	if ($y != 0) {
	    $G{"$y,$tmp"} = -1;
	    $G{"$tmp,$y"} = 1; 
	}
    }
    if (/^([cC]\S*)\s+(\S*)\s+(\S*)\s+(\d*\.?\d*[eE]?[+-]?\d+)(.*)$/) {
	$x = $index_map{$2};
	$y = $index_map{$3};
	$val = $4;

	if ($x != 0) {
	    $org_val = exists $C{"$x,$x"} ? $C{"$x,$x"} : 0;
	    $C{"$x,$x"} = $org_val + $val; 
	}

	if ($y != 0) {
	    $org_val = exists $C{"$y,$y"} ? $C{"$y,$y"} : 0;
	    $C{"$y,$y"} = $org_val + $val; 
	}

	if ($x != 0 && $y != 0) {
	    $org_val = exists $C{"$x,$y"} ? $C{"$x,$y"} : 0;
	    $C{"$x,$y"} = $org_val - $val; 

	    $org_val = exists $C{"$y,$x"} ? $C{"$y,$x"} : 0;
	    $C{"$y,$x"} = $org_val - $val; 
	}
    }
    if (/^([vV]\S*)\s+(\S*)\s+(\S*)\s+(\d*\.?\d*[eE]?[+-]?\d+)(.*)$/) {
	$x = $index_map{$2};
	$y = $index_map{$3};
	$val = $4;

	$branch_label = $branch_label + 1;
	$tmp = $branch_label;

	#add to voltage sources
	$Vsrc{$tmp} = $val;

	#add incidence value 
	if ($x != 0) {
	    $G{"$x,$tmp"} = 1; 
	    $G{"$tmp,$x"} = -1; 
	}

	if ($y != 0) {
	    $G{"$y,$tmp"} = -1;
	    $G{"$tmp,$y"} = 1; 
	}
    }
    #pulse current source
    if (/^([iI]\S*)\s+(\S*)\s+(\S*)\s+(\d*\.?\d*[eE]?[+-]?\d+)\s+pulse\s*\((.*)\)$/) {
	$x = $index_map{$2};
	$y = $index_map{$3};
	$val = $4;

	$str = $5;
	@idx = split(/,/, $str);
	print PULSE_CURRENT_FILE "$x $y @idx\n";
    }
    #pwl current source
    if (/^([iI]\S*)\s+(\S*)\s+(\S*)\s+[pP][wW][lL]\s*\((.*)\)$/) {
	$x = $index_map{$2};
	$y = $index_map{$3};
	@pairs = split(/\s/, $4);

	print PWL_CURRENT_FILE "$x $y\n";

	for ($i = 0; $i < $#pairs+1; $i = $i + 2) {
	    $time = $pairs[$i];
	    #print "$time\n";
	    if ($time =~ /(\d*\.?\d*[eE]?[+-]?\d+)(\S*)/) {
		if ($2) {
		    $time = $time * $scale{$2};
		}
	    }
	    print PWL_CURRENT_FILE "$time $pairs[$i+1]\n";
	} 
	print PWL_CURRENT_FILE "-1\n";
    }
    #constant current source
    if (/^([iI]\S*)\s+(\S*)\s+(\S*)\s+(\d*\.?\d*[eE]?[+-]?\d+)\s*$/) {
	$x = $index_map{$2};
	$y = $index_map{$3};
	$val = $4;

	print PWL_CURRENT_FILE "$x $y\n";
	print PWL_CURRENT_FILE "0 $val\n";
	print PWL_CURRENT_FILE "-1\n";
    }
    if (/^([mM]\S*)\s+(\S*)\s+(\S*)\s+(\S*)\s+(\S*)\s+(\S*)\s+/) {
	$Dnode = $index_map{$2};
	$Gnode = $index_map{$3};
	$Snode = $index_map{$4};
	$Bnode = $index_map{$5};
	$type = $6;

	#format of mos
	#type D G S B level(unused) W L VTO(unused) lambd(unused) KP(unused)
	if ($type =~ /^[pP].*/) {
	    #-1 denotes pmos
	    print MOS_FILE "-1 $Dnode $Gnode $Snode $Bnode 0 2e-6 100e-9 0 0 0\n";
	} else {
	    #1 denotes nmos
	    print MOS_FILE "1 $Dnode $Gnode $Snode $Bnode 0 2e-6 100e-9 0 0 0\n";
	}
    }
}

if ($branch_label > $max_label_num)
{
    $max_label_num = $branch_label;
}

close PULSE_CURRENT_FILE;
close INP_FILE;

open OUT_FILE, ">spG.dat" or die "cannot open: $!\n";
foreach $str (keys %G) {
    $val = $G{$str};
    @idx = split(/,/,$str);
    print OUT_FILE "$idx[0] $idx[1] $val\n";
}
print OUT_FILE "$max_label_num $max_label_num 0\n";
close OUT_FILE;

open OUT_FILE, ">spC.dat" or die "cannot open: $!\n";
foreach $str (keys %C) {
    $val = $C{$str};
    @idx = split(/,/,$str);
    print OUT_FILE "$idx[0] $idx[1] $val\n";
}
print OUT_FILE "$max_label_num $max_label_num 0\n";
close OUT_FILE;

open OUT_FILE, ">Vsrc.dat" or die "cannot open: $!\n";
foreach $str (keys %Vsrc) {
    $val = $Vsrc{$str};
    print OUT_FILE "$str $val\n";
}
close OUT_FILE;

open OUT_FILE, ">OutputNode.dat" or die "cannot open: $!\n";
foreach $str (keys %outNodes) {
    $val = $outNodes{$str};
    print OUT_FILE "$val\n";
}
close OUT_FILE;

open OUT_FILE, ">node2index.dat" or die "cannot open: $!\n";
foreach $str (keys %index_map) {
    $val = $index_map{$str};
    print OUT_FILE "$str $val\n";
}
close OUT_FILE;


