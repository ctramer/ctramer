#!/bin/csh

    foreach interf ( CCCSSS CSCSCS)
        set workdir = ${interf}
        cd ${workdir}
        cp ../bak/cluster cluster.batch
        sed -i "s/NAME/${workdir}/g" cluster.batch
        sbatch cluster.batch
        cd ..
    end
