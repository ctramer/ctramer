#!/bin/csh

module load VMD
set script = $PWD/bak/dist_angle2.tcl

    foreach interf ( AAADDD_0 AAADDD_1 AAADDD_2 AAADDD_3 AAADDD_4 )
        set workdir = ${interf}
        cd ${workdir}
        vmd -dispdev text -parm7 AAADDD_new.prmtop -crdbox ${workdir}_new.mdcrd -e $script
        cd ..
    end
