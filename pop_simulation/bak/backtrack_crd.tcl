# Script to find the xyz coordinates of pairs
# Written in x y z format (for simplification)
# By Pengzhi Zhang
# 3-13-2018

# First load the clusters-pdb.
# Get distance and angle
# Store the atom selections (SPC), distance and angle in arrays. 


set zone [lindex $argv 0]

#array set sel {}
array set dis {}
array set angl {}

set molid [mol load pdb clusters-$zone.pdb]
set numClusters [molinfo $molid get numframes]
puts "molid $molid"
puts "num of clusters $numClusters"

set selC60 [atomselect $molid "resname C60"]
set sel20 [atomselect $molid "resname SPC and name B"]
set sel30 [atomselect $molid "resname SPC and name CL"]

for {set framePDB 0} {$framePDB < $numClusters} {incr framePDB} {
    puts "frame $framePDB"
    #set sel($framePDB) [atomselect $molid "resname SPC" frame $framePDB]
    set selC60 [atomselect $molid "resname C60" frame $framePDB]
    set sel20 [atomselect $molid "resname SPC and name B" frame $framePDB]
    set sel30 [atomselect $molid "resname SPC and name CL" frame $framePDB]
    set vec10 [measure center $selC60]
    set vec20 [measure center $sel20]
    set vec30 [measure center $sel30]

    set angl($framePDB) [expr {acos([vecdot [vecnorm [vecsub $vec10 $vec20] ] [vecnorm [vecsub $vec20 $vec30] ]])}]
    set dis($framePDB)  [vecdist $vec10 $vec20]
    puts "distance is $dis($framePDB) and angle is $angl($framePDB)"
    $selC60 delete
    $sel20 delete
    $sel30 delete
}


mol top 0
# get the number of frames
set num_steps [molinfo top get numframes]
puts "num of frames $num_steps"

# open file for writing
set zonefile [open $zone-cluster.crd w]
puts $zonefile "region 1"

# First find out the resid of C60 & SPC
set C60 [atomselect top "resname C60 and name C"]
set resC60 [$C60 get resid]
$C60 delete

set SPC [atomselect top "resname SPC and name B"]
set resSPC [$SPC get resid]
$SPC delete

# loop over all frames in the trajectory
for {set frame 0} {$frame < $num_steps} {incr frame} {
    puts "frame $frame"
    foreach i $resC60 {
        set sel1 [atomselect top "resid $i" frame $frame]
        set vec1 [measure center $sel1]
        $sel1 delete
        foreach j $resSPC {
            set sel2 [atomselect top "resid $j and name B" frame $frame]
            set vec2 [measure center $sel2]
            set sel3 [atomselect top "resid $j and name CL" frame $frame]
            set vec3 [measure center $sel3]

            set angle [expr {acos([vecdot [vecnorm [vecsub $vec1 $vec2] ] [vecnorm [vecsub $vec2 $vec3] ]])}]
            set dist [vecdist $vec1 $vec2]
            $sel2 delete
            $sel3 delete

            foreach cluster [array names angl] {
                set diffa [expr $angle - $angl($cluster)]
                set diffd [expr $dist - $dis($cluster)]
                if { [expr $diffa*$diffa+$diffd*$diffd < 0.00001] } {
                    puts "for cluster $cluster, at frame $frame, resid $i and $j"
                    puts "distance is $dist and angle is $angle"
                    set selPair [atomselect top "resid $i $j" frame $frame]
                    set crd [$selPair get {x y z}]
                    $selPair delete
                    foreach i $crd {
                        puts $zonefile $i
                    }
                }
            }
        }
    }
}

close $zonefile
quit
