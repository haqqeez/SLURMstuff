#!/bin/bash

############################################################################################################
# This script is used to loop over different parameters for any given script
# It will generate a slurm script for each combination of parameters and submit them as separate jobs
# The slurm script should be a template with placeholders for the parameters (usually in CAPS)
# The script will replace the placeholders with the actual parameters and submit the job

# contact z.haqqee@gmail.com for inquiries

####################### STEP 0 ####################### 

### Enter your 3-letter initials below; this is used to name jobs based on Animal ID
### Note that this and the email input are both OPTIONAL! If you put nothing, or put something incorrect, the script will likely still launch your jobs.
###### Except that the job names might look strange and you won't get e-mail notifications

# for example, the animal "ZHA001" has initials "ZHA" and IDlength 6
initials="ZHA"
IDlength=6
target_dir="Miniscope*" # Searching for all directories with this name in root directory to run the script
goback=1 # if you want to go back one directory before running script using cd ../, set this to 1 (e.g., analyzing both miniscope and behv data)

script_path='/lustre03/project/rrg-markpb68/m3group/Haqqee/GitHub/GLM/troubleshooting/gaussianbases_paramsearch.py' #MATLAB, python, or whatever script you want to run via the slurm script
slurm_path="/lustre03/project/6049321/m3group/Haqqee/GitHub/SLURMstuff/gaussianbases_paramsearch.sl"  # define the path to the slurm script you want to loop over


root_directory=$(pwd)  # directory where you want to run this. $(pwd) is the current directory
# this should be the parent directory where all your target_dir directories are

# Unless you want a different name, the slurmscript-animalID-date name will be used as the job name and in the copied slurm names
slurm_name=$(basename $slurm_path)

# SETUP SLURM HERE #
project_account="rrg-markpb68" # project allocation to use
timelim="6:00:00" # time limit for each job
mem=4000 # memory limit for each job
cpus=3 # number of cpus for each job
email="computezee@gmail.com" # email to send notifications to
mailtype="END,FAIL" # type of email notifications you want; END, FAIL, ALL, BEGIN, etc.
output_directory="/home/haqqeez/SLURMS/GLM/" # directory where you want the output and errors of slurm files to be saved
output_subs=1
# note that for multidparamloop we will create subdirectories based on animal ID
# if you instead want to save all the outputs in the same directory, set output_subs=0

# output directory will be created if it doesn't exist
if [ ! -d "$output_directory" ]; then
  mkdir -p $output_directory
fi


### Don't touch this  bit ###
variables_before=$(set | cut -d= -f1) # Get the list of variables before defining your variables

####################### STEP 1 ####################### 

# Define the parameters with their placeholder value
# No need to modify this unless adding new parameter
# Parameter names should not have spaces, special characters, or underscores
# This should refer to a placeholder string that will be replaced (make sure they exist in the slurm script)

basesize="BASESIZE"
sigma="SIGMA"

#######################  STEP 2 ####################### 

# Define the values for each parameter

### ~~~~ *** USE SPACES NOT COMMAS *** ~~~~ ##

# These should all be arrays (ie., in brackets with spaces NOT commas; like this: (value1 value2 value3))
# The values should be in the order you want them to be looped over
# You can have a single value in the array if you don't want to loop over that parameter
# If you accidentally have multiple values in the array but don't want to loop over that parameter, we just take the first value

basesize+=(4 6 8 10 12 14 16) # gassian bases gridsize by number at triangular base
sigma+=(15 20 25 30 35 40 45) # sigma of each center


#######################  STEP 3 ####################### 

# Set which params you want to loop over
# the otder determines file naming
param1=("${basesize[@]}")
param2=("${sigma[@]}")

# For all remaining parameters, we will take the first value of the array
# If you want to loop over more params, modify the script below accordingly


#############################################################################
######### ONLY MODIFY BELOW THIS LINE IF YOU KNOW WHAT YOU'RE DOING #########
#############################################################################

# Get the list of variables after defining your variables
variables_after=$(set | cut -d= -f1)
# Find the variables that were defined in your script
allmyparams=$(comm -13 <(echo "$variables_before" | sort) <(echo "$variables_after" | sort)) > /dev/null 2>&1

###~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~################### CHANGE IF MORE OR FEWER PARAMS  ############# Generate all combinations of parameters 
combinations=$(eval echo {2..${#param1[@]}}_{2..${#param2[@]}})
# if you wanted a 4th parameter, you would add _{2..${#param4[@]}} to the end of the above line, and so on

# drop the extension in case it's there
slurm_name="${slurm_name%.*}"

data_dirs=$(find $root_directory -type d -name "$target_dir")
for session in $data_dirs; do
  cd $session
  echo "Running in $session"
  if [[ $goback -eq 1 ]]; then
    cd ../
    echo "Moved to $pwd"
  fi
  ID=$initials${session#*$initials}
  animalID=${ID::$IDlength}
  #date=202${session#*202}; date=${date:0::10}
  date=$(echo $session | grep -oP '\d{4}_\d{2}_\d{2}')
  # drop the underscores in date
  date="${date//_/}"
  # based off the scriptname_animalID_YYYYMMDD
  ID="${slurm_name}-${animalID}-${date}"

  if [ $output_subs == 1 ]; then
    sub_directory="${output_directory}/${animalID}"
    if [ ! -d "$sub_directory" ]; then
      mkdir -p $sub_directory
    fi
  fi

  # Loop over all combinations of parameters
  for combination in $combinations; do
    # Extract the parameters from the combination
    IFS='_' read -r -a params <<< "$combination"
    i="${param1[${params[0]} - 1]}"
    j="${param2[${params[1]} - 1]}" ###~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~################### CHANGE IF MORE OR FEWER PARAMS  ###################################
    # if you added a 4th parameter, you would add l="${param4[${params[3]} - 1]}" here, and so on

    # Get the placeholder names from the associative arrays
    param1_placeholder=${param1[0]}
    param2_placeholder=${param2[0]} ###~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~################### CHANGE IF MORE OR FEWER PARAMS  ###################################
    # if you added a 4th parameter, you would add param4_placeholder=${param4[0]} here, and so on

    # Copy the slurm script and rename it
    slurm_script="${slurm_name}_${param1_placeholder,,}${i}_${param2_placeholder,,}${j}.sl"
    cp $slurm_path $slurm_script

    # Modify the copied script with the parameters
    sed -i "s/${param1_placeholder}/${i}/g" $slurm_script
    sed -i "s/${param2_placeholder}/${j}/g" $slurm_script ###~*~*~*~*~*~*~*~*~*~*~*~*~*~*~################## CHANGE IF MORE OR FEWER PARAMS  ###################################

    sed -i -e "s|SCRIPTPATH|${script_path}|g" $slurm_script

    # Define the params you've already used
    used_params=("param1" "param2") ###~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~################### CHANGE IF MORE OR FEWER PARAMS  ###################################

    # Now replace all remaining placeholders with the first value of the remaining parameters
    for param in $allmyparams; do
      # check if param is an iterable array and not in used_params
      if declare -p $param 2> /dev/null | grep -q '^declare \-a' && ! [[ ${used_params[*]} =~ $param ]]; then
        index0="${param}[0]"
        index1="${param}[1]"
        placeholdername=${!index0}
        value=${!index1}
        # echo "Replacing $placeholdername with $value"
        sed -i -e "s|${placeholdername}|${value}|g" $slurm_script
      fi
    done

    # Uncomment this for troubleshooting (and comment out the sbatch command below)
    echo "Variables: $param1_placeholder $param2_placeholder" ###~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~###### CHANGE IF MORE OR FEWER PARAMS  ###################################
    echo "Submitting job with parameters: $i $j" ###~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*########### CHANGE IF MORE OR FEWER PARAMS  ###################################
    #echo "Remaining parameters: $allmyparams"
    #echo "Slurm script: $slurm_script"
    #echo "Slurm name: $slurm_name"
    #echo "Root directory: $root_directory"
    #echo "Current directory: $(pwd)"

    # Submit the Slurm job ###~*~*~*~*~*~*~*~*~*~*~*~*~###### CHANGE IF MORE OR FEWER PARAMS  ##
    sbatch --mail-user=$email \
          --mail-type=$mailtype \
          --job-name=$ID \
          --output=$sub_directory/${date}_${param1_placeholder,,}${i}_${param2_placeholder,,}${j}_%j.out \
          --error="$sub_directory/errors/${date}_${param1_placeholder,,}${i}_${param2_placeholder,,}${j}_%j.err" \
          --account=$project_account \
          --time=$timelim \
          --nodes=1 \
          --ntasks=1 \
          --cpus-per-task=$cpus \
          --mem=$mem \
          $slurm_script
    
    sleep 0.5 # pause to be kind to the job scheduler on the server
  done
done

echo "All jobs submitted!"
