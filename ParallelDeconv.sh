#!/bin/bash

########################################################################################

### Enter your 3-letter initials below; this is used to name jobs based on Animal ID

initials="ZHA"

### Enter your e-mail below

email="computezee@gmail.com"

### Enter the full parent directory for analysis in the () brackets (default is pwd)

pwd=$(pwd)

########################################################################################

data=$(find $pwd -type d -name "Miniscope" -o -name "Miniscope_2")

for session in $data
do
	cd $session
	if [ -f "ms.mat" ] && [ -f "SFP.mat" ]
	then
		echo "Analyzing $session"
		cp /lustre03/project/rpp-markpb68/m3group/Haqqee/SLURMstuff/msDeconvolve.sl .
		cp /lustre03/project/rpp-markpb68/m3group/Haqqee/SLURMstuff/msDeconvolve.m .
		ID=$initials${session#*$initials}
		ID=${ID::6}
		date=202${session#*202}; date=${date::10}
		ID="$ID-$date" 
		sleep 2
		sed -i -e "s/TASKNAME/$ID/g" msDeconvolve.sl
		sed -i -e "s/MYEMAIL/$email/g" msDeconvolve.sl
		sbatch msDeconvolve.sl
		sleep 2
	else
		echo "ERROR $session not compatible for analysis"
	fi 
done
