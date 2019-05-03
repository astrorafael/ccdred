#------------------------------------------------------------------------------
#
# DESCRIPTION
#
# This module performs
# 1) Julian date to calendar coversions
#
# AUTHOR
#
# Rafael González Fuentetaja
# (astrorafael@yahoo.es)
#
# LEGAL STATEMENTS
#
# This file is protected by the GNU GPL License. 
# See the GNU.txt file.
#
# $Id: $

namespace eval astro {

    variable monthlabel

    set monthlabel(1) [mc January]
    set monthlabel(2) [mc February]
    set monthlabel(3) [mc March]
    set monthlabel(4) [mc April]
    set monthlabel(5) [mc May]
    set monthlabel(6) [mc June]
    set monthlabel(7) [mc July]
    set monthlabel(8) [mc August]
    set monthlabel(9) [mc September]
    set monthlabel(10) [mc October]
    set monthlabel(11) [mc November]
    set monthlabel(12) [mc December]

    namespace export jd2calen
}

#------------------------------------------------------------------------------

# calculates calendar date from julian Day
# "Astronomical Algorithms" J. Meeus, page 63

proc astro::jd2calen {jd d m y} {
    upvar $d day
    upvar $m month
    upvar $y year

    variable monthlabel

    set Z [expr {int($jd + 0.5)}]
    set F [expr {$jd+0.5-double($Z)}]
    
    if { $Z < 2299161 } {
	set A $Z
    } else {
	set alpha [expr {int((double($Z)-1867216.25)/36524.25)}]
	set A     [expr {$Z + 1 + $alpha - int($alpha/4)}]
    }

    set B [expr {$A + 1524}]
    set C [expr {int(($B -122.1)/365.25)}]
    set D [expr {int(365.25 * $C)}]
    set E [expr {int(($B-$D)/30.6001)}]
    
 
    set day [expr {$B-$D-int(30.6001 * $E) }]
    
    if {$E < 14} {
	set mon [expr {$E-1}]
    } else {
	set mon [expr {$E-13}]
    }

    if {$mon > 2} {
	set year [expr {$C-4716}]
    } else {
	set year [expr {$C-4715}]
    }

    set month $monthlabel($mon)
    return
}

