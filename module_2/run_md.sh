#!/bin/bash

m1=$(awk -v var=1 'NR==var {print $1}' names.dat)
m2=$(awk -v var=2 'NR==var {print $1}' names.dat)
num_configs=
amber_name=$(awk -v var=1 'NR==var {print $2}' modules.dat)
vmd_name=$(awk -v var=2 'NR==var {print $2}' modules.dat)
matlab_name=$(awk -v var=3 'NR==var {print $2}' modules.dat)

cd module_5/correction/
cp calc_corrections.sh calc_corrections_t.sh
sed -i "s/MOLEC1/$m1/g" calc_corrections_t.sh
sed -i "s/MOLEC2/$m2/g" calc_corrections_t.sh
sed -i "s/CONF_NUM/num_configs/g" calc_corrections_t.sh
sed -i "s/AMBER_MODULE_NAME/amber_name/g" calc_corrections_t.sh
sed -i "s/VMD_MODULE_NAME/vmd_name/g" calc_corrections_t.sh
bash calc_corrections_t.sh
rm calc_corrections_t.sh

cd ..
cp km_calc.sh km_calc_t.sh
sed -i "s/CONF_NUM/$num_configs/g" km_calc_t.sh
sed -i "s/MATLAB_MODULE_NAME/matlab_name/g" km_calc_t.sh
bash km_calc_t.sh
rm km_calc_t.sh

num_m1=$(awk -v var=5 'NR==var {print $2}' module_1/input.dat)

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

mv