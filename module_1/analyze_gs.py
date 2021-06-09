#########################################################################
#   Read QChem output file (python version4)                            #
#   analyze the charge transition                                       #
#   python autoQC.py input qchem.out                                    #
#   @Zhengqing Tong, zt9@nyu.edu                       
#   Huseyin Aksu, Jacob Tinnin
#########################################################################
 
import os
import re
import sys
import numpy as np
import pandas as pd
import math

if(len(sys.argv)<2):
   sys.exit('\n Usage: python autoQC.py input Qchem \n')

#========================================================================
### set input and output 

inputfile0 =sys.argv[1]
print ('\n 1. general inputfile =',inputfile0)

#Part = []

file0 = open(inputfile0,'r')
print ('\n open inputfile =',inputfile0)
lines = file0.readlines()
for line in lines: 
    res1 = re.findall(r'NUM_TOT',line)
    if res1 !=[]:
        totn = int(re.sub("\D",'',line))
        test= 2 + 5

    res2 = re.findall(r'NUM_of_ACCEPTOR',line)
    if res2 !=[]:
        Acc = int(re.sub("\D",'',line))

    res3 = re.findall(r'NUM_of_DONOR',line)
    if res3 !=[]:
        Don = int(re.sub("\D",'',line)) 
       
    res4 = re.findall(r'ATOMS_of_FRAGMENT',line)
    if res4 !=[]:
        Part=[int(s) for s in re.findall(r'\d+',line)]

    res5 = re.findall(r'NUMEXS',line)
    if res5 !=[]:
        Nstate = int(re.sub("\D",'',line))

file0.close()

print("   Total atoms = ", totn)
print("   Number of acceptor = ",Acc)
print("   Number of Donor = ", Don)
print("   Total atoms for each fragment = ",Part)
print("   Number of EX state = ", Nstate)


inputfile = sys.argv[2]
print ('\n 2. QChem inputfile =',inputfile)

No = re.sub("\D", '', inputfile)
test2=re.split("/",inputfile)
test2=re.split("\.",test2[len(test2)-1])
No = test2[0]

outES = 'Excited_states_' + No + '.dat'

outCoup = 'FCD_Coupling_' + No + '.dat'

outTransCoup = 'coupling_' + No + '.dat'

outchg = 'Mulliken_Charge_' + No + '.dat'

outEXchg = 'EX_' + No + '.dat'

outGSchg = 'GS_' + No + '.dat'

chgfile=open(outchg,'w')


energy = []
strength = []

Coup = []
ncoup = 0

chg = []
partchg = []

def main():

    fileQC = open(inputfile,'r')
    print ('\n open inputfile =',inputfile)
    lines = fileQC.readlines()

    for line in lines:

        global Nstate
        res1 = re.findall(r'Excited state',line) 
        if res1 !=[]:
            temp = re.findall(r'-?\d+\.?\d*',line)
            energy.append(float(temp[1]))

        res2 = re.findall(r'Strength   :',line)        
        if res2 != []:
            temp = re.findall(r'-?\d+\.?\d*',line)
            strength.append(float(temp[0]))

        res3 = re.findall(r'FCD Couplings Between Ground and Singlet Excited States',line)
        if res3 != []:
            n = lines.index(line)
#            print(n)
            for s1 in range(Nstate):
                temp=lines[n+s1+4].split()
               # temp =  re.findall(r'-?\d+\.?\d*',lines[n+s1+4])
                Coup.append(float(temp[5]))

#        global ncoup
        ncoup=0
        res4 = re.findall(r'FCD Couplings Between Singlet Excited States',line)
        if res4 != []:
            n = lines.index(line)
            for s1 in range(Nstate-1):
                for s2 in range(s1+1,Nstate):
                    temp=lines[n+ncoup+4].split()
                  #  print(temp,n+4+s1)
                    Coup.append(float(temp[5]))
                    ncoup += 1  
        
        res5 = re.findall(r'Mulliken Net Atomic Charges',line)
        if res5 != []:
            n = lines.index(line)
            chgfile.write('{}'.format(line))
            chgfile.write('{}'.format(lines[n+2]))
            totn = 0
#            print(n)
            for nop in range(len(Part)):
                sump = 0
                for p1 in range(Part[nop]):
                    chgfile.write('{}'.format(lines[n+totn+4]))
#                    temp =  re.findall(r'-?\d+\.?\d*',lines[n+totn+4])   
                    temp = lines[n+totn+4].split()
#                    print(temp,totn)
                    sump += float(temp[2])
                    chg.append(float(temp[2]))
                    totn = totn +1
                partchg.append(sump)
#                    print(totn)
            chgfile.write('{} \n'.format(lines[n+totn+4]))

    fileQC.close()
main()

#Print index and charges for ground state
print("   The Ground State is :",0)
#print("totn=",totn)
filename=open(outGSchg,'w')
for i in range(totn):
    k = 0*totn + i
    filename.write('{:16.10f}\n'.format(chg[k]))    
filename.close()

#Celebrate
print('\n DONE!! \n')