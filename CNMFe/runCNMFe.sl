#!/bin/bash
#SBATCH --job-name=TASKNAME
#SBATCH --account=PROJECTACCOUNT
#SBATCH --time=RUNTIME
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=NUMCPUS
#SBATCH --mem=RAM
#SBATCH --mail-user=MYEMAIL
#SBATCH --mail-type=MAILTYPE
#SBATCH --output=OUTPUTDIR
#SBATCH --error=ERRORDIR

module load StdEnv/2020
module load gentoo/2020
module load matlab/2020a

matlab -nodisplay -batch "addpath(genpath('SCRIPTPATH')); runCNMFe"