#!/bin/bash

num_setups=1

# Generate the bulk charges for AMBER first
./reform_charge_original.pl AAADDD gs gs bnl gs 123 94 2>out


# To Generate charges for bulk systems from a single pair
OLD_PRMTOP_DIR=PRMTOP
NEW_PRMTOP_DIR=PRMTOP.GS
rm -rf $NEW_PRMTOP_DIR
mkdir $NEW_PRMTOP_DIR

for sys in AAADDD; do
    for (( i=1; i<=${num_setups}; i++)); do

        for func in bnl; do

            if [ -L charge ]; then
                unlink charge
            fi

            ln -s charges_amber_${func}_${sys}_gs.txt charge
            #file name too long for sed
            #sed 405,1964d $OLD_PRMTOP_DIR/${sys}_new.prmtop | sed '404r charges_amber_${type}-${func}_CSCSCS.txt' > $NEW_PRMTOP_DIR/${sys}_${type}_${func}.prmtop
            sed 653,3202d $OLD_PRMTOP_DIR/${sys}_${i}_0.prmtop | sed '652r charge' > $NEW_PRMTOP_DIR/${sys}_GS.prmtop
            unlink charge
        done
    done

done

