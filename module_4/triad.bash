for func in bnl srsh; do
	for geom in bent linear; do
		cp qc_run qc_run_${func}_${geom}
		sed -i "s/GEOM/$geom/g" qc_run_${func}_${geom}
		sed -i "s/FUNCTIONAL/$func/g" qc_run_${func}_${geom}
		cp GEOM_${func}.in ${geom}_${func}.in
		sed -i "s/GEOM/$geom/g" ${geom}_${func}.in
		sbatch qc_run_${func}_${geom}
	done
done