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
DIEL=$(awk 'NR==10 {print $2}' input.dat)
OPTDIEL=$(awk 'NR==11 {print $2}' input.dat)
NOMEGA=$(awk 'NR==12 {print $2}' input.dat)
#printf "NUMGEOM is printed: $NUMGEOM\n";

geom=1
while [ $geom -lt $NUMGEOM ]
do

cp ../GEOMETRIES/${geom}.txt . 

#-----------Enter variables for this input file ------#
bbb=0.001
ccc=1000
ddd=1
epsilon=$(echo "scale=3; $ddd / $DIEL" | bc)
HFLR=$(expr $epsilon*$ccc | bc | sed 's/\.0*$//')
WPBE=$(expr $HFLR*$bbb-0.20 | bc)
XPBE=$(expr $ddd-$epsilon | bc)


# ----------- Write input file for Q-chem -----------#

echo '$molecule' > ${geom}.in
cat >> ${geom}.in <<!
read                  ${geom}.txt
!
echo '$end' >> ${geom}.in
echo ' ' >> ${geom}.in
echo '$XC_FUNCTIONAL' >> ${geom}.in
cat >> ${geom}.in <<!
C PBE    1.00
X wPBE   $WPBE
X PBE    $XPBE
X HF     0.20
!
echo '$end' >> ${geom}.in
echo ' ' >> ${geom}.in
echo '$rem' >> ${geom}.in
cat >> ${geom}.in <<!
jobtype               sp
exchange              general
correlation           none
basis                 $BASISSET
omega                 $NOMEGA
omega2                $NOMEGA
lrc_dft               true
src_dft               2
HF_SR                 200
HF_LR                 $HFLR
scf_convergence       8
rpa                   2
cis_n_roots           $NUMEXS
cis_singlets          true
cis_triplets          false
max_cis_cycles        500000
pop_mulliken          -1
sts_fcd               true
sts_acceptor          1-$NUMACC
sts_donor             $SNUMDON-$NUMTOT
MAX_CIS_CYCLES        100
max_scf_cycles        5000
mem_static            4000
mem_total             48000
print_general_basis   true
print_orbitals        10
molden_format         true
solvent_method        pcm
!
echo '$end' >> ${geom}.in
echo ' ' >> ${geom}.in
echo '$pcm' >> ${geom}.in
cat >> ${geom}.in <<!
Theory      pcm
Method      SWIG
Solver      Inversion
HeavyPoints 194
HPoints     194
Radii       bondi
vdwScale    1.2
!
echo '$end' >> ${geom}.in
echo ' ' >> ${geom}.in
echo '$solvent' >> ${geom}.in
cat >> ${geom}.in <<!
Dielectric $DIEL
OpticalDielectric $OPTDIEL
!
echo '$end' >> ${geom}.in
# ---------- End of writing input file ---------#

# ---------- Write PBS script ---------- #

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

