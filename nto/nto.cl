#
# The NTO package
#
# by astrorafael

noao
imred
ccdred
language
system
obsutil

package nto


task classify = "ntodir$classify.cl"
task overscan = "ntodir$overscan.cl"
task findgain2 = "ntodir$findgain2.cl"
task bootgain = "ntodir$bootgain.cl"
task keystat  = "ntodir$keystat.cl"
task $testnto = "ntodir$testnto.cl"

clbye()
