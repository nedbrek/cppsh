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
pack [ttk::panedwindow .t.splitTB -orient vertical] -expand 1 -fill both -side left

# globals
frame .t.fGlobals
pack [label .t.lGlobals -text "Global"] -side top -anchor nw -in .t.fGlobals
pack [text  .t.tGlobals -height 12] -side top -anchor nw -in .t.fGlobals -expand 1 -fill both
.t.splitTB add .t.fGlobals

# main
frame .t.fMain
pack [label .t.lMain -text "Main"] -side top -anchor nw -in .t.fMain
pack [text  .t.tMain] -side top -anchor nw -in .t.fMain -expand 1 -fill both
.t.splitTB add .t.fMain

# output
frame .t.fOutput
pack [label .t.lOut -text "Output"] -side top -anchor nw -in .t.fOutput
pack [text  .t.tOut] -side top -anchor nw -in .t.fOutput -expand 1 -fill both
.t.splitTB add .t.fOutput

# right side
pack [frame .t.fR] -side left -anchor nw

# run button
pack [button .t.bRun -text "Run" -command doRun] -side top -anchor n -in .t.fR

# namespace std
pack [checkbutton .t.cbNsStd -text "namespace std" -variable cbNsStd] -anchor n -in .t.fR; .t.cbNsStd select

