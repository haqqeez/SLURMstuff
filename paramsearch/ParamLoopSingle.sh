#!/bin/bash

############################################################################################################


## Works exactly like ParamLoop.sh but for a single variable ##


# This script is used to loop over different parameters for any given script
# It will generate a slurm script for each combination of parameters and submit them as separate jobs
# The slurm script should be a template with placeholders for the parameters (usually in CAPS)
# The script will replace the placeholders with the actual parameters and submit the job

# contact z.haqqee@gmail.com for inquiries

####################### STEP 0 ####################### 


script_path='/lustre03/project/rrg-markpb68/m3group/Haqqee/GitHub/GLM/troubleshooting/polyvars.py' #MATLAB, python, or whatever script you want to run via the slurm script
slurm_path="/lustre03/project/6049321/m3group/Haqqee/GitHub/SLURMstuff/paramsearch/polyvars.sl"  # define the path to the slurm script you want to loop over

root_directory=$(pwd)  # directory where you want to run this. $(pwd) is the current directory
# this should be the same directory you intend to run the slurm script in
# if you want to loop through directories, use relevant MultiDParamLoop script instead

# Unless you want a different name, the slurmscript name will be used as the job name and in the copied slurm names
slurm_name=$(basename $slurm_path) # for example, if you're running this on a particular animal, maybe name this "AnimalID"

# SETUP SLURM HERE #
project_account="rrg-markpb68" # project allocation to use
timelim="4:00:00" # time limit for each job
mem=4000 # memory limit for each job
cpus=3 # number of cpus for each job
email="computezee@gmail.com" # email to send notifications to
mailtype="END,FAIL" # type of email notifications you want; END, FAIL, ALL, BEGIN, etc.
output_directory="/home/haqqeez/SLURMS/GLM/" # directory where you want the output and errors of slurm files to be saved

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

poly="POLY"
sigma="SIGMA" # just a placeholder it wont be used

#######################  STEP 2 ####################### 

# Define the values for each parameter

### ~~~~ *** USE SPACES NOT COMMAS *** ~~~~ ##

# These should all be arrays (ie., in brackets with spaces NOT commas; like this: (value1 value2 value3))
# The values should be in the order you want them to be looped over
# You can have a single value in the array if you don't want to loop over that parameter
# If you accidentally have multiple values in the array but don't want to loop over that parameter, we just take the first value

poly+=(0 1 2 3 4) # gassian bases gridsize by number at triangular base
sigma+=(0)


#######################  STEP 3 ####################### 

# Set which params you want to loop over
# the otder determines file naming
param1=("${poly[@]}")
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
# Generate all combinations of parameters 
combinations=$(eval echo {2..${#param1[@]}}_{2..${#param2[@]}})
# if you wanted a 4th parameter, you would add _{2..${#param4[@]}} to the end of the above line, and so on

# drop the extension in case it's there
slurm_name="${slurm_name%.*}"

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
  slurm_script="${slurm_name}_${param1_placeholder,,}${i}.sl"
  cp $slurm_path $slurm_script

  # Modify the copied script with the parameters
  sed -i "s/${param1_placeholder}/${i}/g" $slurm_script
  # sed -i "s/${param2_placeholder}/${j}/g" $slurm_script ###~*~*~*~*~*~*~*~*~*~*~*~*~*~*~################## CHANGE IF MORE OR FEWER PARAMS  ###################################

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
  echo "Variables: $param1_placeholder" ###~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~###### CHANGE IF MORE OR FEWER PARAMS  ###################################
  echo "Submitting job with parameters: $i" ###~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*########### CHANGE IF MORE OR FEWER PARAMS  ###################################
  #echo "Remaining parameters: $allmyparams"
  #echo "Slurm script: $slurm_script"
  #echo "Slurm name: $slurm_name"
  #echo "Root directory: $root_directory"
  #echo "Current directory: $(pwd)"

  # Submit the Slurm job ###~*~*~*~*~*~*~*~*~*~*~*~*~###### CHANGE IF MORE OR FEWER PARAMS  ##
  sbatch --mail-user=$email \
          --mail-type=$mailtype \
          --job-name=$slurm_name \
          --output=$output_directory/${slurm_name}_${param1_placeholder,,}${i}_%j.out \
          --error=$output_directory/errors/${slurm_name}_${param1_placeholder,,}${i}_%j.err \
          --account=$project_account \
          --time=$timelim \
          --nodes=1 \
          --ntasks=1 \
          --cpus-per-task=$cpus \
          --mem=$mem \
          $slurm_script
  
  sleep 1 # pause to be kind to the job scheduler on the server
done

echo "All jobs submitted!"
