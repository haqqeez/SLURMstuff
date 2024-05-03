#!/bin/bash

########################################################################################

### Enter your 3-letter initials below; this is used to name jobs based on Animal ID
### For example, the animal "ZHA001" has initials "ZHA" and IDlength=6 characters
### For example, the animal "A12" has initials "A" and IDlength=3
### If your animals don't have a consistent naming scheme (e.g., just random numbers like 124 or 2592) then your jobs will still run but the
### email you get naming your job will just look a bit odd. This step is simply to make jobs readable when submitting.

### Note that this and the email input are both OPTIONAL! If you put nothing, or put something incorrect, the script will likely still launch your jobs.
###### Except that the job names might look strange and you won't get e-mail notifications

initials="ZHA"
IDlength=6
target_dir="Miniscope*" # Searching for all directories with this name in root directory to run the script
goback=0 # if you want to go back one directory before running script using cd ../, set this to 1 (e.g., analyzing both miniscope and behv data)

script_path="/lustre03/project/6049321/m3group/Haqqee/GitHub/SLURMstuff/CNMFe/runCNMFe.m" # where you store your .m MATLAB files
slurm_path="/lustre03/project/6049321/m3group/Haqqee/GitHub/SLURMstuff/CNMFe/runCNMFe.sl"  # where you store your .sl SLURM files

### Enter the full parent directory for analysis to run in the () brackets (default and recommended is pwd)
pwd=$(pwd)

### Enter the names of animals with especially long analysis times (e.g., long deconvolutions) that could take up to 4 hours ###
### You typically find these by trial and error; if one animal is consistently giving OUT OF MEMORY errors when you run CNMFE, put their name below before running this
### and adjust the largerange, largeRAM etc accordingly

large1="xxx"
large2="ZHA029"
large3="ZHA030"

smallrange=(1 20) # range of videos for small recorings (few cells and/or short recordings) this will allocate minimal RAM and runtime
medrange=(21 64) # range of videos for medium recordings (more cells and/or longer recordings) this will allocate mediam RAM and runtime
largerange=(65 101) # range of videos for large recordings (many cells and/or very long recordings) this will allocate high RAM and runtime

smallRAM=70000 # memory limit for each job
medRAM=150000 # memory limit for each job
largeRAM=220000 # memory limit for each job

smallruntime="1:20:00" # time limit for each job
medruntime="2:30:00" # time limit for each job
largeruntime="3:00:00" # time limit for each job

smallCPU=10 # number of cpus for each job
medCPU=10 # number of cpus for each job
largeCPU=4 # number of cpus for each job

# SETUP SLURM HERE #
project_account="rrg-markpb68" # project allocation to use
email="computezee@gmail.com" # email to send notifications to
mailtype="END,FAIL" # type of email notifications you want; END, FAIL, ALL, BEGIN, etc.
output_directory="/home/haqqeez/SLURMS/CNMFe/" # directory where you want the output and errors of slurm files to be saved
output_subs=1
# note that for multidparamloop we will create subdirectories based on animal ID
# if you instead want to save all the outputs in the same directory, set output_subs=0

# output directory will be created if it doesn't exist
if [ ! -d "$output_directory" ]; then
  mkdir -p $output_directory
fi

###############################  OTHER PARAMS  ##############################################

minimum_size=1M # minimum video file size; default is 1M (1 megabyte)
minimum_number=2 # min number of avi files to trigger analysis; set this to 1 if you've already concatenated your videos

##############################################################################################


data=$(find $pwd -type d -name "$target_dir")

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
	elif [ -f "CNMFE-running.temp" ]; then # script used to make this but no longer does I think
		echo "SKIPPED $session already running"
	elif (( $numVideos < $minimum_number )); then
			echo "SKIPPED: too few video files to analyze $session"
	elif (( $numVideos != $video_sizes_check )); then
			echo "ERROR: Some video files may be too small or corrupt in $session"
	elif [ -f "0.avi" ]; then

		if [[ "$session" == *"$large1"* ]] || [[ "$session" == *"$large2"* ]] || [[ "$session" == *"$large3"* ]] #replace with any animal that takes longer than 3 hours to analyze
		then
			runtime=$largeruntime
			RAM=$largeRAM
			CPUS=$largeCPU

		elif (( $numVideos >= ${smallrange[0]} )) && (( $numVideos <= ${smallrange[1]} )) && [ -f "timeStamps.csv" ]
		then
			runtime=$smallruntime
			RAM=$smallRAM
			CPUS=$smallCPU
		elif (( $numVideos >= ${medrange[0]} )) && (( $numVideos <= ${medrange[1]} )) && [ -f "timeStamps.csv" ]
		then
			runtime=$medruntime
			RAM=$medRAM
			CPUS=$medCPU
		elif (( $numVideos >= ${largerange[0]} )) && (( $numVideos <= ${largerange[1]} )) && [ -f "timeStamps.csv" ]
		then
			runtime=$largeruntime
			RAM=$largeRAM
			CPUS=$largeCPU
		else
			echo "ERROR $session not compatible for analysis"
		fi

		echo "Analyzing $session"
		cp $slurm_path .

		# create animalID-date as taskname
		ID=$initials${session#*$initials}
		ID=${ID::$IDlength}

		if [ $output_subs == 1 ]; then
			output_directory="${output_directory}/${ID}"
			if [ ! -d "$output_directory" ]; then
			mkdir -p $output_directory
			fi
		fi

		date=202${session#*202}; date=${date::10}
		ID="$ID-$date"
		
		# replace placeholders in SLURM script
		slurm_name="${slurm_path##*/}"
		script_path_only="${script_path%/*}"
		sed -i -e "s|SCRIPTPATH|${script_path_only}|g" $slurm_name
		sed -i -e "s/TASKNAME/$ID/g" $slurm_name
		sed -i -e "s/MYEMAIL/$email/g" $slurm_name
		sed -i -e "s/PROJECTACCOUNT/$project_account/g" $slurm_name
		sed -i -e "s/MAILTYPE/$mailtype/g" $slurm_name
		sed -i -e "s|OUTPUTDIR|${output_directory}/${date}_%j.out|g" $slurm_name
		sed -i -e "s|ERRORDIR|${output_directory}/errors/${date}_%j.err|g" $slurm_name
		sed -i -e "s|RAM|${RAM}|g" $slurm_name
		sed -i -e "s|RUNTIME|${runtime}|g" $slurm_name
		sed -i -e "s|NUMCPUS|${CPUS}|g" $slurm_name
		sbatch $slurm_name
		sleep 1
	fi
done
