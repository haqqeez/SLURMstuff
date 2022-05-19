#!/bin/bash

########################################################################################

### Enter your 3-letter initials below; this is used to name jobs based on Animal ID

initials="ZHP"
IDlength=6

### Enter your e-mail below

email="computezee@gmail.com"

### Enter the full parent directory for analysis in the () brackets (default is pwd)

pwd=$(pwd)

### Enter the animal IDs you wish to skip, if any (or dates you wish to skip, tasks, etc.) ###

skip1="skipname2"
skip2="skipname2"

# absolute path to your scripts direcory (like behavtouchsync_PAL.sl, etc.)
# make sure there is NO '/' at the end of this path
MY_SCRIPTS_DIRECTORY='/lustre03/project/rpp-markpb68/m3group/Haqqee/GitHub/SLURMstuff'

#name of your scripts for retrieving and executing MATLAB code (inside your scripts directory above)

jobscript=behavtouchsync_PAL.sl
matscript=behavtouchsync_PAL.m


########################################################################################

data=$(find $pwd -type d -name "BehavCam_0")
touch="t"

for session in $data
do
	if [[ "$session" == *"$skip1"* ]] || [[ "$session" == *"$skip2"* ]]
	then
		echo "SKIPPED $session"
	else
		cd $session
		abetcheck=$(find . -mindepth 1 -maxdepth 1 -type f -name "*_abet.csv" | wc -l)
		if [ -f "msTouchSyncBehav.mat" ]
		then
			echo "DONE $session"
		elif [ -f "timeStamps.csv" ] && [ $abetcheck == 1 ]
		then
			echo "Analyzing $session"
			cp $MY_SCRIPTS_DIRECTORY/$jobscript .
			cp $MY_SCRIPTS_DIRECTORY/$matscript .
			ID=${ID::$IDlength}
			date=202${session#*202}; date=${date::10}
			ID="$touch-$ID-$date"
			sleep 2
			sed -i -e "s|TASKNAME|$ID|g" $jobscript
			sed -i -e "s|MYEMAIL|$email|g" $jobscript
			sbatch $jobscript
			sleep 2
		else
			echo "ERROR $session not compatible for analysis"
		fi
	fi 
done
