#!/bin/bash
module load AMBER
module load VMD
MOL1=MOLEC1
MOL2=MOLEC2
cp ../configs.dat configs.dat
cp -r ../../system_construction/states .
for config in 1 2 3; do
        DONOR="EX";
        frame=$(awk -v var="$config" 'NR==var {print $1}' configs.dat)
        index1=$(awk -v var="$config" 'NR==var {print $2}' configs.dat)
        index2=$(awk -v var="$config" 'NR==var {print $3}' configs.dat)
        rm -rf config_${config}
        mkdir config_${config}

    cp extract_frame.tcl config_${config}/extract_frame.tcl
	cp reform_charge.pl config_${config}/reform_charge.pl
	cp ${MOL1}.mol2 config_${config}/${MOL1}.mol2
	cp ${MOL2}.mol2 config_${config}/${MOL2}.mol2
	cd config_${config}
        sed -i "s/FRAME/$frame/g" extract_frame.tcl
        sed -i "s/CONF/$config/g" extract_frame.tcl
        sed -i "s/INDEX1/$index1/g" extract_frame.tcl
	sed -i "s/INDEX2/$index2/g" extract_frame.tcl
        nohup vmd -dispdev none -parm7 ../../../pop_simulation/AAADDD_4/AAADDD_4_new.prmtop \
                -crdbox ../../../pop_simulation/AAADDD_4/AAADDD_4_new.mdcrd \
                -e extract_frame.tcl
        rm extract_frame.tcl

	size={$(tail -n 1 AD_${config}.rst | cut -d ' ' -f 3-7)}
	sed "s/FM1/$MOL1/g;s/FM2/$MOL2/g;s/MOL1/$(echo $MOL1 | awk '{print toupper($0)}')/g;s/MOL2/$(echo $MOL2 | awk '{print toupper($0)}')/g;s/CONF/$config/g;s/BOX_SIZE/$size/g" ../setup.amber.bak > setup.amber
	
	nohup tleap -s -f setup.amber
	func=bnl
	dir=`pwd -P`
	cd ../states/config_$config
	for EX in $(ls * | cut -f 1 -d "_" ); do


		echo " $EX "

		cd $dir
		if [ -L EXcharge ]; then
			unlink EXcharge
		fi
		echo "Calculating ..."

		ln -s ../states/config_${config}/${EX}_${config}.dat EXcharge
		perl reform_charge.pl AAADDD EXcharge \
                        EXcharge $func $config $index1 $index2 >out
		mv charges_amber_${func}_AAADDD_${config}.txt \
                        charges_amber_${func}_${config}_AAADDD_${EX}.txt
                unlink EXcharge

                if [ -L charge ]; then
			unlink charge
                fi

                ln -s charges_amber_${func}_${config}_AAADDD_${EX}.txt charge
                sed 24,57d AD_${config}.prmtop \
                        | sed '23r charge' > AD_${config}_${EX}.prmtop
                unlink charge
		rm charges_amber_${func}_${config}_AAADDD_${EX}.txt

		../pt_ene_sander.sh ${EX} ${config} 
	done
	cd ..
done
rm -rf nohup.out
