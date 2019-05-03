#
# determines if overscan correction must be applied in all images
# for a given subdirectory.
#

procedure classify (basedir, resolution)

string basedir     {prompt="Base directory"}
string resolution  {prompt="image resolution string (i.e. 796x520)"}
string *imglist

begin
	string imgfile, imagedir, img, value, outfile
	bool result


	# The analysis image dir is thw raw subdir because in the reduced
	# subdir the overscan keywords are removed for some images

	basedir  = basedir // "/" 
	imagedir = basedir // "raw/" // resolution // "/"
	outfile  = basedir // "Over_" // resolution // ".txt"	

	result = yes


	# skips if already made

	if(access(outfile))
		return


	# construct the file list to analyze

	imgfile = mktemp("rawimages")
	files(imagedir//"*.fit", > imgfile)
	
	# and iterate through the list, moving each file
	# to its directory

	imglist = imgfile
	while(fscan(imglist, img) != EOF) {
		imgets(img, "biassec")
		value = imgets.value
		if(value == "0") {
			print("image "//img//" has no biassec", >> ccdred.logfile)
			result = no
		}
		;
	}

	# clean up temporary list

	imglist = ""
	delete (imgfile, ver-, >& "dev$null")

	# Create the file if all went ok

	if(result)
		print(value, > outfile)
	
end
	
