#!/bin/csh

    foreach interf ( CCCSSS CSCSCS )
        set workdir = ${interf}
        cd ${workdir}

awk '{if($4<=10.0) print $4,$5}' distance.dat > tem.dat

../2d << EOF
100 100 tem.dat bin.dist_angle.dat
EOF

cp ~/MyColormaps.mat .
../plot_pmf.sh
rm -f tem.dat
rm -f MyColormaps.mat

        cd ..
    end

