#!/bin/bash
#SBATCH --job-name=TASKNAME
#SBATCH --account=rrg-markpb68
#SBATCH --time=1:20:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=10
#SBATCH --mem=70000
#SBATCH --mail-user=MYEMAIL
#SBATCH --mail-type=ALL

module load StdEnv/2020
module load gentoo/2020
module load matlab/2020a

matlab -nodisplay -batch "msRunSingleFolder"
