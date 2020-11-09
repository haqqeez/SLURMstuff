#!/bin/bash
#SBATCH --job-name=TASKNAME
#SBATCH --account=rpp-markpb68
#SBATCH --time=2:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=6
#SBATCH --mem=18000
#SBATCH --mail-user=MYEMAIL
#SBATCH --mail-type=ALL

module load matlab/2020a

srun matlab - nodisplay - singleCompThread -r "msDeconvolve"
