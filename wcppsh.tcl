package require Tk

source cppsh.tcl

proc doRun {} {
	set d [dict create]

	set globals ""
	if {$::cbNsStd} {
		append globals "using namespace std;\n"
	}

	dict set d Globals "${globals}[.t.tGlobals get 1.0 end]"
	dict set d Main    [.t.tMain    get 1.0 end]

	set flags [list]
	lappend flags "-std=c++0x"
	dict set d Flags $flags

	set r [runCC $d]
	set cppout [dGet $r CCOUT]
	if {$cppout ne ""} {
		tk_messageBox -message $cppout
	}

	set execout [dGet $r POUT]
	if {$execout ne ""} {
		.t.tOut insert end "$execout\n"
	}
}

### gui
wm withdraw .

toplevel .t

# left side
pack [frame .t.fL] -side left -anchor nw

# globals
pack [label .t.lGlobals -text "Global"] -side top -anchor nw -in .t.fL
pack [text  .t.tGlobals -height 12] -side top -anchor nw -in .t.fL

# main
pack [label .t.lMain -text "Main"] -side top -anchor nw -in .t.fL
pack [text  .t.tMain] -side top -anchor nw -in .t.fL

# output
pack [label .t.lOut -text "Output"] -side top -anchor nw -in .t.fL
pack [text  .t.tOut] -side top -anchor nw -in .t.fL

# right side
pack [frame .t.fR] -side left -anchor nw

# run button
pack [button .t.bRun -text "Run" -command doRun] -side top -anchor n -in .t.fR

# namespace std
pack [checkbutton .t.cbNsStd -text "namespace std" -variable cbNsStd] -anchor n -in .t.fR; .t.cbNsStd select

