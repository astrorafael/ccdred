#!/iraf/irafbin/bin.linux/ecl.e -f

# $Id: $
# Template CL script automatically 
# generated by  TCL + template file
# Do not edit.

logver = "IRAF V2.12.2 January 2004"
set home      = "/home/astrorafael/ccdred/"
set uparm     = "home$uparm/"
reset imextn  ="fxf:fits,fit,fts"
reset imtype  = fits 
flpr

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

	print("\n==================================================", >> ccdred.logfile)
	print("=                  IRAF CCDPROC                   ", >> ccdred.logfile)
	print("=", >> ccdred.logfile)
	print("= Directorio  base: /home/astrorafael/ccd/2453980", >> ccdred.logfile)
	print("= Lista de entrada: @762x511_object", >> ccdred.logfile)
	print("==================================================\n", >> ccdred.logfile)

	ccdproc @762x511_object output=""
	logout
}

