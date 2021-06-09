#1/bin/bash
num_configs=CONF_NUM
matlab_name=MATLAB_MODULE_NAME
module load $matlab_name
for (( config=1; config<=$num_configs; config++)); do
	cd config_${config}
	rm -f rates.txt
	touch rates.txt
	for state in $(ls *.prmtop | cut -f 3 -d "_"| cut -f 1 -d ".");do
		if [ "${state}" = "EX" ]; then	
			cp ../km_calc.m .
		else
			cp ../km_calc.m .
			snum=$(expr substr $state 3 1)
			sed -i "s/CONF/${config}/g;s/STATE/${state}/g;s/SNUM/${snum}/g" km_calc.m
			matlab -nodisplay -nosplash -nodesktop -r "run km_calc.m; exit;"
			rm km_calc.m
		fi
			
	done
	cd ..
done



