#!/bin/bash

########################################################################################

### Enter your 3-letter initials below; this is used to name jobs based on Animal ID
### Note that this and the email input are both OPTIONAL! If you put nothing, or put something incorrect, the script will likely still launch your jobs.
###### Except that the job names might look strange and you won't get e-mail notifications

# for example, the animal "ZHA001" has initials "ZHA" and IDlength 6
initials="ZHA"
IDlength=6

### Enter your e-mail below
email="computezee@gmail.com"

### Enter the full parent directory for analysis in the () brackets (default is pwd)
### The script will search from *this* directory onwards for BehavCam_0 folders.
root_directory=$(pwd)

# Path of your GLM scripts
glm_script=PAL_GLM.py
glm_slurm=PAL_GLM.sl
scripts_directory='/lustre03/project/rpp-markpb68/m3group/Haqqee/Github/GLM/'

########################################################################################
## Should not need to change anything below this line, unless you know what you're doing!

data=$(find $root_directory -type d -name "BehavCam_0")
taskname="GLM"

for session in $data
do
	cd $session
  cd ../
  
  echo "Analyzing $session"
  ID=$initials${session#*$initials}
  ID=${ID::$IDlength}
  date=202${session#*202}; date=${date::10}
  animalID="$ID-$date$end"
  ID="$taskname-$ID-$date"
  
  cp "$scripts_directory$glm_slurm" .
	sed -i -e "s|SCRIPTPATH|$scripts_directory$glm_script|g" $glm_slurm
	sed -i -e "s|OUTNAME|$ID|g" $glm_slurm
	sed -i -e "s|TASKNAME|$ID|g" $glm_slurm
#	sed -i -e "s|MYID|$animalID|g" $glm_slurm
	sed -i -e "s|MYEMAIL|$email|g" $glm_slurm
	sbatch $glm_slurm
	sleep 1

done