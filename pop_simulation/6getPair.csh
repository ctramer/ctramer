#!/bin/csh

    foreach interf ( CCCSSS CSCSCS)
        set workdir = ${interf}
        cd ${workdir}
        foreach zone ( 1 2 3 )
            sed "s/NAME/${workdir}/g;s/ZONE/zone$zone/g" ../bak/getcrd > getcrd.zone$zone.batch
            sbatch getcrd.zone$zone.batch
        end
        cd ..
    end
