#!/bin/sh
# the next line restarts using tclsh \
exec tclsh "$0" "$@"

#------------------------------------------------------------------------------
#
# DESCRIPTION
#
# CLI script to purge auxiliar files from a single night of CCD observations
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


global argc
global argv
global env
global auto_path

# Fixes the auto path to load new package

if {[lsearch $auto_path [file join $env(HOME) ccdred]] == -1} {
    lappend auto_path [file join $env(HOME) ccdred]
}


if { $argc == 0 } {
    puts [mc "Usage: purge.tcl <julian day>"]
    exit 0
}

set basedir [file join $env(HOME) ccd [lindex $argv 0]]

if { ! [file exists $basedir]} {
    puts [format [mc  "Directory %s does not exists"] $basedir]
    exit 1
}

# loads the package
package require nto

nto::Init $basedir
nto::SetLogCallback [code puts]
nto::Purge
exit 0

