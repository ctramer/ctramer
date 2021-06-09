# Script to find the distance and angle for C70-DBP
# By Pengzhi Zhang and Jacob Tinnin
# 9-13-2017 written for C60-SubPC
# 8-2018 adapted for C70-DBP
# 5-08-2020 order parameters changed

echo "distance angle started"
# get the number of frames
set num_steps [molinfo top get numframes]

# First find out the resid of C70 & DBP
set C70 [atomselect top "resname C70 and name C2"]
set resC70 [$C70 get resid];list
$C70 delete

set DBP [atomselect top "resname DBP and name H1"]
set resDBP [$DBP get resid];list
$DBP delete

date
# loop over all frames in the trajectory
for {set frame 0} {$frame < 10} {incr frame} {
    foreach i $resC70 {
#	set sel_c70 [atomselect top "resid $i" frame 1]
 #       set c70_com [measure center $sel_c70]
#	$sel_c70 delete
	foreach j $resDBP {
 #           set sel2 [atomselect top "resid $j and name C58" frame 1]
  #          set vec2 [measure center $sel2]
   #         $sel2 delete
#	    set dist [vecdist $c70_com $vec2]

		set sel4 [atomselect top "resid $i and within 10 of resid $j" frame 1]
		$sel4 delete
        }
    }
}

echo "finished"
date
quit
