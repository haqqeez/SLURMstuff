#!/bin/bash
#SBATCH --job-name=EarlyProcessing
#SBATCH --account=rpp-markpb68
#SBATCH --time=0:20:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=16000
#SBATCH --mail-user=computezee@gmail.com
#SBATCH --mail-type=ALL

module load matlab/2020a

matlab -nodisplay -batch "EarlyPostprocessing"
