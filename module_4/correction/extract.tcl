#Script to extract frame from trajectory
#Sed in the frame number for FRAME
#Sed in the configuration for CONF

set sel [atomselect top "resid INDEX1 INDEX2" frame FRAME]
$sel writepdb AD_CONF.pdb 
$sel writerst7 AD_CONF.rst
exit
