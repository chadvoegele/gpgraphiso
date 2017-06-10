#!/usr/bin/gawk -f

/^%/ {next;}
line_no == 0 { print "p sp", $1, $3; line_no++; next;}
line_no > 0 && NF == 3 {print "a", $1, $2, $3}
line_no > 0 && NF == 2 {print "a", $1, $2, 1}
