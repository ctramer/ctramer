#!/bin/bash

rm -f charges_amber_*
rm -rf PRMTOP.EX
mkdir PRMTOP.EX

func=bnl

# To Generate charges for bulk systems from a single pair
OLD_PRMTOP_DIR=PRMTOP.GS

dir=`pwd -P`

for sys in AAADDD; do
    for ptype in 1 2 3; do
	index1=$(awk -v var="$ptype" 'NR==var {print $2}' states/configs.dat)
	index2=$(awk -v var="$ptype" 'NR==var {print $3}' states/configs.dat) 

        for round in states; do

                cd ${round}/config_${ptype}
                echo "Working on $round of config $ptype : "
                for EX in $(ls * | cut -f 1 -d "_" ); do

              
                        echo " $EX "

                        cd $dir
                        if [ -L EXcharge ]; then
                            unlink EXcharge
                        fi
                            echo "Calculating ..."

                            ln -s ${round}/config_${ptype}/${EX}_${ptype}.dat EXcharge
                            perl reform_charge.pl $sys gs \
                                EXcharge $func $ptype $index1 $index2 N_ATOMS_MOL1 >out
                            mv charges_amber_${func}_${sys}_${ptype}.txt \
                                charges_amber_${func}_${ptype}_${sys}_${EX}.txt
                            unlink EXcharge

                            if [ -L charge ]; then
                                unlink charge
                            fi

                            ln -s charges_amber_${func}_${ptype}_${sys}_${EX}.txt charge
							#file name too long for sed
							#these commands find the location of the charges in the prmtop file and replace them
							start1=$(awk '/FLAG CHARGE/ {print FNR+1}' $OLD_PRMTOP_DIR/${sys}_${i}_0.prmtop)
							start2=$(awk '/FLAG CHARGE/ {print FNR+2}' $OLD_PRMTOP_DIR/${sys}_${i}_0.prmtop)
							finish=$(awk '/ATOMIC_NUMBER/ {print FNR-1}' $OLD_PRMTOP_DIR/${sys}_${i}_0.prmtop)
                            sed ${start},${finish}d $OLD_PRMTOP_DIR/${sys}_${i}_0.prmtop | sed '${start1}r charge' > $NEW_PRMTOP_DIR/${sys}_GS.prmtop
                            unlink charge
			    rm charges_amber_${func}_${ptype}_${sys}_${EX}.txt
                done
        done
    done
done
