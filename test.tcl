source cppsh.tcl

set d [dict create Flags {} Globals {} Main {}]

dict set d Globals {#include <cstdio>}
dict set d Main    {printf("Hello world\n")}

puts [runCC $d]

dict set d Main {std::vector<int> v}
puts [runCC $d]

