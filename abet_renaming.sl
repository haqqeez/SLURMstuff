#!/bin/bash
#SBATCH --job-name=ABET-sorting
#SBATCH --account=rpp-markpb68
#SBATCH --time=0:10:00
#SBATCH --mail-user=computezee@gmail.com
#SBATCH --mail-type=ALL

module load python/3.7
module load scipy-stack

python abet_renaming_Linux.py
