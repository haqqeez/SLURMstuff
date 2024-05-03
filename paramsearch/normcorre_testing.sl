#!/bin/bash
#SBATCH --account=rrg-markpb68
#SBATCH --time=0:30:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=6
#SBATCH --mem=24000
#SBATCH --job-name=JOBNAMEHERE
#SBATCH --output=/home/haqqeez/SLURMS/normcorre/JOBNAMEHERE_%j.out
#SBATCH --error=/home/haqqeez/SLURMS/normcorre/JOBNAMEHERE_%j.err
#SBATCH --mail-type="END,FAIL"
#SBATCH --mail-user=computezee@gmail.com

module load StdEnv/2020
module load gentoo/2020
module load matlab/2020a

# Get the current working directory
cwd=$(pwd)

# define the corrected video file name
vidname="VIDPARAM1PARAMVAL1_VIDPARAM2PARAMVAL2_VIDPARAM3PARAMVAL3.avi"

SCRIPT_PATH='SCRIPTPATH'

# Get the directory path
DIR_PATH=$(dirname "$SCRIPT_PATH")

# Get the script name
SCRIPT_NAME=$(basename "$SCRIPT_PATH")
SCRIPT_NAME=${SCRIPT_NAME%.*}

#"addpath('path/to/your'); your_function(arg1, arg2); exit;"


# Run the matlab script
matlab -nodisplay -nosplash -nodesktop -batch \
"addpath('${DIR_PATH}'); ${SCRIPT_NAME}('$cwd', DOWNSAMPLING, GSIZ, GSIG, GRIDNESS, \
OVERLAP, BOUNDARY, UPSAMPLING, MAXSHIFT, BINWIDTH, ITERATIONS, \
'TESTFILE', '$vidname'); exit;"
