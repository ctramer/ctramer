#!/bin/bash


for interf in AAADDD; do
	dir=${interf}
	for((run = 0; run < 5; run++)); do
		workdir="${dir}_${run}"
		cd ${workdir}
        cp ../bak/parameter_script.tcl .
        cp ../bak/distance_angle .
        sed -i "s/NAME/${workdir}/g" parameter_script.tcl
		sed -i "s/NAME/${workdir}/g" distance_angle
        sbatch distance_angle
        cd ..
	done
done