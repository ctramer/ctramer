#Script to extract frame from trajectory
#Sed in the frame number for FRAME
#Sed in the configuration for CONF

set sel [atomselect top all frame FRAME]
$sel writerst7 AAADDD_CONF.rst
exit
