#!/bin/bash
#SBATCH --job-name=ZHA028_corrgraphs
#SBATCH --account=rpp-markpb68
#SBATCH --time=1:30:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=20
#SBATCH --mem=8000
#SBATCH --mail-user=computezee@gmail.com
#SBATCH --mail-type=ALL

module load python/3.6
module load scipy-stack

source /home/haqqeez/multiprocess_env/bin/activate

echo "SOURCED"

python multiprocess_corrgraphs.py

echo "Done!"
