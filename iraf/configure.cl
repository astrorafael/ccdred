#!/iraf/irafbin/bin.linux/ecl.e -f

# $Id: $
# Template CL script automatically 
# generated by  TCL + template file
# Do not edit.

logver = "IRAF V2.12.2 January 2004"
set home   = "/home/astrorafael/ccdred/"
set uparm = "home$uparm/"


# load packages

images
imutil
noao
imred
ccdred

keep

# do the work
{
	cd /home/astrorafael/ccd/2453980


	ccdproc.fixpix=no
	ccdproc.biassec="image"
	ccdproc.trimsec="image"
	ccdproc.overscan=no
	ccdproc.trim=no
	ccdproc.zerocor=no
	ccdproc.darkcor=no
	ccdproc.flatcor=no
	ccdproc.zero=""
	ccdproc.dark="" 
	ccdproc.flat="" 
	ccdproc.ccdtype=""
	ccdproc.output=""
	ccdproc.minreplace=1.
	ccdproc.interactive=no 
	ccdproc.order=1	
	
	logout
}


