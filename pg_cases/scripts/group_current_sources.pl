#!/usr/bin/perl 

my $line;
my @token;
my %ISrcs;
my %Times;
my @all_times;
my $prefix_str = "Isrc_group_";
my $cnt;

#1st pass
$cnt = 0;
$Times{0} = 1;
open (INP_FILE, $ARGV[0]) or die "cannot open: $!\n";
while (<INP_FILE>)
{
    chop;
    $line = $_;
    @token = split(/\s+/, $line);
    $key = "$token[4],$token[5],$token[6],$token[7],$token[8]";

    $tdelay = $token[4];
    $tr = $token[5];
    $PW = $token[6];
    $tf = $token[7];
    $Period = $token[8];

    $Times{$tdelay} = 1;
    $Times{$tdelay+$tr} = 1;
    $Times{$tdelay+$tr+$PW} = 1;
    $Times{$tdelay+$tr+$PW+$tf} = 1;
    $Times{$tdelay+$Period} = 1;
    if (!(exists $ISrcs{$key}))
    {
	$filename = $prefix_str."$cnt".".dat";
	open (my $FHANDLE, ">$filename") or die "cannot open: $!\n";
	$ISrcs{$key} = $FHANDLE;
	$cnt = $cnt + 1;
    }
}
close INP_FILE;

open (CONF_FILE, ">Isrc_config.dat") or die "cannot open: $!\n";
print CONF_FILE "$cnt ";
@all_times = sort keys %Times;
foreach $i (@all_times)
{
    print CONF_FILE "$i ";
}
close CONF_FILE;

#2nd pass
open (INP_FILE, $ARGV[0]) or die "cannot open: $!\n";
while (<INP_FILE>)
{
    chop;

    $line = $_;
    @token = split(/\s+/, $line);
    $key = "$token[4],$token[5],$token[6],$token[7],$token[8]";
    $FHANDLE = $ISrcs{$key};

    print $FHANDLE "$line\n";
}

#close all files
foreach $key (keys %ISrcs)
{
    $FHANDLE = $ISrcs{$key};
    close $FHANDLE;
}
