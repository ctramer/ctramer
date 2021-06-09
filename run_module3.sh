#!/bin/bash
num_configs=

cd module_1/RUNJOB/
bash RUN_DFTFUNC_PBS.sh

cd TDDFT
cp ../../analyze_gs.py .

geom=1
while [ $geom -lt $num_configs ]
do

	python analyze_states.py input ${geom}.out
	geom=`expr $geom + 1`
	
done

cd ../../../