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

# Path of your scripts
script=band_detect_and_clean.py
slurm=band_detect_and_clean.sl
scripts_directory='/lustre03/project/rpp-markpb68/m3group/Haqqee/GitHub/band_fixing/'

########################################################################################
## Should not need to change anything below this line, unless you know what you're doing!

data=$(find $root_directory -type d -name "Miniscope_2")
taskname="bandetect"

for session in $data; do
  cd $session

  echo "Analyzing $session"
  ID=$initials${session#*$initials}
  animalID=${ID::$IDlength}
  date=202${session#*202}; date=${date::10}
  ID="$taskname-$animalID-$date"
  animalIDdate="$animalID-$date"

  cp "$scripts_directory$slurm" .
  cp "$scripts_directory$script" .
  #sed -i -e "s|SCRIPTPATH|$scripts_directory$script|g" $slurm
  sed -i -e "s|OUTNAME|$ID|g" $slurm
  sed -i -e "s|TASKNAME|$ID|g" $slurm
  sed -i -e "s|MYID|$animalIDdate|g" $script
  sed -i -e "s|MYEMAIL|$email|g" $slurm
  sbatch $slurm
  sleep 1

done
