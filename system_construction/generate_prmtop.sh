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
                                EXcharge $func $ptype $index1 $index2 >out
                            mv charges_amber_${func}_${sys}_${ptype}.txt \
                                charges_amber_${func}_${ptype}_${sys}_${EX}.txt
                            unlink EXcharge

                            if [ -L charge ]; then
                                unlink charge
                            fi

                            ln -s charges_amber_${func}_${ptype}_${sys}_${EX}.txt charge
                            sed 653,3202d $OLD_PRMTOP_DIR/${sys}_GS.prmtop \
                                | sed '652r charge' > PRMTOP.EX/${sys}_${ptype}_${EX}.prmtop
                            unlink charge
			    rm charges_amber_${func}_${ptype}_${sys}_${EX}.txt
                done
        done
    done
done
