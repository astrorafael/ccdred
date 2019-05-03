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
	cd /home/astrorafael/ccd/2453561

	print("\n==================================================", >> ccdred.logfile)
	print("=              IRAF ZEROCOMBINE                   ", >> ccdred.logfile)
	print("=", >> ccdred.logfile)
	print("= Directorio   base: /home/astrorafael/ccd/2453561", >> ccdred.logfile)
	print("= Lista  de entrada: @Zero_796x520.txt", >> ccdred.logfile)
	print("= Fichero de salida: reduced/796x520/Zero_07.fit", >> ccdred.logfile)
	print("==================================================\n", >> ccdred.logfile)


	zerocombine @Zero_796x520.txt output="reduced/796x520/Zero_07.fit"  process=yes combine=average reject=minmax nlow=0 nhigh=1
	
	imdelete @Zero_796x520.txt
	logout
}

