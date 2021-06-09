#!/bin/csh


foreach interf ( CSCSCS CCCSSS )
        set workdir = ${interf}
        cd ${workdir}
        cp ../bak/sample_pdb.tcl .
        cp ../bak/c60_pmf.sh .
        sed -i "s/NAME/${workdir}/g" sample_pdb.tcl
	sed -i "s/NAME/${workdir}/g" c60_pmf.sh
        sbatch c60_pmf.sh
        cd ..
    end
end
