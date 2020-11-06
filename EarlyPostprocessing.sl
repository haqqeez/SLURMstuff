#!/bin/bash
#SBATCH --job-name=EarlyPostprocessing
#SBATCH --account=rpp-markpb68
#SBATCH --time=1:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=10000
#SBATCH --mail-user=computezee@gmail.com
#SBATCH --mail-type=ALL

module load matlab/2020a

srun matlab - nodisplay - singleCompThread -r "EarlyPostprocessing"
