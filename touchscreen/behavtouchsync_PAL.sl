#!/bin/bash
#SBATCH --job-name=TASKNAME
#SBATCH --account=rpp-markpb68
#SBATCH --time=0:10:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=4000
#SBATCH --mail-user=MYEMAIL
#SBATCH --mail-type=ALL

module load StdEnv/2020
module load matlab/2020a

matlab -nodisplay -batch "behavtouchsync_PAL"
