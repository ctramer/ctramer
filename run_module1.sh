#!/bin/bash

NUMGEOM=$(awk 'NR==3 {print $2}' module_1/input.dat)

cd module_1/RUNJOB/
bash RUN_DFTFUNC_PBS.sh

cd TDDFT
cp ../../analyze_gs.py .

geom=1
while [ $geom -lt $NUMGEOM ]
do

	python analyze_gs.py input ${geom}.out
	geom=`expr $geom + 1`
	
done

cd ../../../
