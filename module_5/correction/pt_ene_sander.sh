#!/bin/bash

module load AMBER
#conform=1 2 3 etc
#state=CT3 EX etc
#name= CT3_1
state=$1
conf=$2

sander=$AMBERHOME/bin/sander

$sander \
  -O -i ../pt_ene_sander.in -o AD_${conf}_${state}.out   \
  -p AD_${conf}_${state}.prmtop -c AD_${conf}.inpcrd \

date
echo "Total Potential Energy is"
awk -f ../get-energies.awk mdinfo > ${conf}_${state}_corr.dat

echo Done!
