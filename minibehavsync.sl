#!/bin/bash
#SBATCH --job-name=TASKNAME
#SBATCH --account=def-wilsyl
#SBATCH -o /lustre02/home/haqqeez/scripting/SLURMS/OUTNAME-%j.out
#SBATCH --mail-user=MYEMAIL
#SBATCH --mail-type=ALL

module load python/3.8
module load scipy-stack

echo "SOURCED"

python SCRIPTPATH

echo "Done!"
