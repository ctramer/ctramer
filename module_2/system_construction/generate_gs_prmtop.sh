#!/bin/bash

# Don't need to change this unless different charges for different initial setups
num_setups=1 

# Generate the bulk charges for AMBER first
# Functional and indices 123 94 2 dummied out
./reform_charge_gs.pl AAADDD gs gs bnl gs 123 94 2 N_ATOMS_MOL1>out


# To Generate charges for bulk systems from a single pair
OLD_PRMTOP_DIR=PRMTOP
NEW_PRMTOP_DIR=PRMTOP.GS
rm -rf $NEW_PRMTOP_DIR
mkdir $NEW_PRMTOP_DIR

if [ -L charge ]; then
	unlink charge
fi

ln -s charges_amber_${func}_${sys}_gs.txt charge
#file name too long for sed
#these commands find the location of the charges in the prmtop file and replace them
start1=$(awk '/FLAG CHARGE/ {print FNR+1}' $OLD_PRMTOP_DIR/${sys}_0.prmtop)
start2=$(awk '/FLAG CHARGE/ {print FNR+2}' $OLD_PRMTOP_DIR/${sys}_0.prmtop)
finish=$(awk '/ATOMIC_NUMBER/ {print FNR-1}' $OLD_PRMTOP_DIR/${sys}_0.prmtop)
sed ${start},${finish}d $OLD_PRMTOP_DIR/${sys}_0.prmtop | sed '${start1}r charge' > $NEW_PRMTOP_DIR/${sys}_GS.prmtop
unlink charge

