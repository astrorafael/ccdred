#
# calculates statistics for a given header keyword
# in a set of images
#

procedure keystat (images)

string images    {prompt="Image list"}
string keyword   {prompt="keyword whose statistics are being calculated"}
real   min       {prompt="(output) min value"}
real   max       {prompt="(output) max value"}
real   mean   = INDEF     {prompt="(output) average value"}
real   stddev = INDEF     {prompt="(output) standard deviation"}
int    N      = INDEF     {prompt="(output) sample size"}

struct *errlist	
string *imglist

begin
	string  img
	bool errorflag = no
	real val, acc, sqacc
	struct errmsg
	file errfile

	# initialize parameters and variables
	
	min =  1.0e+37
	max = -1.0e+37
	N = 0
	acc = 0
	sqacc = 0
	errfile = "error.txt"
	errlist = errfile

	# and iterate through the list

	imglist = images
	while(fscan(imglist, img) != EOF) {
		if(!access(img)) {
			min    = INDEF
			max    = INDEF
			mean   = INDEF
			stddev = INDEF
			errorflag = yes
			break
		}
		N += 1			
		imgets(img, keyword, >>& errfile)
                i = fscan(errlist, errmsg)
		if(strlen(errmsg) != 0) {
			min    = INDEF
			max    = INDEF
			mean   = INDEF
			stddev = INDEF
			errorflag = yes
			break
		}
			
		val = real(imgets.value)
		if(val > max)
			max = val
		if(val < min)
			min = val
		acc   += val
		sqacc += val*val
	}

	# calculate the final statistics

	if(!errorflag) {
		mean   = acc/N	    
		stddev = sqrt(1/(N-1)*(sqacc-mean*mean*N))
	}

	# closes the lists

	imglist = ""
	errlist = ""
	delete(errfile)
end
	
