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
	if [[ "$session" == *"Miniscope_2"* ]]
	then
		cd $session
		numVideos=$(ls -1q *.avi | wc -l)

		if [ -f "ms.mat" ]
		then
			echo "DONE $session it is already analyzed"
			continue
		elif (( $numVideos > 0 )) && (( $numVideos < 21 )) && [ -f "timeStamps.csv" ]
		then
			echo "Analyzing $session"
			cp /lustre03/project/rpp-markpb68/m3group/Haqqee/SLURMstuff/msRunSingleFolderv4Small.sl .
			cp /lustre03/project/rpp-markpb68/m3group/Haqqee/SLURMstuff/msRunSingleFolder.m .
			ID=$initials${session#*$initials}
			ID=${ID::6}
			date=202${session#*202}; date=${date::10}
			ID="$ID-$date" 
			sleep 2
			sed -i -e "s/TASKNAME/$ID/g" msRunSingleFolderv4Small.sl
			sed -i -e "s/MYEMAIL/$email/g" msRunSingleFolderv4Small.sl
			sbatch msRunSingleFolderv4Small.sl
			sleep 2
		elif (( $numVideos >= 21 )) && (( $numVideos <= 64 )) && [ -f "timeStamps.csv" ]
		then
			echo "Analyzing $session"
			cp /lustre03/project/rpp-markpb68/m3group/Haqqee/SLURMstuff/msRunSingleFolderv4.sl .
			cp /lustre03/project/rpp-markpb68/m3group/Haqqee/SLURMstuff/msRunSingleFolder.m .
			ID=$initials${session#*$initials}
			ID=${ID::6}
			date=202${session#*202}; date=${date::10}
			ID="$ID-$date"
			sleep 2
			sed -i -e "s/TASKNAME/$ID/g" msRunSingleFolderv4.sl
			sed -i -e "s/MYEMAIL/$email/g" msRunSingleFolderv4.sl
			sbatch msRunSingleFolderv4.sl
			sleep 2
                elif (( $numVideos >= 65 )) && (( $numVideos <= 99 )) && [ -f "timeStamps.csv" ]
		then
			echo "Analyzing $session"
			cp /lustre03/project/rpp-markpb68/m3group/Haqqee/SLURMstuff/msRunSingleFolderv4Large.sl .
			cp /lustre03/project/rpp-markpb68/m3group/Haqqee/SLURMstuff/msRunSingleFolderX.m .
			ID=$initials${session#*$initials}
			ID=${ID::6}
			date=202${session#*202}; date=${date::10}
			ID="$ID-$date"
			sleep 2
			sed -i -e "s/TASKNAME/$ID/g" msRunSingleFolderv4Large.sl
			sed -i -e "s/MYEMAIL/$email/g" msRunSingleFolderv4Large.sl
			sbatch msRunSingleFolderv4Large.sl
			sleep 2
		else
			echo "ERROR $session not compatible for analysis"
		fi 
	else
		cd $session
		numVideos=$(ls -1q *.avi | wc -l)

		if [ -f "ms.mat" ]
		then
			echo "DONE $session it is already analyzed"
			continue
		elif (( $numVideos > 0 )) && (( $numVideos < 20 )) && [ -f "timeStamps.csv" ]
		then
			echo "Analyzing $session"
			cp /lustre03/project/rpp-markpb68/m3group/Haqqee/SLURMstuff/msRunSingleFolderConvertSmall.sl .
			cp /lustre03/project/rpp-markpb68/m3group/Haqqee/SLURMstuff/msRunSingleFolder.m .
			ID=$initials${session#*$initials}
			ID=${ID::6}
			date=202${session#*202}; date=${date::10}
			ID="$ID-$date"
			sleep 2
			sed -i -e "s/TASKNAME/$ID/g" msRunSingleFolderConvertSmall.sl
			sed -i -e "s/MYEMAIL/$email/g" msRunSingleFolderConvertSmall.sl
			sbatch msRunSingleFolderConvertSmall.sl
			sleep 2
		elif (( $numVideos >= 20 )) && (( $numVideos <= 64 )) && [ -f "timeStamps.csv" ]
		then
			echo "Analyzing $session"
			cp /lustre03/project/rpp-markpb68/m3group/Haqqee/SLURMstuff/msRunSingleFolderConvert.sl .
			cp /lustre03/project/rpp-markpb68/m3group/Haqqee/SLURMstuff/msRunSingleFolder.m .
			ID=$initials${session#*$initials}
			ID=${ID::6}
			date=202${session#*202}; date=${date::10}
			ID="$ID-$date"
			sleep 2
			sed -i -e "s/TASKNAME/$ID/g" msRunSingleFolderConvert.sl
			sed -i -e "s/MYEMAIL/$email/g" msRunSingleFolderConvert.sl
			sbatch msRunSingleFolderConvert.sl
			sleep 2
		elif (( $numVideos >= 65 )) && (( $numVideos <= 99 )) && [ -f "timeStamps.csv" ]
		then
			echo "Analyzing $session"
			cp /lustre03/project/rpp-markpb68/m3group/Haqqee/SLURMstuff/msRunSingleFolderConvertLarge.sl .
			cp /lustre03/project/rpp-markpb68/m3group/Haqqee/SLURMstuff/msRunSingleFolderX.m .
			ID=$initials${session#*$initials}
			ID=${ID::6}
			date=202${session#*202}; date=${date::10}
			ID="$ID-$date"
			sleep 2
			sed -i -e "s/TASKNAME/$ID/g" msRunSingleFolderConvertLarge.sl
			sed -i -e "s/MYEMAIL/$email/g" msRunSingleFolderConvertLarge.sl
			sbatch msRunSingleFolderConvertLarge.sl
			sleep 2
		else
			echo "ERROR $session not compatible for analysis"
		fi
	fi
done
