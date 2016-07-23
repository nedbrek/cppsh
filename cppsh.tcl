proc dGet {d k} {
	if {[dict exists $d $k]} {
		return [dict get $d $k]
	}

	return ""
}

proc runCC {d} {
	set globals [dGet $d Globals]
	set main    [dGet $d Main]
	set flags   [dGet $d Flags]
	lappend flags {-Wall}

	set f [open "tmp.cpp" "w"]
	puts $f "$globals\n"
	puts $f "int main(int argc, char **argv) {"
	puts $f "$main;\n"
	puts $f "return 0; }"
	close $f

	set execout ""
	if {![catch {exec g++ {*}$flags tmp.cpp} cppout]} {
		catch {exec ./a.out} execout
	}
	return [dict create CCOUT $cppout POUT $execout]
}

