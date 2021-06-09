#!/bin/csh


    foreach interf ( CCCSSS CSCSCS )
        set workdir = ${interf}
        cd ${workdir}
        cp ../bak/prd_ext.in .
        cp ../bak/prd_sander_ext .
        sed -i "s/NAME/${workdir}/g" prd_sander_ext
        sbatch prd_sander_ext
        cd ..
end


