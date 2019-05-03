
#------------------------------------------------------------------------------
#
# DESCRIPTION
#
# Utilities for Tk menu definitions
#
# AUTHOR
#
# Brent Welch's menu package as in his book
# converted to using namespaces by astrorafael@yahoo.es
#
# $Id: $



package require Tk

namespace eval menu {
    
    # array holding the menu mappings
    variable menu

    # menu setup and general operations
    namespace export setup define get 

    # menu subtypes
    namespace export command check radio separator cascade

    # Menu accelerators
    namespace export bind

}

#------------------------------------------------------------------------------

proc menu::setup { menubar } {

    variable menu

    menu $menubar
    
    # Associated menu with its main window
    set top [winfo parent $menubar]
    $top config -menu $menubar
    set menu(menubar) $menubar
    set menu(uid) 0
}

#------------------------------------------------------------------------------

proc menu::define { label } {

    variable menu

    if [info exists menu(menu,$label)] {
	error "Menu $label already defined"
    }

    # Create the cascade menu
    set menuName $menu(menubar).mb$menu(uid)
    incr menu(uid)
    menu $menuName -tearoff 1
    $menu(menubar) add cascade -label $label -menu $menuName

    # remember the name to menu mapping
    set menu(menu,$label) $menuName
}

#------------------------------------------------------------------------------

proc menu::get { menuName } {

    variable menu

    if [catch {set menu(menu,$menuName)} m] {
	return -code error "No such menu: $menuName"
    }
    return $m
}

#------------------------------------------------------------------------------

proc menu::command { menuName label command} {

    set m [get $menuName]
    $m add command -label $label -command $command
}

#------------------------------------------------------------------------------

proc menu::check { menuName label var {command {}} } {

    set m [get $menuName]
    $m add check -label $label -variable $var -command $command
}

#------------------------------------------------------------------------------

proc menu::radio { menuName label var {val {} } {command {}} } {

    set m [get $menuName]
    if {[string length $val] == 0} {
	set val $label
    }

    $m add radio -label $label -variable $var -command $command -value $val
}

#------------------------------------------------------------------------------

proc menu::separator { menuName } {
    [get $menuName] add separator
}

#------------------------------------------------------------------------------

proc menu::cascade { menuName label } {

    variable menu

    set m [get $menuName]
    if [info exists menu(menu,$label)] {
	error "Menu $label already defined"
    }

    set sub $m.sub$menu(uid)
    incr menu(uid)
    menu $sub -tearoff 0
    $m add cascade -label $label -menu $sub
    set menu(menu,$label) $sub
}

#------------------------------------------------------------------------------

proc menu::bind { what sequence menuName label } {

    variable menu
    
    set m [get $menuName]
    if [catch {$m index $label} index] {
	error "$label not in menu $menuName"
    }

    set command [$m entrycget $index -command]
    ::bind $what $sequence $command
    $m entryconfigure $index -accelerator $sequence
}

#------------------------------------------------------------------------------
