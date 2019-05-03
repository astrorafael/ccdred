#!/bin/sh
# the next line restarts using tclsh \
exec tclsh "$0" "$@"

#------------------------------------------------------------------------------
#
# DESCRIPTION
#
# CLI script to reduce a batch of images for a single night
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

if {[lsearch $auto_path [file join $env(HOME) ccdred]] == -1} {
    lappend auto_path [file join $env(HOME) ccdred]
}


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

exit 0

