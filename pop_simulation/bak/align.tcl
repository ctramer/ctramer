# align.tcl: align the crd with the first structure
# usage: vmd -dispdev text -e align.tcl -args zone1
# author: Pengzhi Zhang, 7/27/2011

set ZONE [lindex $argv 0]

set molid [mol load pdb ../../format.pdb crd ${ZONE}.dat]
set sel0 [atomselect $molid "resname SPC" frame 1]
set sel1 [atomselect $molid "resname SPC"]
set sel2 [atomselect $molid all]
set nf [molinfo $molid get numframes]

for {set i 2} {$i < $nf} {incr i} {
	$sel1 frame $i
    $sel2 frame $i
	$sel2 move [measure fit $sel1 $sel0]
}

animate write trr ${ZONE}.trr beg 1 end -1 waitfor all $molid 
animate write pdb ${ZONE}_ref.pdb beg 1 end 1 
quit
