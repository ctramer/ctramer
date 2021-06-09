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

#print(len(chg))
print('\n The number of EX state =', Nstate)

#Print each state with its eGAS OS qA and QD
filename=open(outES,'w')
filename.write('\n{}'.format('  STATE     Energy(eV)    Strength  '))
for i in range(len(Part)):
    filename.write('{}{:2.0f}'.format('           Q',i+1))

filename.write('\n{}'.format('     0(GR)     --           --      '))
for i in range(len(Part)):
    filename.write('{:15.6f}'.format(partchg[i]))

for i in range(Nstate):
    filename.write('\n{:6.0f} {:12.4f} {:16.10f}'.format(i+1, energy[i], strength[i]))
    for j in range(len(Part)):
         k=(i+1)*len(Part)+j
         filename.write('{:15.6f}'.format(partchg[k]))
filename.close()

#Print index and charges for state with highest OS
print("   The EX State is :",strength.index(max(strength))+1)
#print("totn=",totn)
filename=open(outEXchg,'w')
for i in range(totn):
    k = (strength.index(max(strength))+1)*totn + i
    filename.write('{:16.10f}\n'.format(chg[k]))    
filename.close()

#Print index and charges of states with qD > 0.3 e (max 5)
test=partchg.copy()
test.sort(reverse=True)
print("   The Highest CT States are :",int((partchg.index(test[0])-1)/len(Part)),
      int((partchg.index(test[1])-1)/len(Part)),int((partchg.index(test[2])-1)/len(Part)),
      int((partchg.index(test[3])-1)/len(Part)),int((partchg.index(test[4])-1)/len(Part)))
num_CT=0
while (test[num_CT] > .3 and num_CT < 5):
    num_CT+=1
for j in range(num_CT):
    outCT = 'CT' + str(j+1) + '_' + No + '.dat'
    filename=open(outCT,'w')
    for i in range(totn):
        k = int(((partchg.index(test[j])-1)/2)*totn + i)
        filename.write('{:16.10f}\n'.format(chg[k]))    
    filename.close()

#Print the coupling between each combo of two states
filename=open(outCoup,'w')
filename.write('{}\n'.format('  STATES      Coupling(eV)'))
ncoup = 0
for i in range(Nstate):
    for j in range(i+1,Nstate+1):
        filename.write('{:4.0f} {:4.0f} {:16.10f} \n'.format(i, j, Coup[ncoup]))
        ncoup += 1
filename.close()

#Print the Egas, qD, and OS for each state
outScat='scatter_data_'+No+'.dat'
filename=open(outScat,'w')
qdata=partchg[3::2]
for i in range(Nstate):
    filename.write('{:12.6f} {:10.4f} {:16.10f} \n'.format(qdata[i], 
                   energy[i], strength[i]))
    ncoup += 1
filename.close()

#Print the coupling between the EX state and each CT state
filename=open(outTransCoup,'w')
ncoup = 0
for i in range(num_CT):
    ex_index = strength.index(max(strength))+1
    ct_index = int((partchg.index(test[i])-1)/2) 
    index1 = min(ct_index,ex_index)
    index2 = max(ct_index,ex_index)
    ncoup = int(index1 / 2 * (2*Nstate+1 - index1) - index1 - 1) + index2
    filename.write('{:16.10f} \n'.format(Coup[ncoup]))
filename.close()

#Print energy difference for each state

for i in range(num_CT):
    outcorr = 'egas_dif_CT' + str(i+1) + '_' + No + '.dat'
    filename=open(outcorr,'w')
    ex_index = strength.index(max(strength))+1
    ct_index = int((partchg.index(test[i])-1)/2) 
    corr = energy[ex_index-1] - energy[ct_index-1]
    filename.write('{:16.4f}\n'.format(corr))
filename.close()

#Celebrate
print('\n DONE!! \n')

#import matplotlib.pyplot as plt
#
#test3=[1]*40
#test4=["o"]*40
#test3[strength.index(max(strength))]=2
#test4[strength.index(max(strength))]="*"
#for i in range(num_CT):
#    test3[int((partchg.index(test[i])-1)/2)-1]=4
#    test4[int((partchg.index(test[i])-1)/2)-1]="x"
#
#plt.scatter(test2,strength,c=test3)
#plt.xlabel('$Q_D$ ($\it{e}$)')
#plt.ylabel('OS')

test3=[x * 0.1 for x in range(-5,len(partchg)*5-5,5)]
ex_indices=[ j for (i,j) in zip(strength,range(1,len(strength)+1)) if i >= max(strength)/2 ]
ex_charge=[0]*len(ex_indices)
for i in range(len(ex_indices)):
    ex_charge[i]=partchg[int(2*ex_indices[i]+1)];
ct_indices=[ j for (i,j) in zip(partchg,test3) if ( i >= 0.3 and j%1 == 0)]
ct_charge=[ i for (i,j) in zip(partchg,test3) if ( i >= 0.3 and j%1 == 0)]
rates=[0]*(len(ex_indices)*len(ct_indices))
for i in range(len(ex_indices)):
    for j in range(len(ct_indices)):
        index1 = min(ct_indices[j],ex_indices[i])
        index2 = max(ct_indices[j],ex_indices[i])
        ncoup = int(index1 / len(Part) * (len(Part)*len(strength)+ 1 - index1) - index1 - 1) + index2
        if (ct_charge[j]-ex_charge[i]) <= 0:
            rates[i*len(ct_indices)+j]=0;
        else:
            rates[i*len(ct_indices)+j]=(16.47+math.log10(math.exp(1))*math.log(Coup[int(ncoup)]**2)
            -13.05*((energy[int(ex_indices[i])-1]-energy[int(ct_indices[j])-1])**2))
            +math.log10(ct_charge[j]-ex_charge[i]);
total_rate=0;
for i in range(len(rates)):
    total_rate += 10**rates[i];
total_rate=math.log10(total_rate);

high_rates=[ i for (i,j) in zip(ct_indices,rates) if ( j >= total_rate-2)]