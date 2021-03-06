package require Tk

source cppsh.tcl

set stdInc {
	"algorithm"
	"cstdio"
	"cstdlib"
	"cstring"
	"iostream"
	"map"
	"sstream"
	"string"
	"vector"
}

proc doRun {} {
	set d [dict create]

	set globals ""

	set i 0
	foreach inc $::stdInc {
		if {[.t.lbInc selection includes $i]} {
			append globals "#include <$inc>\n"
		}
		incr i
	}

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
pack [text  .t.tGlobals -height 12 -yscrollcommand [list .t.sbGlobals set]] -side left -anchor nw -in .t.fGlobals -expand 1 -fill both
pack [scrollbar .t.sbGlobals -orient vertical -command [list .t.tGlobals yview]] -side left -fill y -in .t.fGlobals
.t.splitTB add .t.fGlobals

# main
frame .t.fMain
pack [label .t.lMain -text "Main"] -side top -anchor nw -in .t.fMain
pack [text  .t.tMain -yscrollcommand [list .t.sbMain set]] -side left -anchor nw -in .t.fMain -expand 1 -fill both
pack [scrollbar .t.sbMain -orient vertical -command [list .t.tMain yview]] -side left -fill y -in .t.fMain
.t.splitTB add .t.fMain

# output
frame .t.fOutput
pack [label .t.lOut -text "Output"] -side top -anchor nw -in .t.fOutput
pack [text  .t.tOut -yscrollcommand [list .t.sbOut set]] -side left -anchor nw -in .t.fOutput -expand 1 -fill both
pack [scrollbar .t.sbOut -orient vertical -command [list .t.tOut yview]] -side left -fill y -in .t.fOutput
.t.splitTB add .t.fOutput

# right side
pack [frame .t.fR] -side left -anchor nw

# run button
pack [button .t.bRun -text "Run" -command doRun] -side top -anchor n -in .t.fR

# namespace std
pack [checkbutton .t.cbNsStd -text "namespace std" -variable cbNsStd] -anchor n -in .t.fR; .t.cbNsStd select

# includes
pack [label .t.lInc -text "Includes"] -anchor n -in .t.fR
pack [listbox .t.lbInc -selectmode multiple -listvariable stdInc -exportselection 0] -anchor n -in .t.fR

set i 0
foreach inc $stdInc {
	.t.lbInc selection set $i
	incr i
}

