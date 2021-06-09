#!/bin/sh
#SBATCH  -J NAME_20ns_A		# Job Name
#SBATCH	 -o NAME_20ns_A.o%j	# Output and error file name (%j expands to jobID)
#SBATCH	 -N 1			# Number of node, ensure that all cores are on one machine
#SBATCH  -n 1			# Total number of mpi tasks requested
#SBATCH  -p short		# Partition short <= 4 hours
#SBATCH  -t 4:00:00		# Run time (hh:mm:ss)		
#SBATCH --mem 2000 		# Maximum memory needed in MBs

#Takes a list of 200 sampled structures according to fe
#then uses vmd to make a mdcrd of the structures
#use with pair_format.pdb

rm -r structures
mkdir structures
module purge

module load vmd
vmd -dispdev text -parm7 NAME_new.prmtop -crdbox NAME_new.mdcrd -crdbox NAME_ext.mdcrd -crdbox NAME_ext2.mdcrd -e sample_pdb.tcl

mv NAME_structures.mdcrd structures/
