#!/bin/bash
#SBATCH --job-name=TASKNAME
#SBATCH --account=rpp-markpb68
#SBATCH --time=0:15:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --mem=6000
#SBATCH -o /lustre02/home/haqqeez/scripting/SLURMS/OUTNAME-%j.out
#SBATCH --mail-user=MYEMAIL
#SBATCH --mail-type=ALL

module load python/3.8
module load scipy-stack

virtualenv --no-download $SLURM_TMPDIR/env
source $SLURM_TMPDIR/env/bin/activate
pip install --no-index --upgrade pip
pip install --no-index sklearn
#pip install --no-index pandas==1.3.5

echo "SOURCED"

python SCRIPTPATH

echo "Done!"
