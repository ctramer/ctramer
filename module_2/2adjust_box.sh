#!/bin/bash 

module purge
module load amber_name

m1=$(awk -v var=1 'NR==var {print $1}' ../names.dat)
m2=$(awk -v var=2 'NR==var {print $1}' ../names.dat)

for interf in AAADDD; do
	for((run = 0; run < 5; run++)); do
		dir=${interf}
		workdir="${dir}_${run}"
		cd ${workdir}
		ambpdb -p prmtop < ${workdir}_npt.rst > ${workdir}_new.pdb
		cp ../adj/* .
		sed "s/SYSTEM/${workdir}_new/g" setup.amber.system > setup.amber.${workdir}_new
		sed "s/MOLEC1/$m1/g;s/MOLEC2/$m2/g" setup.amber.${workdir}_new
		tleap -s -f setup.amber.${workdir}_new
		rm -f setup.amber.${workdir}_new
		cd ..
	done
done
