#!/bin/bash


num_m1=$(awk -v var=5 'NR==var {print $2}' module_1/input.dat)
amber_name=$(awk -v var=1 'NR==var {print $2}' modules.dat)

cd module_2/system_construction/make_layers/scripts
bash construct_layers.sh
mv AAADDD_0.prmtop ../PRMTOP/
mv *.inpcrd ../../bak/
cd ..

cp generate_prmtop_gs.sh generate_prmtop_gs_t.sh
sed -i "s/N_ATOMS_MOL1/$num_m1/g" generate_prmtop_gs_t.sh
bash generate_prmtop_gs_t.sh
rm generate_prmtop_gs_t.sh
cp PRMTOP.GS/AAADDD_GS.prmtop ../bak/

cp 1setup.sh 1setup_t.sh
sed -i "s/AMBERNAME/$amber_name/g" 1setup_t.sh
bash 1setup.sh
cp 2adjust_box.sh 2adjust_box_t.sh
sed -i "s/AMBERNAME/$amber_name/g" 2adjust_box_t.sh
bash 2adjust_box_t.sh
bash 3prd_run.sh
bash 4dist_angle.sh