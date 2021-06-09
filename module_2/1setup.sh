#!/bin/bash 

for interf in AAADDD; do
	dir=${interf}
	echo $dir
	for((run = 0; run < 5; run++)); do
		workdir="${dir}_${run}"
		echo $workdir
		rm -rf ${workdir}
        	mkdir ${workdir}
        	sed "s/NAME/${workdir}/g;s/amber_name/AMBERNAME/g" bak/run_sander > ${workdir}/run_sander
        	cp bak/*.in ${workdir}/
        	cp `pwd`/bak/${dir}_gs.prmtop ${workdir}/prmtop
        	cp `pwd`/bak/${workdir}.inpcrd ${workdir}/init.crd
        	cd ${workdir}
        	sbatch run_sander
        	cd ..
	done
done
