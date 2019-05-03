# load language support files, stored in msgs subdirectory

package require msgcat
namespace import -force msgcat::mc 
msgcat::mcload [file join [file dirname [info script]] msgs]


# source the files

source [file join [file dirname [info script]] astro.tcl]
source [file join [file dirname [info script]] menu.tcl]
source [file join [file dirname [info script]] core.tcl]

package provide nto 1.0
