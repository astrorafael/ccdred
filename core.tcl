
#------------------------------------------------------------------------------
#
# DESCRIPTION
#
# This module performs
# 1) Automatic Classifcation of images accordding to its resolution
# 2) Automatic Master Calibration images (Flat, Dar, Zero) as needed
# 3) Automatic reduction of object images
# 4) A backup copy of all images
# 5) A procedure to restart all data reductions
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



# Auxiliar procedure to wrap the proper namespace to a callback

proc code {args} {
    set namespace [uplevel {namespace current}]
    return [list namespace inscope $namespace $args]
}



namespace eval nto {

    # array: module environment
    variable ccdred
    array set ccdred {basedir foo}

    # array: used to instantiate IRAF template scripts 
    variable cl

    # list of all resolutions detected
    variable resolutions

    # array: processing flags
    variable procFlag

    # array: master calibration files
    variable masterFile

    # array: input list files
    variable listFile

    # variable: use catalog
    variable useCatalog 1

    namespace export CalibrationWizard CCDProc CCDRed \
	Init Purge SetLogCallback Register Display \
	SetUseCatalog SetSigClip SetBaseDir
}


#------------------------------------------------------------------------------

# returns a list of image resolutions "ROWSxCOLS"
# should be called at initialization time

proc nto::findResolutions {basedir} {

    global env

    set cwd  [file join $basedir raw]
    if {![file exist $cwd]} {
	return {}
    }
    
    cd $cwd
    if [catch {glob -types d *} resols] {
	set resols {}
    }
    cd ..

    return $resols
}

#------------------------------------------------------------------------------

proc nto::ExecIRAF {clfile} {

    variable cl
    variable ccdred

    set genfile  [file join $ccdred(progdir) iraf $clfile]
    set template ${genfile}.tpl
    set script   ${genfile}.cl

    set fd     [open $template r]
    set stream [read $fd]
    close $fd

    set output [subst -novariables $stream]
    set fd     [open $script w]
    puts $fd $output
    close $fd
    log IRAF [format [mc "Executing script %s"] [file tail $script]]
    exec cl < $script
    update
}

#------------------------------------------------------------------------------

#
# ListGenerator
#
# Inputs:
#
# prefix - either zero, dark or flat

proc nto::ListGenerator {prefix} {

    variable procFlag
    variable listFile
    variable masterFile
    variable ccdred
    variable resolutions
    variable useCatalog

    set masterPfx [string totitle $prefix]

    foreach resol $resolutions {

	# search for an existing master file in the working directory

	set pattern [file join reduced $resol ${masterPfx}*]
	if {![catch {lsort -increasing [glob "$pattern"]} masterList]} {

	    set masterFile($prefix,$resol) [lindex $masterList 0]
	    set procFlag($prefix,$resol) yes
	    log ANALI [format [mc "(%s)(%s) Found: %s"] $resol $prefix [file tail $masterFile($prefix,$resol)]]
	    continue
	} 

	# Master not found in the working directory.
	# Then, search for an existing master file in the global catalog
	# if catalog usage is enabled

	if {$useCatalog == 1} {

	    log ANALI [format [mc "(%s)(%s) No Master File in %s"] $resol $prefix [file tail $ccdred(basedir)]]	    
	    set pattern [file join $resol ${masterPfx}*]
	    set mydir [file join $ccdred(basedir) .. catalog]
	    if {![catch {lsort -increasing [glob -directory $mydir "$pattern"]} masterList]} {
		set masterFile($prefix,$resol) [lindex $masterList 0]
		set procFlag($prefix,$resol) yes
		log ANALI [format [mc "(%s)(%s) Found in catalog: %s"] $resol $prefix [file tail $masterFile($prefix,$resol)]]
		continue
	    } 
	}

	# Master not found in the catalog
	# Search for existing $prefix_* files in the working directory

	log ANALI [format [mc "(%s)(%s) No Master File in catalog"] $resol $prefix]
		
	set pattern [file join reduced $resol ${prefix}_*]
	if {[catch {lsort -increasing [glob $pattern]} allFiles]} {
	    
	    set procFlag($prefix,$resol) no
	    set masterFile($prefix,$resol) ""
	    log ANALI [format [mc "(%s)(%s) No individual images"] $resol $prefix]
	    continue

	} 

	# Classify all $prefix_* files into groups according to a series number
	# The series number identify each key
	# if no files are found then no processing step
	# shoud take place
		
	log ANALI [format [mc "(%s)(%s) Found individual images"] $resol $prefix]
	foreach file $allFiles {
	    set pattern [file join reduced $resol "${prefix}_%2x_%3d.fit"] 
	    scan $file $pattern series seqnum
	    lappend seriesList($resol,$series) $file
	}
		    
	# Find the longest series having bias frames and make the only 
	# list file available for this step
		    
	set max 0
	set pattern "$resol,*"
	foreach key [array names seriesList  $pattern] {
	    set candLen [llength $seriesList($key)]
	    if {$candLen > $max} {
		set max $candLen
		scan $key "%s,%2x" kk series
	    }
	}

	# and finally populates the list file with the file names
		
	set procFlag($prefix,$resol) yes
	set masterFile($prefix,$resol) [file join reduced $resol [format "%s_%02X.fit" $masterPfx $series]]
	set listFile($prefix,$resol)   [format "%s_%s.txt"  $masterPfx $resol]  
	
	log ANALI [format [mc "(%s)(%s) Generated series: %s"] $resol $prefix $listFile($prefix,$resol)]
	
	log ANALI [format [mc "(%s)(%s) Master File to generate: %s"] $resol $prefix [file tail $masterFile($prefix,$resol)]]

	set fd1 [open $listFile($prefix,$resol) w]
	
	foreach filename [lsort -increasing $seriesList($resol,$series)] {
	    puts $fd1 $filename
	}
	close $fd1
    }
}

#------------------------------------------------------------------------------


proc nto::classify {} {

    variable resolutions
    variable ccdred

    log CLASI [format [mc "Classify images by resolution from %s"] [file tail $ccdred(basedir)]]
    ExecIRAF classify

    if {[llength $resolutions] == 0} {
	log CLASI [mc "No images"]
    } 

    log CLASI "-----------------------------------------"    
}

#------------------------------------------------------------------------------

proc nto::ListGenOverscan {} {

    variable cl
    variable resolutions
    variable procFlag
    variable lisFiles


    # generate the input files by calling IRAF
    # IRAF appends to existing files so they are deleted first
    
    foreach resol $resolutions {

	# Avoid calling IRAF if possible

	if [file exists Over_${resol}.txt] {
	    log ANALI [format [mc "(%s) Overscan present"] $resol]
	    set procFlag(over,$resol) yes
	    continue
	}

	set cl(inputlist) [file join reduced $resol *.fit]
	set cl(resolution) $resol
	ExecIRAF overscan

	if [file exists Over_${resol}.txt] {
	    log ANALI [format [mc "(%s) Overscan present"] $resol]
	    set procFlag(over,$resol) yes
	    set listFile(over,$resol) Over_${resol}.txt
	} else {
	    log ANALI [format [mc "(%s) Overscan not present"] $resol]
	    set procFlag(over,$resol) no
	}
    }
}

#------------------------------------------------------------------------------

proc nto::ConfigureIRAF {resol} {
    
    variable cl
    variable procFlag
    variable masterFile

    if { [catch {
	set cl(ccdtype)  ""
	set cl(biassec)  image
	set cl(trimsec)  image
	set cl(overscan) $procFlag(over,$resol)
	set cl(zerocor)  $procFlag(zero,$resol)
	set cl(darkcor)  $procFlag(dark,$resol)
	set cl(flatcor)  $procFlag(flat,$resol)
	set cl(zero)     $masterFile(zero,$resol)
	set cl(dark)     $masterFile(dark,$resol)
	set cl(flat)     $masterFile(flat,$resol)
	ExecIRAF configure

    } myerror]} {

	log ERROR "*********************************************"   
	log ERROR [mc "Execute master files calibration first ! "]    
	log ERROR "*********************************************"   
	return -code break
    }
}

#------------------------------------------------------------------------------

proc nto::MasterCombine {prefix resol} {

    variable cl
    variable masterFile
    variable listFile

    if { ! [file exists  $masterFile($prefix,$resol)] } {
	set cl(input)      $listFile($prefix,$resol)
	set cl(output)     $masterFile($prefix,$resol)
	set cl(process)    yes
	log CALIB [format [mc "(%s)(%s) Making master file"] $resol $prefix]
	ExecIRAF ${prefix}combine
    } else {
	log CALIB [format [mc "(%s)(%s) Nothing to combine for master file"] $resol $prefix]
    }
}

#------------------------------------------------------------------------------


proc nto::CalibrationWizard {} {

    global env

    variable ccdred
    variable cl
    variable resolutions

    variable procFlag
    variable listFile
    variable masterFile

    
    log ANALI "-----------------------------------------"    
    log ANALI [mc "---  STARTING CALIBRATION SEQUIENCE   ---"]
    log ANALI "-----------------------------------------"    

    classify

    # Gather information about what reduction steps are needed
    # returns four arrays indexed by resolution

    ListGenerator zero 
    
    ListGenerator dark 
    
    ListGenerator flat 

    ListGenOverscan
    

    foreach resol $resolutions {

	# Skipping all calibrations not having flats or darks
	
	if {[string equal $procFlag(dark,$resol) no] && 
	    [string equal $procFlag(flat,$resol) no]} {
	   
	    log CALIB "-----------------------------------------"
	    log CALIB [format [mc "(%s) Invalid calibration. Darks and flats needed"] $resol]
	    continue
	}
	
	
	# Skipping all calibrations having only flats
	# without overscan

	if {[string equal $procFlag(zero,$resol) no] && 
	    [string equal $procFlag(dark,$resol) no] &&
	    [string equal $procFlag(flat,$resol) yes]} {

	    log CALIB "-----------------------------------------"
	    log CALIB [format [mc "(%s) Invalid calibration. Darks needed"] $resol]
	    continue
	}


	
	# special case with no overscan or zero correction
	# This is very typical amateur setup where a two sets
	# of darks are needed, one for images and one for flats
	# If we not found a set of flats with the same exposire images as the 
	# flats, then it is a calibration error.
	# the other darks should have the same exposure time as the objects
	
	if {[string equal $procFlag(over,$resol) no] && 
	    [string equal $procFlag(zero,$resol) no] &&
	    [string equal $procFlag(dark,$resol) yes] &&
	    [string equal $procFlag(flat,$resol) yes]} {

	    log CALIB "-----------------------------------------"
	    log CALIB [format [mc "(%s) Calibration with Dark & Flat Dark"] $resol]
	    log CALIB [format [mc "(%s) Calibration not implemented"] $resol]

	    continue
	}
	
	log CALIB "-----------------------------------------"
	log CALIB [format [mc "(%s) Generic calibration"] $resol]
	ConfigureIRAF $resol

	# Generic calibration

	if [string equal $procFlag(zero,$resol) yes] {
	    MasterCombine zero $resol
	}

	if [string equal $procFlag(dark,$resol) yes] {
	    MasterCombine dark $resol
	}

	if [string equal $procFlag(flat,$resol) yes] {
	    MasterCombine flat $resol
	}
    }

    log ANALI "-----------------------------------------"    
    log ANALI [mc "---   CALIBRATION SEQUENCE FINISHED   ---"]    
    log ANALI "-----------------------------------------"    
}


#------------------------------------------------------------------------------

proc nto::ListGenObjects {} {

    variable cl
    variable resolutions
    variable listFile

    # generate the input files by calling IRAF
    # IRAF appends to existing files so they are deleted first

    foreach resol $resolutions {
	log REDUC [format [mc "(%s) Generating object list for reduction"] $resol]
	file delete ${resol}_object
	set cl(images) [file join reduced $resol *.fit]
	set cl(output) "${resol}_"
	set cl(ccdtype) object
	ExecIRAF ccdgroups
	set listFile(object,$resol)  ${resol}_object
	log REDUC [format [mc "(%s) List %s"] $resol  ${resol}_object]
	log REDUC "-----------------------------------------"

    }
}

#------------------------------------------------------------------------------

proc nto::CCDObjects {} {

    variable cl
    variable resolutions
    variable listFile

    ListGenObjects
    
    foreach resol $resolutions {
	log REDUC [format [mc "(%s) Reducing list %s"] $resol $listFile(object,$resol)]
	log REDUC "-----------------------------------------"
	ConfigureIRAF $resol
	set cl(input) $listFile(object,$resol)
	set cl(output) ""
	ExecIRAF ccdproc
    }
}

#------------------------------------------------------------------------------

proc nto::CCDProc {} {

    log REDUC "-----------------------------------------"    
    log REDUC [mc "----    REDUCTION SEQUENCE BEGINS    ----"]
    log REDUC "-----------------------------------------"    

    CCDObjects

    log REDUC "-----------------------------------------"    
    log REDUC [mc "----  REDUCTION SEQUENCE FINISHED   -----"]
    log REDUC "-----------------------------------------"    
}

#------------------------------------------------------------------------------

proc nto::CCDRed {} {

    log REDUC "-----------------------------------------"    
    log REDUC [mc "----    REDUCTION SEQUENCE BEGINS    ----"]
    log REDUC "-----------------------------------------"    

    classify
    CCDObjects

    log REDUC "-----------------------------------------"    
    log REDUC [mc "----  REDUCTION SEQUENCE FINISHED   -----"]
    log REDUC "-----------------------------------------"    
}

#------------------------------------------------------------------------------

proc nto::Purge {} {

    variable ccdred

    log PURGE "-----------------------------------------"    
    log PURGE [mc "-----      PURGE SEQUENCE BEGINS    -----"]
    log PURGE "-----------------------------------------"    

    if {![file exist $ccdred(basedir)]} {
	log PURGE [format [mc "No subdirectory %s !"] [file tail $ccdred(basedir)]]
	log PURGE "-----------------------------------------"    
	log PURGE [mc "-----    PURGE SEQUENCE FINISHED    -----"]
	log PURGE "-----------------------------------------"   
	return
    }

    set cwd [file tail $ccdred(basedir)]
    set filesToPurge [glob -nocomplain *.txt]
    set filesToPurge [concat $filesToPurge [glob -nocomplain *_object]]

    if [file exist reduced] {
	lappend filesToPurge reduced
    }

    if [file exist registered] {
	lappend filesToPurge registered
    }
		      
    foreach file $filesToPurge {
	log PURGE [format [mc "deleting file/subdirectory %s"] $file]
	file delete -force $file
    }


    if [file exist raw] {
	log PURGE [format [mc "copying files from %s"] [file join $cwd raw]]
	file copy raw reduced
    }

    # Truncates IRAF's ccdred logfile

    set logfile [file join $ccdred(basedir) logfile]
    if [file exist $logfile] {
	log PURGE [format [mc "truncating file %s"] [file join $cwd logfile]]
	exec > $logfile
    }


    log PURGE "-----------------------------------------"    
    log PURGE [mc "-----    PURGE SEQUENCE FINISHED    -----"]
    log PURGE "-----------------------------------------"    

}

#--------------------------------------------------------------------------

proc nto::SetLogCallback {cback} {

    variable ccdred

    set ccdred(log) $cback
}

#--------------------------------------------------------------------------

proc nto::log {tag message} {
    
    variable ccdred

    set line [format "%s \[%-5s\] %s" [clock format [clock seconds] -format "%Y-%m-%d %H:%M:%S"] $tag $message] 

    if {[info exists ccdred(log)]} {
	eval {$ccdred(log) $line}
    } else {
	puts stderr [mc "No registered callback for message log"]
    }
}

#--------------------------------------------------------------------------

proc nto::Register {combine} {

    global env
    variable resolutions
    variable XRegListFile
    variable cl
    variable ccdred

    log REGIS "---------------------------------------------"    
    log REGIS [mc "-----   STARTING REGISTERING SEQUENCE   -----"]
    log REGIS "---------------------------------------------"    

    # Create the new directory tree and analyze the input list

    if {![info exists resolutions]} {
	set resolutions [findResolutions $ccdred(basedir)]
    }

    # choose the combination method
    set cl(combine) $combine

    # rearranges the whole batch of input images into groups
    # by image series number

    foreach resol $resolutions {
	file mkdir [file join registered $resol]
	group $resol
    }

    foreach resol $resolutions {
	if {[info exist XRegListFile($resol,input)]} {
	    set N [llength $XRegListFile($resol,input)]
	    for {set i 0} {$i < $N} {incr i} {
		xregister $resol $i
	    }
	}
    }

    log REGIS "---------------------------------------------"    
    log REGIS [mc "-----   REGISTERING SEQUENCE FINISHED   -----"]   
    log REGIS "---------------------------------------------"    
}

#--------------------------------------------------------------------------

proc nto::group {resol} {

    variable XRegListFile

    if {![file exist ${resol}_object]} {
	return
    }

    # decode the input line into components and filter out all files
    # that do not match the <path>/<prefix>_<xx>_<nnn>.fit pattern

    set fd [open ${resol}_object r]
    while {![eof $fd]} {
	set line [gets $fd]
	set num [regexp {(reduced/\d{1,4}x\d{1,4}/)([[:alnum:]]+)_([[:xdigit:]]{2})_(\d{3})\.fit} $line all path prefix series seqnum]
	if {$num != 0} {
	    lappend group($series) $all
	    lappend outfiles($series) [file join registered $resol ${prefix}_${series}_${seqnum}.fit]
	    set pfx($series) $prefix
	}
    }
    close $fd

    # builds up the lists and other auxiliar files

    array unset XRegListFile

    foreach series [array names group] {
	
	# Input file list

	set fname IXReg_$pfx($series)_${series}.txt
	set fd    [open $fname w]
	foreach file $group($series) {
	    puts $fd $file
	}
	close $fd
	lappend XRegListFile($resol,input) $fname
	lappend XRegListFile($resol,N)    [llength $group($series)]
	log REGIS [format [mc "(%s) Input list: %s"] $resol $fname]

	# Output file list

	set fname OXReg_$pfx($series)_${series}.txt
	set fd    [open $fname w]
	foreach file $outfiles($series) {
	    puts $fd $file
	}
	close $fd
	lappend XRegListFile($resol,output) $fname
	log REGIS [format [mc "(%s) Output list: %s"] $resol $fname]

	# Reference file

	set i [llength $group($series)]
	set i [expr {$i/2}]
	set fname [lindex $group($series) $i]
	lappend XRegListFile($resol,reference) $fname
	log REGIS [format [mc "(%s) Reference image: %s"] $resol [file tail $fname]]

	# Shifts file

	set fname SXREG_$pfx($series)_${series}.txt
	lappend XRegListFile($resol,shifts) $fname
	log REGIS [format [mc "(%s) Shifts file: %s"] $resol $fname]

	# Final registered image file

	set fname [file join registered $resol $pfx($series)_${series}.fit] 
	lappend XRegListFile($resol,imoutput) $fname
	log REGIS [format [mc "(%s) Final image: %s"] $resol [file tail $fname]]

    }
}

#--------------------------------------------------------------------------

proc nto::regions {resol} {

    scan $resol "%dx%d" width height
    
    set x1 [expr {$width/3}]
    set x2 [expr {2*$width/3}]
    set y1 [expr {$height/3}]
    set y2 [expr {2*$height/3}]
    
    return "\[$x1:$x2,$y1:$y2\]"
}

#--------------------------------------------------------------------------

proc nto::xregister {resol i} {
    
    variable cl
    variable XRegListFile
    variable optSigClip

    set N             [lindex $XRegListFile($resol,N) $i]
    set cl(input)     [lindex $XRegListFile($resol,input) $i] 
    set cl(output)    [lindex $XRegListFile($resol,output) $i] 
    set cl(reference) [lindex $XRegListFile($resol,reference) $i]
    set cl(shifts)    [lindex $XRegListFile($resol,shifts) $i]
    set cl(imoutput)  [lindex $XRegListFile($resol,imoutput) $i]
    set cl(regions)   [regions $resol]

    if {$optSigClip == 1} {

	if {$N > 10} {
	    set cl(reject) sigclip
	    log REGIS [format [mc "N=%d. Using Sigma Clipping algorithm"] $N]
	} else {
	    set cl(reject) avsigclip
	    log REGIS [format [mc "N=%d. Using Average Sigma Clipping algorithm"] $N]
	}

    } else {
	set cl(reject) none
    }

    ExecIRAF xregister
}

#--------------------------------------------------------------------------

proc nto::Combine {combine} {

    global env
    variable resolutions
    variable XRegListFile
    variable cl
    variable ccdred

    log COMBI "---------------------------------------------"    
    log COMBI [mc "-----   STARTING COMBINING  SEQUENCE    -----"]
    log COMBI "---------------------------------------------"    

    # Create the new directory tree and analyze the input list

    if {![info exists resolutions]} {
	set resolutions [findResolutions $ccdred(basedir)]
    }

    # choose the combination method
    set cl(combine) $combine

    # rearranges the whole batch of input images into groups
    # by image series number

    foreach resol $resolutions {
	group2 $resol
    }

    # combine the images

    foreach resol $resolutions {
	if {[info exist XRegListFile($resol,input)]} {
	    set N [llength $XRegListFile($resol,input)]
	    for {set i 0} {$i < $N} {incr i} {
		combine $resol $i
	    }
	}
    }

    log COMBI "---------------------------------------------"    
    log COMBI [mc "-----    COMBINING SEQUENCE FINISHED    -----"]   
    log COMBI "---------------------------------------------"    
}

#--------------------------------------------------------------------------

proc nto::combine {resol i} {
    
    variable cl
    variable XRegListFile
    variable optSigClip

    set cl(input)     [lindex $XRegListFile($resol,input) $i] 
    set cl(output)    [lindex $XRegListFile($resol,imoutput) $i] 
    set N             [lindex $XRegListFile($resol,N) $i]

    if {$optSigClip == 1} {

	if {$N > 10} {
	    set cl(reject) sigclip
	    log COMBI [format [mc "N=%d. Using Sigma Clipping algorithm"] $N]
	} else {
	    set cl(reject) avsigclip
	    log COMBI [format [mc "N=%d. Using Average Sigma Clipping algorithm"] $N]
	}

    } else {
	set cl(reject) none
    }

    ExecIRAF imcombine
}

#--------------------------------------------------------------------------

proc nto::group2 {resol} {

    variable XRegListFile

    if {![file exist ${resol}_object]} {
	return
    }

    # decode the input line into components and filter out all files
    # that do not match the <path>/<prefix>_<xx>_<nnn>.fit pattern

    set fd [open ${resol}_object r]
    while {![eof $fd]} {
	set line [gets $fd]
	set num [regexp {(reduced/\d{1,4}x\d{1,4}/)([[:alnum:]]+)_([[:xdigit:]]{2})_(\d{3})\.fit} $line all path prefix series seqnum]
	if {$num != 0} {
	    lappend group($series) $all
	    lappend outfiles($series) [file join registered $resol ${prefix}_${series}_${seqnum}.fit]
	    set pfx($series) $prefix
	}
    }
    close $fd

    # builds up the lists and other auxiliar files

    array unset XRegListFile

    foreach series [array names group] {
	
	# Input file list

	set fname ImCom_$pfx($series)_${series}.txt
	set fd    [open $fname w]
	foreach file $group($series) {
	    puts $fd $file
	}
	close $fd
	lappend XRegListFile($resol,input) $fname
	lappend XRegListFile($resol,N)    [llength $group($series)]
	log COMBI [format [mc "(%s) Input list: %s"] $resol $fname]


	# Final combined image file

	set fname [file join reduced $resol $pfx($series)_${series}.fit] 
	lappend XRegListFile($resol,imoutput) $fname
	log COMBI [format [mc "(%s) Final image: %s"] $resol [file tail $fname]]
    }
}


#--------------------------------------------------------------------------

proc nto::Display {} {

    variable XRegListFile
    variable resolutions
    variable ccdred

    log DISPL "---------------------------------------------"    
    log DISPL [mc "-----     STARTING DISPLAY SEQUENCE     -----"]
    log DISPL "---------------------------------------------"    

    set i 1
    foreach resol $resolutions {
	if [info exist XRegListFile($resol,imoutput)] {
	    foreach fname $XRegListFile($resol,imoutput) {
		log DISPL [format [mc "(%s) Frame%d: %s"] $resol $i [file tail $fname]]

		exec xpaset -p ds9 frame frameno $i
		exec xpaset -p ds9 file fits [file join $ccdred(basedir) $fname]
		exec xpaset -p ds9 scale linear
		exec xpaset -p ds9 scale mode zscale
		incr i
	    }
	}
    }

    exec xpaset -p ds9 mode crosshair
    exec xpaset -p ds9 iconify no 
    exec xpaset -p ds9 raise 

    log DISPL "---------------------------------------------"    
    log DISPL [mc "-----     DISPLAY  SEQUENCE FINISHED    -----"]
    log DISPL "---------------------------------------------"    
}

#--------------------------------------------------------------------------

proc nto::UpdateCatalog {} {

    variable masterFile
    variable ccdred
    variable resolutions


    foreach resol $resolutions {
	foreach prefix {zero dark} {

	    set catalog [file join $ccdred(basedir) .. catalog $resol]
	    set pfx [file join $catalog [string totitle $prefix]]

	    set prev [glob -nocomplain -path $pfx *]
	    foreach file $prev {
		log ANALI [format [mc "(%s)(%s) Deleting catalog file %s"] $resol  $prefix [file tail $file]]
		file delete -force $file
	    }


	    if [file exist $masterFile($prefix,$resol)] {
		log ANALI [format [mc "(%s)(%s) Updating catalog file %s"] $resol  $prefix [file tail $masterFile($prefix,$resol)]]
		file mkdir $catalog
		file copy -force $masterFile($prefix,$resol) $catalog
	    }
	}
    }
}

#--------------------------------------------------------------------------

proc nto::PurgeCatalog {} {

    variable ccdred

    set catalog [file join $ccdred(basedir) .. catalog]

    set resolutions [glob -nocomplain -directory $catalog -types d *]

    foreach resol $resolutions {
	log PURGE [format [mc "Purge catalog subdir %s"] [file tail $resol]]
	file delete -force $resol
    }
}

#--------------------------------------------------------------------------

proc nto::SetUseCatalog {boolval} {

    variable useCatalog

    set useCatalog $boolval
    return
}

#--------------------------------------------------------------------------

proc nto::SetSigClip {boolval} {

    variable optSigClip

    set optSigClip $boolval
    return
}

#--------------------------------------------------------------------------

proc nto::SetBaseDir {basedir} {

    variable ccdred
    variable resolutions
    variable cl

    if [string equal $ccdred(basedir) $basedir] {
	return
    }

    set ccdred(basedir) $basedir
    set cl(basedir) $basedir
    cd $basedir
    set resolutions [findResolutions $basedir]
}

#--------------------------------------------------------------------------

proc nto::Init {basedir} {

    global env

    variable cl
    variable ccdred
    variable resolutions
    variable useCatalog
    variable optSigClip

    if [string equal $ccdred(basedir) $basedir] {
	return
    }
    
    set ccdred(basedir) $basedir
    set cl(basedir) $basedir
    cd $basedir
    set resolutions [findResolutions $basedir]

    # makes a dummy directory anyway to show something on the GUI
    # and also makes the catalog directory

    file mkdir [file join $env(HOME) ccd 2450000]
    file mkdir [file join $env(HOME) ccd catalog]

    set ccdred(progdir)   [file join $env(HOME) ccdred]
    set cl(HOME)          $ccdred(progdir)     

    set useCatalog 0
    set optSigClip 0


}
