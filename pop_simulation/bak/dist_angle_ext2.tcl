# Script to find the distance and angle.
# By Pengzhi Zhang and Jacob Tinnin
# 11-3-2017

# get the number of frames
set num_steps [molinfo top get numframes]

# open file for writing
set fil [open NAME_ext2.dat w]

# First find out the resid of C60 & SPC
set C60 [atomselect top "resname C60 and name C"]
set resC60 [$C60 get resid]
$C60 delete

set SPC [atomselect top "resname SPC and name B"]
set resSPC [$SPC get resid]
$SPC delete

# loop over all frames in the trajectory
for {set frame 0} {$frame < $num_steps} {incr frame} {
    foreach i $resC60 {
        set sel1 [atomselect top "resid $i" frame $frame]
        set vec1 [measure center $sel1]
        $sel1 delete
        foreach j $resSPC {
            set sel2 [atomselect top "resid $j and name B" frame $frame]
            set vec2 [measure center $sel2]
            set sel3 [atomselect top "resid $j and name CL" frame $frame]
            set vec3 [measure center $sel3]

	    set dist [vecdist $vec1 $vec2]

	    if {$dist < 20} {

	    	set sel4 [atomselect top "resid $i and within 5 of resid $j" frame $frame]

		if { [$sel4 num] > 0 } {		

            		set angle [expr {acos([vecdot [vecnorm [vecsub $vec1 $vec2] ] [vecnorm [vecsub $vec2 $vec3] ]])*180/acos(-1)}]
            
		    	puts $fil "$frame $i $j $dist $angle"
		}
		$sel4 delete

	   }

	      $sel2 delete
            $sel3 delete
        }
    }
}

close $fil

quit
