#!/bin/bash
#SBATCH --job-name=EarlyPostprocessing
#SBATCH --account=rpp-markpb68
#SBATCH --time=0:30:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=8000
#SBATCH --mail-user=computezee@gmail.com
#SBATCH --mail-type=ALL

module load matlab/2020a

srun matlab - nodisplay - singleCompThread -r "EarlyPostprocessing"
