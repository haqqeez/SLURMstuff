#!/bin/bash
#SBATCH --account=rrg-markpb68
#SBATCH --time=1:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=8000
#SBATCH --job-name=JOBNAMEHERE
#SBATCH --output=/home/haqqeez/SLURMS/GLM/JOBNAMEHERE_%j.out
#SBATCH --error=/home/haqqeez/SLURMS/GLM/JOBNAMEHERE_%j.err
#SBATCH --mail-type="END,FAIL"
#SBATCH --mail-user=computezee@gmail.com

module load python/3.10
module load scipy-stack

#source /lustre02/home/haqqeez/GLM_env/bin/activate

virtualenv --no-download $SLURM_TMPDIR/env
source $SLURM_TMPDIR/env/bin/activate
pip install --no-index --upgrade pip
pip install --no-index sklearn
pip install --no-index scikit-optimize
pip install --no-index numpy==1.23.5

echo "SOURCED"


python SCRIPTPATH BASESIZE SIGMA
