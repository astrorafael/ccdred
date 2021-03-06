#!/iraf/irafbin/bin.linux/ecl.e -f

# $Id: $
# Template CL script automatically 
# generated by  TCL + template file
# Do not edit.

logver = "IRAF V2.12.2 January 2004"
set home   = "[set cl(HOME)]/"
set uparm  = "home$uparm/"
reset imextn  ="fxf:fits,fit,fts"
reset imtype  = fits 
flpr

# load packages

images
imutil
immatch
noao
imred
ccdred

package user
task $grep = "$foreign"

keep

# do the work
{
	cd [set cl(basedir)]

	print("\\n==================================================", >> ccdred.logfile)
	print("=              IRAF IMCOMBINE                   ", >> ccdred.logfile)
	print("=", >> ccdred.logfile)
	print("= Directorio   base: [set cl(basedir)]", >> ccdred.logfile)
	print("= Lista  de entrada: @[set cl(input)]", >> ccdred.logfile)
	print("= Imagen de  salida: [set cl(output)]", >> ccdred.logfile)
	print("==================================================\\n", >> ccdred.logfile)

	print("ImCombine: Borrando imagen final", >> ccdred.logfile)
	imdelete  [set cl(output)]


	print("ImCombine: Combinando imagenes", >> ccdred.logfile)
	imcombine("@[set cl(input)]", "[set cl(output)]", \
		combine="[set cl(combine)]", reject="[set cl(reject)]", \
		lsigma=3, hsigma=3,\
		mclip+, nkeep=1, project-, logfile=ccdred.logfile)	
	print("ImCombine: TERMINADO", >> ccdred.logfile)
	logout
}
