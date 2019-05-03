#
# Bootstrap method for finding gain and rnoise from a set of
# flats and darks
#

procedure bootgain (flatfile, zerofile, resfile)

string flatfile 		{prompt="list of flat files"}
string zerofile 		{prompt="list of bias files"}
string resfile  		{prompt="output file with measures"}
string section = "" 		{prompt="image section to compute"}
bool   verbose = yes		{prompt="verbose output?"}


string *flat1list
string *flat2list
string *zero1list
string *zero2list

begin
	string ze1, ze2, fl1, fl2, ffile, zfile, res
	real r
	file grfile, combfile
	bool pp

	# Query parameters first

	ffile  = flatfile
	if(!access(ffile))
		error(1, "No flat file list found")

	zfile  = zerofile
	if(!access(zfile))
		error(1, "No bias file list found")

	res    = resfile
	if(access(res)) {
		delete(res)
		delete("gain_"//res)
		delete("rdnoise_"//res)
	}

	# image pairs file and gain readout noise file

	combfile = mktemp("tmp$iraf")
	grfile   = mktemp("tmp$iraf")

	flat1list = ffile

	while(fscan(flat1list, fl1) != EOF) {

	  # opens the same zero file again and
	  # skips fl2 files till pointer equals fl1
	  
          flat2list = ffile
          fl2 = ""
          while(fl2 != fl1) 
            x = fscan(flat2list, fl2)

	  # now read fl2 image and 
          # proceed with the zero combination

	  while(fscan(flat2list, fl2) != EOF) {
            zero1list = zfile
	    while(fscan(zero1list, ze1) != EOF) {
	      
              # opens the same zero list again and skips
              # till flat pointers are equal

	      zero2list = zfile
              ze2 = ""
              while(ze2 != ze1) 
                r = fscan(zero2list, ze2)
	      while(fscan(zero2list, ze2) != EOF) {
		if (verbose == YES) 
	              print(fl1 // " " // fl2 // " " // ze1 // " " // ze2)
	        print(fl1 // " " // fl2 // " " // ze1 // " " // ze2,>>combfile)
	        findgain2(fl1, fl2, ze1, ze2, section=section, ver-, >> grfile)
	      }
	      zero2list = ""
	    }
	    zero1list = ""
	  }
	  flat2list = ""
	}
	flat1list = ""
	
	# splits values in two auxiliary files
	# reuses the zerolists variables
	# also exports in CSV Format suitable to import in spreadsheet

	zero1list  = grfile
	zero2list  = combfile

	printf("FLAT-1\tFLAT-2\tBIAS-1\tBIAS-2\tGAIN\tRDNOISE\n", >res)
	while(fscanf(zero1list, "%g %g", x, y) != EOF) {
	  r= fscanf(zero2list, "%s %s %s %s" , fl1, fl2, ze1, ze2)
	  printf( "%g\n", x,  >> "gain_"//res)
	  printf( "%g\n", y , >> "rdnoise_"//res)
	  printf( "%s\t%s\t%s\t%s\t%g\t%g\n", fl1, fl2, ze1, ze2, x, y, >> res)
	}

	# print grand mean

	if(verbose == YES) {
		print("\n\nGAIN\n====\n")
		print("MEAN\t\tSTDDEV\t\tPOINTS")
		type "gain_"//res | average
		print("\n\nRDNOISE\n=======\n")
		print("MEAN\t\tSTDDEV\t\tPOINTS")
		type "rdnoise_"//res | average
	}
	
	zero1list = ""
	zero2list = ""
	delete (combfile, ver-)
	delete (grfile, ver-)

end
	
