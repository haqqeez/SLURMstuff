#!/bin/bash
#SBATCH --job-name=TASKNAME
#SBATCH --account=rpp-markpb68
#SBATCH --time=3:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=12000
#SBATCH --mail-user=MYEMAIL
#SBATCH --mail-type=ALL

module load gentoo/2020 
module load matlab/2020a

srun matlab - nodisplay - singleCompThread -r "msDeconvolve"
