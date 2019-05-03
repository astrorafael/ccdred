#
# Classify FITS images in subdirs according to its cols x rows resolution.
# Files are moved under the 'reduced' subdirectory 
# A backup copy is created under the 'raw' subdirectory
#

procedure classify (basedir)

string basedir {prompt="Base directory"}
string *imglist

begin
	string imgfile, rows, cols, isubdir, osubdir, img

	# make sure some packages are loaded

	# make the 'raw' and 'reduced' subdirs
	
	basedir = basedir // "/"

	if(! access(basedir//"raw"))
		mkdir(basedir//"raw")

	if(! access(basedir//"reduced"))
		mkdir(basedir//"reduced")

	# construct the file list to analyze

	imgfile = mktemp("rawimages")
	files(basedir//"*.fit", > imgfile)
	
	# and iterate through the list, moving each file
	# to its directory

	imglist = imgfile
	while(fscan(imglist, img) != EOF) {

		imgets(img, "i_naxis1")
		rows = imgets.value
		imgets(img, "i_naxis2")
		cols = imgets.value

		# build the subdir name
		# create it if not exists
		# and move the file there

		isubdir = basedir // "raw/"     // rows // "x" // cols	
	
		if (!access(isubdir))
			mkdir(isubdir)

		osubdir = basedir // "reduced/" // rows // "x" // cols	

		if (!access(osubdir))
			mkdir(osubdir)

		copy(img, osubdir, ver-)
		movefiles(img, isubdir, ver-)

	}

	# closes the list and cleans up temporary file

	imglist = ""
	delete (imgfile, ver-, >& "dev$null")
	
end
	
