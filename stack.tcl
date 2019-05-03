#!/bin/sh
# the next line restarts using tclsh \
exec tclsh "$0" "$@"

#------------------------------------------------------------------------------
#
# DESCRIPTION
#
# CLI script to reduce and stack a batch of images for a single night
# of CCD observations.
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


# The global environment for CCD reductions

global argc
global argv
global env
global auto_path

# Fixes the auto path to load new package

if {[lsearch $auto_path [file join $env(HOME) ccdred]] == -1} {
    lappend auto_path [file join $env(HOME) ccdred]
}

# loads the package
package require nto

if { $argc == 0 } {
    puts [mc "Usage: ccdred.tcl <julian day>"]
    exit 0
}

set basedir [file join $env(HOME) ccd [lindex $argv 0]]

if { ! [file exists $basedir]} {
    puts [format [mc  "Directory %s does not exists"] $basedir]
    exit 1
}


nto::Init $basedir
nto::SetLogCallback [code puts]

# find out the calibration needed and generate calibration files

nto::CalibrationWizard 
    
# reduce object images
    
nto::CCDProc 

# Launch visualization tool

set ds9 [exec xpaaccess ds9]

if [string equal $ds9 no] {
    exec ds9 -iconify -xpa &
}

# stack and display groups of images

nto::Register average
nto::Display 

exit 0

