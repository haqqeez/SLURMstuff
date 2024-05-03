#!/bin/bash

########################################################################################

### Enter your 3-letter initials below; this is used to name jobs based on Animal ID

initials="ZHA"

### Enter your e-mail below

email="computezee@gmail.com"

### Enter the full parent directory for analysis in the () brackets (default is pwd)

pwd=$(pwd)

### Enter the animal IDs you wish to skip, if any (or dates you wish to skip, tasks, etc.) ###

skip1="skipname1"
skip2="skipname2"

########################################################################################

data=$(find $pwd -type d -name "Miniscope" -o -name "Miniscope_2")
deconv="deconv"

for session in $data
do
	if [[ "$session" == *"$skip1"* ]] || [[ "$session" == *"$skip2"* ]]
	then
		echo "DONE $session"
	else
		cd $session
		if [ -f "ms.mat" ] && [ -f "SFP.mat" ]
		then
			echo "Analyzing $session"
			cp /lustre03/project/rpp-markpb68/m3group/Haqqee/SLURMstuff/msDeconvolve.sl .
			cp /lustre03/project/rpp-markpb68/m3group/Haqqee/SLURMstuff/msDeconvolve.m .
			ID=$initials${session#*$initials}
			ID=${ID::6}
			date=202${session#*202}; date=${date::10}
			ID="$deconv$ID-$date" 
			sleep 2
			sed -i -e "s/TASKNAME/$ID/g" msDeconvolve.sl
			sed -i -e "s/MYEMAIL/$email/g" msDeconvolve.sl
			sbatch msDeconvolve.sl
			sleep 2
		else
			echo "ERROR $session not compatible for analysis"
		fi
	fi 
done
