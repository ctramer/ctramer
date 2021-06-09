#!/bin/bash

m1=$(awk -v var=1 'NR==var {print $1}' ../../../../names.dat)
m2=$(awk -v var=2 'NR==var {print $1}' ../../../../names.dat)
amber_name=$(awk -v var=1 'NR==var {print $2}' ../../../../modules.dat)
num_systems=5

module purge
module load $amber_name

cd ..
cp -r ../../../INPUT/* .

for ((i = 0 ; i < ${num_systems} ; i++)); do
	cp build_layers.packm AAADDD_${i}.packm
	sed -i "s/NUM/${i}/g;s/MOLEC1/$m1/g;s/MOLEC2/$m2/g;" AAADDD_${i}.packm
	../packmol/packmol < AAADDD_${i}.packm
	rm AAADDD_${i}.packm

	cp add_charge.amber add_charge.amber_$i
	sed -i "s/NUM/${i}/g;s/MOLEC1/$m1/g;s/MOLEC2/$m2/g;" add_charge.amber_$i
	tleap -s -f add_charge.amber_$i
	rm add_charge.amber_$i
done
