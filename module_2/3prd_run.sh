#!/bin/bash

for interf in AAADDD; do
	dir=${interf}
	for((run = 0; run < 5; run++)); do
		workdir="${dir}_${run}"
		cd ${workdir}
        cp ../bak/prd.in .
        cp ../bak/prd_sander .
        sed -i "s/NAME/${workdir}_new/g" prd_sander
        sbatch prd_sander
        cd ..
	done
done
