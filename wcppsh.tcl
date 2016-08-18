package require Tk

source cppsh.tcl

proc doRun {} {
	set d [dict create]
	dict set d Globals [.tMain.tGlobals get 1.0 end]
	dict set d Main    [.tMain.tMain    get 1.0 end]
	dict set d Flags   "-std=c++0x"

	set r [runCC $d]
	set cppout [dGet $r CCOUT]
	if {$cppout ne ""} {
		tk_messageBox -message $cppout
	}

	set execout [dGet $r POUT]
	if {$execout ne ""} {
		.tMain.tOut insert end "$execout\n"
	}
}

### gui
wm withdraw .

toplevel .tMain

# left side
pack [frame .tMain.fL] -side left -anchor nw

pack [label .tMain.lGlobals -text "Global"] -side top -anchor nw -in .tMain.fL
pack [text  .tMain.tGlobals -height 12] -side top -anchor nw -in .tMain.fL

pack [label .tMain.lMain -text "Main"] -side top -anchor nw -in .tMain.fL
pack [text  .tMain.tMain] -side top -anchor nw -in .tMain.fL

pack [label .tMain.lOut -text "Output"] -side top -anchor nw -in .tMain.fL
pack [text  .tMain.tOut] -side top -anchor nw -in .tMain.fL

# right side
pack [frame .tMain.fR] -side left -anchor nw

pack [button .tMain.bRun -text "Run" -command doRun] -side top -anchor n

