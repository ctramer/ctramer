#!/usr/bin/perl -w

use strict;
use File::Basename;
use Switch;
#use Push;

my $layer = 3;
my $cpy = 25;
my $screen = 1.0;

my $bulk = '';
my $bulk_charge = '';
my $pair_charge = '';
my $func = '';
my $type = '';
my $mol1 = 0;
my $mol2 = 0;

my @list = ();
my @chargeMOL1_bulk = ();
my @chargeMOL2_bulk = ();
my @chargeMOL1_pair = ();
my @chargeMOL2_pair = ();
my @charge = ();

my $name = basename($0);
if (@ARGV < 8) {die "usage: $name BULK_TYPE BULK_CHARGE PAIR_CHARGE FUNCTIONAL PAIR_TYPE MOL1 MOL2 N_ATOMS_MOL1\n";}
print "hint: edge   69 & 48
      top   123 & 94
      hollow 52 & 33\n";

$bulk = shift @ARGV;
$bulk_charge = shift @ARGV;
$pair_charge = shift @ARGV;
$func = shift @ARGV;
$type = shift @ARGV;
$mol1 = shift @ARGV;
$mol2 = shift @ARGV;
$N_ATOMS_MOL1 = shift @ARGV;

my $out_file = "charges_amber_$func"."_$bulk"."_$type.txt";

#charge for the system
open (INBULKCHARGE,$bulk_charge) or die "cant open charge file $bulk_charge! \n";
open (INPAIRCHARGE,$pair_charge) or die "cant open charge file $pair_charge! \n";
open (OUT, '>',$out_file) or die "cant open $out_file for writing! \n";

# Read in the bulk charges
my $count = 0;
while( <INBULKCHARGE> ){
    # Only count lines start with space followed by numbers
    next if ! m/^\s+\d+/;
    @list = split (' ', $_);
    print $list[0], ' ', $list[1], "\n";
    if ($count < $N_ATOMS_MOL1) {
        push @chargeMOL1_bulk, $list[2];
    }
    else {
        push @chargeMOL2_bulk, $list[2];
    }
    $count++;
}

print "number of atoms in BULK is  ", $count,"\n";


# Read in the pair charges
$count = 0;
while( <INPAIRCHARGE> ){
    # Only count lines start with space followed by numbers
    next if ! m/^\s+\d+/;
    @list = split (' ', $_);
    print $list[0], ' ', $list[1], "\n";
    if ($count < $N_ATOMS_MOL1) {
        push @chargeMOL1_pair, $list[2];
    }
    else {
        push @chargeMOL2_pair, $list[2];
    }
    $count++;
}

print "number of atoms in PAIR is  ", $count,"\n";



# Build the charges for the system
switch ($bulk) {
    my $mol = 0;
    # SKIP for now
    case "AAADDD" {
        for(my $i = 0; $i < $layer; $i++) {
            for(my $j = 0; $j < $cpy; $j++) {
                $mol++;
                if ($mol == $mol1) {
                    push(@charge, @chargeMOL1_pair);
                } else {
                    push(@charge, @chargeMOL1_bulk);
                }
            }
        }

        for(my $i = 0; $i < $layer; $i++) {
            for(my $j = 0; $j < $cpy; $j++) {
                $mol++;
                if ($mol == $mol2) {
                    push(@charge, @chargeMOL2_pair);
                } else {
                    push(@charge, @chargeMOL2_bulk);
                }
            }
        }
    }


    # In this specific case, all molecules are in GS.
    case "ADADAD" {
        for(my $i = 0; $i < $layer; $i++) {
            for(my $j = 0; $j < $cpy; $j++) {
                $mol++;
                if ($mol == $mol1) {
                    push(@charge, @chargeMOL1_pair);
                } else {
                    push(@charge, @chargeMOL1_bulk);
                }
            }
            for(my $j = 0; $j < $cpy; $j++) {
                $mol++;
                if ($mol == $mol2) {
                    push(@charge, @chargeMOL2_pair);
                } else {
                    push(@charge, @chargeMOL2_bulk);
                }
            }
        }
    }
}


foreach my $j (0 .. $#charge) {
    printf(OUT " %+.8le",$charge[$j]*18.2223*$screen);
    #if((($j%5) eq 0 )&&($j!=0)) {printf(OUT "\n");}
    if(($j%5) eq 4 ) {printf(OUT "\n");}
  }
