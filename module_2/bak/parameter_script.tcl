# Script to find a distance and two angles for MOLEC1-MOLEC2 pair
# By Pengzhi Zhang and Jacob Tinnin
# 12-10-2020 v0.9, independent of molecule choice.
# Returns a dist and two angles corresponding to displacement for each pair
# Does not account for rotational degrees of freedom, requires 3 carbon atoms

echo "distance angle started"
date
# get the number of frames
set num_steps [molinfo top get numframes]

# open file for writing
set fil [open NAME_new.dat w]

# First find out the resid of MOLEC1 & MOLEC2
set MOLEC1 [atomselect top "resname MOLEC1 and name C1"]
set resMOLEC1 [$MOLEC1 get resid];
$MOLEC1 delete

set MOLEC2 [atomselect top "resname MOLEC2 and name C1"]
set resMOLEC2 [$MOLEC2 get resid];
$MOLEC2 delete

# loop over all frames in the trajectory
for {set frame 0} {$frame < $num_steps} {incr frame} {
    foreach i $resMOLEC1 {
	set sel_MOLEC1 [atomselect top "resid $i" frame $frame]
        set MOLEC1_com [measure center $sel_MOLEC1]
	$sel_MOLEC1 delete
	foreach j $resMOLEC2 {
            set sel_MOLEC2 [atomselect top "resid $j" frame $frame]
            set MOLEC2_com [measure center $sel_MOLEC2]
            $sel_MOLEC2 delete
	    
	    set dist [vecdist $MOLEC1_com $MOLEC2_com]
	    #if { $dist < 20 } {
		set sel1 [atomselect top "resid $i and within 6 of resid $j" frame $frame]
		if { [$sel1 num] > 0 } {
			set sel2 [atomselect top "resid $j and name C1" frame $frame"]
			set vec2 [measure center $sel2]
			$sel2 delete
			set sel3 [atomselect top "resid $j and name C2" frame $frame]
			set vec3 [measure center $sel3]
			$sel3 delete		
			set sel4 [atomselect top "resid $j and name C3" frame $frame]
			set vec4 [measure center $sel3]
			$sel4 delete		
			set angle1 [expr {acos([vecdot [vecnorm [vecsub $MOLEC1_com $MOLEC2_com] ] [vecnorm [vecsub $vec2 $vec3] ]])*180/acos(-1)}]
			set vec5 [veccross [vecsub $vec2 $vec3] [vecsub $vec2 $vec4] ]
			set angle2 [expr {acos([vecdot [vecnorm [vecsub $MOLEC1_com $MOLEC2_com] ] [vecnorm $vec5 ]])*180/acos(-1)}]
		    puts $fil "$frame $i $j $dist $angle1 $angle2"
		}
	    
		$sel1 delete
	    #}
	}
    }
}

close $fil

echo "finished"
date
quit
