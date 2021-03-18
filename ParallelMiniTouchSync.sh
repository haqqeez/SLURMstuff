#!/bin/bash

########################################################################################

### Enter your 3-letter initials below; this is used to name jobs based on Animal ID

initials="ZHA"

### Enter your e-mail below

email="computezee@gmail.com"

### Enter the full parent directory for analysis in the () brackets (default is pwd)

pwd=$(pwd)

### Enter the animal IDs you wish to skip, if any (or dates you wish to skip, tasks, etc.) ###

skip1="skipname2"
skip2="skipname2"

########################################################################################

data=$(find $pwd -type d -name "Miniscope" -o -name "Miniscope_2")
touch="t"

for session in $data
do
	if [[ "$session" == *"$skip1"* ]] || [[ "$session" == *"$skip2"* ]]
	then
		echo "SKIPPED $session"
	else
		cd $session
		abetcheck=$(find . -mindepth 1 -maxdepth 1 -type f -name "*_abet.csv" | wc -l)
		if [ -f "msTouchSyncMini.mat" ]
		then
			echo "DONE $session"
		elif [ -f "ms.mat" ] && [ $abetcheck == 1 ] && [ -f "SFP.mat" ]
		then
			echo "Analyzing $session"
			cp /lustre03/project/rpp-markpb68/m3group/Haqqee/GitHub/SLURMstuff/minitouchsync_PAL.sl .
			cp /lustre03/project/rpp-markpb68/m3group/Haqqee/GitHub/SLURMstuff/minitouchsync_PAL.m .
			ID=$initials${session#*$initials}
			ID=${ID::6}
			date=202${session#*202}; date=${date::10}
			ID="$touch-$ID-$date" 
			sleep 2
			sed -i -e "s/TASKNAME/$ID/g" minitouchsync_PAL.sl
			sed -i -e "s/MYEMAIL/$email/g" minitouchsync_PAL.sl
			sbatch minitouchsync_PAL.sl
			sleep 2
		else
			echo "ERROR $session not compatible for analysis"
		fi
	fi 
done
