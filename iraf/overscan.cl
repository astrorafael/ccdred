#!/iraf/irafbin/bin.linux/ecl.e -f

# $Id: $
# Template CL script automatically 
# generated by  TCL + template file
# Do not edit.

logver = "IRAF V2.12.2 January 2004"
set home   = "/home/astrorafael/ccdred/"
set uparm  = "home$uparm/"

# declare tasks and packages

set ntodir = "home$nto/"
task $nto  = ntodir$nto.cl

# load packages

images
imutil
noao
imred
ccdred
nto

keep

# do the work
{
	overscan("/home/astrorafael/ccd/2453980", "762x511")
	logout
}


