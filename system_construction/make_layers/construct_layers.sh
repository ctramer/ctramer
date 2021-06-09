#!/bin/bash

module purge
module load AMBER
num_systems=5

for ((i = 0 ; i < ${num_systems} ; i++)); do
	#cp AAADDD.packm AAADDD_${i}.packm
	#sed -i "s/NUM/${i}/g" AAADDD_${i}.packm
	#packmol/packmol < AAADDD_${i}.packm
	#rm AAADDD_${i}.packm

	cp setup.amber.AAADDD setup.amber.AAADDD_$i
	sed -i "s/NUM/${i}/g" setup.amber.AAADDD_$i
	tleap -s -f setup.amber.AAADDD_$i
	rm setup.amber.AAADDD_$i
done
