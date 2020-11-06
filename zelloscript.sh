#! /bin/bash

#SBATCH --time=00:10:00
#SBATCH --account=rpp-markpb68

pwd=$(pwd)
data=$(find $pwd -type d -name "Miniscope" -o -name "Miniscope_2")

for session in $data
do
	if [[ "$session" == *"ZHA013"* ]]
	then
		cd $session
		numVideos=$(ls -1q *.avi | wc -l)

		if [ -f "ms.mat" ]
		then
			echo "DONE $session it is already analyzed"
			continue
		elif (( $numVideos < 21 )) && [ -f "timeStamps.csv" ]
		then
			echo "Analyzing $session"
			cp /lustre03/project/rpp-markpb68/m3group/Haqqee/SLURMstuff/msRunSingleFolderv4Small.sl .
			cp /lustre03/project/rpp-markpb68/m3group/Haqqee/SLURMstuff/msRunSingleFolder.m .
			sleep 2
			sbatch msRunSingleFolderv4Small.sl
		elif (( $numVideos >= 21 )) && (( $numVideos <= 60 )) && [ -f "timeStamps.csv" ]
		then
			echo "Analyzing $session"
			cp /lustre03/project/rpp-markpb68/m3group/Haqqee/SLURMstuff/msRunSingleFolderv4.sl .
			cp /lustre03/project/rpp-markpb68/m3group/Haqqee/SLURMstuff/msRunSingleFolder.m .
			sleep 2
			sbatch msRunSingleFolderv4.sl
                elif (( $numVideos >= 61 )) && (( $numVideos <= 99 )) && [ -f "timeStamps.csv" ]
		then
			echo "Analyzing $session"
			cp /lustre03/project/rpp-markpb68/m3group/Haqqee/SLURMstuff/msRunSingleFolderv4Large.sl .
			cp /lustre03/project/rpp-markpb68/m3group/Haqqee/SLURMstuff/msRunSingleFolder.m .
			sleep 2
			sbatch msRunSingleFolderv4Large.sl
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
		elif (( $numVideos < 20 )) && [ -f "timeStamps.csv" ]
		then
			echo "Analyzing $session"
			cp /lustre03/project/rpp-markpb68/m3group/Haqqee/SLURMstuff/msRunSingleFolderConvertSmall.sl .
			cp /lustre03/project/rpp-markpb68/m3group/Haqqee/SLURMstuff/msRunSingleFolder.m .
			sleep 2
			sbatch msRunSingleFolderConvertSmall.sl
		elif (( $numVideos >= 20 )) && (( $numVideos <= 60 )) && [ -f "timeStamps.csv" ]
		then
			echo "Analyzing $session"
			cp /lustre03/project/rpp-markpb68/m3group/Haqqee/SLURMstuff/msRunSingleFolderConvert.sl .
			cp /lustre03/project/rpp-markpb68/m3group/Haqqee/SLURMstuff/msRunSingleFolder.m .
			sleep 2
			sbatch msRunSingleFolderConvert.sl
		elif (( $numVideos >= 61 )) && (( $numVideos <= 99 )) && [ -f "timeStamps.csv" ]
		then
			echo "Analyzing $session"
			cp /lustre03/project/rpp-markpb68/m3group/Haqqee/SLURMstuff/msRunSingleFolderConvertLarge.sl .
			cp /lustre03/project/rpp-markpb68/m3group/Haqqee/SLURMstuff/msRunSingleFolder.m .
			sleep 2
			sbatch msRunSingleFolderConvertLarge.sl
		else
			echo "ERROR $session not compatible for analysis"
		fi
	fi
done
