#!/bin/bash

########################################################################################

### Enter your 3-letter initials below; this is used to name jobs based on Animal ID
### For example, the animal "ZHA001" has initials "ZHA" and IDlength=6 characters
### For example, the animal "A12" has initials "A" and IDlength=3
### If your animals don't have a consistent naming scheme (e.g., just random numbers like 124 or 2592) then your jobs will still run but the
### email you get naming your job will just look a bit odd. This step is simply to make jobs readable when submitting.

initials="ZHA"
IDlength=6

### Enter your e-mail below

email="computezee@gmail.com"

### Enter the full parent directory for analysis in the () brackets (default is pwd)

pwd=$(pwd)

### Enter the names of animals with especially long analysis times (e.g., long deconvolutions) that could take up to 4 hours, with recordings >= 60 videos ###
### You typically find these by trial and error; if one animal is consistently giving OUT OF MEMORY errors when you run CNMFE, put their name below before running this

large1="ZHA032"
large2="ZHA029"
large3="ZHA030"

########################################################################################

convert_thresh=300000000 # threshold, below which the script assumes FFV1 video format and converts to GREY before running CNMFE
minimum_size=1M # minimum video file size; default is 1M (1 megabyte)
minimum_number=2 # min number of avi files to trigger analysis; set this to 1 if you've already concatenated your videos


data=$(find $pwd -type d -name "Miniscope" -o -name "Miniscope_2")

for session in $data
do
	cd $session
	numVideos=$(find -maxdepth 1 -type f -name "*.avi" | wc -l)
	filepart_check=$(find -type f -name "*filepart*" | wc -l)
	video_sizes_check=$(find -maxdepth 1 -type f -size +$minimum_size -name "*.avi" | wc -l)
	zero_size=$(du -b "0.avi" | cut -f1)

	if (( $filepart_check > 0 )); then
                echo "ERROR: Incomplete uploading in $session"
	elif [ -f "ms.mat" ]; then
		echo "DONE $session it is already analyzed/analyzing"
	elif [ -f "CNMFE-running.temp" ]; then
		echo "SKIPPED $session already running"
        elif (( $numVideos < $minimum_number )); then
                echo "SKIPPED: too few video files to analyze $session"
        elif (( $numVideos != $video_sizes_check )); then
                echo "ERROR: Some video files may be too small or corrupt in $session"
        elif [ -f "0.avi" ] && (( $zero_size > $convert_thresh )); then

		if (( $numVideos > 0 )) && (( $numVideos < 21 )) && [ -f "timeStamps.csv" ]
		then
			echo "Analyzing $session"
			cp /lustre03/project/rrg-markpb68/m3group/Haqqee/GitHub/SLURMstuff/CNMFe/msRunSingleFolderv4Small.sl .
			cp /lustre03/project/rrg-markpb68/m3group/Haqqee/GitHub/SLURMstuff/CNMFe/msRunSingleFolder.m .
			ID=$initials${session#*$initials}
			ID=${ID::$IDlength}
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
			cp /lustre03/project/rrg-markpb68/m3group/Haqqee/GitHub/SLURMstuff/CNMFe/msRunSingleFolderv4.sl .
			cp /lustre03/project/rrg-markpb68/m3group/Haqqee/GitHub/SLURMstuff/CNMFe/msRunSingleFolder.m .
			ID=$initials${session#*$initials}
			ID=${ID::$IDlength}
			date=202${session#*202}; date=${date::10}
			ID="$ID-$date"
			sleep 2
			sed -i -e "s/TASKNAME/$ID/g" msRunSingleFolderv4.sl
			sed -i -e "s/MYEMAIL/$email/g" msRunSingleFolderv4.sl
			sbatch msRunSingleFolderv4.sl
			sleep 2
		elif (( $numVideos >= 65 )) && (( $numVideos <= 101 )) && [ -f "timeStamps.csv" ]
		then
			echo "Analyzing $session"
			cp /lustre03/project/rrg-markpb68/m3group/Haqqee/GitHub/SLURMstuff/CNMFe/msRunSingleFolderv4Large.sl .
			cp /lustre03/project/rrg-markpb68/m3group/Haqqee/GitHub/SLURMstuff/CNMFe/msRunSingleFolder.m .
			ID=$initials${session#*$initials}
			ID=${ID::$IDlength}
			date=202${session#*202}; date=${date::10}
			ID="$ID-$date"
			if [[ "$session" == *"$large1"* ]] || [[ "$session" == *"$large2"* ]] || [[ "$session" == *"$large3"* ]] #replace with any animal that takes longer than 3 hours to analyze
			then
				cp /lustre03/project/rrg-markpb68/m3group/Haqqee/GitHub/SLURMstuff/CNMFe/msRunSingleFolderv4Xtra.sl .
				cp /lustre03/project/rrg-markpb68/m3group/Haqqee/GitHub/SLURMstuff/CNMFe/msRunSingleFolder.m .
				sleep 2
				sed -i -e "s/TASKNAME/$ID/g" msRunSingleFolderv4Xtra.sl
				sed -i -e "s/MYEMAIL/$email/g" msRunSingleFolderv4Xtra.sl
				sbatch msRunSingleFolderv4Xtra.sl
				sleep 2
			else
				cp /lustre03/project/rrg-markpb68/m3group/Haqqee/GitHub/SLURMstuff/CNMFe/msRunSingleFolderv4Large.sl .
				cp /lustre03/project/rrg-markpb68/m3group/Haqqee/GitHub/SLURMstuff/CNMFe/msRunSingleFolder.m .
				sleep 2
				sed -i -e "s/TASKNAME/$ID/g" msRunSingleFolderv4Large.sl
				sed -i -e "s/MYEMAIL/$email/g" msRunSingleFolderv4Large.sl
				sbatch msRunSingleFolderv4Large.sl
				sleep 2
			fi
		else
			echo "ERROR $session not compatible for analysis"
		fi

	elif [ -f "0.avi" ] && (( $zero_size < $convert_thresh )); then
		if (( $numVideos > 0 )) && (( $numVideos < 20 )) && [ -f "timeStamps.csv" ]
		then
			echo "Convert+Analyzing $session"
			cp /lustre03/project/rrg-markpb68/m3group/Haqqee/GitHub/SLURMstuff/CNMFe/msRunSingleFolderConvertSmall.sl .
			cp /lustre03/project/rrg-markpb68/m3group/Haqqee/GitHub/SLURMstuff/CNMFe/msRunSingleFolder.m .
			ID=$initials${session#*$initials}
			ID=${ID::$IDlength}
			date=202${session#*202}; date=${date::10}
			ID="$ID-$date"
			sleep 2
			sed -i -e "s/TASKNAME/$ID/g" msRunSingleFolderConvertSmall.sl
			sed -i -e "s/MYEMAIL/$email/g" msRunSingleFolderConvertSmall.sl
			sbatch msRunSingleFolderConvertSmall.sl
			sleep 2
		elif (( $numVideos >= 20 )) && (( $numVideos <= 59 )) && [ -f "timeStamps.csv" ]
		then
			echo "Convert+Analyzing $session"
			cp /lustre03/project/rrg-markpb68/m3group/Haqqee/GitHub/SLURMstuff/CNMFe/msRunSingleFolderConvert.sl .
			cp /lustre03/project/rrg-markpb68/m3group/Haqqee/GitHub/SLURMstuff/CNMFe/msRunSingleFolder.m .
			ID=$initials${session#*$initials}
			ID=${ID::$IDlength}
			date=202${session#*202}; date=${date::10}
			ID="$ID-$date"
			sleep 2
			sed -i -e "s/TASKNAME/$ID/g" msRunSingleFolderConvert.sl
			sed -i -e "s/MYEMAIL/$email/g" msRunSingleFolderConvert.sl
			sbatch msRunSingleFolderConvert.sl
			sleep 2
		elif (( $numVideos >= 60 )) && (( $numVideos <= 101 )) && [ -f "timeStamps.csv" ]
		then
			echo "Convert+Analyzing $session"
			ID=$initials${session#*$initials}
			ID=${ID::$IDlength}
			date=202${session#*202}; date=${date::10}
			ID="$ID-$date"
			if [[ "$session" == *"$large1"* ]] || [[ "$session" == *"$large2"* ]] #replace with any animal that takes longer than 3 hours to analyze
			then
				cp /lustre03/project/rrg-markpb68/m3group/Haqqee/GitHub/SLURMstuff/CNMFe/msRunSingleFolderConvertXtra.sl .
				cp /lustre03/project/rrg-markpb68/m3group/Haqqee/GitHub/SLURMstuff/CNMFe/msRunSingleFolder.m .
				sleep 2
				sed -i -e "s/TASKNAME/$ID/g" msRunSingleFolderConvertXtra.sl
				sed -i -e "s/MYEMAIL/$email/g" msRunSingleFolderConvertXtra.sl
				sbatch msRunSingleFolderConvertXtra.sl
				sleep 2
			else
				cp /lustre03/project/rrg-markpb68/m3group/Haqqee/GitHub/SLURMstuff/CNMFe/msRunSingleFolderConvertLarge.sl .
				cp /lustre03/project/rrg-markpb68/m3group/Haqqee/GitHub/SLURMstuff/CNMFe/msRunSingleFolder.m .
				sleep 2
				sed -i -e "s/TASKNAME/$ID/g" msRunSingleFolderConvertLarge.sl
				sed -i -e "s/MYEMAIL/$email/g" msRunSingleFolderConvertLarge.sl
				sbatch msRunSingleFolderConvertLarge.sl
				sleep 2
			fi
		else
			echo "ERROR missing timestamps or too many avi files in $session"
		fi
	fi
done
