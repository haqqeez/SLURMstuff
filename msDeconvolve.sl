#!/bin/bash
#SBATCH --job-name=TASKNAME
#SBATCH --account=rpp-markpb68
#SBATCH --time=1:45:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=8000
#SBATCH --mail-user=MYEMAIL
#SBATCH --mail-type=ALL

module load matlab/2020a

srun matlab - nodisplay - singleCompThread -r "msDeconvolve"
