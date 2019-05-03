#!/bin/sh
# the next line restarts using wish \
exec wish "$0" "$@"

#------------------------------------------------------------------------------
#
# DESCRIPTION
#
# GUI script for CCD data reduction and optional stacking process
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

#--------------------------------------------------------------------------

image create photo ::icon::nto025
::icon::nto025 put {
R0lGODlhhQAwAPcAAAQEBGR+hCQmbLy+xFRTdISGzDQ2NDw6nBQWPFRSlKSi
xDw+bNzg7HymrKSm5Hh+pLy+5GxqbBweHDw+hCQmPMzO5JSUpGxslDQzhFFS
VERDtLSyxLSz5A0OJFxedExKhNTu/JSWxLy+9CwqXHyOnDQ2VHx+tGxshBQU
FDQzbFZWhERGnB0eVKOl1ExNbCsrLHR2nLO19GBglEFBlMzQ9JSVtKTOzIyy
vDg4lISClJye5NnY9ERERBwdTOTq7IaHpDQyPJ+e1MbH9HR2hAwLDEJBfJye
tKyu9Do6hExLtLS11O/v9GNhpFxadEJBrBwePKurxKyu5BweLERGjIyapHNx
pFxiZBQTNGBghJyexDIzfLy69CwufIySxBwaRMzK5EBAjFROZLy65ExKlDAw
VGxyjFxahEZHrKiq3DAyNHh4rGdmlNLR1HyGlCwudLy+1FZWfDw+RERCnENB
dKao7ICArHR6fIiSrHRylDQ1jBMRLExMjJeYzDxCXISGtGpsjBoaHKSmpISK
jIy6vMTGxNTW1FRSpKyutHyWnOPi/CwqTOvq/DExTJSQ1DQyZGxrfERGxExK
fExKxExOpDw+PFxalCQmJDw6bJyavEpKTKSmvLy61PT2/CQmNGRmhKyqrHx+
hMT2/EVGlJSWlJSK1ISKnERGfFRWZExefCwqdDc4PFxWnKWmzMTC7CIhJCQm
RFRSXLCzzL2//CQmZFRVjCQiXKSm3CwuNHd5pLS2/NLS/ICAnNvZ/IiIrCwu
RMfI/Hl5jA4MFKCgvPHw/FxejMfH7CwuXMzO3MTC3EFBZImKvMzKzNza3AQG
DDw+pISCpGxudGxunERGvLSz7BQWHFRGnExMdJSTvOTm9ExKvLSy3BwiNExC
jIyKlKSirDw6jLi6/IyOnFxafKyu7JyapJyezLy67FxajJSSrHRynDw6dGRm
jHx+jCsqbIyKzBgaPERCbKyq5MTC5ERChCwqPNTS5FRWVBQSJE5OhMzy/Jia
xMTC9Dw6VISCtExKnCQiVCH5BAAAAAAALAAAAACFADAABwj/ACUJHEiwoMGD
CBMqXMiwocOHECNKnFhQmopTkwhCknRmDj4NFEOKHEkyocVtTzRsHIhkW5gZ
JWPKnOlQmjMBVw5slDZLDwIvK2kKHSoUkrMrs3AgYKGBSy2iUKOWhKShQzMB
Gw8gkCa1q1eHkA4gxaBHgDStQb+qXUuVxTscGyGx6JEHgcq1eLtCgpTnClaN
efQEc5a3MFGqPbw4SzuwqmLGhiNP3IvhChfIAyEhQKAHA2bJoBdCcpJ48UIW
eZy96+Hkc+jXAvdyueK5oYBZkiClou0atmSjCHqYbuh0oDMvLJz49g1J2u48
vQtCwtEjKCQBeqAvBx02OOGIR9OG/0UqLfr2oc1xwpU4GgHj5rUQ6DyvdjqC
Wncn6xmuEYff8vRFRdUsCKwXkjR2IdQcCwjwF6BMe/VVC4Aj0dVbYGY9CKEG
DM5HEiRe4MDQcY95ZR56gc1CYUmppGIeJLNdpiFFozH43Uy3gXVccifOGBsk
WvjVY0Q4sAARJG7wNuRD4gloFAslFoXWkf4xtWRCcSmUZWYjwaiHi1Fp4MWK
YNVyBXRXRhRdmmF5IVxXGlwBEns46IFfSGk21Jtzesiolxet0chCTnni1eab
X4F442RclEVmTMkskJozGlRqKUTSYOenWhaOhGCDhcZWkBOEMDPKJ59sAEUO
eAADzB8XwP8jKz5jTAHGBCuApIE0dQFamAB5TMVFB6lwBZY0yCKbTbKSzBAA
MwP4wMm01HKCzTLVDrMEM2wMIMgpq/zQRGfvccnllivlmcosoRakwWYOHrQR
Fy2ywAULqdDrxhk3DMLAIYsMI/DAwzBwDMEDL4ING4+UMoIVH4CUroIMDRkX
DrhBOEsHXDxq0G21bENBJ74w4sssCYTSADbeLALCIoks4vIiFRwDs8wxx3yM
N6BQEc4jj/wRzTkLXLKArWCckUQSTuy6q7ExKeWxSAfo0UN+uWU90G2zqKIK
JRmEPQseICCSiBGJJMJL2msn8oY8O8S9Q9tp7zBE2mqzjfcOyLz/EcsGmtyB
yTW9wCrDFMg6jayoWaPbuCTSqONKEVr3tqVC0tSS3dSSzOJ5GmmoksnoswCz
CBW83KE2L6y3XowSSsQiOxRQKEC7MOy0rjsvuuzuOy80WHCCJ8RggQUqcMBB
jAwyVEILPh8UIcoKK4hi/QyigDHDBDC8ss4K0jxdXpaXM65QHh34soZyH9cy
yy0vGMDD/LOUAQIJutyhy/778947//3rHe+K8QMAGvCACFRCDRDIQP4JQQjF
aAUE2FEGFwwPD+nARR3qgAt1rIIWl3AEGL4hhyRUilmXSyEcyGCISjDtAlVI
Rwz5YbJbWOIWlMjhLGiRjzb84hm/CKIQ/4dIRCFqQxsnYIUSl8hEBXCgiEJs
xS5qIEQh7MOKVxQCFIvIimvwAYqtgEMQgigEc7AiC9fYxQNwoQIV7CEFKUDC
N75BKUshCxJz6AIf0CgMchSCDYCMwPxeYIn4qcIAs3CCDUggi178QhaPfCQk
JxlJSpajBbioJCUhOQ00VPKTsmiBPiAZhSy04JSnDAEktyjEKHShC5GspDmi
wQdziEAEsshlEFc5RA6Uoxw/gAEemuACFZDBGMnAZSS7EYhmBiIDh3SFBAqZ
hlvgBhUPiAEMcgmOXHpTFt0EpzhlkQt9tKAO30ynLKYRBHVyMwZ3UKUsHICG
W4pgC+DIAjj2yf/PfYqzmyHohTKmMY0oRMEBDrCFMlygjnk4VAWoaKMKomGC
itaBD+MYRxQyuoUYeHQLIF3HFr75CDuY1A6UKKQEAOGKF7gUN9KIhgP8kIua
2vSm4MhFTm0agyDwQRlHCKpQgzqOIzigC0VN6jjocIRxBOEPxVQBHEpgDKpa
FQ4qwEfytFoJJnjVq6sYAw7GioMDOOOslMIMVdDqDAxw4a1c+MYETDEBhxpD
EcmoaU7BAYvRjc4SgEABIAAhAVdYwhUZKwE8PlCJSkSjCmqoqDt04AAd0IGp
Qh1HDKogh0lMYgWf/ewK5CCHGeDAtGP9Rh5Ui4E85IFz2zlDARpBCtqB0kMC
hQVEMIjQDBT4FrcSyJi8nMDWPOSrs5MQRRHGkBEfDcU59GrRZrywW9+igBoZ
I9/jtMvd7Xq3u+D9rnjDS97xmre7kuDabomAAvYK17kz8twsmtEMADSDt++F
74NAVl8A+BcA+dUvfeR7hR4UeC4BFvB2DlBWDODAwQdgcEAAADs=
}

#-----------------------------------------------------------

global env
global auto_path

# Fixes the auto path to load new package

if {[lsearch $auto_path [file join $env(HOME) ccdred]] == -1} {
    lappend auto_path [file join $env(HOME) ccdred]
}

package require nto

#--------------------------------------------------------------------------

proc Init {} {

    global tkccd
    global env


    # makes a dummy directory anyway to show something on the GUI
    # and also makes the catalog directory

    file mkdir [file join $env(HOME) ccd 2450000]
    file mkdir [file join $env(HOME) ccd catalog]

    # Initialize widget related variables

    set tkccd(calibtype) [mc All]
    set tkccd(logcheck)   0
    set tkccd(xregcheck)  1
    set tkccd(purgeDir)   1
    set tkccd(usecatalog) 0
    set tkccd(sigclip)    1

    set pattern [file join $env(HOME) ccd 2*]
    set tkccd(basedir) [lindex [lsort -decreasing [glob -types d $pattern]] 0]
    trace variable tkccd(basedir) w UpdateDate
   

    nto::Init $tkccd(basedir)
    nto::SetLogCallback    LogLine
    nto::SetUseCatalog     $tkccd(usecatalog)
    nto::SetSigClip        $tkccd(sigclip)

}

#--------------------------------------------------------------------------

proc CreateGUI {} {

    global tkccd
    global env

    wm title . [mc "Automatic reductions with IRAF"]
    
    menu::setup .menubar

    # Menu Archivo
    menu::define  [mc File]
    menu::command [mc File] [mc "Purge"] Purge
    menu::separator [mc File]
    menu::check [mc File] [mc "Purge directory"] tkccd(purgeDir) 
    menu::check [mc File] [mc "Purge catalog"]   tkccd(purgeCat) 
    menu::check [mc File] [mc "Purge screen"]    tkccd(purgeScr) 
    menu::separator [mc File]
    menu::command [mc File] [mc Exit] {exit 0}

    # Menu Ver
    menu::define    [mc View]
    menu::command   [mc View] [mc "IRAF console"] IRAFConsole
    menu::command   [mc View] [mc "DS9 tool"]     DS9Tool
    menu::separator [mc View]
    menu::check     [mc View] [mc "IRAF logfile"] tkccd(logcheck) DoIRAFLogfile

    # Menu Calibracion
    menu::define    [mc Calibration]
    menu::command   [mc Calibration] [mc Calibrate] DoCalibration
    menu::separator [mc Calibration]
    menu::radio     [mc Calibration] [mc "Only Master Files"]     tkccd(calibtype) 
    menu::radio     [mc Calibration] [mc All]                     tkccd(calibtype) 
    menu::separator [mc Calibration]
    menu::check     [mc Calibration] [mc "Use catalog" ] tkccd(usecatalog) DoUseCatalog
    menu::check     [mc Calibration] [mc "Masters -> Catalog" ] tkccd(catalog) 


    # Menu Apilado

    menu::define    [mc Images] 
    menu::command   [mc Images] [mc Average]           {DoCombine average}
    menu::command   [mc Images] [mc "Median Combine"]  {DoCombine median}
    menu::separator [mc Images]
    menu::check     [mc Images] [mc Register]         tkccd(xregcheck)
    menu::check     [mc Images] [mc "Sigma Clipping"] tkccd(sigclip) DoSigmaClip 


    # Menu Ayuda
    menu::define  [mc Help]
    menu::command [mc Help] [mc "About ..."] {wm deiconify .about}

    frame .top -borderwidth 10
    pack  .top -side top -fill x

    label .top.lab1 -text [mc Directory]
    entry .top.dir -width 20 -relief sunken -textvariable tkccd(basedir) 
    set tkccd(date) [label .top.date -text "" -pady 3]
    set tkccd(basedir) $tkccd(basedir)

    pack .top.date -side top -fill x -expand true
    pack .top.lab1 -side left
    pack .top.dir -side top -fill x -expand true

    # Create upper text widget

    frame .frame1
    set tkccd(log) [text .frame1.log -width 80 -height 40 -borderwidth 2 -relief sunken \
		 -setgrid true -yscrollcommand {.frame1.scroll set} -state disabled] 
    scrollbar .frame1.scroll -command {.frame1.log yview}
    pack .frame1.scroll -side right -fill y
    pack .frame1.log -side left -fill both -expand true


    # pack both panels

    pack .frame1 -side top -fill both -expand true
}

#--------------------------------------------------------------------------

proc UpdateDate {name1 name2 op} {

    global tkccd

    set jd [file tail $tkccd(basedir)]

    astro::jd2calen $jd day1 month year
    set day2 [expr {$day1 +1}]

    .top.date configure -text [format [mc "Night %3\$s, %1\$s to %2\$s, %4\$s"] $day1 $day2 $month $year]
}


#--------------------------------------------------------------------------

proc DoCalibration {} {

    global tkccd

    update

    if {![file exists $tkccd(basedir)]} {
	global argv0
	tk_messageBox -message [format [mc "Directory does not exists:\n%s"] $tkccd(basedir)] \
	    -icon error -type ok -title [format [mc "Error in %s"] [file tail $argv0]]
	return
    }

    nto::SetBaseDir $tkccd(basedir)

    if {[string equal $tkccd(calibtype) [mc "Only Master Files"]]} {

	nto::CalibrationWizard
   
    } else {

	nto::CalibrationWizard
	nto::CCDProc          
    }

    DumpIRAFLogfile

    if {$tkccd(catalog) == 1} {
	nto::UpdateCatalog
    }
}

#--------------------------------------------------------------------------

proc LogLine {line} {

    global tkccd

    $tkccd(log) configure -state normal
    $tkccd(log) insert end $line\n
    $tkccd(log) see end 
    $tkccd(log) configure -state disabled
    
    update idletasks
}

#--------------------------------------------------------------------------

proc Purge {} {
    
    global tkccd

    update

    nto::SetBaseDir $tkccd(basedir)

    if {$tkccd(purgeDir) == 1} {
	nto::Purge
    }

    if {$tkccd(purgeCat) == 1} {
	nto::PurgeCatalog
    }

    if {$tkccd(purgeScr) == 1} {

	$tkccd(log) configure -state normal
	$tkccd(log) delete 1.0 end
	$tkccd(log) configure -state disabled
	
	$tkccd(logiraf) configure -state normal
	$tkccd(logiraf) delete 1.0 end
	$tkccd(logiraf) configure -state disabled
    }
}

#--------------------------------------------------------------------------

proc CreateIRAFGUI {} {

    global tkccd

    toplevel .iraf

    wm title    .iraf [mc "IRAF logfile"]
    wm protocol .iraf WM_DELETE_WINDOW HideIRAFLogfile
    wm minsize  .iraf 125 25
    wm withdraw .iraf

    set tkccd(logiraf) [text .iraf.log -width 80 -height 40 -borderwidth 2 -relief sunken \
			    -setgrid true -yscrollcommand {.iraf.scroll set} -state disabled] 
    scrollbar .iraf.scroll -command {.iraf.log yview}
    pack .iraf.scroll -side right -fill y
    pack .iraf.log -side left -fill both -expand true

    set tkccd(position) [wm geometry .iraf]
}

#--------------------------------------------------------------------------

proc HideIRAFLogfile {} {

    global tkccd

    set tkccd(position) [wm geometry .iraf]
    wm withdraw .iraf
    set tkccd(logcheck) 0
}

#--------------------------------------------------------------------------

proc DumpIRAFLogfile {} {

    global tkccd

    set logfile [file join $tkccd(basedir) logfile]

    if {![file exist $logfile]} {
	tk_messageBox -message [format [mc "No IRAF logfile in directory\n%s"] $tkccd(basedir)] \
	    -icon error -type ok -title "Error"
	return
    }

    set size     [file size $logfile]
    set fd       [open $logfile r]
    set contents [read $fd $size]
    close $fd    

    $tkccd(logiraf) configure -state normal
    $tkccd(logiraf) insert end $contents\n
    $tkccd(logiraf) see end 
    $tkccd(logiraf) configure -state disabled
    update idletasks
}

#--------------------------------------------------------------------------

proc ShowIRAFLogfile {} {

    global tkccd

    wm geometry  .iraf $tkccd(position)
    wm deiconify .iraf

}

#--------------------------------------------------------------------------

proc DoIRAFLogfile {} {

    global tkccd

    if {$tkccd(logcheck) == 1} {
	ShowIRAFLogfile
    } else {
	HideIRAFLogfile
    }
}

#--------------------------------------------------------------------------

proc Main {} {
    Init
    CreateGUI
    CreateIRAFGUI
    CreateAboutGUI
}

#--------------------------------------------------------------------------

proc CreateAboutGUI {} {

    global tkccd

    toplevel .about

    wm title    .about [mc "About TkCCDRed"]
    wm protocol .about WM_DELETE_WINDOW {wm withdraw .about}
    wm withdraw .about

    label .about.img -image ::icon::nto025
    label .about.author \
	-text [mc "TkCCDRed 1.0\nby Rafael Gonzalez\nastrorafael@yahoo.es"]
    button .about.b -text "Ok" -command {wm withdraw .about}
    pack  .about.author .about.img .about.b -side top -fill both -expand true

    set tkccd(position) [wm geometry .about]
}

#--------------------------------------------------------------------------

proc DoCombine {combine} {

    global tkccd

    update

    if {![file exists $tkccd(basedir)]} {
	global argv0
	tk_messageBox -message [format [mc "Directory does not exists:\n%s"] $tkccd(basedir)] \
	    -icon error -type ok -title [format [mc "Error in %s"] [file tail $argv0]]

	return
    }

    nto::SetBaseDir $tkccd(basedir)

    set ds9 [exec xpaaccess ds9]

    if [string equal $ds9 no] {
	exec ds9 -iconify -xpa &
    }



    if {$tkccd(xregcheck) == 1} {
	nto::Register $combine
    } else {
	nto::Combine  $combine
    }

    DumpIRAFLogfile

    nto::Display 
}

#--------------------------------------------------------------------------

proc DoUseCatalog {} {

    global tkccd

    nto::SetUseCatalog $tkccd(usecatalog)
}

#--------------------------------------------------------------------------

proc DoSigmaClip {} {

    global tkccd

    nto::SetSigClip $tkccd(sigclip)
}

#--------------------------------------------------------------------------

proc IRAFConsole {} {

    global env

    set cwd [pwd]
    cd $env(HOME)
    exec xgterm -e cl  &
    cd $cwd
    update
}

#--------------------------------------------------------------------------

proc DS9Tool {} {

    set ds9 [exec xpaaccess ds9]

    if [string equal $ds9 no] {
	exec ds9 -xpa &
    } else {
	exec xpaset -p ds9 mode crosshair
	exec xpaset -p ds9 iconify no 
	exec xpaset -p ds9 raise 
    }   
    update
}


#--------------------------------------------------------------------------


Main


