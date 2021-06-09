#!/bin/csh 

module purge
module load AMBER/12
setenv AMBERHOME /project/cacds/apps/amber/amber12


foreach interf ( AAADDD_0 AAADDD_1 AAADDD_2 AAADDD_3 AAADDD_4 )
    set workdir = ${interf}
    cd ${workdir}
    ambpdb -p prmtop < ${workdir}_npt.rst > ${workdir}_new.pdb
    cp ../adj/* .
    sed "s/CSCSCS/${workdir}_new/g" setup.amber.CSCSCS > setup.amber.${workdir}_new
    tleap -s -f setup.amber.${workdir}_new
    rm -f setup.amber.CSCSCS
    cd ..
end
