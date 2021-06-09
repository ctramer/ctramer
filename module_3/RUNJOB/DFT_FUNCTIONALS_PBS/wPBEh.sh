#Q-Chem 4.4

for direc in TDDFT

do

mkdir $direc
cd $direc
dir=`pwd`

cp -a ../../input.dat .

NUMGEOM=$(awk 'NR==3 {print $2}' input.dat)
NUMTOT=$(awk 'NR==4 {print $2}' input.dat)
NUMDON=$(awk 'NR==5 {print $2}' input.dat)
SNUMDON=$(awk 'NR==6 {print $2}' input.dat)
NUMACC=$(awk 'NR==7 {print $2}' input.dat)
NUMEXS=$(awk 'NR==8 {print $2}' input.dat)
BASISSET=$(awk 'NR==9 {print $2}' input.dat)
NOMEGA=$(awk 'NR==12 {print $2}' input.dat)
#printf "NUMGEOM is printed: $NUMGEOM\n";

geom=1
while [ $geom -lt $NUMGEOM ]
do

cp ../GEOMETRIES/${geom}.txt .

# ----------------------If there is--------------------#
# -----------Enter variables for this input file ------#


# ----------- Write input file for Q-chem -----------#


echo '$molecule' > ${geom}.in
cat >> ${geom}.in <<!
read                 ${geom}.txt
!
echo '$end' >> ${geom}.in
echo ' ' >> ${geom}.in
echo '$XC_FUNCTIONAL' >> ${geom}.in
cat >> ${geom}.in <<!
 X wPBE 0.80
 C PBE  1.00
 X HF   0.20
!
echo '$end' >> ${geom}.in
echo ' ' >> ${geom}.in
echo '$rem' >> ${geom}.in
cat >> ${geom}.in <<!
jobtype               sp
exchange              general
correlation           none
basis                 $BASISSET
SEPARATE_JK           TRUE
lrc_dft               true
derscreen             false
ideriv                0
scf_convergence       8
max_scf_cycles        1000
mem_static            3000
MEM_TOTAL             16000
OMEGA                 $NOMEGA
RPA                   2
CIS_N_ROOTS           $NUMEXS
CIS_SINGLETS          TRUE
CIS_TRIPLETS          FALSE
PRINT_ORBITALS        10
pop_mulliken          -1
sts_fcd               true
sts_acceptor          1-$NUMACC
sts_donor             $SNUMDON-$NUMTOT
MAX_CIS_CYCLES        100
sym_ignore            true
molden_format         true
!
echo '$end' >> ${geom}.in
echo ' ' >> ${geom}.in

# ---------- End of writing input file ---------#

# --------------- Write PBS script-- ---------- #

# Change the qchem version below if you have other version

cat > ${geom}.pbs <<!
#PBS -S /bin/bash
#PBS -N DFT
#PBS -e dft.err
#PBS -o dft.out
#PBS -l nodes=1:ppn=12
#PBS -l walltime=24:00:00

module load qchem/4.4.1-openmp
export job=sp

cd $dir

qchem ${geom}.in > ${geom}.out
!

echo 'Submit '$geom '  job for ALPFA= ' $direc
qsub ${geom}.pbs

  # increment the geom value that is started at the beginning
  geom=`expr $geom + 1`

done

cd ..
done




