#!/bin/sh


#############################
#                           #
#       Written by AKSU     #
#        December 2019      #
#############################

cp -a ../input.dat .

DFTLEVEL=$(awk 'NR==1 {print $2}' input.dat)
PHASE=$(awk 'NR==2 {print $2}' input.dat)


# For BNL DFT Functional
if [ $DFTLEVEL -eq 1 ]; then

  if [ $PHASE -eq 0 ]; then
  cp -a DFT_FUNCTIONALS/bnl.sh dft.sh
  ./dft.sh
  else
  cp -a DFT_FUNCTIONALS/bnl-pcm.sh dft.sh
  ./dft.sh 
  fi

# For B3LYP DFT Functional
elif [ $DFTLEVEL -eq 2 ]; then

  if [ $PHASE -eq 0 ]; then
  cp -a DFT_FUNCTIONALS/b3lyp.sh dft.sh
  ./dft.sh
  else
  cp -a DFT_FUNCTIONALS/b3lyp-pcm.sh dft.sh
  ./dft.sh
  fi

# For wPBEh DFT Functional
elif [ $DFTLEVEL -eq 3 ]; then

  if [ $PHASE -eq 0 ]; then
  cp -a DFT_FUNCTIONALS/wPBEh.sh dft.sh
  ./dft.sh
  else
  cp -a DFT_FUNCTIONALS/wPBEh-pcm.sh dft.sh
  ./dft.sh
  fi

# For SRSH  scheme
elif [ $DFTLEVEL -eq 4 ]; then

  cp -a DFT_FUNCTIONALS/wPBEh.sh dft.sh
  ./dft.sh

else

printf "WARNING:Enter a valid number for DFT functional!\n";

fi

rm dft.sh
rm input.dat
