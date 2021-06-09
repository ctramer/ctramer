#!/bin/bash

for charge in `ls  *.dat | cut -f 1 -d '.'` ; do
    ./setup.sh $charge
    #./pt_ene_sander.sh $charge > ${charge}.output
done

