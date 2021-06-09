#Script to write a pdb of a c60-subpc pair
#by Jacob Tinnin 5/2018

set file1 [open "NAME_structures.dat" r]
set file2 [open "NAME_structures.mdcrd" w]
puts $file2 "NAME structures (20 ns)"

while {[gets $file1 line] != -1} {

	set f [lindex $line 0]
	set c60 [lindex $line 1]
	set spc [lindex $line 2]
	set sel1 [atomselect top "resid $c60" frame $f]
	set sel2 [atomselect top "resid $spc" frame $f]
	set crdc60 [$sel1 get {x y z}]
	set crdspc [$sel2 get {x y z}]
	foreach i $crdc60 {
		puts $file2 $i
	}
	foreach i $crdspc {
		puts $file2 $i
	}
	$sel1 delete
	$sel2 delete
}

close $file
close $file2

exit
