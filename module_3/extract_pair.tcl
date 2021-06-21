#Script to extract representative structure from MD
#Written by Jacob Tinnin
#Creates pair number CONF from residues DON_NUM and ACC_NUM in frame FRAME
#Script is written in TCL to be used by VMD
#Updated last for CTRAMER v1.0.1 21 JUN 2021

set sel [atomselect top "resid DON_NUM ACC_NUM" frame FRAME]
$sel writexyz config_CONF.xyz
exit
