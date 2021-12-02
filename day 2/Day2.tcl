set in_f [open "Day2.txt" "r"]
set in_s [read $in_f]

set parsed_input [regexp -all -inline {(?:up|down|forward) [0-9]+} $in_s]

set pos_x 0
set pos_y 0

foreach i $parsed_input {
    if {[lindex $i 0] == "forward"} {
        set pos_x [expr $pos_x + [lindex $i 1]]
    }
    if {[lindex $i 0] == "up"} {
        set pos_y [expr $pos_y - [lindex $i 1]]
    }
    if {[lindex $i 0] == "down"} {
        set pos_y [expr $pos_y + [lindex $i 1]]
    }
}
puts [expr $pos_x * $pos_y]

set pos_x 0
set pos_y 0
set aim 0

foreach i $parsed_input {
    if {[lindex $i 0] == "forward"} {
        set pos_x [expr $pos_x + [lindex $i 1]]
        set pos_y [expr $pos_y + $aim  * [lindex $i 1]]
    }
    if {[lindex $i 0] == "up"} {
        set aim [expr $aim - [lindex $i 1]]
    }
    if {[lindex $i 0] == "down"} {
        set aim [expr $aim + [lindex $i 1]]
    }
}

puts [expr $pos_x * $pos_y]

close $in_f