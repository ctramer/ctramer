# Script to find the distance and angle for C70-DBP
# By Pengzhi Zhang and Jacob Tinnin
# 9-13-2017 written for C60-SubPC
# 8-2018 adapted for C70-DBP
# 5-08-2020 order parameters changed

echo "distance angle started"
date
# get the number of frames
set num_steps [molinfo top get numframes]

# open file for writing
set fil [open NAME_new.dat w]

# First find out the resid of C70 & DBP
set C70 [atomselect top "resname C70 and name C2"]
set resC70 [$C70 get resid];list
$C70 delete

set DBP [atomselect top "resname DBP and name H1"]
set resDBP [$DBP get resid];list
$DBP delete

# loop over all frames in the trajectory
for {set frame 0} {$frame < 1000} {incr frame} {
    foreach i $resC70 {
	set sel_c70 [atomselect top "resid $i" frame $frame]
        set c70_com [measure center $sel_c70]
	$sel_c70 delete
	foreach j $resDBP {
            set sel_dbp [atomselect top "resid $j" frame $frame]
            set dbp_com [measure center $sel_dbp]
            $sel_dbp delete
	    
	    set dist [vecdist $c70_com $dbp_com]
	    if { $dist < 25 } {
		set sel4 [atomselect top "resid $i and within 6 of resid $j" frame $frame]
		if { [$sel4 num] > 0 } {
			set sel2 [atomselect top "resid $j and name C60" frame $frame"]
			set vec2 [measure center $sel2]
			$sel2 delete
			set sel3 [atomselect top "resid $j and name C59" frame $frame]
			set vec3 [measure center $sel3]
			$sel3 delete		
          		#set angle [expr {acos([vecdot [vecnorm [vecsub $c70_com $vec2] ] [vecnorm [vecsub $vec2 $vec3] ]])*180/acos(-1)}]
            		set sel5 [atomselect top "resid $j and name C52 C53" frame $frame]
			set vec5 [measure center $sel5]
			$sel5 delete
			set sel6 [atomselect top "resid $j and name C22 C23" frame $frame]
			set vec6 [measure center $sel6]
			$sel6 delete
			set vec7 [veccross [vecsub $vec5 $vec6] [vecsub $vec2 $vec3] ]
			set rvec [vecsub $c70_com $dbp_com]
			set x [vecdot $rvec [vecnorm $vec7] ]
			set y [vecdot $rvec [vecnorm [vecsub $vec5 $vec6] ] ]
			set z [vecdot $rvec [vecnorm [vecsub $vec2 $vec3] ] ]
			
			set sel_end1 [atomselect top "resid $j and name H4 H5" frame $frame]
			set sel_end2 [atomselect top "resid $j and name H22 H23" frame $frame]
			set vec_end1 [measure center $sel_end1]
			set vec_end2 [measure center $sel_end2]
			$sel_end1 delete
			$sel_end2 delete
			set dist_e [vecdist $vec_end1 $vec_end2]

			set selp1 [atomselect top "resid $j and name C1 C2" frame $frame]
			set selp2 [atomselect top "resid $j and name C62 C63" frame $frame]
			set vecp1 [measure center $selp1]
			set vecp2 [measure center $selp2]
			$selp1 delete
                        $selp2 delete
			set angp1 [expr {atan2([vecdot [vecnorm [vecsub $vec2 $vec3]] [vecnorm [vecsub $vecp1 $vecp2]]],[vecdot [vecnorm $vec7] [vecnorm [vecsub $vecp1 $vecp2]]])*180/acos(-1)}]
			set selp1 [atomselect top "resid $j and name C13 C14" frame $frame]
                        set selp2 [atomselect top "resid $j and name C16 C17" frame $frame]
                        set vecp1 [measure center $selp1]
                        set vecp2 [measure center $selp2]
			$selp1 delete
                        $selp2 delete
                        set angp2 [expr {atan2([vecdot [vecnorm [vecsub $vec2 $vec3]] [vecnorm [vecsub $vecp1 $vecp2]]],[vecdot [vecnorm $vec7] [vecnorm [vecsub $vecp1 $vecp2]]])*180/acos(-1)}]
			set selp1 [atomselect top "resid $j and name C30 C31" frame $frame]
                        set selp2 [atomselect top "resid $j and name C33 C34" frame $frame]
                        set vecp1 [measure center $selp1]
                        set vecp2 [measure center $selp2]
			$selp1 delete
                        $selp2 delete
                        set angp3 [expr {atan2([vecdot [vecnorm [vecsub $vec2 $vec3]] [vecnorm [vecsub $vecp1 $vecp2]]],[vecdot [vecnorm $vec7] [vecnorm [vecsub $vecp1 $vecp2]]])*180/acos(-1)}]
			set selp1 [atomselect top "resid $j and name C43 C44" frame $frame]
                        set selp2 [atomselect top "resid $j and name C46 C47" frame $frame]
                        set vecp1 [measure center $selp1]
                        set vecp2 [measure center $selp2]
			$selp1 delete
                        $selp2 delete
                        set angp4 [expr {atan2([vecdot [vecnorm [vecsub $vec2 $vec3]] [vecnorm [vecsub $vecp1 $vecp2]]],[vecdot [vecnorm $vec7] [vecnorm [vecsub $vecp1 $vecp2]]])*180/acos(-1)}]
			
			set selp1 [atomselect top "resid $j and name C" frame $frame]
                        set selp2 [atomselect top "resid $j and name C3" frame $frame]
                        set vecp1 [measure center $selp1]
                        set vecp2 [measure center $selp2]
			$selp1 delete
                        $selp2 delete
                        set angpl1 [expr {acos([vecdot [vecnorm [vecsub $vec2 $vec3]] [vecnorm [vecsub $vecp1 $vecp2]]])*180/acos(-1)}]
			set selp1 [atomselect top "resid $j and name C12" frame $frame]
                        set selp2 [atomselect top "resid $j and name C15" frame $frame]
                        set vecp1 [measure center $selp1]
                        set vecp2 [measure center $selp2]
			$selp1 delete
                        $selp2 delete
                        set angpl2 [expr {acos([vecdot [vecnorm [vecsub $vec2 $vec3]] [vecnorm [vecsub $vecp1 $vecp2]]])*180/acos(-1)}]
			set selp1 [atomselect top "resid $j and name C32" frame $frame]
                        set selp2 [atomselect top "resid $j and name C29" frame $frame]
                        set vecp1 [measure center $selp1]
                        set vecp2 [measure center $selp2]
			$selp1 delete
                        $selp2 delete
                        set angpl3 [expr {acos([vecdot [vecnorm [vecsub $vec2 $vec3]] [vecnorm [vecsub $vecp1 $vecp2]]])*180/acos(-1)}]
			set selp1 [atomselect top "resid $j and name C42" frame $frame]
                        set selp2 [atomselect top "resid $j and name C45" frame $frame]
                        set vecp1 [measure center $selp1]
                        set vecp2 [measure center $selp2]
			$selp1 delete
			$selp2 delete
                        set angpl4 [expr {acos([vecdot [vecnorm [vecsub $vec2 $vec3]] [vecnorm [vecsub $vecp1 $vecp2]]])*180/acos(-1)}]			

		    	puts $fil "$frame $i $j $dist $x $y $z $dist_e $angp1 $angp2 $angp3 $angp4 $angpl1 $angpl2 $angpl3 $angpl4"
		}
	    
		$sel4 delete
	    }
	}
    }
}

close $fil

echo "finished"
date
quit
