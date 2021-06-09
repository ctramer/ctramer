#!/bin/bash
# Creates a pdb for a donor acceptor pair

#charge= CT1_1 CT2_7 EX_3 etc. given as command line argument
# 1 7 and 3 are the configuration of the pair
charge=$1
MOL1=c70
MOL2=dbp
conf=`echo $charge | cut -f 2 -d '_'`
xyz=${MOL1}_${MOL2}_${conf}.xyz

echo "working on the $charge charge"

module load AMBER
module load VMD
export AMBERHOME=/project/cacds/apps/amber/amber14
# ANTECHAMBER
# Acceptor molecule (MOL1)
# Need to rewrite to get the charges correctly due to the format difference
# in the Mulliken file.

grep -E '^[[:space:]]+' ${charge}.dat | \
sed '1,+69p' -n | awk '{if(NR%8==0) printf("%10.6f\n",$1); else printf("%10.6f",$1)}' > ${MOL1}_${charge}.txt
antechamber	-i ${MOL1}.mol2  	\
		-fi mol2  	\
		-o ${MOL1}_${charge}.mol2 	\
		-fo mol2 	\
		-j 4		\
		-c rc       \
        -cf ${MOL1}_${charge}.txt \
		-at gaff	\
        -an n       \
		-pf y
#parmchk  -i $MOL.$charge.mol2 -f  mol2 -o $MOL.$charge.frcmod

echo "Now the donor"
# Donor molecule (MOL2)
grep -E '^[[:space:]]+' ${charge}.dat | \
sed '71,+99p' -n | awk '{if(NR%8==0) printf("%10.6f\n",$1); else printf("%10.6f",$1)}' > ${MOL2}_${charge}.txt
antechamber -i ${MOL2}.mol2  	\
		-fi mol2  	\
		-o ${MOL2}_${charge}.mol2 	\
		-fo mol2 	\
		-j 4		\
		-c rc       \
        -cf ${MOL2}_${charge}.txt \
		-at gaff	\
        -an n       \
		-pf y
sed -i "s/Cl/CL/g" ${MOL2}_${charge}.mol2
#parmchk  -i $MOL.$charge.mol2 -f  mol2 -o $MOL.$charge.frcmod
echo "Done with the donor"

# convert xyz to pdb
sed "s/NNN/$charge/g" xyz2pdb.tcl.bak > xyz2pdb.tcl
rm -f setup.amber
sed "s/MOL1/${MOL1}/g;s/MOL2/${MOL2}/g;s/PAIR/$charge/g" setup.amber.bak > setup.amber

rm -f $charge.pdb

nohup vmd -dispdev none -parm7 ../pop_simulation/AAADDD_4/AAADDD_4_new.prmtop \
                -crdbox ../pop_simulation/AAADDD_4/AAADDD_4_new.mdcrd \
                -e extract_frame.tcl
nohup vmd -dispdev text -pdb AD.pdb -xyz ${xyz} -e xyz2pdb.tcl

tleap -s -f setup.amber

#rm -f setup.amber
