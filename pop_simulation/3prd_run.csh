#!/bin/csh


    foreach interf ( AAADDD_0 AAADDD_1 AAADDD_2 AAADDD_3 AAADDD_4 )
        set workdir = ${interf}
        cd ${workdir}
        cp ../bak/prd.in .
        cp ../bak/prd_sander .
        sed -i "s/NAME/${workdir}_new/g" prd_sander
        sbatch prd_sander
        cd ..
end

