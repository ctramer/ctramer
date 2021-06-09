#!/bin/csh


foreach interf (AAADDD AAADDD_0 AAADDD_1 AAADDD_2 AAADDD_3 AAADDD_4)
        set workdir = ${interf}
        cd ${workdir}
        cp ../bak/parameter_script.tcl .
        cp ../bak/distance_angle .
        sed -i "s/NAME/${workdir}/g" parameter_script.tcl
	sed -i "s/NAME/${workdir}/g" distance_angle
        sbatch distance_angle
        cd ..
end
